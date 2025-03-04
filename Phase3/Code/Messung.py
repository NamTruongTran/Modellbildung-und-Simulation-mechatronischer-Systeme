# -*- coding: utf-8 -*-
"""
Created on Thu Feb  2 15:00:07 2023

@author: Guehmann
"""
import numpy as np
from OMPython import OMCSessionZMQ
omc = OMCSessionZMQ()
from OMPython import ModelicaSystem

def InitSimul(Dauer):
    mod=ModelicaSystem("Aufgabe3DoE.mo","Aufgabe3DoE.Motor",
                      commandLineOptions="--allowNonStandardModelica=reinitInAlgorithms")
    # Schrittweite für die Simulation nicht verstellen!
    h = 1e-2
    # Simulieren mit Euler
    mod.setSimulationOptions(["stopTime="+str(Dauer),"stepSize=" + str(h),"solver=euler"])
    return mod
    
    
def Messen(mod, N,NOffset,alpha,alphaOffset,Start):
    h = 1e-2
    mod.setParameters(["Start=" + str(Start)])
    mod.setParameters(["NOffset=" + str(NOffset)])
    mod.setParameters(["WinkelAlpha=" + str(alpha)])
    mod.setParameters(["WinkelAlphaOffset=" + str(alphaOffset)])
    mod.setParameters(["N=" + str(N)])
    mod.simulate()
    # Daten extrahieren
    ZeitD = mod.getSolutions(['time'])
    MD = mod.getSolutions(['motormodell.M'])
    alphaD = mod.getSolutions(['motormodell.alpha'])
    Nd = mod.getSolutions(['motormodell.N'])
    # äquidisdaten Schrittweite erzeugen
    index = (np.diff(ZeitD) > h/3).nonzero()
    Zeit = ZeitD[index]
    M = MD[index]
    alphaM = alphaD[index]
    rpmM = Nd[index]
    return Zeit, M, rpmM, alphaM