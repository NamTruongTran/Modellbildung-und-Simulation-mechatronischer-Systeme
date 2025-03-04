model Direkte_Umsetzung_Antrieb_Generator_Test

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

  Direkte_Umsetzung_Antrieb direkte_Umsetzung_Antrieb(C1 = 51.5e-3, Cmu1 = 3.248e-4, J1 = 4.75e-5, LA1 = 3.75e-4, RA1 = 8.25)  annotation(
    Placement(visible = true, transformation(origin = {-10, 1.77636e-15}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Direkte_Umsetzung_Generator direkte_Umsetzung_Generator(C2 = 51.5e-3, Cmu2 = 3.248e-4, J2 = 4.75e-5, LA2 = 3.75e-4, RA2 = 8.25, RL = 10)  annotation(
    Placement(visible = true, transformation(origin = {60, 1.77636e-15}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 4, startTime = 2.004)  annotation(
    Placement(visible = true, transformation(origin = {-74, 56}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
equation
  connect(direkte_Umsetzung_Antrieb.ML, direkte_Umsetzung_Generator.ML) annotation(
    Line(points = {{14.64, -0.44}, {32.64, -0.44}}, color = {0, 0, 127}));
  connect(direkte_Umsetzung_Generator.wdot, direkte_Umsetzung_Antrieb.wDot) annotation(
    Line(points = {{84.64, -11}, {92.04, -11}, {92.04, -34}, {-55.96, -34}, {-55.96, -11}, {-37.36, -11}}, color = {0, 0, 127}));
  connect(direkte_Umsetzung_Generator.w, direkte_Umsetzung_Antrieb.w) annotation(
    Line(points = {{84.64, 1.77636e-15}, {96.04, 1.77636e-15}, {96.04, -40}, {-61.96, -40}, {-61.96, 1.77636e-15}, {-37.36, 1.77636e-15}}, color = {0, 0, 127}));
  connect(step.y, direkte_Umsetzung_Antrieb.u1) annotation(
    Line(points = {{-56.4, 56}, {-48.4, 56}, {-48.4, 11}, {-37.4, 11}}, color = {0, 0, 127}));

annotation(
    uses(Modelica(version = "3.2.3")));
end Direkte_Umsetzung_Antrieb_Generator_Test;