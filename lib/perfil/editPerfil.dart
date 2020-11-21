import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/usuarioService.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../perfil.dart';
import '../models/usuarioModel.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditPerfil extends StatefulWidget {
  EditPerfilForm createState() => EditPerfilForm();
}

class EditPerfilForm extends State<EditPerfil> {
  String id, sexo, endereco;
  File imagem, imagemTemp;
  bool loading = false;
  DateTime dataNascimento = DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  var ptBR = initializeDateFormatting('pt_Br', null);
  final dateFormat = new DateFormat('dd/MM/yyyy');
  List<String> sexos = ["Feminino", "Masculino", "Indiferente"];
  final GlobalKey<FormState> perfil = GlobalKey<FormState>();
  TextEditingController nome = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController cepController = new TextEditingController();
  TextEditingController numeroController = new TextEditingController();
  TextEditingController complementoController = new TextEditingController();
  var maskCep = new MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  
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
        var _genderIndex = sexos.indexOf(model.gender);
        if (model.gender != null && _genderIndex > -1) sexo = sexos.elementAt(_genderIndex);
        else sexo = 'Feminino';
        if (model.address != null) {
          endereco = model.address;
          cepController.text = model.address.split('CEP: ')[1].split(' - ')[0];
        }
        if (model.number != null) numeroController.text = model.number;
        if (model.compliment != null) complementoController.text = model.compliment;
      });
    }
  }

  void getImageFromGallery() async {
    var imagemTemp = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imagem = File(imagemTemp.path);
    });
  }

  void getImageFromCamera() async {
    var imagemTemp = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      imagem = File(imagemTemp.path);
    });
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
                    Align(
                      child: Container (
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(500),
                          border: Border.all(
                            color: Color.fromRGBO(215, 0, 0, 1), 
                            width: 3
                          )
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(500),
                          child: imagem == null ?
                          Center(
                            child: Text("Selecione uma imagem")
                          ) : 
                          OverflowBox(
                            maxWidth: 200,
                            maxHeight: 200,
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              child: Image.file(
                                imagem,
                                errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                  return Center(
                                    child: Text(
                                      "Selecione uma imagem",
                                      style: TextStyle(
                                        color: Color.fromRGBO(215, 0, 0, 1),
                                        fontWeight: FontWeight.w500
                                      )
                                    )
                                  );
                                },
                              )
                            )
                          ),
                        )
                      )
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 0, right: 40),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(215, 0, 0, 1),
                                  borderRadius: BorderRadius.circular(500),
                                  border: Border.all(
                                    color: Color.fromRGBO(215, 0, 0, 1), 
                                    width: 3
                                  )
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white
                                  ),  
                                  onPressed: () => getImageFromCamera(),
                                )
                              )
                            )
                          )
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 0, left: 40),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(215, 0, 0, 1),
                                  borderRadius: BorderRadius.circular(500),
                                  border: Border.all(
                                    color: Color.fromRGBO(215, 0, 0, 1), 
                                    width: 3
                                  )
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.image,
                                    color: Colors.white
                                  ),  
                                  onPressed: () => getImageFromGallery(),
                                )
                              )
                            )
                          )
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
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
                        "CEP",
                        style: TextStyle(
                          color: Color.fromRGBO(215, 0, 0, 1),
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: cepController,
                      onSaved: (value) => cepController.text = value,
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
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      child: Text(endereco == null ? "Nenhum endereço adicionado" : endereco),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Número",
                                  style: TextStyle(
                                    color: Color.fromRGBO(215, 0, 0, 1),
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: numeroController,
                                onSaved: (value) => numeroController.text = value,
                                maxLength: 6,
                                keyboardType: TextInputType.text,
                                validator: (value) => value.isEmpty || value.trim().length == 0 ? "Campo obrigatório. Coloque 's/n' caso não possua" : null,
                              )
                            ]
                          )
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Complemento",
                                    style: TextStyle(
                                      color: Color.fromRGBO(215, 0, 0, 1),
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: complementoController,
                                  onSaved: (value) => complementoController.text = value,
                                  maxLength: 30,
                                  keyboardType: TextInputType.text,
                                  validator: (value) => value.isEmpty || value.trim().length == 0 ? "Campo obrigatório" : null,
                                )
                              ]
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
                            if (perfil.currentState.validate())
                            {
                              perfil.currentState.save();
                              setState(() { loading = true; });
                              var _mensagem = await UsuarioService().update(new UsuarioModel(
                                id: id,
                                birthDate: dataNascimento,
                                gender: sexo,
                                address: endereco,
                                number: numeroController.text,
                                compliment: complementoController.text
                              ));
                              setState(() { loading = false; });

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
              )
            )
          )
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