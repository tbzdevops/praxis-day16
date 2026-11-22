#!/bin/bash
# PRAXIS Tag 16 — DORA-Metriken.
# Bewertet wird P2, der Rechenkern dora.py: je Kriterium eine Testklasse aus
# test_dora.py. Damit niemand die Tests anpasst, statt den Code zu reparieren,
# verlangt das letzte Kriterium, dass test_dora.py byte-gleich zur Vorlage ist
# (Zeilenenden normalisiert) und die ganze Suite grün läuft.
# P1 (Streitfälle) entscheidet die Gruppe auf dem Nimbus-Board, nicht im Repo.
# P3 in DOKUMENTATION.md ist freiwillig und zeigt nur ⭐ (grade.sh kennt keine
# optionalen Kriterien). Gezählt wird nur Text ausserhalb der HTML-Kommentare.
source .github/classroom/grade.sh

solution_for_id() {
  case "$1" in
    p2-frequency) echo "Implementiere deployment_frequency() in dora.py: Anzahl Deployments geteilt durch days. Test: python -m unittest -v test_dora.TestDeploymentFrequency" ;;
    p2-lead) echo "Implementiere lead_time_hours() in dora.py: Median von deployed_at - committed_at in Stunden (statistics.median, hours()). Test: python -m unittest -v test_dora.TestLeadTime" ;;
    p2-cfr) echo "Implementiere change_failure_rate() in dora.py: Anteil der Deployments mit failed. Test: python -m unittest -v test_dora.TestChangeFailureRate" ;;
    p2-recovery) echo "Implementiere recovery_time_hours() in dora.py: Median von restored_at - deployed_at, nur über fehlgeschlagene Deployments. Test: python -m unittest -v test_dora.TestRecoveryTime" ;;
    p2-rework) echo "Implementiere rework_rate() in dora.py: Anteil der Deployments mit rework. Test: python -m unittest -v test_dora.TestReworkRate" ;;
    p2-classify) echo "Implementiere classify() in dora.py nach der Kursskala im Docstring. Test: python -m unittest -v test_dora.TestClassify" ;;
    p2-tests) echo "Alle Tests müssen grün sein (python -m unittest -v), und test_dora.py muss der Vorlage entsprechen. Wiederherstellen: git checkout \$(git rev-list --max-parents=0 HEAD) -- test_dora.py" ;;
    *) echo "Überprüfe die Aufgabenstellung im README" ;;
  esac
}

DOC=DOKUMENTATION.md
TESTS_SHA256=56723be06772b6b71202051587582faadf0194208aaa35a4ecb2b2635e7be59b

# Läuft eine Testklasse aus test_dora.py grün?
tests_ok() {
  [ -f dora.py ] && [ -f test_dora.py ] || return 1
  python3 -m unittest "test_dora.$1" >/dev/null 2>&1
}

tests_unchanged() {
  [ -f test_dora.py ] || return 1
  python3 - "$TESTS_SHA256" <<'PY'
import hashlib, sys
data = open("test_dora.py", "rb").read().replace(b"\r\n", b"\n")
sys.exit(0 if hashlib.sha256(data).hexdigest() == sys.argv[1] else 1)
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

echo "── P2: Rechenkern dora.py ──"

check "p2-frequency" \
  "P2: Deployment Frequency korrekt berechnet" \
  "tests_ok TestDeploymentFrequency"

check "p2-lead" \
  "P2: Lead Time for Changes korrekt berechnet (Median in Stunden)" \
  "tests_ok TestLeadTime"

check "p2-cfr" \
  "P2: Change Failure Rate korrekt berechnet" \
  "tests_ok TestChangeFailureRate"

check "p2-recovery" \
  "P2: Failed Deployment Recovery Time korrekt berechnet" \
  "tests_ok TestRecoveryTime"

check "p2-rework" \
  "P2: Rework Rate korrekt berechnet" \
  "tests_ok TestReworkRate"

check "p2-classify" \
  "P2: Einordnung nach der Kursskala korrekt" \
  "tests_ok TestClassify"

check "p2-tests" \
  "P2: Alle Tests grün, test_dora.py unverändert" \
  "tests_unchanged && python3 -m unittest test_dora"

echo ""
echo "── P3 (für Schnelle, nicht bewertet) ──"
if p3_filled; then
  echo "⭐ P3: Vergleich der beiden Teams ausgefüllt"
else
  echo "ℹ️  P3: Vergleichstabelle in DOKUMENTATION.md noch offen (freiwillig)"
fi

summary 16
