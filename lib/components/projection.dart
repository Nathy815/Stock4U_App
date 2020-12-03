import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fakeData.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';

class Projection extends StatefulWidget {
  double value, raise;
  Projection({this.value, this.raise});

  ProjectionGraph createState() => ProjectionGraph();
}

class ProjectionGraph extends State<Projection> with FakeChartSeries {

  @override
  Widget build(BuildContext context) {
    Map<DateTime, double> line1 = createLine(widget.value, widget.raise);
    LineChart chart = LineChart.fromDateTimeMaps(
            [line1], [Color.fromRGBO(215, 0, 0, 1)], [''],
            tapTextFontWeight: FontWeight.w400);

    return Expanded(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 15),
                child: AnimatedLineChart(
                  chart,
                  key: UniqueKey(),
                )
              )
            )
          ]
        ),
      ),
    );
  }
}