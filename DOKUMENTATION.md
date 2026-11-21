# Tag 16 Praxis – DORA-Metriken

## P1: Streitfälle

<!--
Entscheidet in der Gruppe jeden Fall mit «ja» oder «nein» und begründet die
Entscheidung in mindestens einem ganzen Satz. Es gibt nicht immer eine einzige
richtige Antwort, wichtig ist eine Begründung, die sich auf die Definitionen
aus der Theorie stützt. Jede Person überträgt das Ergebnis in ihr Repository.
-->

| Nr | Fall | Ja/Nein | Begründung |
|----|------|---------|------------|
| 1 | Ein Deployment wird nach drei Minuten automatisch zurückgerollt, keine Kundin hat etwas bemerkt. Ist es ein **fehlgeschlagenes Deployment**? | | |
| 2 | Das Team schaltet ein Feature Flag um, ohne neuen Code auszuliefern. Ist das ein **Deployment**? | | |
| 3 | Ein Deployment geht auf die Staging-Umgebung. Zählt es für die **Deployment Frequency**? | | |
| 4 | Ein Ausfall bei AWS legt den Shop zwei Stunden lahm. Zählt das für die **Change Failure Rate**? | | |
| 5 | Beginnt die **Lead Time** beim ersten Commit und nicht erst beim Merge des Pull Requests? | | |

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
