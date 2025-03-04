model PID_Regler

  parameter Real LA1=3.75e-4;
  parameter Real RA1=8.25;
  parameter Real C1=51.5e-3;
  parameter Real Cmu1=3.248e-4; 
  parameter Real J1=4.75e-5;
   
  parameter Real LA2=3.75e-4;
  parameter Real RA2=8.25;
  parameter Real C2=51.5e-3;
  parameter Real Cmu2=3.248e-4; 
  parameter Real J2=4.75e-5;
  parameter Real RL=10;

  Direkte_Umsetzung_Generator direkte_Umsetzung_Generator(C2 = 51.5e-3, Cmu2 = 3.248e-4, J2 = 4.75e-5, LA2 = 3.75e-4, RA2 = 8.25, RL = 100) annotation(
    Placement(visible = true, transformation(origin = {48, -38}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Direkte_Umsetzung_Antrieb direkte_Umsetzung_Antrieb(C1 = 51.5e-3, Cmu1 = 3.248e-4, J1 = 4.75e-5, LA1 = 3.75e-4, RA1 = 8.25) annotation(
    Placement(visible = true, transformation(origin = {-22, -38}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 4, startTime = 2.004) annotation(
    Placement(visible = true, transformation(origin = {-37, 37}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID pid( limitsAtInit = true, withFeedForward = false, xd_start = 0, xi_start = 0, yMax = 1500, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {33, 37}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
equation
  connect(direkte_Umsetzung_Antrieb.ML, direkte_Umsetzung_Generator.ML) annotation(
    Line(points = {{2.64, -38.44}, {20.64, -38.44}}, color = {0, 0, 127}));
  connect(direkte_Umsetzung_Generator.wdot, direkte_Umsetzung_Antrieb.wDot) annotation(
    Line(points = {{72.64, -49}, {80.04, -49}, {80.04, -72}, {-67.96, -72}, {-67.96, -49}, {-49.36, -49}}, color = {0, 0, 127}));
  connect(direkte_Umsetzung_Generator.w, direkte_Umsetzung_Antrieb.w) annotation(
    Line(points = {{72.64, -38}, {84.04, -38}, {84.04, -78}, {-73.96, -78}, {-73.96, -38}, {-49.36, -38}}, color = {0, 0, 127}));
  connect(direkte_Umsetzung_Generator.UA, pid.u_m) annotation(
    Line(points = {{72, -26}, {80, -26}, {80, 0}, {34, 0}, {34, 14}}, color = {0, 0, 127}));
  connect(pid.y, direkte_Umsetzung_Antrieb.u1) annotation(
    Line(points = {{54, 38}, {60, 38}, {60, 76}, {-72, 76}, {-72, -26}, {-48, -26}}, color = {0, 0, 127}));
  connect(step.y, pid.u_s) annotation(
    Line(points = {{-16, 37}, {10, 37}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")));
end PID_Regler;