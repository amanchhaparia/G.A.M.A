//import 'dart:convert';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import '../models/http_exception.dart';

class User {
  final uid;
  User({@required this.uid});
}

class Auth with ChangeNotifier {
  // String _token;
  // DateTime _expiryDate;
  // String _userId;
  // Timer _authTimer;

  // bool get isAuth {
  //   if(token != null){
  //     return true;
  //   }
  //   return false;
  // }

  // String get token{
  //   if(_expiryDate!=null && _expiryDate.isAfter(DateTime.now()) && _token != null){
  //     return _token;
  //   }
  //   return null;
  // }

  // Future <void> _authenicate(String email, String password, String urlsegment) async {
  //  final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlsegment?key=AIzaSyAx9-V1lpg-Qbxms0kRoNPqCCGUhm0TcL0';
  //  try{
  //    final response = await http.post(
  //     url,
  //     body: json.encode({
  //       'email': email,
  //       'password': password,
  //       'returnSecureToken': true
  //     },)
  //   );
  //   final responseData = json.decode(response.body);
  //   if(responseData['error'] != null){
  //     throw HttpException(responseData['error']['message']);
  //   }
  //   _token = responseData['idToken'];
  //   _userId= responseData['localId'];
  //   _expiryDate= DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
  //   _autoLogout();
  //   notifyListeners();
  //   final prefs = await SharedPreferences.getInstance();
  //   final userData = json.encode({
  //     'token':_token,
  //     'userId': _userId,
  //     'expiryDate': _expiryDate.toIso8601String()
  //   });
  //   prefs.setString('userData', userData);
  //  } catch(error){
  //     throw error;
  //  }
  // }

  // Future <void> signup(String email, String password) async{
  //   return _authenicate(email, password, 'signUp');
  // }

  // Future <void> login(String email, String password) async{
  //   return _authenicate(email, password, 'signInWithPassword');
  // }

  // Future <bool> tryAutoLogin () async{
  //   final prefs = await SharedPreferences.getInstance();
  //   if(!prefs.containsKey('userData')){
  //     return false;
  //   }
  //   final extractedUserData = json.decode(prefs.getString('userData')) as Map<String,Object>;
  //   final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

  //   if(expiryDate.isBefore(DateTime.now())){
  //     return false;
  //   }

  //   _token = extractedUserData['token'];
  //   _userId = extractedUserData['userId'];
  //   _expiryDate = expiryDate;
  //   notifyListeners();
  //   _autoLogout();
  //   return true;

  // }

  // Future <void> logout() async{
  //   _token =null;
  //   _expiryDate = null;
  //   _userId = null;
  //   if(_authTimer!=null){
  //     _authTimer.cancel();
  //     _authTimer = null;
  //   }
  //   notifyListeners();
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  // }

  // void _autoLogout(){
  //   if(_authTimer!=null){
  //     _authTimer.cancel();
  //   }
  //   final timeToExpiry =_expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer =Timer(Duration(seconds: timeToExpiry), logout);
  // }

  //using firebase auth

  User _userfromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  Stream<User> get onAuthStateChanged {
    return FirebaseAuth.instance.onAuthStateChanged.map(_userfromFirebase);
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final response = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Firestore.instance
          .collection('Users')
          .document(response.user.uid)
          .setData({'balance': 0});
    } catch (e) {
      throw e;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return _userfromFirebase(result.user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw e;
    }
  }

  Future<User> currentUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    return _userfromFirebase(user);
  }
}
