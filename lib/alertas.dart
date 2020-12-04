import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'services/alertasService.dart';
import 'alerta/alerta.dart';
import 'resumo.dart';

class Alertas extends StatefulWidget {
  String equityID, ticker;
  Alertas(this.equityID, this.ticker);

  AlertasForm createState() => AlertasForm();
}

class AlertasForm extends State<Alertas> {
  final GlobalKey<ScaffoldState> alertaKey = new GlobalKey<ScaffoldState>();
  var ptBR = initializeDateFormatting('pt_Br', null);
  final dateFormat = new DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: alertaKey,
      appBar: AppBar(
        title: Text("Alertas"),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(_createRoute(Resumo(equityID: widget.equityID, ticker: widget.ticker)));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(_createRoute(Alerta(equityID: widget.equityID, ticker: widget.ticker,)));
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: AlertasService().list(widget.equityID),
        builder: (context2, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/images/no_results.png"),
                    width: 200
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
            );
            else
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context3, index) {
                  var item = snapshot.data[index];
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: alertaKey.currentContext,
                        builder: (BuildContext alertaDialog1) {
                          return AlertDialog(
                            title: Text("Atenção!"),
                            content: Text("Tem certeza que deseja excluir esse alerta?"),
                            actions: [
                              FlatButton(
                                child: Text("Sim"),
                                onPressed: () async {
                                  var _result = await AlertasService().delete(item.id);
                                  Navigator.of(alertaDialog1).pop();
                                  showDialog(
                                    context: alertaKey.currentContext,
                                    builder: (BuildContext alertaDialog2) {
                                      return AlertDialog(
                                        title: Text(_result ? "Sucesso" : "Erro"),
                                        content: Text(_result ? "Alerta excluído com sucesso!" : "Falha ao excluir Alerta. Tente novamente mais tarde."),
                                        actions: [
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(alertaDialog2).pop();
                                              if (_result) Navigator.of(context).push(_createRoute(Alertas(widget.equityID, widget.ticker)));
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
                                onPressed: () => Navigator.of(alertaDialog1).pop(), 
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
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: snapshot.data.length - 1 == index ? 10 : 0),
                      child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              width: 7,
                              color: Colors.red
                            )
                          )
                        ),
                        child: ListTile(
                          title: Text(item.price.toString()),
                          subtitle: Text(item.type.toString()),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(_createRoute(Alerta(equityID: widget.equityID, alertaID: item.id, ticker: widget.ticker)));
                            },
                          ),
                        )
                      )
                    ))
                  );
                }
              );
          }
          else if (snapshot.hasError)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/images/error.png"),
                    width: 200
                  ),
                  Text(
                    "Desculpe! Tente novamente mais tarde.",
                    style: TextStyle(
                      color: Color.fromRGBO(215, 0, 0, 0.2),
                      fontWeight: FontWeight.w500
                    )
                  )
                ]
              )
            );
          else
            return Center(child: CircularProgressIndicator());
        },
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