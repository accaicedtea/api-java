#!/usr/bin/env bash
# ============================================================
#  build.sh — Compila backend (JAR) e frontend (dist)
#             e li copia nelle cartelle Docker.
#
#  Uso:
#    chmod +x build.sh
#    ./build.sh
# ============================================================
set -euo pipefail

# ---------- Percorsi sorgente (modifica se necessario) ----------
BACKEND_SRC="${BACKEND_SRC:-$HOME/Scaricati/ristoranteApp}"
FRONTEND_SRC="${FRONTEND_SRC:-$HOME/Scrivania/sito_gigante/sito-grande}"

# ---------- Percorsi destinazione (relativi a questo script) ----------
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DEST="$ROOT_DIR/backend"
FRONTEND_DEST="$ROOT_DIR/frontend"

# ---------- Colori ----------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
log()  { echo -e "${GREEN}==>${NC} $1"; }
warn() { echo -e "${YELLOW}!!${NC} $1"; }
err()  { echo -e "${RED}xx${NC} $1" >&2; exit 1; }

# ---------- Prerequisiti ----------
log "Verifica prerequisiti..."
command -v java >/dev/null || err "Java non trovato nel PATH"
command -v node >/dev/null || err "Node.js non trovato nel PATH"
command -v npm  >/dev/null || err "npm non trovato nel PATH"

[ -d "$BACKEND_SRC" ]              || err "Backend non trovato: $BACKEND_SRC"
[ -f "$BACKEND_SRC/mvnw" ]         || err "mvnw mancante in $BACKEND_SRC"
[ -d "$FRONTEND_SRC" ]             || err "Frontend non trovato: $FRONTEND_SRC"
[ -f "$FRONTEND_SRC/package.json" ]|| err "package.json mancante in $FRONTEND_SRC"

# ============================================================
#  BACKEND
# ============================================================
log "Compilazione backend Spring Boot..."
cd "$BACKEND_SRC"
./mvnw clean package -DskipTests -q

JAR="$(ls -1 target/*.jar | grep -v '\.original$' | head -n1 || true)"
[ -n "$JAR" ] && [ -f "$JAR" ] || err "Nessun JAR prodotto in $BACKEND_SRC/target"

log "JAR generato: $(basename "$JAR") ($(du -h "$JAR" | cut -f1))"

mkdir -p "$BACKEND_DEST"
cp "$JAR" "$BACKEND_DEST/ristoranteApp-0.0.1-SNAPSHOT.jar"
log "JAR copiato in $BACKEND_DEST/"

# ============================================================
#  FRONTEND
# ============================================================
log "Compilazione frontend Vue..."
cd "$FRONTEND_SRC"

if [ ! -d node_modules ]; then
  warn "node_modules mancante — eseguo npm install..."
  npm install --no-audit --no-fund
fi

npm run build

[ -d "$FRONTEND_SRC/dist" ] || err "Nessuna cartella dist/ prodotta dal build"

mkdir -p "$FRONTEND_DEST/dist"
rm -rf "$FRONTEND_DEST/dist"/*
# Copia anche file nascosti (.htaccess, .well-known, ecc.)
cp -r "$FRONTEND_SRC/dist/." "$FRONTEND_DEST/dist/"
log "Frontend copiato in $FRONTEND_DEST/dist/"

# ============================================================
#  RIEPILOGO
# ============================================================
echo
log "✔ Build completato"

# ============================================================
#  BUILD DOCKER + RESTART
# ============================================================
log "Build immagini Docker..."
docker compose build

log "Riavvio container..."
docker compose down
docker compose up -d

log "Attendo healthcheck (max 60s)..."
for i in $(seq 1 12); do
  sleep 5
  if docker compose ps --format json | grep -q '"Health":"healthy"'; then
    break
  fi
done

docker compose ps
