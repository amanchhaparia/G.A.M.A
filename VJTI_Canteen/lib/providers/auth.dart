import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    if(token != null){
      return true;
    }
    return false;
  }

  String get token{
    if(_expiryDate!=null && _expiryDate.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }

  Future <void> _authenicate(String email, String password, String urlsegment) async {
   final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlsegment?key=AIzaSyAx9-V1lpg-Qbxms0kRoNPqCCGUhm0TcL0';
   try{
     final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      },)
    );
    final responseData = json.decode(response.body);
    if(responseData['error'] != null){
      throw HttpException(responseData['error']['message']);
    }
    _token = responseData['idToken'];
    _userId= responseData['localId'];
    _expiryDate= DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
    notifyListeners();
   } catch(error){
      throw error;
   }
  } 

  Future <void> signup(String email, String password) async{
    return _authenicate(email, password, 'signUp');
  }

  Future <void> login(String email, String password) async{
    return _authenicate(email, password, 'signInWithPassword');
  }
}