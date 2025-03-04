model SystemZweiterOrdnungKausal  
  parameter Modelica.SIunits.Capacitance C = 100e-6;
  parameter Modelica.SIunits.Inductance L = 100e-3;
  parameter Modelica.SIunits.Resistance R = 20;
  Modelica.Blocks.Sources.Pulse pulse1(amplitude = 10, offset = 0, period = 0.1, startTime = 0.002);
  Modelica.Blocks.Continuous.StateSpace stateSpace1(A = [-R / L, -1 / L; 1 / C, 0], B = [1 / L; 0], C = [0, 1], initType = Modelica.Blocks.Types.Init.InitialOutput, x(each fixed = false), x_start = {0, 0.});
equation
  connect(pulse1.y, stateSpace1.u[1]);
  annotation(experiment(StartTime = 0, StopTime = 0.4, Tolerance = 1e-06, Interval = 0.0001)); 
end SystemZweiterOrdnungKausal;

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
    import SI = Modelica.SIunits;
    extends Modelica.Icons.Package;

    package Continuous  "Library of continuous control blocks with internal states" 
      import Modelica.Blocks.Interfaces;
      import Modelica.SIunits;
      extends Modelica.Icons.Package;

      block StateSpace  "Linear state space system" 
        import Modelica.Blocks.Types.Init;
        parameter Real[:, size(A, 1)] A = [1, 0; 0, 1] "Matrix A of state space model (e.g., A=[1, 0; 0, 1])";
        parameter Real[size(A, 1), :] B = [1; 1] "Matrix B of state space model (e.g., B=[1; 1])";
        parameter Real[:, size(A, 1)] C = [1, 1] "Matrix C of state space model (e.g., C=[1, 1])";
        parameter Real[size(C, 1), size(B, 2)] D = zeros(size(C, 1), size(B, 2)) "Matrix D of state space model";
        parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.NoInit "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)" annotation(Evaluate = true);
        parameter Real[nx] x_start = zeros(nx) "Initial or guess values of states";
        parameter Real[ny] y_start = zeros(ny) "Initial values of outputs (remaining states are in steady state if possible)";
        extends Interfaces.MIMO(final nin = size(B, 2), final nout = size(C, 1));
        output Real[size(A, 1)] x(start = x_start) "State vector";
      protected
        parameter Integer nx = size(A, 1) "number of states";
        parameter Integer ny = size(C, 1) "number of outputs";
      initial equation
        if initType == Init.SteadyState then
          der(x) = zeros(nx);
        elseif initType == Init.InitialState then
          x = x_start;
        elseif initType == Init.InitialOutput then
          x = Modelica.Math.Matrices.equalityLeastSquares(A, -B * u, C, y_start - D * u);
        end if;
      equation
        der(x) = A * x + B * u;
        y = C * x + D * u;
      end StateSpace;
    end Continuous;

    package Interfaces  "Library of connectors and partial models for input/output blocks" 
      import Modelica.SIunits;
      extends Modelica.Icons.InterfacesPackage;
      connector RealInput = input Real "'input Real' as connector";
      connector RealOutput = output Real "'output Real' as connector";

      partial block SO  "Single Output continuous control block" 
        extends Modelica.Blocks.Icons.Block;
        RealOutput y "Connector of Real output signal";
      end SO;

      partial block MIMO  "Multiple Input Multiple Output continuous control block" 
        extends Modelica.Blocks.Icons.Block;
        parameter Integer nin = 1 "Number of inputs";
        parameter Integer nout = 1 "Number of outputs";
        RealInput[nin] u "Connector of Real input signals";
        RealOutput[nout] y "Connector of Real output signals";
      end MIMO;

      partial block SignalSource  "Base class for continuous signal source" 
        extends SO;
        parameter Real offset = 0 "Offset of output signal y";
        parameter SIunits.Time startTime = 0 "Output y = offset for time < startTime";
      end SignalSource;
    end Interfaces;

    package Sources  "Library of signal source blocks generating Real, Integer and Boolean signals" 
      import Modelica.Blocks.Interfaces;
      import Modelica.SIunits;
      extends Modelica.Icons.SourcesPackage;

      block Pulse  "Generate pulse signal of type Real" 
        parameter Real amplitude = 1 "Amplitude of pulse";
        parameter Real width(final min = Modelica.Constants.small, final max = 100) = 50 "Width of pulse in % of period";
        parameter Modelica.SIunits.Time period(final min = Modelica.Constants.small, start = 1) "Time for one period";
        parameter Integer nperiod = -1 "Number of periods (< 0 means infinite number of periods)";
        extends Interfaces.SignalSource;
      protected
        Modelica.SIunits.Time T_width = period * width / 100;
        Modelica.SIunits.Time T_start "Start time of current period";
        Integer count "Period count";
      initial algorithm
        count := integer((time - startTime) / period);
        T_start := startTime + count * period;
      equation
        when integer((time - startTime) / period) > pre(count) then
          count = pre(count) + 1;
          T_start = time;
        end when;
        y = offset + (if time < startTime or nperiod == 0 or nperiod > 0 and count >= nperiod then 0 else if time < T_start + T_width then amplitude else 0);
      end Pulse;
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

  package Math  "Library of mathematical functions (e.g., sin, cos) and of functions operating on vectors and matrices" 
    import SI = Modelica.SIunits;
    extends Modelica.Icons.Package;

    package Matrices  "Library of functions operating on matrices" 
      extends Modelica.Icons.Package;

      function equalityLeastSquares  "Solve a linear equality constrained least squares problem" 
        extends Modelica.Icons.Function;
        input Real[:, :] A "Minimize |A*x - a|^2";
        input Real[size(A, 1)] a;
        input Real[:, size(A, 2)] B "subject to B*x=b";
        input Real[size(B, 1)] b;
        output Real[size(A, 2)] x "solution vector";
      protected
        Integer info;
      algorithm
        assert(size(A, 2) >= size(B, 1) and size(A, 2) <= size(A, 1) + size(B, 1), "It is required that size(B,1) <= size(A,2) <= size(A,1) + size(B,1)\n" + "This relationship is not fulfilled, since the matrices are declared as:\n" + "  A[" + String(size(A, 1)) + "," + String(size(A, 2)) + "], B[" + String(size(B, 1)) + "," + String(size(B, 2)) + "]\n");
        (x, info) := LAPACK.dgglse_vec(A, a, B, b);
        assert(info == 0, "Solving a linear equality-constrained least squares problem
      with function \"Matrices.equalityLeastSquares\" failed.");
      end equalityLeastSquares;

      package LAPACK  "Interface to LAPACK library (should usually not directly be used but only indirectly via Modelica.Math.Matrices)" 
        extends Modelica.Icons.Package;

        function dgglse_vec  "Solve a linear equality constrained least squares problem" 
          extends Modelica.Icons.Function;
          input Real[:, :] A "Minimize |A*x - c|^2";
          input Real[size(A, 1)] c;
          input Real[:, size(A, 2)] B "subject to B*x=d";
          input Real[size(B, 1)] d;
          output Real[size(A, 2)] x "solution vector";
          output Integer info;
        protected
          Integer nrow_A = size(A, 1);
          Integer nrow_B = size(B, 1);
          Integer ncol_A = size(A, 2) "(min=nrow_B,max=nrow_A+nrow_B) required";
          Real[size(A, 1), size(A, 2)] Awork = A;
          Real[size(B, 1), size(A, 2)] Bwork = B;
          Real[size(A, 1)] cwork = c;
          Real[size(B, 1)] dwork = d;
          Integer lwork = ncol_A + nrow_B + max(nrow_A, max(ncol_A, nrow_B)) * 5;
          Real[size(A, 2) + size(B, 1) + max(size(A, 1), max(size(A, 2), size(B, 1))) * 5] work;
          external "FORTRAN 77" dgglse(nrow_A, ncol_A, nrow_B, Awork, nrow_A, Bwork, nrow_B, cwork, dwork, x, work, lwork, info) annotation(Library = "lapack");
        end dgglse_vec;
      end LAPACK;
    end Matrices;

    package Icons  "Icons for Math" 
      extends Modelica.Icons.IconsPackage;

      partial function AxisCenter  "Basic icon for mathematical function with y-axis in the center" end AxisCenter;
    end Icons;

    function asin  "Inverse sine (-1 <= u <= 1)" 
      extends Modelica.Math.Icons.AxisCenter;
      input Real u;
      output SI.Angle y;
      external "builtin" y = asin(u);
    end asin;

    function exp  "Exponential, base e" 
      extends Modelica.Math.Icons.AxisCenter;
      input Real u;
      output Real y;
      external "builtin" y = exp(u);
    end exp;
  end Math;

  package Constants  "Library of mathematical constants and constants of nature (e.g., pi, eps, R, sigma)" 
    import SI = Modelica.SIunits;
    import NonSI = Modelica.SIunits.Conversions.NonSIunits;
    extends Modelica.Icons.Package;
    final constant Real pi = 2 * Modelica.Math.asin(1.0);
    final constant Real small = ModelicaServices.Machine.small "Smallest number such that small and -small are representable on the machine";
    final constant SI.Velocity c = 299792458 "Speed of light in vacuum";
    final constant SI.FaradayConstant F = 9.648533289e4 "Faraday constant, C/mol (previous value: 9.64853399e4)";
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

    partial package TypesPackage  "Icon for packages containing type definitions" 
      extends Modelica.Icons.Package;
    end TypesPackage;

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
    type Capacitance = Real(final quantity = "Capacitance", final unit = "F", min = 0);
    type Inductance = Real(final quantity = "Inductance", final unit = "H");
    type Resistance = Real(final quantity = "Resistance", final unit = "Ohm");
    type FaradayConstant = Real(final quantity = "FaradayConstant", final unit = "C/mol");
  end SIunits;
  annotation(version = "3.2.3", versionBuild = 4, versionDate = "2019-01-23", dateModified = "2020-06-04 11:00:00Z"); 
end Modelica;

model SystemZweiterOrdnungKausal_total
  extends SystemZweiterOrdnungKausal;
 annotation(experiment(StartTime = 0, StopTime = 0.4, Tolerance = 1e-06, Interval = 0.0001));
end SystemZweiterOrdnungKausal_total;
