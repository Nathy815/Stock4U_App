import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/models/alertaModel.dart';
import '../services/alertasService.dart';
import '../alertas.dart';

class Alerta extends StatefulWidget {
  String equityID, alertaID, ticker;
  Alerta({this.equityID, this.alertaID, this.ticker});

  AlertaForm createState() => AlertaForm();
}

class AlertaForm extends State<Alerta> {
  final GlobalKey<FormState> alerta = GlobalKey<FormState>();
  List<String> opcoes = ['Maior ou igual', 'Menor ou igual'];
  TextEditingController priceController = TextEditingController();
  String opcao;
  bool loadPage = true;
  bool loading = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      getData();
    });
  }

  getData() async {
    if (widget.alertaID != null) {
      var _model = await AlertasService().get(widget.alertaID);
      if (_model != null) {
        priceController.text = _model.price.toString();
        setState(() {
          opcao = opcoes[_model.type - 2];
          loadPage = false;
        });
      }
    }
    setState(() { 
      opcao = opcoes[0]; 
      loadPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alertas"),
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        automaticallyImplyLeading: false,
      ),
      body: 
      loadPage ? Center(child: CircularProgressIndicator())
      : Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            shadowColor: Color.fromRGBO(250, 250, 250, 1),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: alerta,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Preço",
                      style: TextStyle(
                        color: Color.fromRGBO(215, 0, 0, 1),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: InputDecorator(
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                  color: Colors.redAccent, fontSize: 16.0
                                ),
                                hintText: 'Selecione...'
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: opcao,
                                  isDense: true,
                                  onChanged: (String value) {
                                    setState(() {
                                      opcao = value;
                                    });
                                  },
                                  items: opcoes.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: TextFormField(
                              controller: priceController,
                              onSaved: (value) => priceController.text = value,
                              keyboardType: TextInputType.number,
                              validator: (value)  => value.isEmpty || value.trim().length == 0 ? 'Campo obrigatório' : null
                            ),
                          )
                        )
                      ],
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
                            if (alerta.currentState.validate())
                            {
                              alerta.currentState.save();
                              setState(() { loading = true; });
                              
                              String _mensagem = null;
                              var _index = opcoes.indexOf(opcao);
                              if (widget.alertaID == null)
                              {
                                _mensagem = await AlertasService().create(
                                  new AlertaModel(
                                    price: double.parse(priceController.text),
                                    type: _index + 2
                                  ),
                                  widget.equityID
                                );
                              }
                              else
                              {
                                _mensagem = await AlertasService().update(
                                  new AlertaModel(
                                    id: widget.alertaID,
                                    price: double.parse(priceController.text),
                                    type: _index + 2
                                  )
                                );
                              }

                              setState(() { loading = false; });

                              if (_mensagem == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context2) {
                                    return AlertDialog(
                                      title: Text("Sucesso"),
                                      content: Text(widget.alertaID == null ? "Alerta cadastrado com sucesso!" : "Alerta editado com sucesso!"),
                                      actions: [
                                        FlatButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            setState(() {
                                              alerta.currentState.reset();
                                            });
                                            Navigator.of(context2).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(_createRoute(Alertas(widget.equityID, widget.ticker)));
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
                            Navigator.of(context).push(_createRoute(Alertas(widget.equityID, widget.ticker)));
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