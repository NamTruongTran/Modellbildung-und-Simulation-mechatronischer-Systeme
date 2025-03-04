# -*- coding: utf-8 -*-

import os
import numpy as np  # numpy - aehnlich wie mit MATLAB arbeiten
from numpy import linalg as la  # fuer die Eigenwertberechnung
import matplotlib.pyplot as plt  # zum plotten
from OMPython import ModelicaSystem  # Für die Steuerung von openModelica
from OMPython import OMCSessionZMQ
import pandas as pd
from scipy.interpolate import interp1d

########## WICHTIG : Auskommentieren bei Windows und Linux ##########
# Set the path to the OpenModelica executable
os.environ["PATH"] += os.pathsep + "/opt/openmodelica/bin"
########## WICHTIG : Auskommentieren bei Windows und Linux ##########

# für das Plotten
font = {"family": "sans-serif", "color": "black", "weight": "normal", "size": 14}

#### Simulationsschrittweite
### SystemZweiterOrdnungKausal
# h = 0.0001  # Simulationsschrittweite
### Antrieb oder Generator Testen
# h = 0.05
### Antrieb + Generator Testen
# h = 0.05
### PID-Regler
h = 0.05

##### Simulationszeit
### SystemZweiterOrdnungKausal
# STime = 0.2
### Antrieb oder Generator Testen
# STime = 2
### Antrieb oder Generator Testen
# STime = 4
### PID-Regler
STime = 30

omc = OMCSessionZMQ()

########## WICHTIG : Absoluten Pfad ändern nach deinem System ##########
# Objekt für die Simulation erzeugen
### Ohne Anfangswerte
# mod = ModelicaSystem(
#     "/Users/truong/Desktop/Uni/ModellbildungUndSimulationMechatronischerSysteme/Übungen/Übung1/SystemZweiterOrdnungKausalTotal.mo",
#     "SystemZweiterOrdnungKausal",
# )
### Mit Anfangswerte
# mod = ModelicaSystem(
#     "/Users/truong/Desktop/Uni/ModellbildungUndSimulationMechatronischerSysteme/Übungen/Übung1/SystemZweiterOrdnungKausalTotalResult.mo",
#     "SystemZweiterOrdnungKausal",
# )
### Antrieb Testen
# mod = ModelicaSystem(
#     "/Users/truong/Desktop/Uni/ModellbildungUndSimulationMechatronischerSysteme/Übungen/Übung1/Direkte_Umsetzung_Antrieb_TestTotal.mo",
#     "Direkte_Umsetzung_Antrieb_Test",
# )
# ### Generator Testen
# mod = ModelicaSystem(
#     "/Users/truong/Desktop/Uni/ModellbildungUndSimulationMechatronischerSysteme/Übungen/Übung1/Direkte_Umsetzung_Generator_TestTotal.mo",
#     "Direkte_Umsetzung_Generator_Test",
# )
### Antrieb+Generator Testen
mod2 = ModelicaSystem(
    "/Users/truong/Desktop/Uni/ModellbildungUndSimulationMechatronischerSysteme/Übungen/Übung1/Direkte_Umsetzung_Antrieb_Generator_TestTotal.mo",
    "Direkte_Umsetzung_Antrieb_Generator_Test",
)
### Antrieb+Generator Reale Messung
reale_messung_eingang = pd.read_csv("Reale_Messung_1.csv")  # Zeiten und Eingänge
reale_messung_daten = pd.read_csv("Reale_Messung_2.csv")  # Messdaten
### PID Messung
## 10 OHM
# mod = ModelicaSystem(
#     "/Users/truong/Desktop/Uni/ModellbildungUndSimulationMechatronischerSysteme/Übungen/Übung1/PID_ReglerTotal_10OHM.mo",
#     "PID_Regler",
# )
## 100 OHM
# mod = ModelicaSystem(
#     "/Users/truong/Desktop/Uni/ModellbildungUndSimulationMechatronischerSysteme/Übungen/Übung1/PID_ReglerTotal_100OHM.mo",
#     "PID_Regler",
# )
# 1000 OHM
mod = ModelicaSystem(
    "/Users/truong/Desktop/Uni/ModellbildungUndSimulationMechatronischerSysteme/Übungen/Übung1/PID_ReglerTotal_1000OHM.mo",
    "PID_Regler",
)
########## WICHTIG : Absoluten Pfad ändern nach deinem System ##########

# Simulationsparameter setzen
mod.setSimulationOptions(
    ### SystemZweiterOrdnungKausal
    # ["stopTime=" + str(STime), "stepSize=" + str(h), "solver=euler"]
    ### Antrieb & Generator Testen
    ["stopTime=" + str(STime), "stepSize=" + str(h), "solver=dassl"]
)
# Für Berechnung des Enrms
mod2.setSimulationOptions(
    ### SystemZweiterOrdnungKausal
    # ["stopTime=" + str(STime), "stepSize=" + str(h), "solver=euler"]
    ### Antrieb & Generator Testen
    ["stopTime=" + str(STime), "stepSize=" + str(h), "solver=dassl"]
)
mod2.simulate()
mod2.getSolutions()

# simulieren
mod.simulate()

# mit diesem Befehl werden alle Größen aufgelistet, die zur Auswertung
# zur Verfügung stehen

# Die simulierten Größen werden Python-Variablen zugewiesen
solutions = [
    ### SystemZweiterOrdnungKausal
    # mod.getSolutions(["time", "stateSpace1.y[1]", "pulse1.y"]),
    # mod.getSolutions(["time", "transferFunction.y", "pulse1.y"]),
    # mod.getSolutions(["time", "RCLDirekt.integrator2.y", "pulse1.y"]),
    ### Antrieb Testen
    # mod.getSolutions(["time", "direkte_Umsetzung_Antrieb.Mw", "step.y"]),
    ### Generator Testen
    # mod.getSolutions(["time", "direkte_Umsetzung_Generator.UA", "step.y"]),
    # mod.getSolutions(["time", "direkte_Umsetzung_Generator.integrator.y", "step.y"]),
    # mod.getSolutions(["time", "direkte_Umsetzung_Generator.add1.y", "step.y"]),
    ### Antrieb + Generator Testen
    ##Antrieb
    # mod.getSolutions(["time", "direkte_Umsetzung_Antrieb.ML", "step.y"]),
    # mod.getSolutions(["time", "direkte_Umsetzung_Antrieb.w", "step.y"]),
    # mod.getSolutions(["time", "direkte_Umsetzung_Antrieb.wDot", "step.y"]),
    ##Generator
    # mod.getSolutions(["time", "direkte_Umsetzung_Generator.UA", "step.y"]),
    # mod.getSolutions(["time", "direkte_Umsetzung_Generator.w", "step.y"]),
    # mod.getSolutions(["time", "direkte_Umsetzung_Generator.wdot", "step.y"]),
    ### PID-Regler
    mod.getSolutions(["time", "direkte_Umsetzung_Generator.UA", "step.y"]),
]

### Antrieb+Generator Reale Messung
## Die simulierten Größen werden Python-Variablen zugewiesen
simulation_zeit, simulation_generatorspannung = mod2.getSolutions(
    ["time", "direkte_Umsetzung_Generator.UA"]
)
## Interpolation der Simulationsdaten auf die realen Messzeitpunkte
zeit_messung = reale_messung_daten["Zeit[s]"]
sim_generatorspannung_interp = np.interp(
    zeit_messung, simulation_zeit, simulation_generatorspannung
)
## Reale Spannungsdaten extrahieren
y_mess = reale_messung_daten["Generatorspannung[V]"]
y_sim = sim_generatorspannung_interp
## Max und Min Werte der Messung für Berechnung "enrms"
N = len(y_mess)
max_mess = y_mess.max()
min_mess = y_mess.min()
## Metrik Fehlerberechnung
enrms = np.sqrt(np.sum(((y_mess - y_sim) / (max_mess - min_mess)) ** 2) / N)

## Zeit und Generatorspannung extrahieren
zeit = reale_messung_daten["Zeit[s]"]
generatorspannung = reale_messung_daten["Generatorspannung[V]"]

# äquidisdaten Schrittweite erzeugen
plt.figure(num=1)
labels = [
    ### SystemZweiterOrdnungKausal
    # "Zustandsraumdarstellung",
    # "Übertragungsfunktion",
    # "Direkte-Umsetzung",
    ### Antrieb Testen
    # "Antrieb",
    ### Generator Testen
    # "Ausgangsspannung",
    # "Winkelgeschw.",
    # "Winkelbeschleunigung",
    ### Antrieb + Generator Testen
    ##Antrieb
    # "Antrieb",
    ##Generator
    # "Generator",
    ### PID-Regler
    "PID Regler",
]
# Anpassbare Labels für die Kurven
colors = ["red", "green", "purple"]  # Farben für die Kurven

for i, (zeitD, yD, uD) in enumerate(solutions):
    index = (np.diff(zeitD) > h / 3).nonzero()
    Zeit = zeitD[index]
    y = yD[index]
    u = uD[index]

    if i == 0:
        plt.step(Zeit, u, c="blue", linestyle="--", label="Eingang $U_{{1}}$")

    ### SystemZweiterOrdnungKausal Testen
    # plt.step(Zeit, y, color=colors[i], label=f"Ausgang $y$ ({labels[i]})")
    ### Antrieb Testen
    # plt.plot(Zeit, y, color=colors[i], label=rf"Ausgang $M_{{L}}$ ({labels[i]})")
    ### Generator Testen
    # plt.plot(Zeit, y, color=colors[i], label=rf"Ausgang $U_{{A}}$ ({labels[i]})")
    # plt.plot(Zeit, y, color=colors[i], label=rf"Ausgang $\omega(t)$ ({labels[i]})")
    # plt.plot(Zeit, y, color=colors[i], label=rf"Ausgang $\dot\omega(t)$ ({labels[i]})")
    ### Antrieb + Generator Testen
    ##Antrieb
    # plt.plot(Zeit, y, color=colors[i], label=rf"Ausgang $M_{{L}}$ ({labels[i]})")
    # plt.plot(Zeit, y, color=colors[i], label=rf"Eingang $\omega(t)$ ({labels[i]})")
    # plt.plot(Zeit, y, color=colors[i], label=rf"Eingang $\dot\omega(t)$ ({labels[i]})")
    ##Generator
    # plt.plot(Zeit, y, color=colors[i], label=rf"Ausgang UA ({labels[i]})")
    # plt.plot(Zeit, y, color=colors[i], label=rf"Ausgang $\omega(t)$ ({labels[i]})")
    # plt.plot(Zeit, y, color=colors[i], label=rf"Ausgang $\dot\omega(t)$ ({labels[i]})")
    ### PID-Regler
    # plt.plot(Zeit, y, color=colors[i], label=rf"Ausgang $U_{{A}}$ (10$\Omega$)")
    # plt.plot(Zeit, y, color=colors[i], label=rf"Ausgang $U_{{A}}$ (100$\Omega$)")
    plt.plot(Zeit, y, color=colors[i], label=rf"Ausgang $U_{{A}}$ (1000$\Omega$)")

# Plot-Anpassungen
plt.xlabel("$Zeit$ $[s]$", fontdict=font)
plt.ylabel("$Amplitude$", fontdict=font)

### Antrieb+Generator Reale Messung
# plt.plot(zeit, generatorspannung, label="Reale Messung UA", color="blue")
# plt.xlabel("Zeit [s]")
# plt.ylabel("Generatorspannung [V]")
# plt.title("Reale Messung der Generatorspannung")

plt.xlim(0, max(Zeit))

### SystemZweiterOrdnungKausal
# plt.xlim([0, 0.07])
# plt.title("Möglichkeiten der Modellierung")
### Antrieb Testen
# plt.xlim([0, 2])
# plt.title("Antrieb Test mit Sprungfunktion")
### Generator Testen
# plt.xlim([0, 1.8])
# plt.title("Generator Test mit Sprungfunktion")
### Antrieb + Generator Testen
# plt.xlim([0, 3.8])
# plt.title("Antrieb und Generator Test mit Sprungfunktion")
### PID-Regler
plt.xlim([0, 30])
plt.title("PID-Regler zur Stabilisierung der Ausgangsspannung $U_{{A}}$")

plt.grid(True)
plt.legend()
### Antrieb + Generator Testen
##Antrieb
# plt.legend(loc="lower right")
# plt.legend(loc="upper left")
### PID-Regler
plt.legend(loc="lower right")

# hier kommt jetzt Ihre Eigenwertanalyse
# Parameter des Systems
L = 100.0e-3
R = 20.0
C = 100.0e-6

# Systemmatrix A aufstellen
A = np.array([[-R / L, -1 / L], [1 / C, 0]])

######### Eigenwertanalyse #########

# Eigenwerte bestimmen
print("**************************************")
eigenwerte, eigenvektoren = la.eig(A)
print("\n Eigenwerte des Systems:", eigenwerte)  # λ1 = −100+300j und λ2=−100−300j

# λ = a ± j * b
# In einem typischen RLC-System die Eigenwerte ein konjugiert komplexes Paar sind.
# Das bedeutet, dass der zweite Eigenwert nur das Spiegelbild des ersten in Bezug auf die Realachse ist.
a = eigenwerte.real[0]
b = np.abs(eigenwerte.imag[0])

# Eigenfrequenz ausrechnen
# Achtung homogene Laesung hierzu erzeugen!!
# hier steht Ihr Code
f = 1 / np.pi / 2 * b  # Frequenz in Herz
print("\n Die Eigenfrequenz beträgt: {:.5f}".format(f))

# Daempfung ausrechnen
# hier steht Ihr Code
D = -(a / np.sqrt(a**2 + b**2))
print("\n Das Dämpfungsmaß D beträgt: {:.5f}".format(D))

# Berechnung Verhaeltniss
Verhaeltniss = np.exp(-(2 * np.pi * D) / (np.sqrt(1 - D**2)))
print("\n Das Verhaeltniss beträgt: {:.5f} \n".format(Verhaeltniss))
print("**************************************")

# Print Enrms
print("\n**************************************")
print(f"\nNormalisierter RMSE-Fehler: {enrms:.2%}")
## Validierung
if enrms < 0.05:
    print("\nSehr gute Übereinstimmung (< 5%).")
elif enrms < 0.30:
    print("\nGute Übereinstimmung (< 30%).")
else:
    print("\nNur qualitative Aussage (> 30%).")
print("\n**************************************\n")

# Vergleich mit Plot
# hier steht Ihr Code
plt.show()
