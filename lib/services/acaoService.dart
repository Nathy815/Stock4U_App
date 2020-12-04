import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/acaoModel.dart';
import 'dart:convert';

class AcaoService {

  final _auth = FirebaseAuth.instance;
  final String _apiURL = 'http://ec2-52-67-44-12.sa-east-1.compute.amazonaws.com/stock_api/';
  
  Future<List<AcaoCompareModel>> list() async {
    
    var prefs = await SharedPreferences.getInstance();
    var _userID = prefs.getString("userID");
    
    var _lista = new List<AcaoCompareModel>();
    var _result = await http.get(_apiURL + "api/equity/list/" + _userID,
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer ' + prefs.getString('userToken')
                                  });
    
    if (_result.statusCode == 200) {
      var _response = json.decode(_result.body);
      
      for (var item in _response)
      {
        _lista.add(new AcaoCompareModel(
          id: item['id'].toString(),
          ticker: item['ticker'].toString(),
          name: item['name'].toString(),
          value: item['value'],
          percentage: item['percentage'],
          higher: item['higher'],
        ));
      }
    }
    
    return _lista;
  }

  Future<bool> delete(String equityID) async {
    var prefs = await SharedPreferences.getInstance();
    
    var _result = await http.delete(_apiURL + "api/equity/delete/" + equityID + "/" + prefs.getString("userID"),
                                    headers: {
                                      'Authorization': 'Bearer ' + prefs.getString("userToken")
                                    });

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
        notes: _response['notes'],
        alerts: _response['alerts'],
        itens: new List<AcaoItemModel>(),
        compare: new List<AcaoCompareModel>()
      );

      if (_response['items'] != null) {
        for(var item in _response['items'])
          _model.itens.add(new AcaoItemModel(
            higher: item['higher'],
            label: item['label'],
            percentage: item['percentage'],
            value: item['value']
          ));
      }

      if (_response['compare'] != null) {
        for(var item in _response['compare'])
        {
          _model.compare.add(new AcaoCompareModel(
            id: item['id'].toString(),
            ticker: item['ticker'].toString(),
            name: item['name'].toString(),
            value: item['value'],
            variation: item['variation'],
            percentage: item['percentage'],
            higher: item['higher']
          ));
        }
      }

      print('passou get');

      return _model;
    }

    print('code: ' + _result.statusCode.toString());
     
    return new AcaoModel();
  }

  Future<List<Map<DateTime, double>>> getChart(String equityID, String filter) async {
    var prefs = await SharedPreferences.getInstance();
    var _body = json.encode({ "UserID": prefs.getString("userID"), "EquityID": equityID, "Filter": filter });
    
    var _result = await http.post(_apiURL + "api/equity/chart",
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer ' + prefs.getString('userToken')
                                  },
                                  body: _body);

    var _lista = new List<Map<DateTime, double>>();
    if (_result.statusCode == 200)
    {
      var _response = json.decode(_result.body);
      for(var item in _response)
      {
        var _map = new Map<DateTime, double>();
        for(var point in item)
          _map[DateTime.parse(point['legend'].toString())] = point['point'];
        _lista.add(_map);
      }
    }
    
    print('chart: ' + _result.statusCode.toString());
    return _lista;
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

  Future<bool> remove(String equityID, String compareID) async {
    var prefs = await SharedPreferences.getInstance();
    var _body = json.encode({"UserID": prefs.getString("userID"), "EquityID": equityID, "CompareID": compareID});
    
    var _result = await http.patch(_apiURL + "api/equity/remove",
                                   body: _body,
                                   headers: {
                                     'Content-Type': 'application/json',
                                     'Authorization': 'Bearer ' + prefs.getString("userToken")
                                   });

    if (_result.statusCode == 200)
      return true;

    print('remove code: ' + _result.statusCode.toString());
    return false;
  }
}