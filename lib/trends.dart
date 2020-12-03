import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'noticias.dart';
import 'components/stock4_u_icons.dart' as CustomIcons;
import 'perfil.dart';
import 'components/projection.dart';

class Trends extends StatefulWidget {
  TrendsTable createState() => TrendsTable();
}

class TrendsTable extends State<Trends> {
  double start = 16.02, raise = 9.9;
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Tendências"),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(51, 51, 51, 1)
        ),
        automaticallyImplyLeading: false
      ),
      bottomNavigationBar: BottomNavigationBar(
        //selectedFontSize: 0,
        selectedItemColor: Color.fromRGBO(215, 0, 0, 1),
        unselectedItemColor: Colors.black54,
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.Stock4U.newspaper),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.Stock4U.hotjar),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: ""
          )
        ],
        onTap: (value) {
          if (value == 0)
          {
            Navigator.of(context).pop();
            Navigator.of(context).push(_createRoute(Home()));
          }
          else if (value == 1)
          {
            Navigator.of(context).pop();
            Navigator.of(context).push(_createRoute(Noticias()));
          }
          else if (value == 3)
          {
            Navigator.of(context).pop();
            Navigator.of(context).push(_createRoute(Perfil()));
          }
        },
      ),
      body: Column(
        children: [
          Projection(value: start, raise: raise),
          SingleChildScrollView(
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                )
              ),
              children: [
                TableRow(
                  children: ("Posição,Ticker,Nome,Aumento (%)").split(",").map((name) {
                    return Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          name,
                          style: TextStyle(
                            color: Color.fromRGBO(215, 0, 0, 1),
                            fontWeight: FontWeight.w500
                          )
                        )
                      )
                    );
                  }).toList()
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: index == 1 ? Color.fromRGBO(215, 0, 0, 0.15) : Colors.white
                  ),
                  children: ("1,TIET11,AES Tietê,9.9%").split(",").map((name) {
                    return GestureDetector(
                      onTap: () => setState(() { index = 1; start = 16.02; raise = 9.9; }),
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            name
                          )
                        )
                      )
                    );
                  }).toList()
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: index == 2 ? Color.fromRGBO(215, 0, 0, 0.15) : Colors.white
                  ),
                  children: ("2,SANB11,Santander Brasil,8.6%").split(",").map((name) {
                    return GestureDetector(
                      onTap: () => setState(() { index = 2; start = 41.31; raise = 8.6; }),
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                          )
                        )
                      )
                    );
                  }).toList()
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: index == 3 ? Color.fromRGBO(215, 0, 0, 0.15) : Colors.white
                  ),
                  children: ("3,EGIE3,Engie,8%").split(",").map((name) {
                    return GestureDetector(
                      onTap: () => setState(() { index = 3; start = 42.88; raise = 8; }),
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            name,
                            textAlign: TextAlign.center
                          )
                        )
                      )
                    );
                  }).toList()
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: index == 4 ? Color.fromRGBO(215, 0, 0, 0.15) : Colors.white
                  ),
                  children: ("4,BBAS3,Banco do Brasil,8%").split(",").map((name) {
                    return GestureDetector(
                      onTap: () => setState(() { index = 4; start = 35.24; raise = 8; }),
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                          )
                        )
                      )
                    );
                  }).toList()
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: index == 5 ? Color.fromRGBO(215, 0, 0, 0.15) : Colors.white
                  ),
                  children: ("5,SAPR11,Sanepar,7.6%").split(",").map((name) {
                    return GestureDetector(
                      onTap: () => setState(() { index = 5; start = 27.24; raise = 7.6; }),
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            name
                          )
                        )
                      )
                    );
                  }).toList()
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: index == 6 ? Color.fromRGBO(215, 0, 0, 0.15) : Colors.white
                  ),
                  children: ("6,CCRO3,CCR,7.2%").split(",").map((name) {
                    return GestureDetector(
                      onTap: () => setState(() { index = 6; start = 14.24; raise = 7.2; }),
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            name
                          )
                        )
                      )
                    );
                  }).toList()
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: index == 7 ? Color.fromRGBO(215, 0, 0, 0.15) : Colors.white
                  ),
                  children: ("7,VALE3,Vale,7.2%").split(",").map((name) {
                    return GestureDetector(
                      onTap: () => setState(() { index = 7; start = 78.96; raise = 7.2; }),
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            name
                          )
                        )
                      )
                    );
                  }).toList()
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: index == 8 ? Color.fromRGBO(215, 0, 0, 0.15) : Colors.white
                  ),
                  children: ("8,ITUB4,Itaú,7.1%").split(",").map((name) {
                    return GestureDetector(
                      onTap: () => setState(() { index = 8; start = 29.96; raise = 7.1; }),
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            name
                          )
                        )
                      )
                    );
                  }).toList()
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: index == 9 ? Color.fromRGBO(215, 0, 0, 0.15): Colors.white
                  ),
                  children: ("9,TRPL4,Transmissão Paulista,7.1%").split(",").map((name) {
                    return GestureDetector(
                      onTap: () => setState(() { index = 9; start = 26.94; raise = 7.1; }),
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                          )
                        )
                      )
                    );
                  }).toList()
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: index == 10 ? Color.fromRGBO(215, 0, 0, 0.15) : Colors.white
                  ),
                  children: ("10,BBDC4,Bradesco,7%").split(",").map((name) {
                    return GestureDetector(
                      onTap: () => setState(() { index = 10; start = 25.58; raise = 7; }),
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            name
                          )
                        )
                      )
                    );
                  }).toList()
                )
              ],
            )
          )
        ]
      )
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}