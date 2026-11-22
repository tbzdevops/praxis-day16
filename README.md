# Tag 16 Praxis — DORA-Metriken

> **Praxisauftrag.** Dieses Repository ist dein Arbeitsplatz für die Praxis
> von Tag 16. Es enthält das fertige Werkzeug `dora.py`, vier
> Deployment-Protokolle in `data/` und die Vorlage `DOKUMENTATION.md`.

## Ausgangslage

In Theorie 1 habt ihr die fünf DORA-Metriken und ihre Definitionen
kennengelernt, im Spiel «Release Rush» habt ihr sie erlebt. Jetzt messt ihr
selbst. Programmieren müsst ihr dafür nicht: `dora.py` ist ein fertiges
Werkzeug, so wie ein Dashboard im Betrieb. Die Arbeit eines Cloud Engineers
liegt davor und danach: festlegen, was zählt, die Rohdaten aus der Pipeline
aufbereiten, das Ergebnis nachprüfen und einordnen. Dasselbe Werkzeug setzt
ihr im Projekt auf die echten Daten eurer TechStyle-Pipeline an.

Die vollständige Anleitung steht in der Tagesplanung von Tag 16, Abschnitt
**Praxis**.

## Aufgaben

**Zeit:** 45 Min inklusive 10 Min Pause, die Gruppe legt die Pause selbst |
**Format:** Gruppen à 3–4 mit einem Nimbus-Board pro Gruppe

| Auftrag | Zeit | Format | Ergebnis |
|---------|------|--------|----------|
| **P0** Setup | – | jede Person | Repository im Codespace, Nimbus-Board der Gruppe offen |
| **P1** Streitfälle entscheiden | 10 Min | Gruppe | Entscheid und Begründung auf dem Nimbus-Board |
| **P2a** Eine Woche nachrechnen | 10 Min | jede Person, die Gruppe hilft sich | Werte in `DOKUMENTATION.md` |
| **P2b** Rohdaten aufbereiten | 15 Min | jede Person, die Gruppe hilft sich | `data/team-shop.csv`, Werte und Stufen in `DOKUMENTATION.md` |
| **P3** Zwei Teams vergleichen (für Schnelle) | – | jede Person | Vergleich in `DOKUMENTATION.md` |

### P0 — Setup

1. Classroom-Auftrag annehmen (erledigt, wenn du dieses README liest).
2. Repository in einem **GitHub Codespace** öffnen: **Code** →
   **Codespaces** → **Create codespace on main**. Python ist dort bereits
   installiert, `dora.py` braucht nur die Standardbibliothek.
3. Das Nimbus-Board eurer Gruppe öffnen.

### P1 — Streitfälle (Gruppe, Nimbus-Board)

Auf dem Board liegen fünf Karten mit Streitfällen: Was zählt als Deployment,
als Fehler, als Lead Time? Lest jeden Fall, entscheidet mit **Ja** oder
**Nein** und begründet jede Entscheidung in einer Zeile auf dem Board. Stützt
euch auf die Definitionen aus Theorie 1. Das Board bleibt stehen: Im Projekt
nutzt ihr die Entscheidungen für die Definitionen in `DORA.md`.

### P2a — Eine Woche nachrechnen (10 Min)

Wer einem Werkzeug vertraut, sollte einmal nachgerechnet haben, was es tut.

1. Öffne `data/woche.csv`: sieben Deployments in einer Woche, eine Zeile pro
   Deployment. Das Format steht im Kopf von `dora.py`.
2. Rechne die fünf Metriken von Hand, mit dem Taschenrechner oder einer
   Tabellenkalkulation aus (Messzeitraum: 7 Tage):

   | Metrik | So rechnest du |
   |--------|----------------|
   | Deployment Frequency | Anzahl Deployments ÷ Tage |
   | Lead Time for Changes | Median von `deployed_at − committed_at` in Stunden |
   | Change Failure Rate | Anteil der Deployments mit `failed = ja` |
   | Failed Deployment Recovery Time | Median von `restored_at − deployed_at`, **nur** über die Deployments mit `failed = ja` |
   | Rework Rate | Anteil der Deployments mit `rework = ja` |

3. Trage deine Werte in `DOKUMENTATION.md` unter **P2a** in die Spalte
   **Von Hand** ein, z.B. `4 h` oder `2/7`.
4. Lass das Werkzeug rechnen und vergleiche:

   ```bash
   python dora.py data/woche.csv --tage 7
   ```

5. Beantworte die Frage zu Median und Durchschnitt.

### P2b — Rohdaten aufbereiten (15 Min)

`data/rohdaten.csv` ist ein Export aus der Pipeline von zwei Wochen. Er
enthält mehr, als gezählt werden darf, und nicht alles ist richtig markiert.
Die Spalte `notiz` sagt, was passiert ist.

1. Kopiere die Datei und öffne die Kopie im Editor:

   ```bash
   cp data/rohdaten.csv data/team-shop.csv
   ```

2. Bereinige `data/team-shop.csv` nach der **Kursdefinition** (vergleicht sie
   mit euren Entscheiden auf dem Nimbus-Board):

   | Fall in den Rohdaten | Regel | Streitfall |
   |----------------------|-------|------------|
   | `umgebung = staging` | Zeile löschen: Gezählt wird nur Produktion | 3 |
   | Feature Flag im Admin-Panel, kein Pipeline-Lauf | Zeile löschen: Ein Deployment ist ein erfolgreicher Lauf der Pipeline in Produktion | 2 |
   | Automatischer Rollback | `failed = ja`, `restored_at` = Zeitpunkt des Rollbacks | 1 |
   | Ausfall ohne eigene Änderung (z.B. AWS) | `failed = nein`, `restored_at` leeren | 4 |
   | Beginn der Lead Time | Spalte `first_commit_at` in `committed_at` umbenennen, nicht `merged_at` | 5 |

   Die Spalten `merged_at`, `umgebung` und `notiz` dürfen stehen bleiben,
   `dora.py` ignoriert sie. Zeitpunkte schreibst du wie in der Datei, z.B.
   `2026-11-11T10:03:00Z`.

3. Lass das Werkzeug rechnen:

   ```bash
   python dora.py data/team-shop.csv --tage 14
   ```

4. Trage Werte und Stufen in `DOKUMENTATION.md` unter **P2b** ein und
   beantworte die Frage, was das Aufbereiten verändert hat. Tipp: Lass
   `dora.py` zum Vergleich auch einmal auf die unbereinigte Kopie laufen.

Habt ihr im Spiel «Release Rush» das Spielprotokoll aus Nimbus exportiert,
rechnet ihr es mit demselben Befehl durch: `python dora.py <export>.csv --tage 42`.

### P3 — Zwei Teams vergleichen (für Schnelle)

Rechne `data/team-kasse.csv` und `data/team-katalog.csv` durch, trage die Werte
in `DOKUMENTATION.md` ein und beantworte die Frage, ob «Wir deployen selten,
dafür sicher» stimmt.

## Abnahmekriterien

Diese Kriterien prüft die Pipeline bei jedem Push automatisch. **Die Haken
setzt die Pipeline selbst:** Ein erfülltes Kriterium wird abgehakt, und
sobald eine Änderung es wieder bricht, verschwindet der Haken. Du musst hier
nichts von Hand pflegen, beim nächsten Push wird die Liste überschrieben.

<!-- c50:progress -->
**Fortschritt: 0 / 7 Kriterien erfüllt** ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ — Stand: 2026-11-22 20:07 UTC.
<!-- /c50:progress -->

- [ ] ⬜ P2a: Deployment Frequency und Lead Time nachgerechnet
- [ ] ⬜ P2a: Change Failure Rate und Rework Rate nachgerechnet
- [ ] ⬜ P2a: Recovery Time nachgerechnet (Median nur über fehlgeschlagene Deployments)
- [ ] ⬜ P2b: team-shop.csv enthält nur Produktions-Deployments aus der Pipeline
- [ ] ⬜ P2b: team-shop.csv misst die Lead Time ab dem ersten Commit
- [ ] ⬜ P2b: team-shop.csv markiert Fehler nach der Kursdefinition
- [ ] ⬜ P2b: Messwerte und Stufen in DOKUMENTATION.md eingetragen

Zusätzlich, nicht bewertet:

- P1 bespricht die Lehrperson in Theorie 2 direkt auf den Nimbus-Boards.
- P3 (für Schnelle): Die Prüfung zeigt ⭐, sobald die Vergleichstabelle für
  beide Teams ausgefüllt ist.

## Abnahmekriterien selber prüfen

**Lokal**, jederzeit und ohne Push:

```bash
bash .github/classroom/grade.sh
```

Das Skript liest die Tagesnummer aus `.classroom50.yaml`. Du kannst sie auch
erzwingen:

```bash
CLASSROOM_DAY=16 bash .github/classroom/grade.sh
```

Die Ausgabe listet jedes Kriterium mit ✅ oder ❌ und nennt bei jedem ❌ den
konkreten Lösungshinweis. Sobald ein Kriterium fehlt, endet das Skript mit
Exit-Code 1.

**In GitHub**, bei jedem Push:

Der Workflow **🎓 Classroom Autograding** läuft automatisch und hakt die
erfüllten Kriterien oben im README ab. Ergebnis im Tab
**Actions** → letzter Run → Job *Abnahmekriterien prüfen*.

Die Punktzahl ist **anteilig**: Jedes erfüllte Abnahmekriterium zählt einen
Punkt (z. B. `Points 5/7`). Grün wird der Lauf erst, wenn alle Kriterien
erfüllt sind, Teilpunkte gibt es aber ab dem ersten.

## Musterlösung

Nach dem Unterricht findest du die Musterlösung im Repository
[`tbzdevops/musterloesungen-praxisauftraege`](https://github.com/tbzdevops/musterloesungen-praxisauftraege/tree/day_16_solution)
auf dem Branch `day_16_solution`.
