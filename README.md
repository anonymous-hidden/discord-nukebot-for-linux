# C-REAL Nuke Bot — Linux Build

> **Original bot** by [tkperson](https://github.com/TKperson) and cyxl.  
> **Linux build, Python 3.12 compatibility patches & automation scripts** edited by [cayden (anonymous-hidden)](https://github.com/anonymous-hidden).

---

## What is this?

This is the **Linux-ready** version of C-REAL v2.4.1 — the fastest free open-source Discord nuke bot — updated to work with **Python 3.12** and **discord.py 2.x** out of the box.  
It is intended for **security testing your own server** (e.g. verifying an anti-nuke system works).

> **⚠️ Legal notice:** Only use this against servers you own or have explicit written permission to test. Misuse violates Discord's ToS and may be illegal in your jurisdiction. Neither the original authors nor the Linux build maintainer accept responsibility for misuse.

---

## What's changed in the Linux build

| Change | Reason |
|---|---|
| `self_bot=is_selfbot` parameter removed at runtime | Dropped in discord.py 2.x |
| `client.logout()` → `client.close()` at runtime | Renamed in discord.py 2.x |
| `setup.sh` — automated venv creation | One-command setup on any Linux distro |
| `run.sh` — auto-patches source and launches | No manual edits needed |
| First-run credential prompt | Token/user ID saved to `data/default.json` once; never re-asked |
| `data/default.json.example` — pre-filled config template | Ready to use immediately |

---

## Requirements

- Linux (tested on Ubuntu 22.04+ / Debian 12 / Raspberry Pi OS)
- Python 3.8 or higher (Python 3.12 fully supported)
- A **bot token** from the [Discord Developer Portal](https://discord.com/developers/applications)
- Your **Discord user ID** (the account that sends commands to the bot)

### Bot intents (enable in Developer Portal → Bot page)

- ✅ Server Members Intent
- ✅ Message Content Intent

---

## Installation

### 1. Clone this repo

```bash
git clone https://github.com/anonymous-hidden/discord-nukebot-for-linux.git
cd discord-nukebot-for-linux
```

### 2. Get the original source

Download the original C-REAL v2.4.1 source file:

```bash
mkdir -p ~/Documents/Nuking-Discord-Server-Bot-Nuke-Bot-2.4.1
curl -L https://raw.githubusercontent.com/TKperson/Nuking-Discord-Server-Bot-Nuke-Bot/master/c-realV2.py \
     -o ~/Documents/Nuking-Discord-Server-Bot-Nuke-Bot-2.4.1/c-realV2.py
```

### 3. Run setup (once)

```bash
chmod +x setup.sh run.sh
./setup.sh
```

This creates a Python virtual environment and installs all dependencies automatically.

---

## Configuration

### Option A — Auto (recommended)

Just run `./run.sh` and on the first launch it will ask for your bot token and Discord user ID, then save them to `data/default.json`. You won't be asked again.

### Option B — Manual

```bash
cp data/default.json.example data/default.json
```

Edit `data/default.json` and replace:
- `"YOUR_BOT_TOKEN_HERE"` → your bot token
- `"YOUR_DISCORD_USER_ID_HERE"` → your Discord user ID

To reset credentials later, delete `data/default.json` and re-run `./run.sh`.

---

## Running

```bash
./run.sh
```

The script patches the source file at runtime (no permanent changes to the original file) and starts the bot. Invite the bot to your **test server** first, then send commands from the Discord account whose user ID you configured.

---

## Usage

### Core test commands

| Command | Description |
|---|---|
| `.channelbomb <count> <wordlist>` | Mass-create text channels |
| `.roleBomb <count> <wordlist>` | Mass-create roles |
| `.kaboom <count> <wordlist>` | Mass-create channels, roles, and categories |
| `.deleteAllChannels` | Delete every channel |
| `.deleteAllRoles` | Delete every role |
| `.banAll` | Ban every member |
| `.nuke` | Full nuke: delete channels/roles/emojis/webhooks + ban all |
| `.config` | Show and edit bot configuration |
| `.help` | List all 51 commands |

**Wordlists for bomb commands:**

| Wordlist | Description |
|---|---|
| `fixed` | Names from `bomb_messages.fixed` in your `data/default.json` |
| `b64` | Random base64 strings |
| `an` | Random alphanumeric strings |

### Example: stress-test anti-nuke with 100 channel bomb

```
.channelbomb 100 fixed
```

---

## All 51 commands

```
[addRole] [addChannel] [autoNick] [addVoiceChannel] [autoStatus]
[addEmoji] [addCategory] [banAll] [bans] [ban] [channelBomb]
[categoryBomb] [config] [checkRolePermissions] [connect] [categories]
[changeStatus] [channels] [deleteRole] [deleteChannel]
[deleteVoiceChannel] [deleteCategory] [deleteCC] [deleteEmoji]
[deleteAllRoles] [deleteAllChannels] [disableCommunityMode]
[deleteAllEmojis] [deleteAllWebhooks] [emojis] [grantAllPerm]
[help] [joinNuke] [kaboom] [leave] [leaveAll] [link] [moveRole]
[members] [nuke] [off] [purge] [roles] [roleBomb] [roleTo] [servers]
[serverIcon] [serverName] [unban] [voiceChannels] [webhook]
```

Full command reference: [manual.md](manual.md)

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Bot doesn't respond to commands | Make sure Message Content Intent is enabled in the Developer Portal |
| `venv not found` error | Run `./setup.sh` first |
| `Source file not found` error | Re-download `c-realV2.py` (see Installation step 2) |
| Rate limiting messages in console | Normal — the bot runs faster than Discord's rate limits and handles them automatically |
| Terminal appears frozen | Click the terminal window and press any key (selection/"mark" mode) |
| Want to reset token/user ID | Delete `data/default.json` and re-run `./run.sh` |

---

## Notes

- Rate limiting in the console is **expected and normal** — C-REAL intentionally creates/deletes faster than Discord's limits, then backs off automatically.
- The bot will respect Discord's [server limits](https://discordia.me/en/server-limits), but since it uses raw HTTP requests it can exceed the old 250-channel/role limit that older nuke bots had.

---

## Credits

- **Original C-REAL bot:** [tkperson](https://github.com/TKperson) & cyxl — [original repo](https://github.com/TKperson/Nuking-Discord-Server-Bot-Nuke-Bot)
- **Linux build & Python 3.12 patches:** [cayden (anonymous-hidden)](https://github.com/anonymous-hidden)
