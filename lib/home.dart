import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/acaoService.dart';
import 'resumo.dart';
import 'perfil.dart';
import 'acoes.dart';
import 'package:signalr_client/signalr_client.dart';
import 'components/stock4_u_icons.dart' as CustomIcons;
import 'models/acaoModel.dart';
import 'noticias.dart';

class Home extends StatefulWidget {
  HomeForm createState() => HomeForm();
}

class HomeForm extends State<Home> {
  final hubConnection = HubConnectionBuilder().withUrl("http://ec2-52-67-44-12.sa-east-1.compute.amazonaws.com/stock_api/api/equityHub").build();
  List<AcaoCompareModel> _lista = new List<AcaoCompareModel>();
  final GlobalKey<ScaffoldState> home = new GlobalKey<ScaffoldState>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      getData();
      //hubConfig();
    });
  }

  getData() async {
    setState(() { loading = true; });
    var result = await AcaoService().list();
    setState(() {
      _lista.addAll(result);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: home,
      resizeToAvoidBottomPadding: false,
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
            onPressed: () async {
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
            icon: Icon(CustomIcons.Stock4U.newspaper),
            label: ""
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
            Navigator.of(context).push(_createRoute(Noticias()));
          }
          else if (value == 2)
          {
            Navigator.of(context).pop();
            Navigator.of(context).push(_createRoute(Perfil()));
          }
        },
      ),
      body: loading ? 
        Center(child: CircularProgressIndicator())
        : _lista.length == 0 ?
        Center(child: Text("Não há ações para listar"))
        : ListView.builder(
          itemCount: _lista.length,
          itemBuilder: (context, index) {
          var item = _lista[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(_createRoute(Resumo(equityID: item.id, ticker: item.ticker)));
            },
            onLongPress: () {
              showDialog(
                context: home.currentContext,
                builder: (BuildContext dialogHome1) {
                  return AlertDialog(
                    title: Text("Atenção!"),
                    content: Text("Tem certeza que deseja excluir essa ação da sua lista?"),
                    actions: [
                      FlatButton(
                        child: Text("Sim"),
                        onPressed: () async {
                          var _result = await AcaoService().delete(item.id);
                          Navigator.of(dialogHome1).pop();
                          showDialog(
                            context: home.currentContext,
                            builder: (BuildContext dialogHome2) {
                              return AlertDialog(
                                title: Text(_result ? "Sucesso" : "Erro"),
                                content: Text(_result ? "Ação excluída com sucesso!" : "Falha ao excluir ação. Tente novamente mais tarde."),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(dialogHome2).pop();
                                      if (_result) Navigator.of(home.currentContext).push(_createRoute(Home()));
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
                        onPressed: () => Navigator.of(dialogHome1).pop(), 
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
                      width: index != _lista.length ? 0.5 : 0,
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: item.higher == null ? Colors.blue : item.higher == true ? Colors.green : Colors.red
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      item.value.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18
                                      ),
                                    )
                                  )
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
                                            item.percentage != null ? item.percentage.toString() + "%" : "0%",
                                            style: TextStyle(color: item.higher == null ? Colors.blue : item.higher == true ? Colors.green : Colors.red),
                                          )
                                        )
                                      )
                                    ]
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