model PID_Regler  
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
  Direkte_Umsetzung_Generator direkte_Umsetzung_Generator(C2 = 51.5e-3, Cmu2 = 3.248e-4, J2 = 4.75e-5, LA2 = 3.75e-4, RA2 = 8.25, RL = 10);
  Direkte_Umsetzung_Antrieb direkte_Umsetzung_Antrieb(C1 = 51.5e-3, Cmu1 = 3.248e-4, J1 = 4.75e-5, LA1 = 3.75e-4, RA1 = 8.25);
  Modelica.Blocks.Sources.Step step(height = 4, startTime = 2.004);
  Modelica.Blocks.Continuous.LimPID pid(limitsAtInit = true, withFeedForward = false, xd_start = 0, xi_start = 0, yMax = 1500, y_start = 0);
equation
  connect(direkte_Umsetzung_Antrieb.ML, direkte_Umsetzung_Generator.ML);
  connect(direkte_Umsetzung_Generator.wdot, direkte_Umsetzung_Antrieb.wDot);
  connect(direkte_Umsetzung_Generator.w, direkte_Umsetzung_Antrieb.w);
  connect(direkte_Umsetzung_Generator.UA, pid.u_m);
  connect(pid.y, direkte_Umsetzung_Antrieb.u1);
  connect(step.y, pid.u_s);
end PID_Regler;

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

package ModelicaServices  "ModelicaServices (OpenModelica implementation) - Models and functions used in the Modelica Standard Library requiring a tool specific implementation" 
  extends Modelica.Icons.Package;

  package Machine  "Machine dependent constants" 
    extends Modelica.Icons.Package;
    final constant Real eps = 1e-15 "Biggest number such that 1.0 + eps = 1.0";
    final constant Real small = 1e-60 "Smallest number such that small and -small are representable on the machine";
    final constant Real inf = 1e60 "Biggest Real number such that inf and -inf are representable on the machine";
    final constant Integer Integer_inf = OpenModelica.Internal.Architecture.integerMax() "Biggest Integer number such that Integer_inf and -Integer_inf are representable on the machine";
  end Machine;
  annotation(version = "3.2.3", versionBuild = 4, versionDate = "2019-01-23", dateModified = "2020-06-04 11:00:00Z"); 
end ModelicaServices;

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

      block Derivative  "Approximated derivative block" 
        parameter Real k(unit = "1") = 1 "Gains";
        parameter .Modelica.SIunits.Time T(min = Modelica.Constants.small) = 0.01 "Time constants (T>0 required; T=0 is ideal derivative block)";
        parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.NoInit "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)" annotation(Evaluate = true);
        parameter Real x_start = 0 "Initial or guess value of state";
        parameter Real y_start = 0 "Initial value of output (= state)";
        extends .Modelica.Blocks.Interfaces.SISO;
        output Real x(start = x_start) "State of block";
      protected
        parameter Boolean zeroGain = abs(k) < Modelica.Constants.eps;
      initial equation
        if initType == .Modelica.Blocks.Types.Init.SteadyState then
          der(x) = 0;
        elseif initType == .Modelica.Blocks.Types.Init.InitialState then
          x = x_start;
        elseif initType == .Modelica.Blocks.Types.Init.InitialOutput then
          if zeroGain then
            x = u;
          else
            y = y_start;
          end if;
        end if;
      equation
        der(x) = if zeroGain then 0 else (u - x) / T;
        y = if zeroGain then 0 else k / T * (u - x);
      end Derivative;

      block LimPID  "P, PI, PD, and PID controller with limited output, anti-windup compensation, setpoint weighting and optional feed-forward" 
        extends Modelica.Blocks.Interfaces.SVcontrol;
        output Real controlError = u_s - u_m "Control error (set point - measurement)";
        parameter .Modelica.Blocks.Types.SimpleController controllerType = .Modelica.Blocks.Types.SimpleController.PID "Type of controller";
        parameter Real k(min = 0, unit = "1") = 1 "Gain of controller";
        parameter Modelica.SIunits.Time Ti(min = Modelica.Constants.small) = 0.5 "Time constant of Integrator block";
        parameter Modelica.SIunits.Time Td(min = 0) = 0.1 "Time constant of Derivative block";
        parameter Real yMax(start = 1) "Upper limit of output";
        parameter Real yMin = -yMax "Lower limit of output";
        parameter Real wp(min = 0) = 1 "Set-point weight for Proportional block (0..1)";
        parameter Real wd(min = 0) = 0 "Set-point weight for Derivative block (0..1)";
        parameter Real Ni(min = 100 * Modelica.Constants.eps) = 0.9 "Ni*Ti is time constant of anti-windup compensation";
        parameter Real Nd(min = 100 * Modelica.Constants.eps) = 10 "The higher Nd, the more ideal the derivative block";
        parameter Boolean withFeedForward = false "Use feed-forward input?" annotation(Evaluate = true);
        parameter Real kFF = 1 "Gain of feed-forward input";
        parameter .Modelica.Blocks.Types.InitPID initType = .Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)" annotation(Evaluate = true);
        parameter Real xi_start = 0 "Initial or guess value for integrator output (= integrator state)";
        parameter Real xd_start = 0 "Initial or guess value for state of derivative block";
        parameter Real y_start = 0 "Initial value of output";
        parameter Modelica.Blocks.Types.LimiterHomotopy homotopyType = Modelica.Blocks.Types.LimiterHomotopy.Linear "Simplified model for homotopy-based initialization" annotation(Evaluate = true);
        parameter Boolean strict = false "= true, if strict limits with noEvent(..)" annotation(Evaluate = true);
        parameter Boolean limitsAtInit = true "Has no longer an effect and is only kept for backwards compatibility (the implementation uses now the homotopy operator)" annotation(Evaluate = true);
        constant Modelica.SIunits.Time unitTime = 1 annotation(HideResult = true);
        Modelica.Blocks.Interfaces.RealInput u_ff if withFeedForward "Optional connector of feed-forward input signal";
        Modelica.Blocks.Math.Add addP(k1 = wp, k2 = -1);
        Modelica.Blocks.Math.Add addD(k1 = wd, k2 = -1) if with_D;
        Modelica.Blocks.Math.Gain P(k = 1);
        Modelica.Blocks.Continuous.Integrator I(k = unitTime / Ti, y_start = xi_start, initType = if initType == .Modelica.Blocks.Types.InitPID.SteadyState then .Modelica.Blocks.Types.Init.SteadyState else if initType == .Modelica.Blocks.Types.InitPID.InitialState or initType == .Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState then .Modelica.Blocks.Types.Init.InitialState else .Modelica.Blocks.Types.Init.NoInit) if with_I;
        Modelica.Blocks.Continuous.Derivative D(k = Td / unitTime, T = max([Td / Nd, 1.e-14]), x_start = xd_start, initType = if initType == .Modelica.Blocks.Types.InitPID.SteadyState or initType == .Modelica.Blocks.Types.InitPID.InitialOutput then .Modelica.Blocks.Types.Init.SteadyState else if initType == .Modelica.Blocks.Types.InitPID.InitialState then .Modelica.Blocks.Types.Init.InitialState else .Modelica.Blocks.Types.Init.NoInit) if with_D;
        Modelica.Blocks.Math.Gain gainPID(k = k);
        Modelica.Blocks.Math.Add3 addPID;
        Modelica.Blocks.Math.Add3 addI(k2 = -1) if with_I;
        Modelica.Blocks.Math.Add addSat(k1 = +1, k2 = -1) if with_I;
        Modelica.Blocks.Math.Gain gainTrack(k = 1 / (k * Ni)) if with_I;
        Modelica.Blocks.Nonlinear.Limiter limiter(uMax = yMax, uMin = yMin, strict = strict, limitsAtInit = limitsAtInit, homotopyType = homotopyType);
      protected
        parameter Boolean with_I = controllerType == .Modelica.Blocks.Types.SimpleController.PI or controllerType == .Modelica.Blocks.Types.SimpleController.PID annotation(Evaluate = true, HideResult = true);
        parameter Boolean with_D = controllerType == .Modelica.Blocks.Types.SimpleController.PD or controllerType == .Modelica.Blocks.Types.SimpleController.PID annotation(Evaluate = true, HideResult = true);
      public
        Modelica.Blocks.Sources.Constant Dzero(k = 0) if not with_D;
        Modelica.Blocks.Sources.Constant Izero(k = 0) if not with_I;
        Modelica.Blocks.Sources.Constant FFzero(k = 0) if not withFeedForward;
        Modelica.Blocks.Math.Add addFF(k1 = 1, k2 = kFF);
      initial equation
        if initType == .Modelica.Blocks.Types.InitPID.InitialOutput then
          gainPID.y = y_start;
        end if;
      equation
        if initType == .Modelica.Blocks.Types.InitPID.InitialOutput and (y_start < yMin or y_start > yMax) then
          Modelica.Utilities.Streams.error("LimPID: Start value y_start (=" + String(y_start) + ") is outside of the limits of yMin (=" + String(yMin) + ") and yMax (=" + String(yMax) + ")");
        end if;
        connect(u_s, addP.u1);
        connect(u_s, addD.u1);
        connect(u_s, addI.u1);
        connect(addP.y, P.u);
        connect(addD.y, D.u);
        connect(addI.y, I.u);
        connect(P.y, addPID.u1);
        connect(D.y, addPID.u2);
        connect(I.y, addPID.u3);
        connect(limiter.y, addSat.u1);
        connect(limiter.y, y);
        connect(addSat.y, gainTrack.u);
        connect(gainTrack.y, addI.u3);
        connect(u_m, addP.u2);
        connect(u_m, addD.u2);
        connect(u_m, addI.u2);
        connect(Dzero.y, addPID.u2);
        connect(Izero.y, addPID.u3);
        connect(addPID.y, gainPID.u);
        connect(addFF.y, limiter.u);
        connect(gainPID.y, addFF.u1);
        connect(FFzero.y, addFF.u2);
        connect(addFF.u2, u_ff);
        connect(addFF.y, addSat.u2);
      end LimPID;
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

      partial block SVcontrol  "Single-Variable continuous controller" 
        extends Modelica.Blocks.Icons.Block;
        RealInput u_s "Connector of setpoint input signal";
        RealInput u_m "Connector of measurement input signal";
        RealOutput y "Connector of actuator output signal";
      end SVcontrol;
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

    package Nonlinear  "Library of discontinuous or non-differentiable algebraic control blocks" 
      extends Modelica.Icons.Package;

      block Limiter  "Limit the range of a signal" 
        parameter Real uMax(start = 1) "Upper limits of input signals";
        parameter Real uMin = -uMax "Lower limits of input signals";
        parameter Boolean strict = false "= true, if strict limits with noEvent(..)" annotation(Evaluate = true);
        parameter Types.LimiterHomotopy homotopyType = Modelica.Blocks.Types.LimiterHomotopy.Linear "Simplified model for homotopy-based initialization" annotation(Evaluate = true);
        parameter Boolean limitsAtInit = true "Has no longer an effect and is only kept for backwards compatibility (the implementation uses now the homotopy operator)" annotation(Evaluate = true);
        extends .Modelica.Blocks.Interfaces.SISO;
      protected
        Real simplifiedExpr "Simplified expression for homotopy-based initialization";
      equation
        assert(uMax >= uMin, "Limiter: Limits must be consistent. However, uMax (=" + String(uMax) + ") < uMin (=" + String(uMin) + ")");
        simplifiedExpr = if homotopyType == Types.LimiterHomotopy.Linear then u else if homotopyType == Types.LimiterHomotopy.UpperLimit then uMax else if homotopyType == Types.LimiterHomotopy.LowerLimit then uMin else 0;
        if strict then
          if homotopyType == Types.LimiterHomotopy.NoHomotopy then
            y = smooth(0, noEvent(if u > uMax then uMax else if u < uMin then uMin else u));
          else
            y = homotopy(actual = smooth(0, noEvent(if u > uMax then uMax else if u < uMin then uMin else u)), simplified = simplifiedExpr);
          end if;
        else
          if homotopyType == Types.LimiterHomotopy.NoHomotopy then
            y = smooth(0, if u > uMax then uMax else if u < uMin then uMin else u);
          else
            y = homotopy(actual = smooth(0, if u > uMax then uMax else if u < uMin then uMin else u), simplified = simplifiedExpr);
          end if;
        end if;
      end Limiter;
    end Nonlinear;

    package Sources  "Library of signal source blocks generating Real, Integer and Boolean signals" 
      extends Modelica.Icons.SourcesPackage;

      block Constant  "Generate constant signal of type Real" 
        parameter Real k(start = 1) "Constant output value";
        extends .Modelica.Blocks.Interfaces.SO;
      equation
        y = k;
      end Constant;

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
      type InitPID = enumeration(NoInit "No initialization (start values are used as guess values with fixed=false)", SteadyState "Steady state initialization (derivatives of states are zero)", InitialState "Initialization with initial states", InitialOutput "Initialization with initial outputs (and steady state of the states if possible)", DoNotUse_InitialIntegratorState "Do not use, only for backward compatibility (initialize only integrator state)") "Enumeration defining initialization of PID and LimPID blocks" annotation(Evaluate = true);
      type SimpleController = enumeration(P "P controller", PI "PI controller", PD "PD controller", PID "PID controller") "Enumeration defining P, PI, PD, or PID simple controller type" annotation(Evaluate = true);
      type LimiterHomotopy = enumeration(NoHomotopy "Homotopy is not used", Linear "Simplified model without limits", UpperLimit "Simplified model fixed at upper limit", LowerLimit "Simplified model fixed at lower limit") "Enumeration defining use of homotopy in limiter components" annotation(Evaluate = true);
    end Types;

    package Icons  "Icons for Blocks" 
      extends Modelica.Icons.IconsPackage;

      partial block Block  "Basic graphical layout of input/output block" end Block;
    end Icons;
  end Blocks;

  package Math  "Library of mathematical functions (e.g., sin, cos) and of functions operating on vectors and matrices" 
    extends Modelica.Icons.Package;

    package Icons  "Icons for Math" 
      extends Modelica.Icons.IconsPackage;

      partial function AxisCenter  "Basic icon for mathematical function with y-axis in the center" end AxisCenter;
    end Icons;

    function asin  "Inverse sine (-1 <= u <= 1)" 
      extends Modelica.Math.Icons.AxisCenter;
      input Real u;
      output .Modelica.SIunits.Angle y;
      external "builtin" y = asin(u);
    end asin;

    function exp  "Exponential, base e" 
      extends Modelica.Math.Icons.AxisCenter;
      input Real u;
      output Real y;
      external "builtin" y = exp(u);
    end exp;
  end Math;

  package Utilities  "Library of utility functions dedicated to scripting (operating on files, streams, strings, system)" 
    extends Modelica.Icons.UtilitiesPackage;

    package Streams  "Read from files and write to files" 
      extends Modelica.Icons.FunctionsPackage;

      function error  "Print error message and cancel all actions - in case of an unrecoverable error" 
        extends Modelica.Icons.Function;
        input String string "String to be printed to error message window";
        external "C" ModelicaError(string) annotation(Library = "ModelicaExternalC");
      end error;
    end Streams;
  end Utilities;

  package Constants  "Library of mathematical constants and constants of nature (e.g., pi, eps, R, sigma)" 
    extends Modelica.Icons.Package;
    final constant Real pi = 2 * Math.asin(1.0);
    final constant Real eps = ModelicaServices.Machine.eps "Biggest number such that 1.0 + eps = 1.0";
    final constant Real small = ModelicaServices.Machine.small "Smallest number such that small and -small are representable on the machine";
    final constant .Modelica.SIunits.Velocity c = 299792458 "Speed of light in vacuum";
    final constant .Modelica.SIunits.FaradayConstant F = 9.648533289e4 "Faraday constant, C/mol (previous value: 9.64853399e4)";
    final constant Real N_A(final unit = "1/mol") = 6.022140857e23 "Avogadro constant (previous value: 6.0221415e23)";
    final constant Real mue_0(final unit = "N/A2") = 4 * pi * 1.e-7 "Magnetic constant";
  end Constants;

  package Icons  "Library of icons" 
    extends Icons.Package;

    partial package Package  "Icon for standard packages" end Package;

    partial package InterfacesPackage  "Icon for packages containing interfaces" 
      extends Modelica.Icons.Package;
    end InterfacesPackage;

    partial package SourcesPackage  "Icon for packages containing sources" 
      extends Modelica.Icons.Package;
    end SourcesPackage;

    partial package UtilitiesPackage  "Icon for utility packages" 
      extends Modelica.Icons.Package;
    end UtilitiesPackage;

    partial package TypesPackage  "Icon for packages containing type definitions" 
      extends Modelica.Icons.Package;
    end TypesPackage;

    partial package FunctionsPackage  "Icon for packages containing functions" 
      extends Modelica.Icons.Package;
    end FunctionsPackage;

    partial package IconsPackage  "Icon for packages containing icons" 
      extends Modelica.Icons.Package;
    end IconsPackage;

    partial function Function  "Icon for functions" end Function;
  end Icons;

  package SIunits  "Library of type and unit definitions based on SI units according to ISO 31-1992" 
    extends Modelica.Icons.Package;

    package Conversions  "Conversion functions to/from non SI units and type definitions of non SI units" 
      extends Modelica.Icons.Package;

      package NonSIunits  "Type definitions of non SI units" 
        extends Modelica.Icons.Package;
        type Temperature_degC = Real(final quantity = "ThermodynamicTemperature", final unit = "degC") "Absolute temperature in degree Celsius (for relative temperature use SIunits.TemperatureDifference)" annotation(absoluteValue = true);
      end NonSIunits;
    end Conversions;

    type Angle = Real(final quantity = "Angle", final unit = "rad", displayUnit = "deg");
    type Time = Real(final quantity = "Time", final unit = "s");
    type Velocity = Real(final quantity = "Velocity", final unit = "m/s");
    type Acceleration = Real(final quantity = "Acceleration", final unit = "m/s2");
    type ElectricCharge = Real(final quantity = "ElectricCharge", final unit = "C");
    type FaradayConstant = Real(final quantity = "FaradayConstant", final unit = "C/mol");
  end SIunits;
  annotation(version = "3.2.3", versionBuild = 4, versionDate = "2019-01-23", dateModified = "2020-06-04 11:00:00Z"); 
end Modelica;

model PID_Regler_total
  extends PID_Regler;
end PID_Regler_total;
