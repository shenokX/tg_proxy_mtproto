#!/usr/bin/env bash
set -euo pipefail

cd /opt/MTProxy

PUBLIC_HOST="${PUBLIC_HOST:-}"
MTPROXY_PORT="${MTPROXY_PORT:-443}"
MTPROXY_STATS_PORT="${MTPROXY_STATS_PORT:-8888}"
MTPROXY_WORKERS="${MTPROXY_WORKERS:-2}"
MTPROXY_SECRET="${MTPROXY_SECRET:-}"
MTPROXY_ADTAG="${MTPROXY_ADTAG:-}"
MTPROXY_TLS_DOMAIN="${MTPROXY_TLS_DOMAIN:-}"
MTPROXY_EXTRA_ARGS="${MTPROXY_EXTRA_ARGS:-}"

if [[ -z "$PUBLIC_HOST" ]]; then
  echo "[ERROR] PUBLIC_HOST is not set"
  exit 1
fi

if [[ ! -f proxy-secret ]]; then
  echo "[INFO] Downloading proxy-secret..."
  curl -fsSL -o proxy-secret https://core.telegram.org/getProxySecret
fi

if [[ ! -f proxy-multi.conf ]]; then
  echo "[INFO] Downloading proxy-multi.conf..."
  curl -fsSL -o proxy-multi.conf https://core.telegram.org/getProxyConfig
fi

mkdir -p /data

if [[ -z "$MTPROXY_SECRET" ]]; then
  echo "[INFO] Generating secret..."
  MTPROXY_SECRET="$(head -c 16 /dev/urandom | xxd -ps -c 32)"
fi

echo "$MTPROXY_SECRET" > /data/generated-secret.txt

echo "[INFO] Public host: $PUBLIC_HOST"
echo "[INFO] Port: $MTPROXY_PORT"
echo "[INFO] Stats port: $MTPROXY_STATS_PORT"
echo "[INFO] Secret saved to /data/generated-secret.txt"
echo "[INFO] Client link: tg://proxy?server=${PUBLIC_HOST}&port=${MTPROXY_PORT}&secret=${MTPROXY_SECRET}"
echo "[INFO] Client link with random padding: tg://proxy?server=${PUBLIC_HOST}&port=${MTPROXY_PORT}&secret=dd${MTPROXY_SECRET}"

ARGS=(
  -u nobody
  -p "$MTPROXY_STATS_PORT"
  -H "$MTPROXY_PORT"
  -S "$MTPROXY_SECRET"
  -M "$MTPROXY_WORKERS"
  --aes-pwd proxy-secret proxy-multi.conf
)

if [[ -n "$MTPROXY_ADTAG" ]]; then
  ARGS+=( -P "$MTPROXY_ADTAG" )
fi

if [[ -n "$MTPROXY_TLS_DOMAIN" ]]; then
  ARGS+=( -D "$MTPROXY_TLS_DOMAIN" )
fi

if [[ -n "$MTPROXY_EXTRA_ARGS" ]]; then
  # shellcheck disable=SC2206
  EXTRA=( $MTPROXY_EXTRA_ARGS )
  ARGS+=( "${EXTRA[@]}" )
fi

exec /opt/MTProxy/objs/bin/mtproto-proxy "${ARGS[@]}"
