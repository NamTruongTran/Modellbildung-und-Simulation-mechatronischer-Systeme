import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from scipy import signal


###################################  Aufgabe 2  #########################################
def paramSchätzung(outArr, inArr, na, nb):
    """
    Schätzt die Parameter eines linearen, zeitinvarianten Systems mit MKQ.
      - param  inArr: Array mit Eingangsgrößen u(k)
      - param outArr: Array mit Ausgangswerten y(k)
      - param na    : Anzahl der Rückführungen von y
      - param nb    : Anzahl der Rückführungen von u
      - return      : Geschätzte Parameter (theta), Matrix Psi (Regressionsmatrix)
    """
    # Bedingung prüfen: na ≥ nb
    if na < nb:
        raise ValueError("Fehler: 'na' muss größer oder gleich 'nb' sein (na ≥ nb).")

    # Anzahl der Messwerte
    N = len(outArr)

    # Init Regressionsmatrix PSI
    psi = np.zeros((N - na, na + nb))

    # Füllen der Matrix Psi mit Verzögerungen von y
    for j in range(na):
        for i in range(len(psi)):
            psi[i, j] = outArr[i + na - 1 - j]

    # Füllen der Matrix Psi mit Verzögerungen von u
    for j in range(na, na + nb):
        for i in range(len(psi)):
            index = i + na - 1 - j + nb
            psi[i, j] = inArr[index]

    outArr = outArr[na:]

    # Berechnung der Parameterschätzung mit der Methode der kleinsten Quadrate
    theta_est = np.linalg.pinv(psi.T @ psi) @ psi.T @ outArr

    return theta_est, psi, outArr


def test_paramSchätzung():
    print("\n===== Starte Test der Funktion paramSchaetzung =====\n")

    # Test 1: Dummy-Daten definieren
    na, nb, N = 2, 2, 10
    dummy_params = np.array([0.5, -0.3, 1.2, -0.7])

    # Test 2: Künstliche Systemdaten generieren
    y = np.zeros(N)
    u = np.random.uniform(-1, 1, N)  # Zufällige Eingangsfolge

    for k in range(max(na, nb), N):
        y[k] = (
            -dummy_params[0] * y[k - 1]
            - dummy_params[1] * y[k - 2]
            + dummy_params[2] * u[k - 1]
            + dummy_params[3] * u[k - 2]
            + np.random.normal(0, 0.01)  # Kleines Messrauschen
        )

    # Test 3: Parameteridentifikation ausführen
    estimated_params, psi, outArr = paramSchätzung(y, u, na, nb)

    print("Wahre Parameter:     ", dummy_params)
    print("Geschätzte Parameter:", estimated_params)

    # Überprüfung der Werte (ungefähr gleich mit einer gewissen Toleranz)
    error = np.abs(estimated_params - dummy_params)
    print("Abweichung der geschätzten Parameter:", error)


# Test ausführen
test_paramSchätzung()
###################################  Aufgabe 2.1  #########################################


###################################  Aufgabe 2.2  #########################################

plt.close("all")

# Setzte Parametrisierung na outputs und nb inputs
na = 5
nb = 4

# Start und Dauer setzen
Start = 3
Dauer = 10

# Pfad zur CSV-Datei
# csv_file = "Daten_Aufgabe2/5000rpm_40_80.csv"
csv_file = "Daten_Aufgabe2/1000rpm_60_80.csv"

# Einlesen
df = pd.read_csv(csv_file)

# Extrahiere Spalten aus Dataframe und speichere sie in Listen
time = df["time"].tolist()
drehzahl_N = df["motormodellAufgabe3_me_FMU.N"].tolist()
alpha_a = df["motormodellAufgabe3_me_FMU.alpha"].tolist()
motormodellAufgabe3_me_FMU_M = df["motormodellAufgabe3_me_FMU.M"].tolist()

# Umwandlung der Listen in Numpy-Arrays
Zeit = np.array(time)
drehzahl = np.array(drehzahl_N)
alpha = np.array(alpha_a)
M = np.array(motormodellAufgabe3_me_FMU_M)

# Sprungantwort herausschneiden
index = (Zeit > Start - 0.03).nonzero()
Zeit = Zeit[index]
drehzahl = drehzahl[index]
alpha = alpha[index]
M = M[index]

# die Änderung des Moments am Arbeitspunkt
DeltaM = M - M[0]
DeltaAlpha = alpha - alpha[0]

# Erstelle Figure mit GridSpec für flexiblere Anordnung
fig = plt.figure(figsize=(10, 6))
gs = fig.add_gridspec(2, 2, height_ratios=[1, 2])

# Oberer Bereich: Zwei nebeneinander liegende Plots
ax1 = fig.add_subplot(gs[0, 0])
ax2 = fig.add_subplot(gs[0, 1])

ax1.plot(Zeit.T, drehzahl.T, color="red")
ax1.set_ylabel("N [rpm]")
ax1.set_xlim(Start - 0.05, Dauer)
ax1.set_title("Drehzahl")
ax1.grid(True)

ax2.plot(Zeit.T, DeltaAlpha.T, color="green")
ax2.set_ylabel(r"$\alpha$" + " " + " $[\degree]$")
ax2.set_xlim(Start - 0.05, Dauer)
ax2.set_title("Alpha")
ax2.grid(True)

# Unterer Bereich: Der große M-Plot über gesamte Breite
ax3 = fig.add_subplot(gs[1, :])
ax3.plot(Zeit.T, DeltaM.T, color="blue")
ax3.set_ylabel("M [Nm]")
ax3.set_xlim(Start - 0.05, Dauer)
ax3.set_xlabel("t [s]")
ax3.set_title("Moment")
ax3.grid(True)

# Layout anpassen
fig.tight_layout()
# plt.show()


###################  M(k) mit M(k)_Schätzung vergleichen  ###################
param_schätzung, psi, outArr = paramSchätzung(DeltaM, DeltaAlpha, na, nb)

# Nehme die Nennerkoeffizienten na (Ausgang)
a = (-param_schätzung[0:na]).flatten().tolist()

# Einfügen einer 1 als führenden Nennerkoeffizienten für ad
a = np.insert(a, 0, 1)

# Nehme die Zählerkoeffizienten nb (Eingang)
b = param_schätzung[na : na + nb].flatten().tolist()

# Drehmoment schätzen (filtert das Eingangssignal mit dem geschätzten Modell)
Mdach = signal.lfilter(b, a, DeltaAlpha)

fig = plt.figure()
plt.plot(Zeit, DeltaM, color="green")
plt.plot(Zeit, Mdach, color="red")
plt.title(r" Drehmoment ${M}(k)$ vs. DrehmomentSchätzung $\hat{M}(k)$")
plt.ylabel("M [Nm]")
plt.xlabel("t [s]")
plt.grid(True)

# Labels für die Legende
plt.plot(Zeit, DeltaM, color="green", label=r"$M(k)$")  # Normales M(k)
plt.plot(Zeit, Mdach, color="red", label=r"$\hat{M}(k)$")  # M(k) mit Dach
plt.legend()

plt.legend(loc="lower right")
plt.savefig("M(k)_vergleich_a2.pdf")

# plt.show()
###################  M(k) mit M(k)_Schätzung vergleichen  ###################


###################  Beurteilung des Modells mit mit Bestimmungsmaß R   ###################
def bestimmtheitsmaß_R2(Mdach, DeltaM):
    qs_res = np.sum((DeltaM - Mdach) ** 2)  # Residuen-Quadratsumme
    qs_tot = np.sum((DeltaM - np.mean(DeltaM)) ** 2)  # Gesamt-Quadratsumme
    R2 = 1 - (qs_res / qs_tot)
    return R2


# Berechnung des Bestimmtheitsmaßes R
R2 = bestimmtheitsmaß_R2(Mdach, DeltaM)
print(f"\nDas Bestimmungsmaß beträgt: {R2:.4f} \n")

##### RMSE Beurteilung
# def rmse(Mdach, DeltaM):
#     beurteilung = np.sqrt(((Mdach - DeltaM) ** 2).mean())
#     return beurteilung
# # Beurteilungs des Modells
# print(
#     "Der RMSE beträgt: {}".format(rmse(Mdach, DeltaM))
# )
###################  Beurteilung des Modells mit   ###################

################### Parameter ausgeben ###################
print("\nDie geschätzten Parameter sind:")
for i in range(na):
    print(f"a{i + 1} = {param_schätzung[i]:.4f}")

for j in range(nb):
    print(f"b{j + 1} = {param_schätzung[na + j]:.4f}")
################### Parameter ausgeben ###################

################### Laplace ###################
# Pfad zur CSV-Datei der Laplace-Simulation
csv_file2 = "Daten_Aufgabe2/laplace.csv"  # Passe den Pfad an

# CSV-Datei mit pandas einlesen
df_laplace = pd.read_csv(csv_file2)

# Extrahiere die relevanten Spalten (Spaltennamen ggf. anpassen!)
tlap = df_laplace["time"].values  # Zeitwerte
Mlap = df_laplace["transferFunction.y"].values  # Drehmoment-Werte aus der Simulation

# Auf gleiche Länge bringen wie ARX-Daten
Mlap = Mlap[300 : 300 + len(Zeit)]
tlap = tlap[300 : 300 + len(Zeit)]

plt.figure(figsize=(10, 5))

# ARX-Modell
# plt.plot(Zeit, DeltaM, color="green", label="ARX-Modell $M(k)$")
plt.plot(Zeit, Mdach, color="red", label="Schätzung-Modell $\hat{M}(k)$")

# Laplace-Modell
plt.plot(tlap, Mlap, color="blue", linestyle="dashed", label="Laplace-Modell $M_L(k)$")

plt.xlabel("t [s]")
plt.ylabel("M [Nm]")
plt.title("Schätz-Modell vs. Laplace-Modell")
plt.legend()
plt.grid(True)

plt.savefig("Vergleich_ARX_Laplace.pdf")
plt.show()
################### Laplace ###################

###################################  Aufgabe 2  #########################################
