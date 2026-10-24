#!/bin/bash
# PO-TION Installer: installiert oder aktualisiert PO-TION in ~/Applications.
# Aufruf: curl -fsSL https://raw.githubusercontent.com/flavour-flex/potion-releases/main/install.sh | bash
set -euo pipefail
RAW="https://raw.githubusercontent.com/flavour-flex/potion-releases/download"

[ "$(uname -s)" = "Darwin" ] || { echo "PO-TION läuft nur auf macOS."; exit 1; }
[ "$(uname -m)" = "arm64" ] || { echo "PO-TION braucht einen Mac mit Apple-Chip (M1 oder neuer)."; exit 1; }

DEST="$HOME/Applications"
APP="$DEST/PO-TION.app"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

curl -fsSL "$RAW/latest.txt?t=$(date +%s)" -o "$TMP/latest.txt" || { echo "Keine Version gefunden. Bitte später nochmal versuchen."; exit 1; }
VERSION="$(sed -n 's/^version=//p' "$TMP/latest.txt")"
SHA="$(sed -n 's/^sha256=//p' "$TMP/latest.txt")"
echo "→ Lade PO-TION $VERSION …"
: > "$TMP/potion.zip"
for PART in $(sed -n 's/^part=//p' "$TMP/latest.txt"); do
  curl -fL --progress-bar "$RAW/$PART?t=$(date +%s)" >> "$TMP/potion.zip"
done
if [ -n "$SHA" ]; then
  GOT="$(shasum -a 256 "$TMP/potion.zip" | cut -d' ' -f1)"
  [ "$GOT" = "$SHA" ] || { echo "Prüfsumme stimmt nicht, Abbruch. Bitte nochmal versuchen."; exit 1; }
fi
echo "→ Entpacke …"
/usr/bin/ditto -x -k "$TMP/potion.zip" "$TMP"
[ -d "$TMP/PO-TION.app" ] || { echo "Das Paket ist unvollständig."; exit 1; }

# Laufende Version beenden
osascript -e 'tell application id "app.potion.desktop" to quit' >/dev/null 2>&1 || true
sleep 1

mkdir -p "$DEST"
rm -rf "$APP" "$DEST/crxs.app"
mv "$TMP/PO-TION.app" "$APP"
# Nicht von Apple notarisiert: Quarantäne entfernen und lokal signieren
xattr -cr "$APP" 2>/dev/null || true
codesign --force --deep --sign - "$APP" >/dev/null 2>&1 || true

echo "✓ PO-TION $VERSION ist installiert: $APP"
echo "  Beim ersten Start lädt PO-TION einmalig das lokale KI-Modell (ca. 2,5 GB)."
open "$APP"
