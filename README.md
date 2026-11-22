# Tag 16 Praxis — DORA-Metriken

> **Praxisauftrag.** Dieses Repository ist dein Arbeitsplatz für die Praxis
> von Tag 16. Es enthält den Rechenkern `dora.py` mit Lücken, die Tests
> `test_dora.py`, zwei Deployment-Protokolle in `data/` und die Vorlage
> `DOKUMENTATION.md` für den Vergleich in P3.

## Ausgangslage

In Theorie 1 habt ihr die fünf DORA-Metriken und ihre Definitionen
kennengelernt. Jetzt macht ihr sie messbar: Zuerst klärt ihr in der Gruppe auf
dem Nimbus-Board, was überhaupt gezählt wird. Dann schreibt jede Person einen
kleinen Rechenkern, der aus einem Deployment-Protokoll alle fünf DORA-Metriken
berechnet. Denselben Rechenkern setzt ihr nach dem Spiel «Release Rush» im
Projekt auf die echten Daten eurer TechStyle-Pipeline an.

Die vollständige Anleitung steht in der Tagesplanung von Tag 16, Abschnitt
**Praxis**.

## Aufgaben

**Zeit:** 45 Min inklusive 10 Min Pause, die Gruppe legt die Pause selbst |
**Format:** Gruppen à 3–4 mit einem Nimbus-Board pro Gruppe

| Auftrag | Zeit | Format | Ergebnis |
|---------|------|--------|----------|
| **P0** Setup | – | jede Person | Repository im Codespace, Nimbus-Board der Gruppe offen |
| **P1** Streitfälle entscheiden | 10 Min | Gruppe | Entscheid und Begründung auf dem Nimbus-Board |
| **P2** Rechenkern `dora.py` | 25 Min | jede Person im eigenen Repository, die Gruppe hilft sich | `dora.py`, alle Tests grün |
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

### P2 — Rechenkern `dora.py`

1. Lies den Kopf von `dora.py`: Er beschreibt das Protokoll-Format. Einlesen,
   `hours()` und `period_days()` sind schon fertig.
2. Ersetze in den sechs Funktionen `deployment_frequency`, `lead_time_hours`,
   `change_failure_rate`, `recovery_time_hours`, `rework_rate` und `classify`
   jedes `raise NotImplementedError` durch deinen Code.
3. Teste nach jeder Funktion:

   ```bash
   python -m unittest -v test_dora.TestLeadTime
   python -m unittest -v          # alle Tests
   ```

4. Verändere `test_dora.py` nicht. Die Bewertung prüft, dass die Datei der
   Vorlage entspricht.
5. Wenn alle Tests grün sind, rechne ein Protokoll durch:

   ```bash
   python dora.py data/team-kasse.csv --tage 28
   ```

Nach dem Spiel «Release Rush» könnt ihr das exportierte Spielprotokoll aus
Nimbus mit demselben Befehl durchrechnen: Es hat dasselbe Format.

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
**Fortschritt: 0 / 7 Kriterien erfüllt** ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ — Stand: 2026-11-22 16:54 UTC.
<!-- /c50:progress -->

- [ ] ⬜ P2: Deployment Frequency korrekt berechnet
- [ ] ⬜ P2: Lead Time for Changes korrekt berechnet (Median in Stunden)
- [ ] ⬜ P2: Change Failure Rate korrekt berechnet
- [ ] ⬜ P2: Failed Deployment Recovery Time korrekt berechnet
- [ ] ⬜ P2: Rework Rate korrekt berechnet
- [ ] ⬜ P2: Einordnung nach der Kursskala korrekt
- [ ] ⬜ P2: Alle Tests grün, test_dora.py unverändert

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
