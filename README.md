# Automatisierungtechnik: Modellbildung-und-Simulation-mechatronischer-Systeme

## Content

„Dieses Repository basiert auf dem Kurs „Modellbildung und Simulation mechatronischer Systeme“ an der Technischen Universität Berlin, der ein obligatorischer Teilbereich des Kurses [„Simulation und Technische Diagnose“](https://moseskonto.tu-berlin.de/moses/modultransfersystem/bolognamodule/beschreibung/anzeigen.html?nummer=40706&version=10&sprache=de) ist.“

Ziel ist es verschiedene Modellierungsverfahren kennenzulernen und Anwendungsbeispiele mit der Software Modellica umzusetzten. Dazu wurden 3 Pratikas absolviert jeweils für die Themen:

- Praktika 1: Physikalisch-orientierte Modellbildung und Simulation – kausal
- Praktika 2: Physikalisch-orientierte Modellbildung und Simulation – akausal
- Praktika 3:           Datenbasierte Modellbildung                 – Identifikation

Im folgenden, werden die einzelnen Teilbereiche näher erläutert. 

## Vorwort

Die Modellierung und Simulation von Maschinen ist eine wichtige Voraussetzung für die Umsetzung realer Projekte. Sie bietet die Möglichkeit, den realen Prozess abstrakt mit verschiedener Software darzustellen. Zudem bringt die Modellierung viele Vorteile mit sich: Zum Beispiel können erhebliche Kosten eingespart und die Sicherheit durch zahlreiche Tests gewährleistet werden, ohne das physische System zu beschädigen.
Die nachfolgenden Inhalte stützen sich auf die Konzepte von Model-in-the-Loop (MiL) und Software-in-the-Loop (SiL). Diese Phasen beinhalten die Erstellung physikalischer und datenbasierter Modelle sowie deren Simulation mit numerischen Verfahren.
Nach einer erfolgreichen Testphase mit MiL und SiL kann im nächsten Schritt Hardware-in-the-Loop (HiL) eingesetzt werden (dies wird hier nicht betrachtet). Dabei wird das Steuergerät in das Simulationssystem integriert.

### Physikalisch-orientierte Modellbildung und Simulation – kausal

In der ersten Phase wird die physikalisch-orientierte Modellbildung basierend auf Basis von Differenzial-Algebraischen Gleichungen untersucht. Dabei liegt der Fokus auf eine Signal-flussorientierte (kausale) Modellierung. Es wurde eine Scheibläufermaschine in Modellica simuliert und eine reale Messung (mit Antrieb, Generator und Drehzahlmesser) durchgeführt. Ziel ist es, die gemessenen Werte mit den Simulationswerte zu vergleichen, um am Ende eine Aussage über die Übereinstimmung zu treffen. Es gibt drei verschiedene Umsetzungsmöglichkeiten: die Zustandsraumdarstellung, die Übertragungsfunktion oder die direkte Umsetzung mittels Blockschaltbild. In Modelica wurde das Modell mithilfe der direkten Umsetzung (Blockschaltbild) simuliert. Nach der realen Messung wurden die Werte mithilfe des normalisierten Root-Mean-Square-Error ausgewertet. 
Das Protkoll zu dem Versuch kann hier angeschaut werden: 
[Google Drive](https://drive.google.com/file/d/1h5TW_BGzKsXgrvK_b4RTWAj3D2FF_GCN/view?usp=sharing)

Einige Ergebnisse sind in folgenden ausgeführt:



### Physikalisch-orientierte Modellbildung und Simulation – akausal

In der zweiten Phase

### Datenbasierte Modellbildung – Identifikation

In der dritten Phase 

Für die datenbasierte Modellierung und Simulation werden Methoden der Prozessidentifikation (Methode der kleinsten Fehlerquadrate) sowohl für den dynamischen als auch für den statischen Fall erarbeitet.

Grundlagen der objektorientierten und Signal-flussorientierten Modellbildung
Wiederholung:  Systemdarstellung dynamischer Systeme - Differenzialgleichungen, Zustandsraum, Übertragungsfunktionen
Grundlagen der Simulation: Integrationsverfahren
Grundlagen der datenbasierten Modellbildung 
statistischen Versuchsplanung (DoE) zur Modellierung
Grundlagen zur Systemidentifikation und Simulation
