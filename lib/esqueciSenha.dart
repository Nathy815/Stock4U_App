import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/usuarioService.dart';
import 'login.dart';

class EsqueciSenha extends StatefulWidget {
  EsqueciSenhaForm createState() => EsqueciSenhaForm();
}

class EsqueciSenhaForm extends State<EsqueciSenha> {
  String email;
  bool loading = false;
  final GlobalKey<FormState> esqueci = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(51, 51, 51, 1)
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: esqueci,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 80, bottom: 40),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      color: Color.fromRGBO(215, 0, 0, 1)
                    ),
                    child: Icon(
                      Icons.vpn_key,
                      size: 100,
                      color: Colors.white
                    )
                  )
                ),
                Text(
                  "Esqueceu sua senha?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(215, 0, 0, 1)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Text(
                    "Não se preocupe. Informe seu e-mail que nós te enviaremos um link para cadastrar uma nova.",
                    textAlign: TextAlign.center,
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "E-mail"
                    ),
                    onSaved: (value) => email = value,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value)  => value.isEmpty || value.trim().length == 0 ? 'Campo obrigatório' : null
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(30),
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
                        "Enviar",
                        style: TextStyle(
                          color: Colors.white
                        )
                      ),
                      onPressed: () async {
                        if (esqueci.currentState.validate())
                        {
                          setState(() { loading = true; });
                          esqueci.currentState.save();
                          await UsuarioService().resetPassword(email);
                          setState(() { loading = false; });

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Sucesso"),
                                content: Text("E-mail enviado com sucesso! Lembre-se de verificar a caixa de spam."),
                                actions: [
                                  FlatButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(_createRoute(Login()));
                                    }
                                  )
                                ],
                              );
                            }
                          );
                        }
                      }
                    )
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
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
                        Navigator.of(context).push(_createRoute(Login()));
                      }
                    )
                  )
                )
              ],
            )
          )
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