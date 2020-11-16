import 'enderecoModel.dart';

class UsuarioModel {
  String id;
  String name;
  String email;
  String image;
  String gender;
  DateTime birthDate;
  EnderecoModel address;

  UsuarioModel(
    {
      this.id, 
      this.name, 
      this.email, 
      this.image,
      this.gender, 
      this.birthDate,
      this.address
    }
  );
}