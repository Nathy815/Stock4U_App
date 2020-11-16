import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'home.dart';
import 'acoes.dart';
import 'services/usuarioService.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Perfil extends StatefulWidget {
  PerfilForm createState() => PerfilForm();
}

class PerfilForm extends State<Perfil> {
  final GlobalKey _part1 = GlobalKey();
  var ptBR = initializeDateFormatting('pt_Br', null);
  final dateFormat = new DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context2) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Center(
          child: Text("")
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (opcao) async {
              if (opcao != "Editar") {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Atenção!"),
                      content: Text(opcao == "Sair" ? "Tem certeza que deseja sair?" : "Tem certeza que deseja excluir sua conta?"),
                      actions: [
                        FlatButton(
                          child: Text("Sim"),
                          onPressed: () async{
                            if (opcao == "Sair")
                              await UsuarioService().logout();
                            else
                              await UsuarioService().delete();
                            Navigator.of(context).pop();
                            Navigator.of(context2).pop();
                            Navigator.of(context2).push(_createRoute(Login()));
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
              }
              print(opcao);
            },
            itemBuilder: (BuildContext context) {
              return ["Editar", "Sair", "Excluir Conta"].map((String opcao) {
                return PopupMenuItem<String>(
                  value: opcao,
                  child: ListTile(
                    leading: Icon(
                      opcao == 'Editar' ? Icons.edit : opcao == 'Sair' ? Icons.exit_to_app : Icons.delete,
                      color: opcao == "Excluir Conta" ? Colors.red : Colors.black,
                    ),
                    title: Text(
                      opcao,
                      style: TextStyle(
                        color: opcao == "Excluir Conta" ? Colors.red : Colors.black
                      )
                    )
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: ""
          )
        ],
        onTap: (value) {
          Navigator.of(context).pop();
          if (value == 0)
            Navigator.of(context).push(_createRoute(Home()));
          else if (value == 1)
            Navigator.of(context).push(_createRoute(Acoes()));
        },
      ),
      body: FutureBuilder(
        future: UsuarioService().get(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 250, bottom: 30),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.person, 
                            color: Color.fromRGBO(215, 0, 0, 1),
                          ),
                          title: Text("Nome"),
                          subtitle: Text(snapshot.data.name),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ListTile(
                            leading: Icon(
                              Icons.email, 
                              color: Color.fromRGBO(215, 0, 0, 1),
                            ),
                            title: Text("E-mail"),
                            subtitle: Text(snapshot.data.email),
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ListTile(
                            leading: Icon(
                              Icons.person, 
                              color: Color.fromRGBO(215, 0, 0, 1),
                            ),
                            title: Text("Sexo"),
                            subtitle: Text(snapshot.data.gender == null ? "-" : snapshot.data.gender),
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ListTile(
                            leading: Icon(
                              Icons.calendar_today, 
                              color: Color.fromRGBO(215, 0, 0, 1),
                            ),
                            title: Text("Data de Nascimento"),
                            subtitle: Text(snapshot.data.birthDate == null ? "-" : dateFormat.format(snapshot.data.birthDate)),
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ListTile(
                            leading: Icon(
                              Icons.location_city, 
                              color: Color.fromRGBO(215, 0, 0, 1),
                            ),
                            title: Text("Endereço"),
                            subtitle: Text(
                              snapshot.data.address.zipCode == null ? "-" : 
                              snapshot.data.address.local + ", " + snapshot.data.address.number + (snapshot.data.address.compliment == null ? "" : ", " + snapshot.data.address.compliment) + " - " + snapshot.data.address.neighborhood + " - " + snapshot.data.address.city + "/" + snapshot.data.address.state
                            ),
                          )
                        ),
                      ],
                    )
                  )
                ),
                Positioned(
                  child: Column(
                    children: [ 
                      Container(
                        color: Color.fromRGBO(215, 0, 0, 1),
                        height: 105,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Container(
                        color: Colors.transparent,
                        height: 145,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ]
                  )
                ),
                Flexible (
                  key: _part1,
                  child: Column (
                    children: <Widget>[
                      Center(
                        child: SizedBox (
                          width: 200,
                          height: 200,
                          child: RaisedButton(
                            child: snapshot.data.image != null ? 
                            Center(child: Image.network(snapshot.data.image)) :
                            Center(child: Text("Sem imagem")),
                            color: Colors.white,
                            textColor: Color.fromRGBO(215, 0, 0, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200.0),
                              side: BorderSide(
                                color: Color.fromRGBO(215, 0, 0, 1),
                                width: 2
                              )
                            ),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Home()))
                          ),
                        )
                      )
                    ]
                  ),
                ),
              ]
            );
          else if (snapshot.hasError)
            return Center(child: Text('Não foi possível carregar o seu perfil'));
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