import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stock_app/services/usuarioService.dart';
import 'home.dart';
import 'esqueciSenha.dart';

class Login extends StatefulWidget {
  LoginForm createState() => LoginForm();
}

class LoginForm extends State<Login> {
  String nome, email, senha;
  bool cadastro = false;
  bool loading = false;
  final GlobalKey<FormState> login = GlobalKey<FormState>();

  @override  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(51, 51, 51, 1)
        ),
      ),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 0.5,
              color: Color.fromRGBO(155, 155, 155, 1)
            )
          )
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cadastro ? "JÁ TEM CONTA?" : "NÃO TEM CONTA?",
                  style: TextStyle(
                    color: Color.fromRGBO(155, 155, 155, 1)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: InkWell(
                    child: Text(
                      cadastro ? "FAÇA LOGIN" : "CADASTRE-SE",
                      style: TextStyle(
                        color: Color.fromRGBO(215, 0, 0, 1)
                      )
                    ),
                    onTap: () => setState(() { 
                      login.currentState.reset();
                      cadastro = !cadastro; 
                    })
                  )
                )
              ],
            )
          )
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 170,
              color: Color.fromRGBO(215, 0, 0, 1),
              child: Center(
                child: Text(
                  "Stock4U",
                  style: TextStyle(
                    fontSize: 54,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  )
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Form(
                key: login,
                child: Column(
                  children: [
                    Visibility(
                      visible: cadastro,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "Nome"
                          ),
                          onSaved: (value) => nome = value,
                          maxLength: 100,
                          keyboardType: TextInputType.text,
                          validator: (value)  => value.isEmpty || value.trim().length == 0 ? 'Campo obrigatório' : null
                        ),
                      )
                    ),
                    cadastro ?
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "E-mail"
                      ),
                      onSaved: (value) => email = value,
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 200,
                      validator: (value)  => value.isEmpty || value.trim().length == 0 ? 'Campo obrigatório' : null
                    )
                    :
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "E-mail"
                      ),
                      onSaved: (value) => email = value,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value)  => value.isEmpty || value.trim().length == 0 ? 'Campo obrigatório' : null
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key),
                          labelText: "Senha"
                        ),
                        obscureText: true,
                        onSaved: (value) => senha = value,
                        validator: (value)  => value.isEmpty || value.trim().length == 0 ? 'Campo obrigatório' : null
                      )
                    ),
                    Visibility(
                      visible: !cadastro,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(_createRoute(EsqueciSenha()));
                            },
                            child: Text(
                              "Esqueceu sua senha?",
                              style: TextStyle(
                                color: Color.fromRGBO(215, 0, 0, 1),
                              ),
                            )
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
                            cadastro ? "Salvar" : "Entrar",
                            style: TextStyle(
                              color: Colors.white
                            )
                          ),
                          onPressed: () async {
                            if (login.currentState.validate())
                            {
                              setState(() { loading = true; });
                              login.currentState.save();
                              String _mensagem;
                              if (cadastro)
                                _mensagem = await UsuarioService().register(nome, email, senha);
                              else
                                _mensagem = await UsuarioService().login(email, senha);
                              setState(() { loading = false; });
                              if (_mensagem == null) {
                                if (cadastro) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Sucesso"),
                                        content: Text("Usuário cadastrado com sucesso!"),
                                        actions: [
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              setState(() {
                                                login.currentState.reset();
                                                cadastro = !cadastro; 
                                              });
                                              Navigator.of(context).pop();
                                            }
                                          )
                                        ],
                                      );
                                    }
                                  );
                                }
                                else {
                                  Navigator.of(context).pop();
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) => Home()));
                                }
                              }
                              else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Erro"),
                                      content: Text(_mensagem),
                                      actions: [
                                        FlatButton(
                                          child: Text("OK"),
                                          onPressed: () => Navigator.of(context).pop()
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
                    Visibility(
                      visible: !cadastro,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Color.fromRGBO(155, 155, 155, 1),
                              )
                            ),       
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "ou",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(155, 155, 155, 1),
                                ),
                              )
                            ),
                            Expanded(
                              child: Divider(
                                color: Color.fromRGBO(155, 155, 155, 1),
                              )
                            ),
                          ]
                        )
                      ),
                    ),
                    Visibility(
                      visible: !cadastro,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              child: Image(
                                width: 50,
                                height: 50,
                                image: AssetImage("assets/images/logo_facebook.png"),
                              ),
                              onTap: () async {
                                var _mensagem = await UsuarioService().loginWithFacebook();
                                
                                if (_mensagem == null) {
                                  Navigator.of(context).pop();
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) => Home()));
                                }
                                else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Erro"),
                                        content: Text(_mensagem),
                                        actions: [
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () => Navigator.of(context).pop()
                                          )
                                        ],
                                      );
                                    }
                                  );
                                }
                              },
                            )
                          ),
                          Expanded(
                            child: InkWell(
                              child: Image(
                                width: 50,
                                height: 50,
                                image: AssetImage("assets/images/logo_google.png"),
                              ),
                              onTap: () async {
                                var _mensagem = await UsuarioService().loginWithGoogle();

                                if (_mensagem == null) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(_createRoute(Home()));
                                }
                                else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Erro"),
                                        content: Text(_mensagem),
                                        actions: [
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () => Navigator.of(context).pop()
                                          )
                                        ],
                                      );
                                    }
                                  );
                                }
                              },
                            )
                          )
                        ],
                      )
                    )
                  ],
                ),
              )
            )
          ],
        ),
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