import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/acaoModel.dart';
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
}