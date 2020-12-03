import 'dart:math';

class FakeChartSeries {
  double doubleInRange(Random source, num start, num end) => 
    source.nextDouble() * (end - start) + start;

  Map<DateTime, double> createLine(double start, double raise) {
    double value = start + (start * (100 + raise) / 100);
    Map<DateTime, double> data = {};
    for(var dia = 1; dia < 180; dia ++)
      data[DateTime.now().add(Duration(days: dia))] = doubleInRange(new Random(), start - 30, value + 30);
    data[DateTime.now().add(Duration(days: 180))] = value;
    return data;
  }

  Map<DateTime, double> createLine1() {
    Map<DateTime, double> data = {};
    for(var dia = 1; dia < 366; dia ++)
      data[DateTime.now().add(Duration(days: dia))] = (25 * dia).toDouble();

    return data;
  }
}