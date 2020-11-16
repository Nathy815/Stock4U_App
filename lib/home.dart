import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/acaoService.dart';
import 'perfil.dart';
import 'acoes.dart';

class Home extends StatefulWidget {
  HomeForm createState() => HomeForm();
}

class HomeForm extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(51, 51, 51, 1)
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: ""
          )
        ],
        onTap: (value) {
          Navigator.of(context).pop();
          if (value == 1)
            Navigator.of(context).push(_createRoute(Acoes()));
          else if (value == 2)
            Navigator.of(context).push(_createRoute(Perfil()));
        },
      ),
      body: FutureBuilder(
        future: new AcaoService().list(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var item = snapshot.data[index];
                return Padding(
                  padding: EdgeInsets.all(0),//EdgeInsets.only(left: 30, right: 30, top: index == 0 ? 30 : 15, bottom: index == 5 ? 30 : 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      item.ticker.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    )
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black38
                                    ),
                                  )
                                )
                              ]
                            )
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      item.value.toString(),
                                      style: TextStyle(
                                        fontSize: 18
                                      ),
                                    )
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: item.higher != null ? Icon(
                                              item.higher == true ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                              size: 50,
                                              color: item.higher == true ? Colors.green : Colors.red
                                            ) : Text("")
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                item.variation != null ? item.variation.toString() : "0",
                                                style: TextStyle(color: item.higher == null ? Colors.blue : item.higher == true ? Colors.green : Colors.red),
                                              )
                                            )
                                          )
                                        ]
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: item.higher == null ? Colors.blue : item.higher == true ? Colors.green : Colors.red
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Text(
                                              item.percentage != null ? item.percentage.toString() + "%" : "0%",
                                              style: TextStyle(
                                                color: Colors.white
                                              )
                                            ),
                                          )
                                        )
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                  )
                );
              },
            );
          else if (snapshot.hasError)
            return Center(child: Text("Você ainda não possui ações."));
          else
            return Center(child: CircularProgressIndicator());
        }
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