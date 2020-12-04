import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/acaoService.dart';
import 'models/acaoModel.dart';
import 'components/grafico.dart';
import 'package:getwidget/getwidget.dart';
import 'notas.dart';
import 'acoes.dart';
import 'home.dart';
import 'alertas.dart';

class Resumo extends StatefulWidget {
  String equityID, ticker;
  Resumo({this.equityID, this.ticker});
  
  ResumoForm createState() => ResumoForm();
}

class ResumoForm extends State<Resumo> {
  final GlobalKey<ScaffoldState> resumoKey = new GlobalKey<ScaffoldState>();
  AcaoModel acao = new AcaoModel();
  List<AcaoCompareModel> acoes = new List<AcaoCompareModel>();
  List<AcaoItemModel> itens = new List<AcaoItemModel>();
  List<int> _list = [0,1];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      getData();
    });
  }

  getData() async {
    var _result = await AcaoService().get(widget.equityID);
    
    if (_result != null)
      setState(() {
        acao = _result;
        if (acao.compare != null && acao.compare.length > 0)
        {
          acoes.clear();
          acoes.addAll(acao.compare);
        }
        if (acao.itens != null && acao.itens.length > 0)
        {
          itens.clear();
          itens.addAll(acao.itens);
        }
      });
    setState(() { loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      key: resumoKey,
      appBar: AppBar(
        title: Text(widget.ticker == null ? "" : widget.ticker),
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
      body: loading ?
        Center(child: CircularProgressIndicator()) :
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 18, top: 10),
                child: Text(
                  acao.name,
                  style: TextStyle(
                    color: Colors.grey
                  )
                )
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: GFCarousel(
                pagination: true,
                activeIndicator: Color.fromRGBO(215, 0, 0, 1),
                enlargeMainPage: true,
                viewportFraction: 1.0,
                height: 300,
                items: [
                  Container(
                    //color: Color.fromRGBO(245, 245, 245, 1),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                    children: [
                      Center(
                        child: Text(
                          acao.itens[3].value.toString(),
                          style: TextStyle(
                            color: acao.itens[3].higher == null ? Colors.black54 : acao.itens[3].higher ? Colors.green : Colors.red,
                            fontSize: 40,
                            fontWeight: FontWeight.w500
                          )
                        ),
                      ),
                      Center(
                        child: Text(
                          "" + acao.itens[3].percentage.toString() + "%  |  " + acao.itens[4].valueToString(),
                          style: TextStyle(
                            color: acao.itens[3].higher == null ? Colors.blue : acao.itens[3].higher ? Colors.green : Colors.red,
                            fontSize: 18
                          )
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 7, bottom: 7),
                        child: Container(
                          width: 135,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: acao.itens[0].higher == null ? Colors.blue : acao.itens[0].higher ? Colors.green : Colors.red,
                                width: 3
                              )
                            )
                          )
                        )
                      ),
                      Center(
                        child: Text(
                          "Atual",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12
                          )
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          acao.itens[0].value.toString(),
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 20
                                          )
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5, bottom: 5),
                                          child: Text(
                                            "(" + (acao.itens[0].higher == null ? "" : acao.itens[0].higher == true ? "+ " : "- ") + acao.itens[0].percentage.toString() + "%)",
                                            style: TextStyle(
                                              color: acao.itens[0].higher == null ? Colors.blue : acao.itens[0].higher ? Colors.green : Colors.red,
                                            )
                                          )
                                        )
                                      ]
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: acao.itens[0].higher == null ? Colors.blue : acao.itens[0].higher ? Colors.green : Colors.red,
                                          width: 3
                                        )
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      acao.itens[0].label,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey
                                      )
                                    )
                                  )
                                ],
                              )
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          acao.itens[1].value.toString(),
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 20
                                          )
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5, bottom: 5),
                                          child: Text(
                                            "(" + (acao.itens[1].higher == null ? "" : acao.itens[1].higher == true ? "+ " : "- ") + acao.itens[0].percentage.toString() + "%)",
                                            style: TextStyle(
                                              color: acao.itens[1].higher == null ? Colors.blue : acao.itens[1].higher ? Colors.green : Colors.red,
                                            )
                                          )
                                        )
                                      ]
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: acao.itens[1].higher == null ? Colors.blue : acao.itens[1].higher ? Colors.green : Colors.red,
                                          width: 3
                                        )
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      acao.itens[1].label,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey
                                      )
                                    )
                                  )
                                ],
                              )
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          acao.itens[2].value.toString(),
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 20
                                          )
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5, bottom: 5),
                                          child: Text(
                                            "(" + (acao.itens[2].higher == null ? "" : acao.itens[2].higher == true ? "+ " : "- ") + acao.itens[0].percentage.toString() + "%)",
                                            style: TextStyle(
                                              color: acao.itens[2].higher == null ? Colors.blue : acao.itens[2].higher ? Colors.green : Colors.red,
                                            )
                                          )
                                        )
                                      ]
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: acao.itens[2].higher == null ? Colors.blue : acao.itens[2].higher ? Colors.green : Colors.red,
                                          width: 3
                                        )
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      acao.itens[2].label,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey
                                      )
                                    )
                                  )
                                ],
                              )
                            )
                          ],
                        )
                      )
                    ],
                  ))),
                  Grafico(widget.equityID)
                ],
              )
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(_createRoute(Alertas(acao.id, acao.ticker))),
                    child: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.only(top: 17, bottom: 17), 
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.add_alert,
                                    color: Colors.white
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Text(
                                        acao.alerts == null ? "0" : acao.alerts.toString(),
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white
                                        )
                                      ),
                                      Text(
                                        "Alertas",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white54
                                        ),
                                      )
                                    ],
                                  )
                                )
                              ],
                            )
                          ],
                        )
                      )
                    ),
                  )
                ),
                Container(
                  width: 1,
                  height: 84,
                  color: Color.fromRGBO(215, 0, 0, 1)
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(_createRoute(Notas(acao.id, acao.ticker))),
                    child: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.only(top: 17, bottom: 17), 
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Text(
                                        acao.notes == null ? "0" : acao.notes.toString(),
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
              visible: acao.compare == null || acao.compare.length < 3,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(_createRoute(Acoes(equityID: acao.id, ticker: acao.ticker)));
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
              child: acoes == null || acoes.length == 0 ?
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("assets/images/no_results.png"),
                      width: 150
                    ),
                    Text(
                      "Sem resultados",
                      style: TextStyle(
                        color: Color.fromRGBO(215, 0, 0, 0.2),
                        fontWeight: FontWeight.w500
                      )
                    )
                  ]
                )
              ) :
              ListView.builder(
                itemCount: acoes.length,
                itemBuilder: (context, index) {
                  var item = acoes[index];
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: resumoKey.currentContext,
                        builder: (BuildContext dialogResumo1) {
                          return AlertDialog(
                            title: Text("Atenção!"),
                            content: Text("Tem certeza que deseja remover essa ação da comparação?"),
                            actions: [
                              FlatButton(
                                child: Text("Sim"),
                                onPressed: () async {
                                  var _result = await AcaoService().remove(acao.id, item.id);
                                  Navigator.of(dialogResumo1).pop();
                                  showDialog(
                                    context: resumoKey.currentContext,
                                    builder: (BuildContext dialogResumo2) {
                                      return AlertDialog(
                                        title: Text(_result ? "Sucesso" : "Erro"),
                                        content: Text(_result ? "Ação removida com sucesso!" : "Falha ao remover ação. Tente novamente mais tarde."),
                                        actions: [
                                          FlatButton(
                                            onPressed: () async {
                                              Navigator.of(dialogResumo2).pop();
                                              if (_result) {//setState(() {});
                                                Navigator.of(resumoKey.currentContext).push(_createRoute(Resumo(equityID: widget.equityID, ticker: widget.ticker)));
                                              }
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
                                onPressed: () => Navigator.of(dialogResumo1).pop(), 
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
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: acoes.length - 1 == index ? 10 : 0),
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
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: item.higher == null ? Colors.blue : item.higher == true ? Colors.green : Colors.red
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(7),
                                              child: Text(
                                                item.value != null ? item.value.toString() : "0",
                                                style: TextStyle(
                                                  color: Colors.white
                                                )
                                              ),
                                            )
                                          )
                                        )
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
                                            ),
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