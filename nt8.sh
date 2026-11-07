#!/usr/bin/env bash
# Daily helper for the NinjaTrader 8 VM.
# Usage: ./nt8.sh start | stop | open | status | logs | launcher
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

URL="http://localhost:8006"
CONTAINER="nt8"

SUDO=""
docker info >/dev/null 2>&1 || SUDO="sudo"
if $SUDO docker compose version >/dev/null 2>&1; then
  COMPOSE=($SUDO docker compose)
else
  COMPOSE=($SUDO docker-compose)
fi

wait_ready() {
  printf 'Waiting for the VM'
  for _ in $(seq 1 90); do
    if curl -fs -o /dev/null "$URL"; then echo " ready."; return 0; fi
    printf '.'; sleep 2
  done
  echo; echo "The web viewer did not answer yet. Try: ./nt8.sh logs" >&2
  return 1
}

case "${1:-open}" in
  start)
    "${COMPOSE[@]}" up -d
    wait_ready
    ;;
  open)
    "${COMPOSE[@]}" up -d
    wait_ready
    xdg-open "$URL" >/dev/null 2>&1 || echo "Open $URL in your browser"
    ;;
  stop)
    echo "Shutting Windows down safely (can take up to 2 minutes)..."
    "${COMPOSE[@]}" stop
    ;;
  status)
    $SUDO docker ps -a --filter "name=^${CONTAINER}$" --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
    ;;
  logs)
    $SUDO docker logs -f "$CONTAINER"
    ;;
  launcher)
    apps="$HOME/.local/share/applications"
    mkdir -p "$apps"
    cat > "$apps/ninjatrader8.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=NinjaTrader 8
Comment=Start the NinjaTrader 8 VM and open it in the browser
Exec=$PWD/nt8.sh open
Icon=utilities-system-monitor
Terminal=false
Categories=Finance;Office;
EOF
    echo "Added 'NinjaTrader 8' to the app menu. Search for it in Activities."
    ;;
  *)
    echo "Usage: $0 start | stop | open | status | logs | launcher" >&2
    exit 1
    ;;
esac
