model Dynamisch
  Aufgabe3DoE.MotormodellAufgabe3_me_FMU motormodellAufgabe3_me_FMU annotation(
    Placement(visible = true, transformation(origin = {42, 2}, extent = {{-36, -36}, {36, 36}}, rotation = 0)));
  Modelica.Blocks.Sources.Step Drezahl(offset = 1000, startTime = 0)  annotation(
    Placement(visible = true, transformation(origin = {-62, 54}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Step alpha(height = 20, offset = 60, startTime = 5)  annotation(
    Placement(visible = true, transformation(origin = {-63, -21}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
equation
  connect(Drezahl.y, motormodellAufgabe3_me_FMU.N) annotation(
    Line(points = {{-40, 54}, {-12, 54}, {-12, 28}, {2, 28}}, color = {0, 0, 127}));
  connect(alpha.y, motormodellAufgabe3_me_FMU.alpha) annotation(
    Line(points = {{-42, -20}, {-12, -20}, {-12, 18}, {2, 18}}, color = {0, 0, 127}));

protected
  annotation(
    uses(Modelica(version = "3.2.3")));
end Dynamisch;