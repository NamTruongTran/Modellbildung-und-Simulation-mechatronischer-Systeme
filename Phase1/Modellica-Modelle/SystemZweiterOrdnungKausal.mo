model SystemZweiterOrdnungKausal
  parameter Modelica.SIunits.Capacitance C = 100e-6;
  parameter Modelica.SIunits.Inductance L = 100e-3;
  parameter Modelica.SIunits.Resistance R = 20;
  Modelica.Blocks.Continuous.StateSpace stateSpace1(A = [-R / L, -1 / L; 1 / C, 0], B = [1 / L; 0], C = [0, 1], initType = Modelica.Blocks.Types.Init.InitialState, x(each fixed = false), x_start = {0., 5}) annotation(
    Placement(visible = true, transformation(origin = {35, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Modelica.Blocks.Sources.Pulse pulse1(amplitude = 0, offset = 0, period = 0.1, startTime = 0.5) annotation(
    Placement(visible = true, transformation(origin = {-69, 3}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {1, R / L, 1 / (L * C)}, b = {1 / (L * C)}, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 5) annotation(
    Placement(visible = true, transformation(origin = {36, -66}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  RCLTiefpass RCLDirekt(C = 100e-6, L = 100e-3, R = 20) annotation(
    Placement(visible = true, transformation(origin = {34, 70}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
equation
  connect(stateSpace1.u[1], pulse1.y) annotation(
    Line(points = {{5, 3}, {-46, 3}}, color = {0, 0, 127}));
  connect(transferFunction.u, pulse1.y) annotation(
    Line(points = {{5, -66}, {-46, -66}, {-46, 3}}, color = {0, 0, 127}));
  connect(RCLDirekt.Input, pulse1.y) annotation(
    Line(points = {{3, 72}, {-46, 72}, {-46, 3}}, color = {0, 0, 127}));
protected
  annotation(
    uses(Modelica(version = "3.2.3")),
    experiment(StartTime = 0, StopTime = 0.4, Tolerance = 1e-06, Interval = 0.0001));
end SystemZweiterOrdnungKausal;