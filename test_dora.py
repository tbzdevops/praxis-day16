"""Tests für dora.py. Nicht verändern: Die Bewertung prüft, dass diese Datei
unverändert ist.

Ausführen:
    python -m unittest -v                 # alle Tests
    python -m unittest -v test_dora.TestLeadTime   # nur eine Metrik
"""

import os
import tempfile
import unittest

import dora

# Zehn Deployments über fünf Tage. Lead Times: 1 bis 9 Stunden und einmal
# 30 Stunden. Zwei Deployments schlagen fehl (Erholung nach 0.5 h und 2.5 h),
# eines ist ein ungeplanter Hotfix.
PROTOKOLL = """deployed_at,committed_at,failed,restored_at,rework
2026-11-02T08:00:00Z,2026-11-02T07:00:00Z,nein,,nein
2026-11-02T14:00:00Z,2026-11-02T12:00:00Z,nein,,nein
2026-11-03T09:00:00Z,2026-11-03T06:00:00Z,ja,2026-11-03T09:30:00Z,nein
2026-11-03T11:00:00Z,2026-11-03T07:00:00Z,nein,,ja
2026-11-04T10:00:00Z,2026-11-04T05:00:00Z,nein,,nein
2026-11-04T16:00:00Z,2026-11-04T10:00:00Z,ja,2026-11-04T18:30:00Z,nein
2026-11-05T09:00:00Z,2026-11-05T02:00:00Z,nein,,nein
2026-11-05T15:00:00Z,2026-11-05T07:00:00Z,nein,,nein
2026-11-06T10:00:00Z,2026-11-06T01:00:00Z,nein,,nein
2026-11-06T17:00:00Z,2026-11-05T11:00:00Z,nein,,nein
"""

OHNE_FEHLER = """deployed_at,committed_at,failed,restored_at,rework
2026-11-02T08:00:00Z,2026-11-02T06:00:00Z,nein,,nein
2026-11-03T08:00:00Z,2026-11-03T04:00:00Z,nein,,nein
"""


def lade(text):
    fd, path = tempfile.mkstemp(suffix=".csv")
    with os.fdopen(fd, "w", encoding="utf-8") as handle:
        handle.write(text)
    try:
        return dora.load(path)
    finally:
        os.remove(path)


class Basis(unittest.TestCase):
    def setUp(self):
        self.deployments = lade(PROTOKOLL)
        self.ohne_fehler = lade(OHNE_FEHLER)


class TestProtokoll(Basis):
    def test_zehn_deployments_ueber_fuenf_tage(self):
        self.assertEqual(len(self.deployments), 10)
        self.assertEqual(dora.period_days(self.deployments), 5)


class TestDeploymentFrequency(Basis):
    def test_deployments_pro_tag(self):
        self.assertAlmostEqual(dora.deployment_frequency(self.deployments, 5), 2.0)

    def test_laengerer_zeitraum(self):
        self.assertAlmostEqual(dora.deployment_frequency(self.deployments, 20), 0.5)

    def test_ohne_deployments(self):
        self.assertEqual(dora.deployment_frequency([], 7), 0)


class TestLeadTime(Basis):
    def test_median_in_stunden(self):
        # Median von 1, 2, ..., 9 und 30: (5 + 6) / 2
        self.assertAlmostEqual(dora.lead_time_hours(self.deployments), 5.5)

    def test_gerade_anzahl(self):
        self.assertAlmostEqual(dora.lead_time_hours(self.ohne_fehler), 3.0)

    def test_ohne_deployments(self):
        self.assertIsNone(dora.lead_time_hours([]))


class TestChangeFailureRate(Basis):
    def test_anteil_fehlgeschlagen(self):
        self.assertAlmostEqual(dora.change_failure_rate(self.deployments), 0.2)

    def test_keine_fehler(self):
        self.assertEqual(dora.change_failure_rate(self.ohne_fehler), 0)

    def test_ohne_deployments(self):
        self.assertIsNone(dora.change_failure_rate([]))


class TestRecoveryTime(Basis):
    def test_median_der_fehlgeschlagenen(self):
        # Erholung nach 0.5 h und 2.5 h
        self.assertAlmostEqual(dora.recovery_time_hours(self.deployments), 1.5)

    def test_keine_fehler_keine_recovery(self):
        self.assertIsNone(dora.recovery_time_hours(self.ohne_fehler))


class TestReworkRate(Basis):
    def test_anteil_ungeplant(self):
        self.assertAlmostEqual(dora.rework_rate(self.deployments), 0.1)

    def test_ohne_deployments(self):
        self.assertIsNone(dora.rework_rate([]))


class TestClassify(unittest.TestCase):
    def test_frequency(self):
        self.assertEqual(dora.classify("frequency", 2.0), "Elite")
        self.assertEqual(dora.classify("frequency", 1.0), "Elite")
        self.assertEqual(dora.classify("frequency", 1 / 7), "Hoch")
        self.assertEqual(dora.classify("frequency", 0.1), "Mittel")
        self.assertEqual(dora.classify("frequency", 0.01), "Niedrig")

    def test_lead_time(self):
        self.assertEqual(dora.classify("lead_time", 5.5), "Elite")
        self.assertEqual(dora.classify("lead_time", 24), "Hoch")
        self.assertEqual(dora.classify("lead_time", 200), "Mittel")
        self.assertEqual(dora.classify("lead_time", 720), "Niedrig")

    def test_change_failure_rate(self):
        self.assertEqual(dora.classify("change_failure_rate", 0.05), "Elite")
        self.assertEqual(dora.classify("change_failure_rate", 0.1), "Hoch")
        self.assertEqual(dora.classify("change_failure_rate", 0.2), "Mittel")
        self.assertEqual(dora.classify("change_failure_rate", 0.4), "Niedrig")

    def test_recovery(self):
        self.assertEqual(dora.classify("recovery", 0.5), "Elite")
        self.assertEqual(dora.classify("recovery", 1.5), "Hoch")
        self.assertEqual(dora.classify("recovery", 30), "Mittel")
        self.assertEqual(dora.classify("recovery", 168), "Niedrig")

    def test_keine_daten(self):
        self.assertEqual(dora.classify("recovery", None), "–")


if __name__ == "__main__":
    unittest.main()
