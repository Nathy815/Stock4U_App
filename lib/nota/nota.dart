import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:stock_app/models/notaModel.dart';
import '../services/notasService.dart';
import '../notas.dart';

class Nota extends StatefulWidget {
  String equityID, notaID;
  Nota({this.equityID, this.notaID});

  NotaForm createState() => NotaForm();
}

class NotaForm extends State<Nota> {
  final GlobalKey<FormState> nota = GlobalKey<FormState>();
  var ptBR = initializeDateFormatting('pt_Br', null);
  final dateFormat = new DateFormat('dd/MM/yyyy HH:mm');
  TextEditingController titulo = new TextEditingController();
  TextEditingController comentario = new TextEditingController();
  File anexo;
  DateTime alerta = DateTime.now();
  bool alertar = false;
  bool loading = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      getData();
    });
  }

  getData() async {
    var _model = await NotasService().get(widget.notaID);
    if (_model != null) {
      titulo.text = _model.title;
      comentario.text = _model.comments;
      setState(() {
        if (_model.alert != null)
        {
          alertar = true;
          alerta = _model.alert;
        }
        //if (_model.attach != null) 
      });
    }
  }

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
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            shadowColor: Color.fromRGBO(250, 250, 250, 1),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: nota,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Título",
                      style: TextStyle(
                        color: Color.fromRGBO(215, 0, 0, 1),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    TextFormField(
                      controller: titulo,
                      onSaved: (value) => titulo.text = value,
                      maxLength: 100,
                      keyboardType: TextInputType.text,
                      validator: (value)  => value.isEmpty || value.trim().length == 0 ? 'Campo obrigatório' : null
                    ),
                    Text(
                      "Comentário",
                      style: TextStyle(
                        color: Color.fromRGBO(215, 0, 0, 1),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    TextFormField(
                      controller: comentario,
                      onSaved: (value) => comentario.text = value,
                      maxLength: 256,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      validator: (value)  => value.isEmpty || value.trim().length == 0 ? 'Campo obrigatório' : null
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      trailing: IconButton(
                        onPressed: () {
                          print("upload");
                        },
                        icon: Icon(
                          Icons.attach_file,
                          color: anexo == null ? Colors.black38 : Color.fromRGBO(215, 0, 0, 1),
                        )
                      ),
                      title: Text(
                        "Anexar",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(215, 0, 0, 1),
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      subtitle: Text(
                        anexo == null ? "Nenhum arquivo anexado" : anexo.path,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Alerta",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(215, 0, 0, 1),
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Switch(
                          value: alertar,
                          onChanged: (value) {
                            setState(() {
                              alertar = value;
                            });
                          },
                          activeColor: Color.fromRGBO(215, 0, 0, 1),
                        )
                      ],
                    ),
                    Visibility(
                      visible: alertar,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(2030, 12, 31), 
                              onConfirm: (date) {
                                setState(() {
                                  alerta = date;
                                });
                              }, 
                              currentTime: alerta,
                              locale: LocaleType.pt
                            );
                          },
                          child: Text(
                            dateFormat.format(alerta),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(215, 0, 0, 1)
                            ),
                          )
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
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
                          child: 
                          loading ?
                          CircularProgressIndicator() :
                          Text(
                            "Salvar",
                            style: TextStyle(
                              color: Colors.white
                            )
                          ),
                          onPressed: () async {
                            if (nota.currentState.validate())
                            {
                              nota.currentState.save();
                              setState(() { loading = true; });
                              var _alert = alertar ? alerta : null;
                              print(_alert.toString());
                              var _mensagem = await NotasService().create(
                                new NotaModel(
                                  title: titulo.text, 
                                  comments: comentario.text,
                                  attachFile: anexo,
                                  alert: _alert
                                ),
                                widget.equityID
                              );
                              setState(() { loading = true; });

                              if (_mensagem == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context2) {
                                    return AlertDialog(
                                      title: Text("Sucesso"),
                                      content: Text("Nota cadastrada com sucesso!"),
                                      actions: [
                                        FlatButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            setState(() {
                                              nota.currentState.reset();
                                            });
                                            Navigator.of(context2).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(_createRoute(Notas(widget.equityID)));
                                          }
                                        )
                                      ],
                                    );
                                  }
                                );
                              }
                              else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context2) {
                                    return AlertDialog(
                                      title: Text("Erro"),
                                      content: Text(_mensagem),
                                      actions: [
                                        FlatButton(
                                          child: Text("OK"),
                                          onPressed: () => Navigator.of(context2).pop()
                                        )
                                      ],
                                    );
                                  }
                                );
                              }
                            }
                          }
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color.fromRGBO(180, 180, 180, 1), Color.fromRGBO(180, 180, 180, 0.8)],
                            begin: FractionalOffset.centerLeft,
                            end: FractionalOffset.centerRight,
                          ),
                        ),
                        child: FlatButton(
                          child: Text(
                            "Cancelar",
                            style: TextStyle(
                              color: Colors.white
                            )
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(_createRoute(Notas(widget.equityID)));
                          }
                        )
                      )
                    )
                  ],
                )
              )
            ),
          ),
        ),
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