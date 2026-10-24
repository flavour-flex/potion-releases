#!/bin/bash
# PO-TION Installer: installiert oder aktualisiert PO-TION in ~/Applications.
# Aufruf: curl -fsSL https://raw.githubusercontent.com/flavour-flex/potion-releases/main/install.sh | bash
set -euo pipefail
REPO="flavour-flex/potion-releases"
URL="https://github.com/$REPO/releases/latest/download/potion-mac.zip"

[ "$(uname -s)" = "Darwin" ] || { echo "PO-TION läuft nur auf macOS."; exit 1; }
[ "$(uname -m)" = "arm64" ] || { echo "PO-TION braucht einen Mac mit Apple-Chip (M1 oder neuer)."; exit 1; }

DEST="$HOME/Applications"
APP="$DEST/PO-TION.app"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "→ Lade die neueste Version von PO-TION …"
curl -fL --progress-bar -o "$TMP/potion.zip" "$URL"
echo "→ Entpacke …"
/usr/bin/ditto -x -k "$TMP/potion.zip" "$TMP"
[ -d "$TMP/PO-TION.app" ] || { echo "Das Paket ist unvollständig, bitte später nochmal versuchen."; exit 1; }

# Laufende Version beenden
osascript -e 'tell application id "app.potion.desktop" to quit' >/dev/null 2>&1 || true
sleep 1

mkdir -p "$DEST"
rm -rf "$APP" "$DEST/crxs.app"
mv "$TMP/PO-TION.app" "$APP"
# Nicht von Apple notarisiert: Quarantäne entfernen und lokal signieren
xattr -cr "$APP" 2>/dev/null || true
codesign --force --deep --sign - "$APP" >/dev/null 2>&1 || true

VERSION="$(cat "$APP/Contents/Resources/app/VERSION" 2>/dev/null || echo "?")"
echo "✓ PO-TION $VERSION ist installiert: $APP"
echo "  Beim ersten Start lädt PO-TION einmalig das lokale KI-Modell (ca. 2,5 GB)."
open "$APP"
