import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notaModel.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class NotasService {
  final String _apiURL = 'http://ec2-52-67-44-12.sa-east-1.compute.amazonaws.com/stock_api/';

  Future<List<NotaModel>> list(String equityID) async {
    var prefs = await SharedPreferences.getInstance();
    var _userID = prefs.getString("userID");
    var _body = json.encode({"UserID" : _userID, "EquityID": equityID});
    
    var _result = await http.post(_apiURL + "api/note/list",
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer ' + prefs.getString("userToken")
                                  },
                                  body: _body
                                  );

    var _lista = new List<NotaModel>();
    if (_result.statusCode == 200)
    {
      var _response = json.decode(_result.body);
      for (var item in _response)
        _lista.add(new NotaModel(
          id: item['id'].toString(),
          title: item['title'].toString(),
          comments: item['comments'] != null ? item['comments'].toString() : null,
          attach: item['attach'] != null ? item['attach'].toString() : null,
          alert: item['alert'] == null ? null : DateTime.parse(item['alert'].toString())
        ));
    }

    return _lista;
  }

  Future<NotaModel> get(String id) async {
    var prefs = await SharedPreferences.getInstance();
    
    var _result = await http.get(_apiURL + "api/note/" + id,
                                 headers: {
                                   'Authorization': 'Bearer ' + prefs.getString("userToken")
                                 });

    if (_result.statusCode == 200) {
      var _response = json.decode(_result.body);
      return new NotaModel(
        id: _response['id'].toString(),
        title: _response['title'].toString(),
        comments: _response['comments'] == null ? null : _response['comments'].toString(),
        attach: _response['attach'] == null ? null : _response['attach'].toString(),
        alert: _response['alert'] == null ? null : DateTime.parse(_response['alert'].toString())
      );
    }

    return null;
  }

  Future<bool> delete(String id) async {
    var prefs = await SharedPreferences.getInstance();

    var _result = await http.delete(_apiURL + "api/note/delete/" + id,
                                    headers: {
                                      'Authorization': 'Bearer ' + prefs.getString("userToken")
                                    });

    if (_result.statusCode == 200)
      return true;

    return false;
  }

  Future<String> create(NotaModel model, String equityID) async {
    var prefs = await SharedPreferences.getInstance();

    var _data = new FormData.fromMap({
      "Title": model.title,
      "Comments": model.comments,
      "Attach": model.attachFile,
      "Alert": model.alert,
      "EquityID": equityID,
      "UserID": prefs.getString("userID")
    });

    var _result = await new Dio().post(_apiURL + "api/note/create",
                                       data: _data);

    if (_result.statusCode == 200)
      return null;
    else 
      return "Falha ao cadastrar nota. Tente novamente mais tarde.";
  }

  Future<String> update(NotaModel model) async {
    var _data = new FormData.fromMap({
      "Id": model.id,
      "Title": model.title,
      "Comments": model.comments,
      "Attach": model.attachFile,
      "Alert": model.alert
    });

    var _result = await new Dio().patch(_apiURL + "api/note/update",
                                        data: _data);

    if (_result.statusCode == 200)
      return null;
    else 
      return "Falha ao editar nota. Tente novamente mais tarde.";
  }
}