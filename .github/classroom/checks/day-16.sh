#!/bin/bash
# PRAXIS Tag 16 — DORA-Metriken.
# dora.py ist ein fertiges Werkzeug. Bewertet wird P2: Metriken für eine
# Woche nachrechnen (P2a) und Rohdaten nach der Kursdefinition aufbereiten
# (P2b). Die Prüfung rechnet mit eigenen Sollwerten, nicht mit dora.py, damit
# ein verändertes Werkzeug nichts am Ergebnis ändert.
# P1 (Streitfälle) entscheidet die Gruppe auf dem Nimbus-Board, nicht im Repo.
# P3 in DOKUMENTATION.md ist freiwillig und zeigt nur ⭐ (grade.sh kennt keine
# optionalen Kriterien). In DOKUMENTATION.md zählt nur Text ausserhalb der
# HTML-Kommentare.
source .github/classroom/grade.sh

solution_for_id() {
  case "$1" in
    p2a-throughput) echo "Rechne für data/woche.csv Deployments pro Tag (7 Tage) und den Median von deployed_at - committed_at in Stunden aus und trage beides in DOKUMENTATION.md, P2a, Spalte «Von Hand» ein" ;;
    p2a-instability) echo "Trage in DOKUMENTATION.md, P2a, Spalte «Von Hand» den Anteil fehlgeschlagener Deployments (failed = ja) und den Anteil Rework-Deployments ein, z.B. «2/7» oder «29 %»" ;;
    p2a-recovery) echo "Recovery Time: restored_at - deployed_at nur für die Deployments mit failed = ja, davon der Median. Bei zwei Werten ist das der Mittelwert der beiden" ;;
    p2b-production) echo "data/team-shop.csv: nur Deployments in Produktion über die Pipeline. Zeilen mit umgebung = staging und die Feature-Flag-Umschaltung ohne Pipeline-Lauf löschen" ;;
    p2b-leadtime) echo "data/team-shop.csv braucht die Spalte committed_at mit dem Zeitpunkt des ERSTEN Commits: Spalte first_commit_at in committed_at umbenennen, nicht merged_at" ;;
    p2b-failures) echo "data/team-shop.csv: automatischer Rollback zählt als failed = ja (restored_at = Zeitpunkt des Rollbacks), der AWS-Ausfall ist keine eigene Änderung (failed = nein)" ;;
    p2b-report) echo "Lass python dora.py data/team-shop.csv --tage 14 laufen und trage alle fünf Werte und die vier Stufen in DOKUMENTATION.md, P2b ein" ;;
    *) echo "Überprüfe die Aufgabenstellung im README" ;;
  esac
}

DOC=DOKUMENTATION.md
SHOP=data/team-shop.csv

# Prüflogik in Python: p2 <kriterium>
p2() {
  python3 - "$1" "$DOC" "$SHOP" <<'PY'
import csv, re, sys
from datetime import datetime

what, doc_path, shop_path = sys.argv[1:4]

# ---- Sollwerte --------------------------------------------------------------
WOCHE = {  # data/woche.csv, 7 Tage
    "Deployment Frequency": (1.0, 0.05),
    "Lead Time for Changes": (4.0, 0.1),
    "Change Failure Rate": (2 / 7, 0.015),
    "Failed Deployment Recovery Time": (1.0, 0.06),
    "Rework Rate": (1 / 7, 0.015),
}
SHOP = {  # data/team-shop.csv, 14 Tage
    "Deployment Frequency": (9 / 14, 0.05),
    "Lead Time for Changes": (5.0, 0.1),
    "Change Failure Rate": (2 / 9, 0.015),
    "Failed Deployment Recovery Time": (1.525, 0.06),
    "Rework Rate": (1 / 9, 0.015),
}
SHOP_LEVELS = {
    "Deployment Frequency": "hoch",
    "Lead Time for Changes": "elite",
    "Change Failure Rate": "niedrig",
    "Failed Deployment Recovery Time": "hoch",
}
PERCENT = ("Change Failure Rate", "Rework Rate")

# deployed_at -> (committed_at, failed, restored_at)
PROD = {
    "2026-11-09T09:00": ("2026-11-09T07:00", False, None),
    "2026-11-10T15:00": ("2026-11-10T09:00", False, None),
    "2026-11-11T10:00": ("2026-11-11T07:00", True, "2026-11-11T10:03"),
    "2026-11-12T16:00": ("2026-11-11T20:00", False, None),
    "2026-11-13T11:00": ("2026-11-13T06:00", True, "2026-11-13T14:00"),
    "2026-11-13T14:00": ("2026-11-13T13:00", False, None),
    "2026-11-17T09:00": ("2026-11-15T07:00", False, None),
    "2026-11-18T13:00": ("2026-11-18T09:00", False, None),
    "2026-11-20T10:00": ("2026-11-20T02:00", False, None),
}

# ---- DOKUMENTATION.md -------------------------------------------------------
def section(title):
    try:
        text = open(doc_path, encoding="utf-8").read()
    except OSError:
        return ""
    text = re.sub(r"<!--.*?-->", "", text, flags=re.S)
    m = re.search(r"^## " + re.escape(title) + r".*?$(.*?)(?=^## |\Z)", text, re.S | re.M)
    return m.group(1) if m else ""

def table(title):
    rows = {}
    for line in section(title).splitlines():
        line = line.strip()
        if not line.startswith("|") or re.fullmatch(r"\|[\s:|-]+\|", line):
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        rows[cells[0].replace("*", "").strip()] = cells[1:]
    return rows

NUM = r"\d+(?:[.,]\d+)?"

def number(cell, metric):
    # Mit Rechenweg («2/7 = 28.6 %») zählt das Ergebnis nach dem letzten «=».
    cell = cell.replace("'", "").replace("÷", "/").split("=")[-1]
    m = re.search(rf"({NUM})\s*/\s*({NUM})", cell)
    if m:
        a, b = (float(x.replace(",", ".")) for x in m.groups())
        return a / b if b else None
    m = re.search(NUM, cell)
    if not m:
        return None
    value = float(m.group().replace(",", "."))
    if metric in PERCENT and ("%" in cell or value > 1):
        value /= 100
    return value

def values_ok(rows, col, soll, metrics):
    for metric in metrics:
        cells = rows.get(metric)
        if not cells or len(cells) <= col:
            return False
        value = number(cells[col], metric)
        target, tol = soll[metric]
        if value is None or abs(value - target) > tol:
            return False
    return True

# ---- data/team-shop.csv -----------------------------------------------------
def minute(text):
    text = (text or "").strip()
    if not text:
        return None
    try:
        t = datetime.fromisoformat(text.replace("Z", "+00:00"))
    except ValueError:
        return "ungültig"
    return t.strftime("%Y-%m-%dT%H:%M")

def shop():
    try:
        with open(shop_path, newline="", encoding="utf-8-sig") as handle:
            rows = list(csv.DictReader(handle))
    except OSError:
        return None
    return {minute(r.get("deployed_at")): r for r in rows}

def yes(text):
    return (text or "").strip().lower() in ("ja", "true", "1", "yes")

def check():
    if what == "p2a-throughput":
        return values_ok(table("P2a"), 0, WOCHE, ["Deployment Frequency", "Lead Time for Changes"])
    if what == "p2a-instability":
        return values_ok(table("P2a"), 0, WOCHE, ["Change Failure Rate", "Rework Rate"])
    if what == "p2a-recovery":
        return values_ok(table("P2a"), 0, WOCHE, ["Failed Deployment Recovery Time"])
    if what == "p2b-report":
        rows = table("P2b")
        if not values_ok(rows, 0, SHOP, list(SHOP)):
            return False
        return all(len(rows[m]) > 1 and SHOP_LEVELS[m] in rows[m][1].lower()
                   for m in SHOP_LEVELS)
    data = shop()
    if data is None:
        return False
    if what == "p2b-production":
        return set(data) == set(PROD)
    if not set(PROD) <= set(data):
        return False
    if what == "p2b-leadtime":
        return all(minute(data[k].get("committed_at")) == v[0] for k, v in PROD.items())
    if what == "p2b-failures":
        for k, (_, failed, restored) in PROD.items():
            row = data[k]
            if yes(row.get("failed")) != failed:
                return False
            if failed and minute(row.get("restored_at")) != restored:
                return False
        return True
    return False

sys.exit(0 if check() else 1)
PY
}

# P3 ist freiwillig: alle zehn Zellen der Vergleichstabelle gefüllt?
p3_filled() {
  python3 - "$DOC" <<'PY'
import re, sys
try:
    text = open(sys.argv[1], encoding="utf-8").read()
except OSError:
    sys.exit(1)
text = re.sub(r"<!--.*?-->", "", text, flags=re.S)
m = re.search(r"^## P3.*?$(.*?)(?=^## |\Z)", text, re.S | re.M)
if not m:
    sys.exit(1)
cells = []
for line in m.group(1).splitlines():
    line = line.strip()
    if line.startswith("|") and not re.fullmatch(r"\|[\s:|-]+\|", line):
        cells.append([c.strip() for c in line.strip("|").split("|")])
data = [r for r in cells[1:] if len(r) >= 3]
sys.exit(0 if len(data) >= 5 and all(re.search(r"\d", c) for r in data for c in r[1:3]) else 1)
PY
}

echo "🔍 Prüfe Abnahmekriterien für Tag 16 Praxis — DORA-Metriken"
echo ""

echo "── P2a: Eine Woche nachrechnen ──"

check "p2a-throughput" \
  "P2a: Deployment Frequency und Lead Time nachgerechnet" \
  "p2 p2a-throughput"

check "p2a-instability" \
  "P2a: Change Failure Rate und Rework Rate nachgerechnet" \
  "p2 p2a-instability"

check "p2a-recovery" \
  "P2a: Recovery Time nachgerechnet (Median nur über fehlgeschlagene Deployments)" \
  "p2 p2a-recovery"

echo ""
echo "── P2b: Rohdaten aufbereiten ──"

check "p2b-production" \
  "P2b: team-shop.csv enthält nur Produktions-Deployments aus der Pipeline" \
  "p2 p2b-production"

check "p2b-leadtime" \
  "P2b: team-shop.csv misst die Lead Time ab dem ersten Commit" \
  "p2 p2b-leadtime"

check "p2b-failures" \
  "P2b: team-shop.csv markiert Fehler nach der Kursdefinition" \
  "p2 p2b-failures"

check "p2b-report" \
  "P2b: Messwerte und Stufen in DOKUMENTATION.md eingetragen" \
  "p2 p2b-report"

echo ""
echo "── P3 (für Schnelle, nicht bewertet) ──"
if p3_filled; then
  echo "⭐ P3: Vergleich der beiden Teams ausgefüllt"
else
  echo "ℹ️  P3: Vergleichstabelle in DOKUMENTATION.md noch offen (freiwillig)"
fi

summary 16
