model Direkte_Umsetzung_Generator

  parameter Real LA2=3.75e-4;
  parameter Real RA2=8.25;
  parameter Real C2=51.5e-3;
  parameter Real Cmu2=3.248e-4; 
  parameter Real J2=4.75e-5;
  parameter Real RL=10;
  
  Modelica.Blocks.Continuous.Integrator integrator annotation(
    Placement(visible = true, transformation(origin = {43, -50}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain4(k = C2 / LA2) annotation(
    Placement(visible = true, transformation(origin = {-24, 28}, extent = {{-12, -12}, {12, 12}}, rotation = 180)));
  Modelica.Blocks.Math.Gain gain2(k = C2 / J2) annotation(
    Placement(visible = true, transformation(origin = {18, 4}, extent = {{-12, -12}, {12, 12}}, rotation = 180)));
  Modelica.Blocks.Math.Add3 add1(k1 = -1, k2 = 1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-12, -26}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = 1 / J2) annotation(
    Placement(visible = true, transformation(origin = {-74, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Cmu2 / J2) annotation(
    Placement(visible = true, transformation(origin = {-12, -78}, extent = {{-12, -12}, {12, 12}}, rotation = 180)));
  Modelica.Blocks.Continuous.Integrator integrator2 annotation(
    Placement(visible = true, transformation(origin = {18, 50}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = -1, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {-58, 50}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain5(k = (RA2 + RL) / LA2) annotation(
    Placement(visible = true, transformation(origin = {-20, 82}, extent = {{-12, -12}, {12, 12}}, rotation = 180)));
  Modelica.Blocks.Math.Gain gain6(k = RL)  annotation(
    Placement(visible = true, transformation(origin = {76, 50}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ML annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-122, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UA annotation(
    Placement(visible = true, transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {112, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput w annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {112, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput wdot annotation(
    Placement(visible = true, transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {112, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(gain1.y, add1.u2) annotation(
    Line(points = {{-60, 0}, {-42.5, 0}, {-42.5, -26}, {-29, -26}}, color = {0, 0, 127}));
  connect(gain2.y, add1.u1) annotation(
    Line(points = {{5, 4}, {-37.2, 4}, {-37.2, -15}, {-29, -15}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{3, -26}, {18.4, -26}, {18.4, -50}, {26, -50}}, color = {0, 0, 127}));
  connect(gain3.y, add1.u3) annotation(
    Line(points = {{-25, -78}, {-43.2, -78}, {-43.2, -37}, {-29, -37}}, color = {0, 0, 127}));
  connect(add2.y, integrator2.u) annotation(
    Line(points = {{-45, 50}, {1, 50}}, color = {0, 0, 127}));
  connect(gain3.u, integrator.y) annotation(
    Line(points = {{2, -78}, {72, -78}, {72, -50}, {58, -50}}, color = {0, 0, 127}));
  connect(gain2.u, integrator2.y) annotation(
    Line(points = {{32, 4}, {50, 4}, {50, 50}, {33, 50}}, color = {0, 0, 127}));
  connect(gain5.u, integrator2.y) annotation(
    Line(points = {{-6, 82}, {50, 82}, {50, 50}, {33, 50}}, color = {0, 0, 127}));
  connect(gain5.y, add2.u1) annotation(
    Line(points = {{-34, 82}, {-84, 82}, {-84, 57}, {-72, 57}}, color = {0, 0, 127}));
  connect(gain4.y, add2.u2) annotation(
    Line(points = {{-38, 28}, {-84, 28}, {-84, 43}, {-72, 43}}, color = {0, 0, 127}));
  connect(gain6.u, integrator2.y) annotation(
    Line(points = {{62, 50}, {33, 50}}, color = {0, 0, 127}));
  connect(gain4.u, integrator.y) annotation(
    Line(points = {{-10, 28}, {42, 28}, {42, -20}, {72, -20}, {72, -50}, {58, -50}}, color = {0, 0, 127}));
  connect(w, integrator.y) annotation(
    Line(points = {{110, 0}, {72, 0}, {72, -50}, {58, -50}}, color = {0, 0, 127}));
  connect(gain6.y, UA) annotation(
    Line(points = {{90, 50}, {110, 50}}, color = {0, 0, 127}));
  connect(wdot, add1.y) annotation(
    Line(points = {{110, -50}, {86, -50}, {86, -90}, {12, -90}, {12, -26}, {3, -26}}, color = {0, 0, 127}));
  connect(ML, gain1.u) annotation(
    Line(points = {{-120, 0}, {-88, 0}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Text(origin = {72, 49}, extent = {{-24, 13}, {24, -13}}, textString = "UA"), Rectangle(origin = {71.93, -0.05}, lineThickness = 2, extent = {{-27.93, 20.05}, {27.93, -20.05}}), Rectangle(origin = {-72.07, 1.95}, lineThickness = 2, extent = {{-27.93, 20.05}, {27.93, -20.05}}), Text(origin = {72, -53}, extent = {{-24, 13}, {24, -13}}, textString = "WDot"), Text(origin = {-34, -84}, extent = {{-64, 20}, {64, -20}}, textString = "DIREKT"), Rectangle(origin = {71.93, 49.95}, lineThickness = 2, extent = {{-27.93, 20.05}, {27.93, -20.05}}), Text(origin = {-72, 1}, extent = {{-24, 13}, {24, -13}}, textString = "ML"), Rectangle(origin = {71.93, -52.05}, lineThickness = 2, extent = {{-27.93, 20.05}, {27.93, -20.05}}), Text(origin = {72, -3}, extent = {{-24, 13}, {24, -13}}, textString = "W"), Text(origin = {-32, 82}, extent = {{-64, 20}, {64, -20}}, textString = "Generator"), Rectangle(lineColor = {0, 0, 255}, lineThickness = 4, extent = {{-100, 100}, {100, -100}})}));
end Direkte_Umsetzung_Generator;