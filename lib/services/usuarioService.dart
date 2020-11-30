import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/usuarioModel.dart';

class UsuarioService {
  final FirebaseMessaging _msg = new FirebaseMessaging();
  final _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookLogin = new FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final String _apiURL = 'http://ec2-52-67-44-12.sa-east-1.compute.amazonaws.com/stock_api/';

  Future<String> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      var _result = await findByEmail(email);
      
      if (_result == 200)
      {
        if (_auth.currentUser != null)
          await salvarInformacao('userToken', await _auth.currentUser.getIdToken());
        return null;
      }
      else {
        if (_auth.currentUser != null) await _auth.signOut();
        if (_result == 400)
          return "E-mail e/ou senha inválido(s).";

        print('login: ' + _result.toString());
        return "Falha ao logar usuário. Tente novamente mais tarde.";
      }
    }
    catch(e) {
      var mensagem = "";
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          mensagem = "E-mail inválido!";
          break;
        case "ERROR_WRONG_PASSWORD":
          mensagem = "Senha incorreta!";
          break;
        case "ERROR_USER_NOT_FOUND":
          mensagem = "Usuário não cadastrado!";
          break;
        case "ERROR_USER_DISABLED":
          mensagem = "Usuário não cadastrado!";
          break;
        default:
          mensagem = "Ocorreu um erro. Tente novamente mais tarde.";
          break;
      }

      return mensagem;
    }
  }

  Future<String> loginWithFacebook() async {
    try {
      final FacebookLoginResult result = await _facebookLogin.logIn(["email"]);

      if (result.status == FacebookLoginStatus.loggedIn) {
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,email,picture&access_token=' + token);
        Map<String, dynamic> profile = json.decode(graphResponse.body);

        final credentials = FacebookAuthProvider.credential(token);
        await _auth.signInWithCredential(credentials);
        if (_auth.currentUser != null)
        {
          await salvarInformacao('userToken', await _auth.currentUser.getIdToken());
          await salvarInformacao('userImage', _auth.currentUser.photoURL + "?height=800&access_token=" + token);
        }

        var _result = await create(profile['name'].toString(), profile['email'].toString());

        if (_result == 200)
          return null;
        else {
          if (await _facebookLogin.isLoggedIn) _facebookLogin.logOut();
          if (_auth.currentUser != null) _auth.currentUser.delete();

          if (_result == 400)
            return "Falha ao fazer login com Facebook. Tente novamente mais tarde. (Erro 400)";
        }
        
        return "Falha ao fazer login com Facebook. Tente novamente mais tarde. (Erro " + _result.toString() + ")";    
      }
      
      return "Falha ao fazer login com Facebook. Tente novamente mais tarde. (Erro f0001)";
    }
    catch(e) {
      print(e.toString());
      return "Falha ao fazer login com Facebook. Tente novamente mais tarde. (Erro f0002)";
    }
  }

  Future<String> loginWithGoogle() async {
    return await _googleSignIn.signIn().then((googleUser) async {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await _auth.signInWithCredential(credential);
      if (_auth.currentUser != null) {
        await salvarInformacao('userToken', await _auth.currentUser.getIdToken());
        await salvarInformacao('userImage', _googleSignIn.currentUser.photoUrl.replaceAll('s96-c', 's1000-c'));
      }  

      var _result = await create(googleUser.displayName, googleUser.email);
      
      if (_result == 200)
        return null;
      else {
        _googleSignIn.signOut();
        if (_auth.currentUser != null)
          _auth.currentUser.delete();

        if (_result == 400)
          return "Falha ao fazer login com Google. Tente novamente mais tarde. (Erro " + _result.toString() + ")";    
      }
      return "Falha ao fazer login com Google. Tente novamente mais tarde. (Erro g0001)";
    }).catchError((e) {
      return "Falha ao fazer login com Google. Tente novamente mais tarde. (Erro g0002)";
    });
  }

  Future<int> create(String nome, String email) async {
    var _body = json.encode({"Name": nome,"Email": email,"Role": "Client", "PushToken": await _msg.getToken()});

    var _result = await http.post(_apiURL + "api/user/create",
                                  headers: {
                                    'Content-Type': 'application/json'
                                  },
                                  body: _body);

    if (_result.statusCode == 200) {
      var _response = json.decode(_result.body);
      await salvarInformacao('userID', _response.toString());
    }

    return _result.statusCode;
  }

  Future<int> findByEmail(String email) async {
    var _body = json.encode({"Email": email, "PushToken": await _msg.getToken()});
    
    var _result = await http.post(_apiURL + "api/user/findByEmail",
                                  headers: {
                                    'Content-Type': 'application/json'
                                  },
                                  body: _body);

    if (_result.statusCode == 200) {
      var _response = json.decode(_result.body);
      await salvarInformacao('userID', _response.toString());
    }

    return _result.statusCode;
  }

  Future<String> register(String nome, String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);

      var _result = await create(nome, email);

      if (_result == 200)
        return null;
      else
      {
        if (_auth.currentUser != null) _auth.currentUser.delete();
        if (_result == 400)
          return "Falha ao cadastrar usuário. Tente novamente mais tarde. (Erro r0001)";
        return "Falha ao cadastrar usuário. Tente novamente mais tarde. (Erro r0002)";
      }
    } catch(e) {
      await _auth.currentUser.delete();
      if (e.toString().contains("weak-password"))
        return "A senha deve ter, no mínimo 6 caracteres.";
      else if (e.toString().contains(("email-already-in-use")))
        return "E-mail já cadastrado.";
      return "Falha ao cadastrar usuário. Tente novamente mais tarde. (Erro r0003)";
    }
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("userID") != null && prefs.getString("userToken") != null)
    {
      if (_auth.currentUser != null &&
          (await _facebookLogin.isLoggedIn ||
          await _googleSignIn.isSignedIn()))
        return true;
      else
        await deleteInformacoes();
    }
    return false;
  }

  Future<UsuarioModel> get() async {
      final prefs = await SharedPreferences.getInstance();
      
      var _result = await http.get(_apiURL + "api/user/" + prefs.getString('userID'),
                                   headers: {
                                     'Authorization': 'Bearer ' + prefs.getString('userToken')
                                   });

      if (_result.statusCode == 200)
      {
        var _response = json.decode(_result.body);
        var _imagem = _response['image'] != null ? _response['image'].toString() : null;
        if (_imagem == null)
        {
          if (await _googleSignIn.isSignedIn() || await _facebookLogin.isLoggedIn)
            _imagem = prefs.getString("userImage");
        }
        
        return new UsuarioModel(
          id: _response['id'].toString(),
          name: _response['nome'].toString(),
          email: _response['email'].toString(),
          image: _imagem,
          gender: _response['gender'] != null ? _response['gender'].toString() : null,
          birthDate: _response['birthDate'] != null ? DateTime.parse(_response['birthDate'].toString()) : null,
          address: _response['address'] != null ? _response['address'].toString() : null,
          number: _response['number'] != null ? _response['number'].toString() : null,
          compliment: _response['compliment'] != null ? _response['compliment'].toString() : null
        );
      }
      else
      {
        return null;
      }
  }

  Future<String> getAddress(String termo) async {
    final prefs = await SharedPreferences.getInstance();
    print('cep: ' + termo);
    var _result = await http.get(_apiURL + "api/user/address/" + termo,
                                 headers: {
                                   'Authorization': 'Bearer ' + prefs.getString("userToken")
                                 });

    if (_result.statusCode == 200)
    {
      var _response = json.decode(_result.body);
      
      var _logradouro = _response['logradouro'].toString();
      var _bairro = _response['bairro'] != null ? ", " + _response['bairro'].toString() : "";
      var _cidade = _response['localidade'] != null ? " - " + _response['localidade'].toString() : "";
      var _uf = _response['uf'] != null ? "/" + _response['uf'].toString() : "";

      return (_logradouro + _bairro + " - CEP: " + termo + _cidade + _uf);
    }

    print('erro: ' + _result.statusCode.toString() + ' com termo ' + termo);
    return null;
  }

  Future<bool> delete() async {
    var prefs = await SharedPreferences.getInstance();

    var _result = await http.delete(_apiURL + "api/user/delete/" + prefs.getString("userID"),
                                    headers: {
                                      'Authorization': 'Bearer ' + prefs.getString("userToken")
                                    });

    if (_result.statusCode == 200) {
      await _auth.currentUser.delete();
      await deleteInformacoes();
      return true;
    }

    return false;
  }

  Future<bool> salvarInformacao(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    return true;
  }

  Future deleteInformacoes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userID");
    prefs.remove("userToken");
    prefs.remove("userImage");
  }

  Future<void> logout() async {
    if (await _facebookLogin.isLoggedIn) {
      await _facebookLogin.logOut();
    }
    if (await _googleSignIn.isSignedIn()) { 
      await _googleSignIn.signOut();
    }
    if (_auth.currentUser != null) await _auth.signOut();
    await deleteInformacoes();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<String> update(UsuarioModel model) async {
    try
    {
      var _data = new FormData.fromMap({
        "id": model.id,
        "birthDate": model.birthDate,
        "image": model.imageFile == null ? null : await MultipartFile.fromFile(model.imageFile.path),
        "gender": model.gender,
        "address": model.address,
        "number": model.number,
        "compliment": model.compliment
      });
      
      var prefs = await SharedPreferences.getInstance();

      var _result = await new Dio().patch(_apiURL + "api/user/update",
                                          data: _data,
                                          options: Options(
                                            headers: {
                                              'Authorization': 'Bearer ' + prefs.getString("userToken")
                                            }
                                          ));

      if (_result.statusCode == 200)
        return null;

      return "Falha ao editar perfil. Tente novamente mais tarde. (Erro u001)"; 
    }
    catch(e) {
      return "Falha ao editar perfil. Tente novamente mais tarde. (Erro u002)"; 
    }
  }
}