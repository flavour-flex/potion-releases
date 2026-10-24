# PO-TION

Dein persönlicher KI-Assistent fürs Product Ownership. Aufgaben, Projekte, Meilensteine und Notizen per Chat, mit einem KI-Modell, das komplett lokal auf deinem Mac läuft.

Dieses Repository enthält nur die fertigen Versionen zum Herunterladen. Der Quellcode ist privat.

## Installieren

Voraussetzung: Mac mit Apple-Chip (M1 oder neuer), macOS 12 oder neuer, etwa 4 GB freier Speicher.

Terminal öffnen und diese Zeile einfügen:

```
curl -fsSL https://raw.githubusercontent.com/flavour-flex/potion-releases/main/install.sh | bash
```

Der Installer legt PO-TION in deinen Ordner „Programme“ im Benutzerordner (`~/Applications`) und startet es. Beim ersten Start wählst du, ob deine Daten nur auf deinem Mac liegen oder in Linear, und PO-TION lädt einmalig das lokale KI-Modell.

## Updates

PO-TION meldet neue Versionen selbst (oben rechts „Update …“ oder unter Einstellungen → App). Ein Klick auf „Jetzt aktualisieren“ installiert sie, deine Daten bleiben unverändert. Alternativ den Installer-Befehl oben einfach nochmal ausführen.

## Datenschutz

- Das KI-Modell läuft auf deinem Mac, keine Inhalte gehen an eine Cloud-KI.
- Im Modus „Nur auf diesem Mac“ liegen auch Aufgaben und Notizen ausschließlich lokal (`~/Library/Application Support/crxs`), mit täglicher Sicherungskopie.
- Nach außen spricht PO-TION nur mit Diensten, die du selbst einträgst (Linear, Jira/Confluence, Kalender-Abo) und mit GitHub für die Update-Prüfung.

## Deinstallieren

`~/Applications/PO-TION.app` löschen. Deine Daten liegen in `~/Library/Application Support/crxs` und können ebenfalls gelöscht werden.
