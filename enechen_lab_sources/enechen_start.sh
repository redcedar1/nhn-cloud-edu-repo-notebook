#!/bin/bash
# =======================================================
# Enechen Bakery Lab - Docker 컨테이너 시작 스크립트
# =======================================================

echo "🧹 기존 컨테이너 및 네트워크 정리 중..."
docker rm -f coffee1 mixer1 drink1 sandwich1 salad1 griddle1 foodcourt 2>/dev/null
docker network rm bakery-net 2>/dev/null

echo "🌐 Docker 네트워크 생성..."
docker network create bakery-net

PORT_COFFEE=8081
PORT_MIXER=8082
PORT_DRINK=8083
PORT_SANDWICH=8084
PORT_SALAD=8085
PORT_GRIDDLE=8086
PORT_FOODCOURT=8080

echo "🚀 조리기기 컨테이너 실행..."
docker run -d --name coffee1 --network bakery-net -p ${PORT_COFFEE}:${PORT_COFFEE} -e PORT=${PORT_COFFEE} coffee-machine:v1
docker run -d --name mixer1 --network bakery-net -p ${PORT_MIXER}:${PORT_MIXER} -e PORT=${PORT_MIXER} dough-mixer:v1
docker run -d --name drink1 --network bakery-net -p ${PORT_DRINK}:${PORT_DRINK} -e PORT=${PORT_DRINK} drink-dispenser:v1
docker run -d --name sandwich1 --network bakery-net -p ${PORT_SANDWICH}:${PORT_SANDWICH} -e PORT=${PORT_SANDWICH} sandwich-maker:v1
docker run -d --name salad1 --network bakery-net -p ${PORT_SALAD}:${PORT_SALAD} -e PORT=${PORT_SALAD} salad-station:v1
docker run -d --name griddle1 --network bakery-net -p ${PORT_GRIDDLE}:${PORT_GRIDDLE} -e PORT=${PORT_GRIDDLE} griddle:v1

echo "🚀 foodcourt-web 컨테이너 실행..."
docker run -d --name foodcourt --network bakery-net \
  -p ${PORT_FOODCOURT}:8080 \
  -e PORT=8080 \
  -e POD_NAME=local-foodcourt \
  -e SIDECARS="coffee1:${PORT_COFFEE},mixer1:${PORT_MIXER},drink1:${PORT_DRINK},sandwich1:${PORT_SANDWICH},salad1:${PORT_SALAD},griddle1:${PORT_GRIDDLE}" \
  foodcourt-web:v1

echo "✅ 실행 중인 컨테이너 목록:"
docker ps --format "table {{.Names}}	{{.Image}}	{{.Ports}}"

echo "🍱 Foodcourt Web: http://localhost:${PORT_FOODCOURT} 접속 가능!"
