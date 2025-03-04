model Direkte_Umsetzung_Antrieb_Test

  parameter Real LA1=3.75e-4;
  parameter Real RA1=8.25;
  parameter Real C1=51.5e-3;
  parameter Real Cmu1=3.248e-4; 
  parameter Real J1=4.75e-5;

  Direkte_Umsetzung_Antrieb direkte_Umsetzung_Antrieb(C1 = 51.5e-3, Cmu1 = 3.248e-4, J1 = 4.75e-5, LA1 = 3.75e-4, RA1 = 8.25)  annotation(
    Placement(visible = true, transformation(origin = {46, 10}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-55, -37}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 10, offset = 0, startTime = 0.5) annotation(
    Placement(visible = true, transformation(origin = {-54, 42}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
equation
  connect(step.y, direkte_Umsetzung_Antrieb.u1) annotation(
    Line(points = {{-28, 42}, {-8, 42}, {-8, 22}, {16, 22}}, color = {0, 0, 127}));
  connect(step1.y, direkte_Umsetzung_Antrieb.w) annotation(
    Line(points = {{-30, -37}, {-12, -37}, {-12, 10}, {16, 10}}, color = {0, 0, 127}));
  connect(direkte_Umsetzung_Antrieb.wDot, step1.y) annotation(
    Line(points = {{16, -2}, {0, -2}, {0, -37}, {-30, -37}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")));
end Direkte_Umsetzung_Antrieb_Test;