import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/acaoService.dart';
import 'models/acaoModel.dart';
import 'components/grafico.dart';
import 'notas.dart';
import 'acoes.dart';

class Resumo extends StatefulWidget {
  AcaoModel acao;
  Resumo(this.acao);
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
        title: Text(widget.acao.ticker),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: FutureBuilder(
        future: new AcaoService().get(widget.acao.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                /*Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 30),
                  child: Center(
                    child: Grafico()
                  )
                ),*/
                Grafico(),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: widget.acao.higher == null ? Colors.blue.withOpacity(0.2) : widget.acao.higher == true ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2), 
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.acao.value.toString(),
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
                                          child: widget.acao.higher != null ? Icon(
                                            widget.acao.higher == true ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                            size: 50,
                                            color: widget.acao.higher == true ? Colors.green : Colors.red
                                          ) : Text("")
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              widget.acao.variation != null ? widget.acao.variation.toString() : "0",
                                              style: TextStyle(color: widget.acao.higher == null ? Colors.blue : widget.acao.higher == true ? Colors.green : Colors.red),
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
                                          color: widget.acao.higher == null ? Colors.blue : widget.acao.higher == true ? Colors.green : Colors.red
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(7),
                                          child: Text(
                                            widget.acao.percentage != null ? widget.acao.percentage.toString() + "%" : "0%",
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
                        onTap: () => Navigator.of(context).push(_createRoute(Notas(widget.acao.id))),
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
                Expanded(
                  child: snapshot.data.compare == null || snapshot.data.compare.length == 0 ?
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
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
                  ) :
                  ListView.builder(
                    itemCount: snapshot.data.compare.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data.compare[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
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
                      );
                    }
                  )
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