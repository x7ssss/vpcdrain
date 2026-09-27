#!/usr/bin/env bash
set -euo pipefail

BINARY_NAME="vpcdrain"
BUILD_DIR="bin"
VERSION="1.0.0"
LDFLAGS="-s -w -X main.version=${VERSION}"

echo "==> Building vpcdrain cross-platform static binaries (CGO_ENABLED=0)..."
mkdir -p "${BUILD_DIR}"

export CGO_ENABLED=0

TARGETS=(
  "linux/amd64"
  "linux/arm64"
  "darwin/amd64"
  "darwin/arm64"
  "windows/amd64"
)

for TARGET in "${TARGETS[@]}"; do
  GOOS="${TARGET%/*}"
  GOARCH="${TARGET#*/}"
  EXT=""
  if [ "$GOOS" = "windows" ]; then
    EXT=".exe"
  fi
  OUT="${BUILD_DIR}/${BINARY_NAME}-${GOOS}-${GOARCH}${EXT}"
  echo "  -> Compiling ${OUT} (${GOOS}/${GOARCH})..."
  GOOS="${GOOS}" GOARCH="${GOARCH}" go build -ldflags="${LDFLAGS}" -o "${OUT}" .
done

echo "==> All binaries successfully compiled to ${BUILD_DIR}/"
ls -lh "${BUILD_DIR}"
