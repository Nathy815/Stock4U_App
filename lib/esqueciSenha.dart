import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EsqueciSenha extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Text("Esqueci Minha Senha"),
      )
    );
  }
}