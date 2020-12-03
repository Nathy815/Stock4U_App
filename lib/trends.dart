import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'noticias.dart';
import 'components/stock4_u_icons.dart' as CustomIcons;
import 'perfil.dart';

class Trends extends StatelessWidget {
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
          /*Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            child: Text("2021"),
          ),*/
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(
                color: Colors.grey,
                width: 0.5
              )
            ),
            children: [
              TableRow(
                children: ("Posição,Ticker,Nome,Valor").split(",").map((name) {
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
                children: ("#1,TIET11,AES Tietê,9.9%").split(",").map((name) {
                  return Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        name
                      )
                    )
                  );
                }).toList()
              ),
              TableRow(
                children: ("#2,SANB11,Santander Brasil,8.6%").split(",").map((name) {
                  return Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        name
                      )
                    )
                  );
                }).toList()
              ),
              TableRow(
                children: ("#3,EGIE3,Engie,8%").split(",").map((name) {
                  return Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        name
                      )
                    )
                  );
                }).toList()
              ),
              TableRow(
                children: ("#4,BBAS3,Banco do Brasil,8%").split(",").map((name) {
                  return Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        name
                      )
                    )
                  );
                }).toList()
              ),
              TableRow(
                children: ("#5,SAPR11,Sanepar,7.6%").split(",").map((name) {
                  return Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        name
                      )
                    )
                  );
                }).toList()
              ),
              TableRow(
                children: ("#6,CCRO3,CCR,7.2%").split(",").map((name) {
                  return Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        name
                      )
                    )
                  );
                }).toList()
              ),
              TableRow(
                children: ("#7,VALE3,Vale,7.2%").split(",").map((name) {
                  return Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        name
                      )
                    )
                  );
                }).toList()
              ),
              TableRow(
                children: ("#8,ITUB4,Itaú,7.1%").split(",").map((name) {
                  return Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        name
                      )
                    )
                  );
                }).toList()
              ),
              TableRow(
                children: ("#9,TRPL4,Transmissão Paulista,7.1%").split(",").map((name) {
                  return Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        name
                      )
                    )
                  );
                }).toList()
              ),
              TableRow(
                children: ("#10,BBDC4,Bradesco,7%").split(",").map((name) {
                  return Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        name
                      )
                    )
                  );
                }).toList()
              )
            ],
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