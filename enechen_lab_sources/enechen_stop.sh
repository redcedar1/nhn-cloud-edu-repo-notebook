#!/bin/bash
# =======================================================
# Enechen Bakery Lab - Docker 컨테이너 중지 & 삭제 스크립트
# =======================================================

CONTAINERS=("coffee1" "mixer1" "drink1" "sandwich1" "salad1" "griddle1" "foodcourt")

echo "🛑 Docker 컨테이너 중지 및 삭제 시작..."

for container in "${CONTAINERS[@]}"; do
  if [ "$(docker ps -aq -f name=$container)" ]; then
    echo "🛑 컨테이너 중지: $container"
    docker stop $container >/dev/null 2>&1
    echo "🗑 컨테이너 삭제: $container"
    docker rm $container >/dev/null 2>&1
  else
    echo "⚠️  $container 컨테이너 없음 (건너뜀)"
  fi
done

echo "🌐 Docker 네트워크 삭제..."
docker network rm bakery-net 2>/dev/null

echo "✅ 모든 컨테이너와 네트워크 정리 완료!"
