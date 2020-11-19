
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'fakeData.dart';

class Grafico extends StatefulWidget {
  GraficoLine createState() => GraficoLine();
}

class GraficoLine extends State<Grafico> with FakeChartSeries {

  @override
  Widget build(BuildContext context) {
    Map<DateTime, double> line1 = createLine2();
    Map<DateTime, double> line2 = createLine2_2();
    Map<DateTime, double> line3 = createLine1();
    Map<DateTime, double> line4 = createLineAlmostSaveValues();

    LineChart chart = LineChart.fromDateTimeMaps(
          [line1, line2, line3, line4], 
          [Colors.red, Colors.green, Colors.blue, Colors.orange],
          ['C','C','C','C'],
          tapTextFontWeight: FontWeight.w400,
          );
    

    /*  chart = AreaLineChart.fromDateTimeMaps(
          [line1], [Colors.red.shade900], ['C'],
          gradients: [Pair(Colors.yellow.shade400, Colors.red.shade700)]);*/
    
    return Expanded(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: AnimatedLineChart(
                  chart,
                  key: UniqueKey(),
                ),
              )
            )
          ]
        ),
      ),
    );
  }
}