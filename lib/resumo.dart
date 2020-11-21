import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/acaoService.dart';
import 'models/acaoModel.dart';
import 'components/grafico.dart';
import 'notas.dart';
import 'acoes.dart';
import 'home.dart';
import 'perfil.dart';

class Resumo extends StatefulWidget {
  String equityID, ticker;
  Resumo({this.equityID, this.ticker});
  
  ResumoForm createState() => ResumoForm();
}

class ResumoForm extends State<Resumo> {
  List<AcaoModel> acoes;

  @override
  void initState() {
    super.initState();
    acoes = new List<AcaoModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ticker),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(51, 51, 51, 1)
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(_createRoute(Home()));
            }
          ),
        ],
      ),
      body: FutureBuilder(
        future: new AcaoService().get(widget.equityID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Grafico(),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: snapshot.data.higher == null ? Colors.blue.withOpacity(0.2) : snapshot.data.higher == true ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2), 
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snapshot.data.value.toString(),
                                    style: TextStyle(
                                      fontSize: 18
                                    ),
                                  )
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: snapshot.data.higher != null ? Icon(
                                            snapshot.data.higher == true ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                            size: 50,
                                            color: snapshot.data.higher == true ? Colors.green : Colors.red
                                          ) : Text("")
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              snapshot.data.variation != null ? snapshot.data.variation.toString() : "0",
                                              style: TextStyle(color: snapshot.data.higher == null ? Colors.blue : snapshot.data.higher == true ? Colors.green : Colors.red),
                                            )
                                          )
                                        )
                                      ]
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: snapshot.data.higher == null ? Colors.blue : snapshot.data.higher == true ? Colors.green : Colors.red
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(7),
                                          child: Text(
                                            snapshot.data.percentage != null ? snapshot.data.percentage.toString() + "%" : "0%",
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
                          )
                        )
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(_createRoute(Notas(snapshot.data.id, snapshot.data.ticker))),
                        child: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.only(top: 27, bottom: 27), 
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data.notes == null ? "0" : snapshot.data.notes.toString(),
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white
                                            )
                                          ),
                                          Text(
                                            "Notas",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white54
                                            ),
                                          )
                                        ],
                                      )
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.add_circle,
                                        color: Colors.white
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          )
                        ),
                      )
                    )
                  ]
                ),
                Visibility(
                  visible: snapshot.data.compare == null || snapshot.data.compare.length < 3,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(_createRoute(Acoes(equityID: snapshot.data.id)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red
                            ),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: InkWell(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    "Adicionar ação para comparar",
                                    style: TextStyle(
                                      color: Colors.red
                                    ),
                                  )
                                ]
                              )
                            ),
                          )
                        )
                      )
                    )
                  )
                ),
                Expanded(
                  child: snapshot.data.compare == null || snapshot.data.compare.length == 0 ?
                  Center(child: Text("Não há ações para comparar")) :
                  ListView.builder(
                    itemCount: snapshot.data.compare.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data.compare[index];
                      return GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context2) {
                              return AlertDialog(
                                title: Text("Atenção!"),
                                content: Text("Tem certeza que deseja remover essa ação da comparação?"),
                                actions: [
                                  FlatButton(
                                    child: Text("Sim"),
                                    onPressed: () async {
                                      var _result = await AcaoService().remove(snapshot.data.id, item.id);
                                      Navigator.of(context).pop(context2);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context3) {
                                          return AlertDialog(
                                            title: Text(_result ? "Sucesso" : "Erro"),
                                            content: Text(_result ? "Ação removida com sucesso!" : "Falha ao remover ação. Tente novamente mais tarde."),
                                            actions: [
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context3).pop();
                                                  if (_result) setState(() {});
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
                          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: snapshot.data.compare.length - 1 == index ? 10 : 0),
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 10,
                                    color: index == 0 ? Colors.orange : index == 1 ? Colors.blue : Colors.green
                                  )
                                )
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
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
                                    ),
                                  ],
                                )
                              )
                            )
                          )
                        )
                      );
                    }
                  ),
                )
              ]
            );
          }
          else if (snapshot.hasError)
            return Center(child: Text("Não foi possível carregar os dados dessa ação."));
          else
            return Center(child: CircularProgressIndicator());
        }
      ),
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