#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Run C-REAL nuke bot (Linux / Python 3.12)
#
# What this does:
#   1. On first run: prompts for your TEST bot token and Discord user ID,
#      saves them into data/default.json (so you're never prompted again).
#   2. Patches two discord.py 2.x breaking changes on-the-fly without
#      touching the original source file:
#        - removes `self_bot=is_selfbot` (parameter dropped in discord.py 2.x)
#        - replaces `client.logout()` → `client.close()` (renamed in 2.x)
#   3. Launches the bot from THIS directory so it finds data/default.json
#      (which has all bomb messages pre-filled).
#
# Usage:
#   cd "/home/cayden/discord bot/discord bot"
#   ./tests/nuke-bot/run.sh
#
# To reset token/userID: delete tests/nuke-bot/data/default.json and re-run.
# ─────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV="$SCRIPT_DIR/venv"
SOURCE="/home/cayden/Documents/Nuking-Discord-Server-Bot-Nuke-Bot-2.4.1/c-realV2.py"
PATCHED="$SCRIPT_DIR/.c-realV2-patched.py"
CONFIG="$SCRIPT_DIR/data/default.json"

# ── Sanity checks ─────────────────────────────────────────────────────────────
if [ ! -d "$VENV" ]; then
    echo "[nuke-bot] ERROR: venv not found. Run './tests/nuke-bot/setup.sh' first."
    exit 1
fi

if [ ! -f "$SOURCE" ]; then
    echo "[nuke-bot] ERROR: Source file not found at:"
    echo "  $SOURCE"
    exit 1
fi

# ── First-run: inject token and user ID into default.json ─────────────────────
CURRENT_TOKEN=$(python3 -c "import json; d=json.load(open('$CONFIG')); print(d.get('token') or '')" 2>/dev/null)
CURRENT_PERMS=$(python3 -c "import json; d=json.load(open('$CONFIG')); print(len(d.get('permissions', [])))" 2>/dev/null)

if [ -z "$CURRENT_TOKEN" ] || [ "$CURRENT_PERMS" = "0" ]; then
    echo "─────────────────────────────────────────────────────"
    echo " C-REAL first-run setup"
    echo " This is saved to data/default.json for future runs."
    echo " To reset, delete data/default.json and re-run."
    echo "─────────────────────────────────────────────────────"
    read -rp " Enter your TEST bot token: " BOT_TOKEN
    read -rp " Enter your Discord user ID (the account that commands the bot): " USER_ID

    if [ -z "$BOT_TOKEN" ] || [ -z "$USER_ID" ]; then
        echo "[nuke-bot] ERROR: Token and user ID cannot be empty."
        exit 1
    fi

    # Write token + permissions into the JSON using Python (handles escaping safely)
    python3 - <<PYEOF
import json
with open('$CONFIG', 'r') as f:
    cfg = json.load(f)
cfg['token'] = '$BOT_TOKEN'
cfg['permissions'] = ['$USER_ID']
with open('$CONFIG', 'w') as f:
    json.dump(cfg, f, indent=2)
print('[nuke-bot] Config saved.')
PYEOF
fi

# ── Patch for discord.py 2.x compatibility ────────────────────────────────────
# Patch 1: remove 'self_bot=is_selfbot, ' — parameter was removed in discord.py 2.x
# Patch 2: logout() was renamed to close() in discord.py 2.x
sed \
    -e 's/self_bot=is_selfbot, //' \
    -e 's/await client\.logout()/await client.close()/' \
    "$SOURCE" > "$PATCHED"

# ── Launch from SCRIPT_DIR so the bot finds data/default.json ─────────────────
echo "[nuke-bot] Starting C-REAL v2.4.1..."
cd "$SCRIPT_DIR"
"$VENV/bin/python" "$PATCHED"
