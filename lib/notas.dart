import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'services/notasService.dart';
import 'nota/nota.dart';
import 'resumo.dart';

class Notas extends StatefulWidget {
  String equityID, ticker;
  Notas(this.equityID, this.ticker);

  NotasForm createState() => NotasForm();
}

class NotasForm extends State<Notas> {
  var ptBR = initializeDateFormatting('pt_Br', null);
  final dateFormat = new DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notas"),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            print('ticker notas back: ' + widget.ticker);
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
              Navigator.of(context).push(_createRoute(Nota(equityID: widget.equityID, ticker: widget.ticker,)));
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      /*floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(_createRoute(Nota(equityID: widget.equityID)));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
      ),*/
      body: FutureBuilder(
        future: NotasService().list(widget.equityID),
        builder: (context2, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return Center(child: Text("Essa ação não possui notas."));
            else
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context3, index) {
                  var item = snapshot.data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(_createRoute(Nota(equityID: widget.equityID, notaID: item.id, ticker: widget.ticker)));
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context2) {
                          return AlertDialog(
                            title: Text("Atenção!"),
                            content: Text("Tem certeza que deseja excluir essa nota?"),
                            actions: [
                              FlatButton(
                                child: Text("Sim"),
                                onPressed: () async {
                                  var _result = await NotasService().delete(item.id);
                                  Navigator.of(context).pop(context2);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context3) {
                                      return AlertDialog(
                                        title: Text(_result ? "Sucesso" : "Erro"),
                                        content: Text(_result ? "Nota excluída com sucesso!" : "Falha ao excluir Nota. Tente novamente mais tarde."),
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
                        child: ExpansionTile(
                          key: GlobalKey(),
                          initiallyExpanded: false,
                          leading: item.alert == null ? 
                            Icon(Icons.alarm_off) :
                            Icon(Icons.alarm_on),
                          title: Text(item.title),
                          trailing: Icon(Icons.arrow_drop_down),
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Comentário",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(215, 0, 0, 1),
                                    fontWeight: FontWeight.w500
                                  ),
                                )
                              )
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.comments,
                                  style: TextStyle(
                                    color: Color.fromRGBO(15, 15, 15, 1)
                                  )
                                )
                              )
                            ),
                            Visibility(
                              visible: item.attach != null,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Anexo",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(215, 0, 0, 1),
                                      fontWeight: FontWeight.w500
                                    ),
                                  )
                                )
                              )
                            ),
                            Visibility(
                              visible: item.attach != null,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Tem anexo",
                                    style: TextStyle(
                                      color: Color.fromRGBO(15, 15, 15, 1)
                                    )
                                  )
                                )
                              )
                            ),
                            Visibility(
                              visible: item.alert != null,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Alerta",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(215, 0, 0, 1),
                                      fontWeight: FontWeight.w500
                                    ),
                                  )
                                )
                              )
                            ),
                            Visibility(
                              visible: item.alert != null,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.alert != null ? dateFormat.format(item.alert) : "-",
                                    style: TextStyle(
                                      color: Color.fromRGBO(15, 15, 15, 1)
                                    )
                                  )
                                )
                              )
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color.fromRGBO(215, 0, 0, 1), Color.fromRGBO(215, 0, 0, 0.8)],
                                    begin: FractionalOffset.centerLeft,
                                    end: FractionalOffset.centerRight,
                                  ),
                                ),
                                child: FlatButton(
                                  onPressed: () {
                                    //Navigator.of(context).pop();
                                    setState(() {});
                                    Navigator.of(context).push(_createRoute(Nota(notaID: item.id, equityID: widget.equityID,)));
                                  },
                                  child: Text(
                                    "Editar",
                                    style: TextStyle(
                                      color: Colors.white
                                    )
                                  ),
                                )
                              )
                            )
                          ],
                        )
                      )
                    ))
                  );
                }
              );
          }
          else if (snapshot.hasError)
            return Center(child: Text("Não foi possível carregar as notas."));
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