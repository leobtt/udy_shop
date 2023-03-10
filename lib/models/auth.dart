import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:udy_shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _email;
  String? _token;
  String? _uid;
  DateTime? _expiryDate;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;

    return isValid && _token != null;
  }

  String? get token => isAuth ? _token : null;
  String? get email => isAuth ? _email : null;
  String? get uid => isAuth ? _uid : null;

  Future<void> _authenticate(
    String email,
    String password,
    String urlFragment,
  ) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:${urlFragment}?key=${dotenv.get("KEY_API")}';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _uid = body['localId'];

      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(body['expiresIn']),
      ));

      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
