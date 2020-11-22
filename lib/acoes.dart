import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'models/acaoModel.dart';
import 'services/acaoService.dart';
import 'resumo.dart';

class Acoes extends StatefulWidget {
  String equityID, ticker;
  Acoes({this.equityID, this.ticker});
  AcoesForm createState() => AcoesForm();
}

class AcoesForm extends State<Acoes> {
  List<AcaoModel> acoes;
  bool loading;

  @override
  void initState() {
    super.initState();
    acoes = new List<AcaoModel>();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ações"),
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
            onPressed: () => Navigator.of(context).pop()
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Color.fromRGBO(195, 195, 195, 1)
                  )
                )
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Pesquisar",
                          border: InputBorder.none
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) async {
                          if (value.length > 2) {
                            setState(() { loading = true; });
                              var _result = await AcaoService().search(value);
                              setState(() {
                                acoes.clear();
                                acoes.addAll(_result);
                                loading = false;
                              });
                            }
                          },
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(Icons.search)
                    )
                  ]
                )
              ),
              loading ? 
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(child: CircularProgressIndicator())
              ) :
              acoes.length > 0 ?
              ListView.builder(
                itemCount: acoes.length,
                shrinkWrap: true,
                itemBuilder: (context2, index) {
                  final item = acoes[index];
                  return ListTile(
                    title: Text(item.ticker),
                    subtitle: Text(item.name),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context3) {
                          return AlertDialog(
                            title: Text("Atenção!"),
                            content: Text("Tem certeza que deseja adicionar essa ação à sua lista?"),
                            actions: [
                              FlatButton(
                                child: Text("Sim"),
                                onPressed: () async {
                                  setState(() { loading = true; });
                                  var _result = null;
                                  if (widget.equityID == null)
                                    _result = await AcaoService().add(item.ticker, item.name);
                                  else
                                    _result = await AcaoService().addCompare(item.ticker, item.name, widget.equityID);
                                  setState(() { loading = false; });
                                  Navigator.of(context3).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context4) {
                                      return AlertDialog(
                                        title: Text(_result == null ? "Sucesso" : "Erro"),
                                        content: Text(_result == null ? "Ação adicionada com sucesso!" : _result),
                                        actions: [
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context4).pop();
                                              if (widget.equityID == null)
                                                Navigator.of(context).push(_createRoute(Home()));
                                              else
                                                Navigator.of(context).push(_createRoute(Resumo(equityID: widget.equityID, ticker: widget.ticker)));
                                            }
                                          )
                                        ]
                                      );
                                    }
                                  );
                                }
                              ),
                              FlatButton(
                                child: Text(
                                  "Cancelar", 
                                  style: TextStyle(
                                    color: Colors.black38
                                  )
                                ),
                                onPressed: () => Navigator.of(context).pop()
                              )
                            ],
                          );
                        }
                      );
                    },
                  );
                },
              ) :
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(child: Text("Não há ações para exibir"))
              )
            ],
          )
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