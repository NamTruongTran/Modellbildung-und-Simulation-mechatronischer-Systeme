model Direkte_Umsetzung_Antrieb_Generator_Test  
  parameter Real LA1 = 3.75e-4;
  parameter Real RA1 = 8.25;
  parameter Real C1 = 51.5e-3;
  parameter Real Cmu1 = 3.248e-4;
  parameter Real J1 = 4.75e-5;
  parameter Real LA2 = 3.75e-4;
  parameter Real RA2 = 8.25;
  parameter Real C2 = 51.5e-3;
  parameter Real Cmu2 = 3.248e-4;
  parameter Real J2 = 4.75e-5;
  parameter Real RL = 10;
  Direkte_Umsetzung_Antrieb direkte_Umsetzung_Antrieb(C1 = 51.5e-3, Cmu1 = 3.248e-4, J1 = 4.75e-5, LA1 = 3.75e-4, RA1 = 8.25);
  Direkte_Umsetzung_Generator direkte_Umsetzung_Generator(C2 = 51.5e-3, Cmu2 = 3.248e-4, J2 = 4.75e-5, LA2 = 3.75e-4, RA2 = 8.25, RL = 10);
  Modelica.Blocks.Sources.Step step(height = 4, startTime = 2.004);
equation
  connect(direkte_Umsetzung_Antrieb.ML, direkte_Umsetzung_Generator.ML);
  connect(direkte_Umsetzung_Generator.wdot, direkte_Umsetzung_Antrieb.wDot);
  connect(direkte_Umsetzung_Generator.w, direkte_Umsetzung_Antrieb.w);
  connect(step.y, direkte_Umsetzung_Antrieb.u1);
end Direkte_Umsetzung_Antrieb_Generator_Test;

model Direkte_Umsetzung_Generator  
  parameter Real LA2 = 3.75e-4;
  parameter Real RA2 = 8.25;
  parameter Real C2 = 51.5e-3;
  parameter Real Cmu2 = 3.248e-4;
  parameter Real J2 = 4.75e-5;
  parameter Real RL = 10;
  Modelica.Blocks.Continuous.Integrator integrator;
  Modelica.Blocks.Math.Gain gain4(k = C2 / LA2);
  Modelica.Blocks.Math.Gain gain2(k = C2 / J2);
  Modelica.Blocks.Math.Add3 add1(k1 = -1, k2 = 1, k3 = -1);
  Modelica.Blocks.Math.Gain gain1(k = 1 / J2);
  Modelica.Blocks.Math.Gain gain3(k = Cmu2 / J2);
  Modelica.Blocks.Continuous.Integrator integrator2;
  Modelica.Blocks.Math.Add add2(k1 = -1, k2 = 1);
  Modelica.Blocks.Math.Gain gain5(k = (RA2 + RL) / LA2);
  Modelica.Blocks.Math.Gain gain6(k = RL);
  Modelica.Blocks.Interfaces.RealInput ML;
  Modelica.Blocks.Interfaces.RealOutput UA;
  Modelica.Blocks.Interfaces.RealOutput w;
  Modelica.Blocks.Interfaces.RealOutput wdot;
equation
  connect(gain1.y, add1.u2);
  connect(gain2.y, add1.u1);
  connect(add1.y, integrator.u);
  connect(gain3.y, add1.u3);
  connect(add2.y, integrator2.u);
  connect(gain3.u, integrator.y);
  connect(gain2.u, integrator2.y);
  connect(gain5.u, integrator2.y);
  connect(gain5.y, add2.u1);
  connect(gain4.y, add2.u2);
  connect(gain6.u, integrator2.y);
  connect(gain4.u, integrator.y);
  connect(w, integrator.y);
  connect(gain6.y, UA);
  connect(wdot, add1.y);
  connect(ML, gain1.u);
end Direkte_Umsetzung_Generator;

model Direkte_Umsetzung_Antrieb  
  parameter Real LA1 = 3.75e-4;
  parameter Real RA1 = 8.25;
  parameter Real C1 = 51.5e-3;
  parameter Real Cmu1 = 3.248e-4;
  parameter Real J1 = 4.75e-5;
  Modelica.Blocks.Math.Add3 add1(k1 = -1, k2 = 1, k3 = -1);
  Modelica.Blocks.Math.Gain gain1(k = 1 / LA1);
  Modelica.Blocks.Math.Gain gain2(k = RA1 / LA1);
  Modelica.Blocks.Math.Gain gain3(k = C1 / LA1);
  Modelica.Blocks.Math.Add3 add2(k1 = 1, k2 = -1, k3 = -1);
  Modelica.Blocks.Math.Gain gain5(k = Cmu1);
  Modelica.Blocks.Math.Gain gain6(k = J1);
  Modelica.Blocks.Continuous.Integrator integrator;
  Modelica.Blocks.Math.Gain gain4(k = C1);
  Modelica.Blocks.Interfaces.RealInput u1;
  Modelica.Blocks.Interfaces.RealInput w;
  Modelica.Blocks.Interfaces.RealInput wDot;
  Modelica.Blocks.Interfaces.RealOutput ML;
equation
  connect(gain1.y, add1.u2);
  connect(gain2.y, add1.u1);
  connect(gain3.y, add1.u3);
  connect(integrator.u, add1.y);
  connect(gain5.y, add2.u2);
  connect(gain6.y, add2.u3);
  connect(gain4.u, integrator.y);
  connect(gain4.y, add2.u1);
  connect(u1, gain1.u);
  connect(w, gain3.u);
  connect(wDot, gain6.u);
  connect(ML, add2.y);
  connect(gain5.u, w);
  connect(gain2.u, integrator.y);
end Direkte_Umsetzung_Antrieb;

package Modelica  "Modelica Standard Library - Version 3.2.3" 
  extends Modelica.Icons.Package;

  package Blocks  "Library of basic input/output control blocks (continuous, discrete, logical, table blocks)" 
    extends Modelica.Icons.Package;

    package Continuous  "Library of continuous control blocks with internal states" 
      extends Modelica.Icons.Package;

      block Integrator  "Output the integral of the input signal with optional reset" 
        parameter Real k(unit = "1") = 1 "Integrator gain";
        parameter Boolean use_reset = false "=true, if reset port enabled" annotation(Evaluate = true, HideResult = true);
        parameter Boolean use_set = false "=true, if set port enabled and used as reinitialization value when reset" annotation(Evaluate = true, HideResult = true);
        parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.InitialState "Type of initialization (1: no init, 2: steady state, 3,4: initial output)" annotation(Evaluate = true);
        parameter Real y_start = 0 "Initial or guess value of output (= state)";
        extends .Modelica.Blocks.Interfaces.SISO(y(start = y_start));
        Modelica.Blocks.Interfaces.BooleanInput reset if use_reset "Optional connector of reset signal";
        Modelica.Blocks.Interfaces.RealInput set if use_reset and use_set "Optional connector of set signal";
      protected
        Modelica.Blocks.Interfaces.BooleanOutput local_reset annotation(HideResult = true);
        Modelica.Blocks.Interfaces.RealOutput local_set annotation(HideResult = true);
      initial equation
        if initType == .Modelica.Blocks.Types.Init.SteadyState then
          der(y) = 0;
        elseif initType == .Modelica.Blocks.Types.Init.InitialState or initType == .Modelica.Blocks.Types.Init.InitialOutput then
          y = y_start;
        end if;
      equation
        if use_reset then
          connect(reset, local_reset);
          if use_set then
            connect(set, local_set);
          else
            local_set = y_start;
          end if;
          when local_reset then
            reinit(y, local_set);
          end when;
        else
          local_reset = false;
          local_set = 0;
        end if;
        der(y) = k * u;
      end Integrator;
    end Continuous;

    package Interfaces  "Library of connectors and partial models for input/output blocks" 
      extends Modelica.Icons.InterfacesPackage;
      connector RealInput = input Real "'input Real' as connector";
      connector RealOutput = output Real "'output Real' as connector";
      connector BooleanInput = input Boolean "'input Boolean' as connector";
      connector BooleanOutput = output Boolean "'output Boolean' as connector";

      partial block SO  "Single Output continuous control block" 
        extends Modelica.Blocks.Icons.Block;
        RealOutput y "Connector of Real output signal";
      end SO;

      partial block SISO  "Single Input Single Output continuous control block" 
        extends Modelica.Blocks.Icons.Block;
        RealInput u "Connector of Real input signal";
        RealOutput y "Connector of Real output signal";
      end SISO;

      partial block SI2SO  "2 Single Input / 1 Single Output continuous control block" 
        extends Modelica.Blocks.Icons.Block;
        RealInput u1 "Connector of Real input signal 1";
        RealInput u2 "Connector of Real input signal 2";
        RealOutput y "Connector of Real output signal";
      end SI2SO;

      partial block SignalSource  "Base class for continuous signal source" 
        extends SO;
        parameter Real offset = 0 "Offset of output signal y";
        parameter .Modelica.SIunits.Time startTime = 0 "Output y = offset for time < startTime";
      end SignalSource;
    end Interfaces;

    package Math  "Library of Real mathematical functions as input/output blocks" 
      extends Modelica.Icons.Package;

      block Gain  "Output the product of a gain value with the input signal" 
        parameter Real k(start = 1, unit = "1") "Gain value multiplied with input signal";
        .Modelica.Blocks.Interfaces.RealInput u "Input signal connector";
        .Modelica.Blocks.Interfaces.RealOutput y "Output signal connector";
      equation
        y = k * u;
      end Gain;

      block Add  "Output the sum of the two inputs" 
        extends .Modelica.Blocks.Interfaces.SI2SO;
        parameter Real k1 = +1 "Gain of input signal 1";
        parameter Real k2 = +1 "Gain of input signal 2";
      equation
        y = k1 * u1 + k2 * u2;
      end Add;

      block Add3  "Output the sum of the three inputs" 
        extends Modelica.Blocks.Icons.Block;
        parameter Real k1 = +1 "Gain of input signal 1";
        parameter Real k2 = +1 "Gain of input signal 2";
        parameter Real k3 = +1 "Gain of input signal 3";
        .Modelica.Blocks.Interfaces.RealInput u1 "Connector of Real input signal 1";
        .Modelica.Blocks.Interfaces.RealInput u2 "Connector of Real input signal 2";
        .Modelica.Blocks.Interfaces.RealInput u3 "Connector of Real input signal 3";
        .Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal";
      equation
        y = k1 * u1 + k2 * u2 + k3 * u3;
      end Add3;
    end Math;

    package Sources  "Library of signal source blocks generating Real, Integer and Boolean signals" 
      extends Modelica.Icons.SourcesPackage;

      block Step  "Generate step signal of type Real" 
        parameter Real height = 1 "Height of step";
        extends .Modelica.Blocks.Interfaces.SignalSource;
      equation
        y = offset + (if time < startTime then 0 else height);
      end Step;
    end Sources;

    package Types  "Library of constants, external objects and types with choices, especially to build menus" 
      extends Modelica.Icons.TypesPackage;
      type Init = enumeration(NoInit "No initialization (start values are used as guess values with fixed=false)", SteadyState "Steady state initialization (derivatives of states are zero)", InitialState "Initialization with initial states", InitialOutput "Initialization with initial outputs (and steady state of the states if possible)") "Enumeration defining initialization of a block" annotation(Evaluate = true);
    end Types;

    package Icons  "Icons for Blocks" 
      extends Modelica.Icons.IconsPackage;

      partial block Block  "Basic graphical layout of input/output block" end Block;
    end Icons;
  end Blocks;

  package Icons  "Library of icons" 
    extends Icons.Package;

    partial package Package  "Icon for standard packages" end Package;

    partial package InterfacesPackage  "Icon for packages containing interfaces" 
      extends Modelica.Icons.Package;
    end InterfacesPackage;

    partial package SourcesPackage  "Icon for packages containing sources" 
      extends Modelica.Icons.Package;
    end SourcesPackage;

    partial package TypesPackage  "Icon for packages containing type definitions" 
      extends Modelica.Icons.Package;
    end TypesPackage;

    partial package IconsPackage  "Icon for packages containing icons" 
      extends Modelica.Icons.Package;
    end IconsPackage;
  end Icons;

  package SIunits  "Library of type and unit definitions based on SI units according to ISO 31-1992" 
    extends Modelica.Icons.Package;
    type Time = Real(final quantity = "Time", final unit = "s");
  end SIunits;
  annotation(version = "3.2.3", versionBuild = 4, versionDate = "2019-01-23", dateModified = "2020-06-04 11:00:00Z"); 
end Modelica;

model Direkte_Umsetzung_Antrieb_Generator_Test_total
  extends Direkte_Umsetzung_Antrieb_Generator_Test;
end Direkte_Umsetzung_Antrieb_Generator_Test_total;
