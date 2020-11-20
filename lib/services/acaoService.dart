import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/acaoModel.dart';
import '../models/acaoDetalheModel.dart';
import 'dart:convert';

class AcaoService {

  final _auth = FirebaseAuth.instance;
  final String _apiURL = 'http://ec2-52-67-44-12.sa-east-1.compute.amazonaws.com/stock_api/';

  Future<List<AcaoModel>> list() async {
    var prefs = await SharedPreferences.getInstance();
    var _userID = prefs.getString("userID");
    
    var _lista = new List<AcaoModel>();
    var _result = await http.get(_apiURL + "api/equity/list/" + _userID,
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer ' + prefs.getString('userToken')
                                  });
    
    if (_result.statusCode == 200) {
      var _response = json.decode(_result.body);
      
      for (var item in _response)
      {
        _lista.add(new AcaoModel(
          id: item['id'].toString(),
          ticker: item['ticker'].toString(),
          name: item['name'].toString(),
          value: item['value'],
          variation: item['variation'],
          percentage: item['percentage'],
          higher: item['higher'],
        ));
      }
    }
    
    return _lista;
  }

  Future<bool> delete(String equityID) async {
    var prefs = await SharedPreferences.getInstance();
    print('equity: ' + equityID);
    print('user: ' + prefs.getString("userID"));
    var _result = await http.delete(_apiURL + "api/equity/delete/" + equityID + "/" + prefs.getString("userID"));

    if (_result.statusCode == 200)
      return true;

    return false;
  }

  Future<AcaoModel> get(String equityID) async {
    var prefs = await SharedPreferences.getInstance();
    var _body = json.encode({ "UserID": prefs.getString("userID"), "EquityID": equityID});
    
    var _result = await http.post(_apiURL + "api/equity/get",
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer ' + prefs.getString('userToken')
                                  },
                                  body: _body
                                  );
    
    if (_result.statusCode == 200) {
      var _response = json.decode(_result.body);
      
      var _model = new AcaoModel(
        id: _response['id'].toString(),
        ticker: _response['ticker'].toString(),
        name: _response['name'].toString(),
        value: _response['value'],
        variation: _response['variation'],
        percentage: _response['percentage'],
        higher: _response['higher'],
        notes: _response['notes'],
        compare: new List<AcaoModel>()
      );

      for(var item in _response['compare'])
      {
        _model.compare.add(new AcaoModel(
          id: item['id'].toString(),
          ticker: item['ticker'].toString(),
          name: item['name'].toString(),
          value: item['value'],
          variation: item['variation'],
          percentage: item['percentage'],
          higher: item['higher']
        ));
      }

      print('passou');

      return _model;
    }

    print('code: ' + _result.statusCode.toString());
     
    return new AcaoModel();
  }

  Future<List<AcaoModel>> search(String termo) async {
    var prefs = await SharedPreferences.getInstance();
    var _result = await http.get(_apiURL + "api/equity/search/" + termo,
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer ' + prefs.getString('userToken')
                                  });
    var _lista = new List<AcaoModel>();
    
    if (_result.statusCode == 200) {
      var _response = json.decode(_result.body);
      
      for (var item in _response)
      {
        _lista.add(new AcaoModel(
          ticker: item['ticker'].toString(),
          name: item['name'].toString()
        ));
      }
    }

    return _lista;
  }

  Future<String> add(String ticker, String name) async {
    var prefs = await SharedPreferences.getInstance();
    var _body = json.encode({ "Ticker": ticker, "Name": name, "UserID": prefs.getString("userID")});
    
    var _result = await http.post(_apiURL + "api/equity/create",
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer ' + prefs.getString('userToken')
                                  },
                                  body: _body);
    
    if (_result.statusCode == 200)
      return null;
    else
      return "Falha ao adicionar ação. Tente novamente mais tarde.";
  }

  Future<String> addCompare(String ticker, String name, String equityID) async {
    var prefs = await SharedPreferences.getInstance();
    var _body = json.encode({ "Ticker": ticker, "Name": name, "EquityID": equityID, "UserID": prefs.getString("userID")});
    print(_body.toString());
    var _result = await http.post(_apiURL + "api/equity/compare",
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer ' + prefs.getString('userToken')
                                  },
                                  body: _body);
    
    if (_result.statusCode == 200)
      return null;
    else
      return "Falha ao adicionar ação. Tente novamente mais tarde.";
  }
}