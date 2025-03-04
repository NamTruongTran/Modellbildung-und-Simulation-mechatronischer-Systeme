model Direkte_Umsetzung_Antrieb

  parameter Real LA1=3.75e-4;
  parameter Real RA1=8.25;
  parameter Real C1=51.5e-3;
  parameter Real Cmu1=3.248e-4; 
  parameter Real J1=4.75e-5;

  Modelica.Blocks.Math.Add3 add1(k1 = -1, k2 = 1, k3 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-17, 35}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = 1 / LA1)  annotation(
    Placement(visible = true, transformation(origin = {-74, 50}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = RA1 / LA1)  annotation(
    Placement(visible = true, transformation(origin = {-18, 76}, extent = {{-12, -12}, {12, 12}}, rotation = 180)));
  Modelica.Blocks.Math.Gain gain3(k = C1 / LA1)  annotation(
    Placement(visible = true, transformation(origin = {-74, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add2(k1 = 1, k2 = -1, k3 = -1)  annotation(
    Placement(visible = true, transformation(origin = {78, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain5(k = Cmu1)  annotation(
    Placement(visible = true, transformation(origin = {-23, -21}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain6(k = J1)  annotation(
    Placement(visible = true, transformation(origin = {-74, -50}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator annotation(
    Placement(visible = true, transformation(origin = {37, 50}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain4(k = C1)  annotation(
    Placement(visible = true, transformation(origin = {78, 50}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u1 annotation(
    Placement(visible = true, transformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-122, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput w annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-122, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput wDot annotation(
    Placement(visible = true, transformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-122, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ML annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {112, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(gain1.y, add1.u2) annotation(
    Line(points = {{-61, 50}, {-48.4, 50}, {-48.4, 35}, {-33, 35}}, color = {0, 0, 127}));
  connect(gain2.y, add1.u1) annotation(
    Line(points = {{-31, 76}, {-42.2, 76}, {-42.2, 45}, {-33, 45}}, color = {0, 0, 127}));
  connect(gain3.y, add1.u3) annotation(
    Line(points = {{-61, 0}, {-53.8, 0}, {-53.8, 25}, {-33, 25}}, color = {0, 0, 127}));
  connect(integrator.u, add1.y) annotation(
    Line(points = {{20, 50}, {6.8, 50}, {6.8, 35}, {-3, 35}}, color = {0, 0, 127}));
  connect(gain5.y, add2.u2) annotation(
    Line(points = {{-9, -21}, {-1.7, -21}, {-1.7, 0}, {64, 0}}, color = {0, 0, 127}));
  connect(gain6.y, add2.u3) annotation(
    Line(points = {{-61, -50}, {10.5, -50}, {10.5, -10}, {64, -10}}, color = {0, 0, 127}));
  connect(gain4.u, integrator.y) annotation(
    Line(points = {{64, 50}, {52, 50}}, color = {0, 0, 127}));
  connect(gain4.y, add2.u1) annotation(
    Line(points = {{91, 50}, {96, 50}, {96, 20}, {40, 20}, {40, 10}, {64, 10}}, color = {0, 0, 127}));
  connect(u1, gain1.u) annotation(
    Line(points = {{-120, 50}, {-88, 50}}, color = {0, 0, 127}));
  connect(w, gain3.u) annotation(
    Line(points = {{-120, 0}, {-88, 0}}, color = {0, 0, 127}));
  connect(wDot, gain6.u) annotation(
    Line(points = {{-120, -50}, {-88, -50}}, color = {0, 0, 127}));
  connect(ML, add2.y) annotation(
    Line(points = {{110, 0}, {91, 0}}, color = {0, 0, 127}));
  connect(gain5.u, w) annotation(
    Line(points = {{-39, -21}, {-96, -21}, {-96, 0}, {-120, 0}}, color = {0, 0, 127}));
  connect(gain2.u, integrator.y) annotation(
    Line(points = {{-4, 76}, {58, 76}, {58, 50}, {52, 50}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Rectangle(origin = {-72.07, -50.05}, lineThickness = 2, extent = {{-27.93, 20.05}, {27.93, -20.05}}), Text(origin = {-72, -51}, extent = {{-24, 13}, {24, -13}}, textString = "WDot"), Text(origin = {-72, -3}, extent = {{-24, 13}, {24, -13}}, textString = "W"), Rectangle(origin = {-72.07, 49.95}, lineThickness = 2, extent = {{-27.93, 20.05}, {27.93, -20.05}}), Rectangle(origin = {-72.07, -0.05}, lineThickness = 2, extent = {{-27.93, 20.05}, {27.93, -20.05}}), Text(origin = {-72, 49}, extent = {{-24, 13}, {24, -13}}, textString = "U1"), Rectangle(origin = {71.93, -2.05}, lineThickness = 2, extent = {{-27.93, 20.05}, {27.93, -20.05}}), Text(origin = {72, -3}, extent = {{-24, 13}, {24, -13}}, textString = "ML"), Text(origin = {30, 74}, extent = {{-64, 20}, {64, -20}}, textString = "Antrieb"), Rectangle(lineColor = {0, 0, 255},lineThickness = 4, extent = {{-100, 100}, {100, -100}}), Text(origin = {30, -82}, extent = {{-64, 20}, {64, -20}}, textString = "DIREKT")}));
end Direkte_Umsetzung_Antrieb;