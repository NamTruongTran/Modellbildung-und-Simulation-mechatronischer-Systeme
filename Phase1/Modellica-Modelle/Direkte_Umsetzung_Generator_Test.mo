model Direkte_Umsetzung_Generator_Test

  parameter Real LA2=3.75e-4;
  parameter Real RA2=8.25;
  parameter Real C2=51.5e-3;
  parameter Real Cmu2=3.248e-4; 
  parameter Real J2=4.75e-5;
  parameter Real RL=10;

  Modelica.Blocks.Sources.Step step(height = 10, offset = 0, startTime = 0.5) annotation(
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Direkte_Umsetzung_Generator direkte_Umsetzung_Generator(C2 = 51.5e-3, Cmu2 = 3.248e-4, J2 = 4.75e-5, LA2 = 3.75e-4, RA2 = 8.25, RL = 10)  annotation(
    Placement(visible = true, transformation(origin = {58, -3.10862e-15}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
equation
  connect(step.y, direkte_Umsetzung_Generator.ML) annotation(
    Line(points = {{-32, 0}, {22, 0}}, color = {0, 0, 127}));

annotation(
    uses(Modelica(version = "3.2.3")));
end Direkte_Umsetzung_Generator_Test;