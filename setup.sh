#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Setup script for C-REAL nuke bot (Linux / Python 3.12)
# Run once before your first test session.
# ─────────────────────────────────────────────────────────────────────────────
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/venv"

echo "[nuke-bot] Checking Python version..."
python3 --version

echo "[nuke-bot] Creating virtual environment at $VENV_DIR ..."
python3 -m venv "$VENV_DIR"

echo "[nuke-bot] Installing dependencies..."
"$VENV_DIR/bin/pip" install --upgrade pip --quiet
"$VENV_DIR/bin/pip" install -r "$SCRIPT_DIR/requirements.txt"

echo ""
echo "✓ Setup complete."
echo "  Run './tests/nuke-bot/run.sh' from the project root to start the nuke bot."
echo ""
echo "  Before running, make sure your TEST bot token has these enabled"
echo "  in the Discord Developer Portal (Bot page):"
echo "    • Server Members Intent"
echo "    • Message Content Intent"
