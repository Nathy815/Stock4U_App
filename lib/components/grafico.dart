
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import '../services/acaoService.dart';

class Grafico extends StatefulWidget {
  String equityID;
  Grafico(this.equityID);

  GraficoLine createState() => GraficoLine();
}

class GraficoLine extends State<Grafico> {
  List<String> filters = ["day", "week", "month", "threeMonths", "sixMonths", "year", "fiveYears"];
  int filter;

  @override
  void initState() {
    super.initState();
    setState(() { filter = 0; });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AcaoService().getChart(widget.equityID, filters[filter]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          LineChart chart;

          if (snapshot.data != null)
          {
            List<Color> pallette = [Colors.red, Colors.orange, Colors.blue, Colors.green];
            List<Color> colors = new List<Color>();
            List<String> units = new List<String>();
            for(var i = 0; i < snapshot.data.length; i++)
            {
              colors.add(pallette[i]);
              units.add('');
            }

            chart = LineChart.fromDateTimeMaps(
              [snapshot.data[0]], 
              [colors[0]],
              [units[0]],
              tapTextFontWeight: FontWeight.w400,
            );
          }

          return Expanded(
            child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => filter == 0 ? null : setState(() { filter = 0; }),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(215, 0, 0, 1),
                              width: 1
                            ),
                            color: filter == 0 ? Color.fromRGBO(215, 0, 0, 1) : Colors.white
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Hoje",
                              style: TextStyle(
                                color: filter == 0 ? Colors.white : Color.fromRGBO(215, 0, 0, 1)
                              )
                            )
                          )
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: GestureDetector(
                        onTap: () => filter == 1 ? null : setState(() { filter = 1; }),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(215, 0, 0, 1),
                              width: 1
                            ),
                            color: filter == 1 ? Color.fromRGBO(215, 0, 0, 1) : Colors.white
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "5D",
                              style: TextStyle(
                                color: filter == 1 ? Colors.white : Color.fromRGBO(215, 0, 0, 1)
                              )
                            )
                          )
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: GestureDetector(
                        onTap: () => filter == 2 ? null : setState(() { filter = 2; }),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(215, 0, 0, 1),
                              width: 1
                            ),
                            color: filter == 2 ? Color.fromRGBO(215, 0, 0, 1) : Colors.white
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "1M",
                              style: TextStyle(
                                color: filter == 2 ? Colors.white : Color.fromRGBO(215, 0, 0, 1)
                              )
                            )
                          )
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: GestureDetector(
                        onTap: () => filter == 3 ? null : setState(() { filter = 3; }),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(215, 0, 0, 1),
                              width: 1
                            ),
                            color: filter == 3 ? Color.fromRGBO(215, 0, 0, 1) : Colors.white
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "3M",
                              style: TextStyle(
                                color: filter == 3 ? Colors.white : Color.fromRGBO(215, 0, 0, 1)
                              )
                            )
                          )
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: GestureDetector(
                        onTap: () => filter == 4 ? null : setState(() { filter = 4; }),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(215, 0, 0, 1),
                              width: 1
                            ),
                            color: filter == 4 ? Color.fromRGBO(215, 0, 0, 1) : Colors.white
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "6M",
                              style: TextStyle(
                                color: filter == 4 ? Colors.white : Color.fromRGBO(215, 0, 0, 1)
                              )
                            )
                          )
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: GestureDetector(
                        onTap: () => filter == 5 ? null : setState(() { filter = 5; }),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(215, 0, 0, 1),
                              width: 1
                            ),
                            color: filter == 5 ? Color.fromRGBO(215, 0, 0, 1) : Colors.white
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "1A",
                              style: TextStyle(
                                color: filter == 5 ? Colors.white : Color.fromRGBO(215, 0, 0, 1)
                              )
                            )
                          )
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () => filter == 6 ? null : setState(() { filter = 6; }),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(215, 0, 0, 1),
                              width: 1
                            ),
                            color: filter == 6 ? Color.fromRGBO(215, 0, 0, 1) : Colors.white
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "5A",
                              style: TextStyle(
                                color: filter == 6 ? Colors.white : Color.fromRGBO(215, 0, 0, 1)
                              )
                            )
                          )
                        )
                      )
                    )
                  ],
                )
              ),
              Expanded(
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
              )
            ])
          );
        }
        else if (snapshot.hasError)
          return Center(child: Text("Não foi possível carregar os dados do gráfico."));
        else
          return Padding(
            padding: EdgeInsets.only(top: 30, bottom: 30),
            child: Center(
              child: CircularProgressIndicator()
            )
          );
      },
    );

    
  }
}