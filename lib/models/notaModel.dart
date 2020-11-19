import 'dart:io';

class NotaModel {
  String id;
  String title;
  String comments;
  String attach;
  File attachFile;
  DateTime alert;

  NotaModel({this.id, this.title, this.comments, this.attach, this.attachFile, this.alert});
}