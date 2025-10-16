#!/bin/bash
# =======================================================
# Enechen Bakery Lab - Image Build & Push Script
# =======================================================

read -p "👉 NHN Container Registry 주소를 입력하세요 (예: 1739a6b8-kr2-registry.container.nhncloud.com/nhn-ncr): " REGISTRY

if [ -z "$REGISTRY" ]; then
  echo "❌ [ERROR] Registry 주소를 입력하지 않았습니다. 종료합니다."
  exit 1
fi

VERSION1="v1"
VERSION2="v2"

BASE_DIR="."
FOODCOURT_DIR="./foodcourt-web"

DEVICE_SINGLE=("sandwich-maker" "salad-station" "griddle")
DEVICE_MULTI=("coffee-machine" "dough-mixer" "drink-dispenser")

remove_old_image() {
  local image_name=$1
  local version=$2
  if docker images | grep -q "${image_name}" | grep -q "${version}"; then
    echo "🧹 [REMOVE] 기존 이미지 삭제: ${image_name}:${version}"
    docker rmi -f ${image_name}:${version} >/dev/null 2>&1
    docker rmi -f ${REGISTRY}/${image_name}:${version} >/dev/null 2>&1
  fi
}

build_image() {
  local image_name=$1
  local version=$2
  local path=$3

  if [ ! -d "$path" ]; then
    echo "❌ [ERROR] 경로 없음: $path"
    exit 1
  fi

  remove_old_image $image_name $version

  echo "🚀 [BUILD] ${image_name}:${version}"
  docker build -t ${image_name}:${version} ${path} || { echo "❌ [FAIL] ${image_name}:${version} build 실패"; exit 1; }

  echo "🏷️ [TAG] ${REGISTRY}/${image_name}:${version}"
  docker tag ${image_name}:${version} ${REGISTRY}/${image_name}:${version}

  echo "📤 [PUSH] ${REGISTRY}/${image_name}:${version}"
  docker push ${REGISTRY}/${image_name}:${version} || { echo "❌ [FAIL] ${image_name}:${version} push 실패"; exit 1; }
}

echo "📦 1단계: 멀티버전 기기 빌드 & 푸시"
for device in "${DEVICE_MULTI[@]}"; do
  build_image $device $VERSION1 "${BASE_DIR}/devices/${device}/v1"
  build_image $device $VERSION2 "${BASE_DIR}/devices/${device}/v2"
done

echo "📦 2단계: 단일버전 기기 빌드 & 푸시"
for device in "${DEVICE_SINGLE[@]}"; do
  build_image $device $VERSION1 "${BASE_DIR}/devices/${device}"
done

echo "📦 3단계: foodcourt-web 빌드 & 푸시"
build_image "foodcourt-web" $VERSION1 "${FOODCOURT_DIR}"

echo "✅ ✅ ✅ 모든 이미지 빌드 & 푸시 완료!"
