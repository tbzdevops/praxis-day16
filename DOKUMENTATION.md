# Tag 16 Praxis – DORA-Metriken

## P2a: Eine Woche nachrechnen

<!--
Rechnet die fünf Metriken für data/woche.csv von Hand, mit dem Taschenrechner
oder einer Tabellenkalkulation aus (Messzeitraum: 7 Tage). Tragt das Ergebnis
in die Spalte «Von Hand» ein, als Zahl mit Einheit, z.B. «0.5 pro Tag»,
«12 h» oder «25 %». Danach:
    python dora.py data/woche.csv --tage 7
und das Ergebnis des Werkzeugs in die Spalte «dora.py» übertragen.
-->

| Metrik | Von Hand | dora.py |
|--------|----------|---------|
| Deployment Frequency | | |
| Lead Time for Changes | | |
| Change Failure Rate | | |
| Failed Deployment Recovery Time | | |
| Rework Rate | | |

### Median oder Durchschnitt?

<!--
Wie gross wäre der Durchschnitt der Lead Time? Warum nimmt DORA den Median?
Ein bis zwei Sätze genügen.
-->

## P2b: Rohdaten aufbereiten

<!--
Erstellt aus data/rohdaten.csv die Datei data/team-shop.csv nach der
Kursdefinition in der Aufgabe. Danach:
    python dora.py data/team-shop.csv --tage 14
und Werte und Stufen aus dem Bericht hier eintragen.
-->

| Metrik | Wert | Stufe |
|--------|------|-------|
| Deployment Frequency | | |
| Lead Time for Changes | | |
| Change Failure Rate | | |
| Failed Deployment Recovery Time | | |
| Rework Rate | | – |

### Was hat das Aufbereiten verändert?

<!--
Welche Korrektur hat die Zahlen am stärksten verändert? Sehen die
bereinigten Zahlen besser oder schlechter aus als die Rohdaten, und warum
ist das trotzdem richtig?
-->

## P3 (für Schnelle): Zwei Teams im Vergleich

<!--
Lasst dora.py auf beide Protokolle laufen:
    python dora.py data/team-kasse.csv --tage 28
    python dora.py data/team-katalog.csv --tage 28
und tragt die Werte mit Stufe ein, z.B. «1.3 pro Tag (Elite)».
-->

| Metrik | Team Kasse | Team Katalog |
|--------|------------|--------------|
| Deployment Frequency | | |
| Lead Time for Changes | | |
| Change Failure Rate | | |
| Failed Deployment Recovery Time | | |
| Rework Rate | | |

### Stimmt «Wir deployen selten, dafür sicher»?

<!--
Das Team Katalog sagt: «Wir deployen nur einmal pro Woche, dafür sicher.»
Was zeigen die Daten? Welche Fähigkeit (Capability) würdet ihr beim Team
Katalog zuerst verbessern, und welche Metrik sollte sich dadurch bewegen?
-->
