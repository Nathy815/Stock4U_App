import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alertaModel.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class AlertasService {
  final String _apiURL = 'http://ec2-52-67-44-12.sa-east-1.compute.amazonaws.com/stock_api/';

  Future<AlertaModel> get(String alertaID) async {
    var _prefs = await SharedPreferences.getInstance();

    var _result = await http.get(_apiURL + "api/price/" + alertaID);

    if (_result.statusCode == 200)
    {
      var _response = json.decode(_result.body);
      return new AlertaModel(
        id: _response['id'],
        price: _response['price'],
        type: _response['type']
      );
    }

    return null;
  }

  Future<List<AlertaModel>> list(String equityID) async {
    var _prefs = await SharedPreferences.getInstance();
    print('user: ' + _prefs.getString("userID") + " | equity: " + equityID);
    var _result = await http.get(_apiURL + "api/price/" + _prefs.getString("userID") + "/" + equityID);

    var _lista = new List<AlertaModel>();
    if (_result.statusCode == 200)
    {
      var _response = json.decode(_result.body);
      for(var _item in _response)
        _lista.add(new AlertaModel(
          id: _item['id'],
          price: _item['price'],
          type: _item['type'] 
        ));
    }

    return _lista;
  }

  Future<String> create(AlertaModel model, String equityID) async {
    var _prefs = await SharedPreferences.getInstance();
    var _body = json.encode({
                              "UserID": _prefs.getString("userID"),
                              "EquityID": equityID,
                              "Price": model.price,
                              "Type": model.type
                            });
    
    var _result = await http.post(_apiURL + "api/price",
                                  body: _body,
                                  headers: {
                                    "Content-Type": "application/json"
                                  });

    if (_result.statusCode == 200)
      return null;

    return "Falha ao cadastrar alerta. Tente novamente mais tarde.";
  }

  Future<String> update(AlertaModel model) async {
    var _body = json.encode({
                              "Id": model.id,
                              "Price": model.price,
                              "Type": model.type
                            });

    var _result = await http.patch(_apiURL + "api/price",
                                   body: _body,
                                   headers: {
                                     "Content-Type": "application/json"
                                   });

    if (_result.statusCode == 200)
      return null;

    print('update alerta: ' + _result.statusCode.toString() + ' | sent: ' + _body.toString());
    return "Falha ao editar alerta. Tente novamente mais tarde.";
  }

  Future<bool> delete(String id) async {
    var _result = await http.delete(_apiURL + "api/price/" + id);

    if (_result.statusCode == 200)
      return true;

    print('delete alerta: ' + _result.statusCode.toString() + " | sent: " + id.toString());
    return false;
  }
}