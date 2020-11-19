import 'dart:io';

class UsuarioModel {
  String id;
  String name;
  String email;
  File imageFile;
  String image;
  String gender;
  DateTime birthDate;
  String address;
  String number;
  String compliment;

  UsuarioModel(
    {
      this.id, 
      this.name, 
      this.email, 
      this.imageFile,
      this.image,
      this.gender, 
      this.birthDate,
      this.address,
      this.number,
      this.compliment
    }
  );
}