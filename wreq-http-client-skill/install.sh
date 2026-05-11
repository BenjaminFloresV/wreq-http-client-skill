#!/bin/bash
# Instala el comando /implementar-wreq de forma global en Claude Code.
# Corre una sola vez por developer — funciona en todos los repos.
#
# Uso: ./install.sh

set -e

CMD_FILE="$(cd "$(dirname "$0")" && pwd)/implementar-wreq.md"
TARGET_DIR="$HOME/.claude/commands"

mkdir -p "$TARGET_DIR"

ln -sf "$CMD_FILE" "$TARGET_DIR/implementar-wreq.md"
echo "✓ /implementar-wreq instalado en $TARGET_DIR"

echo ""
echo "Listo. Abre cualquier repo con Claude Code y usa:"
echo "  /implementar-wreq <descripción o CURL>"
