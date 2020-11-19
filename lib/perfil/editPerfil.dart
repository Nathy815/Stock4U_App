import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/usuarioService.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../perfil.dart';
import '../models/usuarioModel.dart';

class EditPerfil extends StatefulWidget {
  EditPerfilForm createState() => EditPerfilForm();
}

class EditPerfilForm extends State<EditPerfil> {
  String id, sexo, cep, endereco, numero, complemento;
  DateTime dataNascimento = DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  var ptBR = initializeDateFormatting('pt_Br', null);
  final dateFormat = new DateFormat('dd/MM/yyyy HH:mm');
  List<String> sexos = ["Feminino", "Masculino", "Indiferente"];
  final GlobalKey<FormState> perfil = GlobalKey<FormState>();
  TextEditingController nome = new TextEditingController();
  TextEditingController email = new TextEditingController();
  var maskCep = new MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      getData();
    });
  }

  getData() async {
    var model = await UsuarioService().get();
    if (model != null) {
      setState(() {
        id = model.id;
        nome.text = model.name;
        email.text = model.email;
        if (model.birthDate != null) dataNascimento = model.birthDate;
        if (model.gender != null) sexo = sexos.elementAt(sexos.indexOf(model.gender));
        else sexo = 'Feminino';
        print(model.address);
        if (model.address != null) {
          endereco = model.address;
          cep = model.address.split('CEP: ')[1].split(' - ')[0];
        }
        if (model.number != null) numero = model.number;
        if (model.compliment != null) complemento = model.compliment;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(215, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Center(
          child: Text("Edição de Perfil")
        ),
      ),
      body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                key: perfil,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft, 
                            child: Text(
                              "Nome",
                              style: TextStyle(
                                color: Color.fromRGBO(215, 0, 0, 1),
                                fontWeight: FontWeight.w500
                              ),
                            )
                          ),
                          TextFormField(
                            controller: nome,
                            enabled: false
                          ),
                        ]
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "E-mail",
                              style: TextStyle(
                                color: Color.fromRGBO(215, 0, 0, 1),
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: email,
                            enabled: false
                          ),
                        ],
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Sexo",
                              style: TextStyle(
                                color: Color.fromRGBO(215, 0, 0, 1),
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          InputDecorator(
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0
                              ),
                              hintText: 'Selecione...'
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: sexo,
                                isDense: true,
                                onChanged: (String value) {
                                  setState(() {
                                    sexo = value;
                                  });
                                },
                                items: sexos.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ]
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Data de Nascimento",
                              style: TextStyle(
                                color: Color.fromRGBO(215, 0, 0, 1),
                                fontWeight: FontWeight.w500
                              ),
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  DatePicker.showDatePicker(
                                    context,
                                    showTitleActions: true,
                                    minTime: DateTime(DateTime.now().year - 100, DateTime.now().month, DateTime.now().day),
                                    maxTime: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day), 
                                    onConfirm: (date) {
                                      setState(() {
                                        dataNascimento = date;
                                      });
                                    }, 
                                    currentTime: dataNascimento,
                                    locale: LocaleType.pt
                                  );
                                },
                                child: Text(
                                  dateFormat.format(dataNascimento),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(215, 0, 0, 1)
                                  ),
                                )
                              ),
                            )
                          )
                        ]
                      )
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Endereco",
                        style: TextStyle(
                          color: Color.fromRGBO(215, 0, 0, 1),
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    TextFormField(
                      onSaved: (value) => cep = value,
                      maxLength: 9,
                      inputFormatters: [maskCep],
                      onChanged: (value) async {
                        if (value.length == 9) {
                          var _result = await UsuarioService().getAddress(value);
                          
                          if (_result != null) {
                            setState(() {
                              endereco = _result;
                            });
                          }
                        }
                        else {
                          setState(() {
                            endereco = null;
                          });
                        }
                      },
                      keyboardType: TextInputType.number,
                      validator: (value)  => value.isEmpty || value.trim().length == 0 ? 'Campo obrigatório' : null
                    ),
                    Text(endereco == null ? "Nenhum endereço adicionado" : endereco),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            onSaved: (value) => numero = value,
                            maxLength: 6,
                            keyboardType: TextInputType.text,
                            validator: (value) => value.isEmpty || value.trim().length == 0 ? "Campo obrigatório. Coloque 's/n' caso não possua" : null,
                          )
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: TextFormField(
                              onSaved: (value) => complemento = value,
                              maxLength: 30,
                              keyboardType: TextInputType.text,
                              validator: (value) => value.isEmpty || value.trim().length == 0 ? "Campo obrigatório" : null,
                            )
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
                          child: Text(
                            "Salvar",
                            style: TextStyle(
                              color: Colors.white
                            )
                          ),
                          onPressed: () async {
                            if (perfil.currentState.validate())
                            {
                              perfil.currentState.save();
                              
                              var _mensagem = await UsuarioService().update(new UsuarioModel(
                                id: id,
                                birthDate: dataNascimento,
                                gender: sexo,
                                address: endereco,
                                number: numero,
                                compliment: complemento
                              ));

                              if (_mensagem == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context2) {
                                    return AlertDialog(
                                      title: Text("Sucesso"),
                                      content: Text("Perfil editado com sucesso!"),
                                      actions: [
                                        FlatButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            setState(() {
                                              perfil.currentState.reset();
                                            });
                                            Navigator.of(context2).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(_createRoute(Perfil()));
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
                            colors: [Color.fromRGBO(185, 185, 185, 1), Color.fromRGBO(185, 185, 185, 0.8)],
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
                            Navigator.of(context).push(_createRoute(Perfil()));
                          }
                        )
                      )
                    )
                  ],
                )
              )))
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