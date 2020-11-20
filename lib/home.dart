import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/acaoService.dart';
import 'resumo.dart';
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
        title: Text("Minhas Ações"),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(51, 51, 51, 1)
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white
            ),
            onPressed: () {
              //Navigator.of(context).pop();
              Navigator.of(context).push(_createRoute(Acoes()));
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: ""
          )
        ],
        onTap: (value) {
          if (value == 1)
          {
            Navigator.of(context).pop();
            Navigator.of(context).push(_createRoute(Perfil()));
          }
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
                return GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pop();
                    Navigator.of(context).push(_createRoute(Resumo(item)));
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context2) {
                        return AlertDialog(
                          title: Text("Atenção!"),
                          content: Text("Tem certeza que deseja excluir essa ação da sua lista?"),
                          actions: [
                            FlatButton(
                              child: Text("Sim"),
                              onPressed: () async {
                                var _result = await AcaoService().delete(item.id);
                                Navigator.of(context).pop(context2);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context3) {
                                    return AlertDialog(
                                      title: Text(_result ? "Sucesso" : "Erro"),
                                      content: Text(_result ? "Ação excluída com sucesso!" : "Falha ao excluir ação. Tente novamente mais tarde."),
                                      actions: [
                                        FlatButton(
                                          onPressed: () {
                                            //Navigator.of(context).pop(context);
                                            Navigator.of(context3).pop();
                                            if (_result) setState(() {});//Navigator.of(context).push(_createRoute(Home()));
                                          }, 
                                          child: Text("OK")
                                        )
                                      ],
                                    );
                                  }
                                );
                              },
                            ),
                            FlatButton(
                              onPressed: () => Navigator.of(context2).pop(), 
                              child: Text(
                                "Cancelar", 
                                style: TextStyle(
                                  color: Colors.black38
                                )
                              )
                            )
                          ],
                        );
                      }
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            width: index != snapshot.data.length ? 0.5 : 0,
                            color: Colors.black12
                          )
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 15, bottom: 10, right: 5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
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
                              flex: 6,
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
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight, 
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.black38
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                    )
                  ))
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