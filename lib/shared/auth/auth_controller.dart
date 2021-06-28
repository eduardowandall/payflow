import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payflow/shared/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  var _isAuthenticated = false;
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(BuildContext context, UserModel? user) {
    _isAuthenticated = user != null;
    if (_isAuthenticated) {
      _user = user;
      saveUser(_user!);
      Navigator.pushReplacementNamed(context, "/home", arguments: user);
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", user.toJson());
    return;
  }

  Future<void> redirectToHomeIfHasLoggedUser(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("user")) {
      final json = prefs.get("user") as String;
      setUser(context, UserModel.fromJson(json));
    } else {
      setUser(context, null);
    }
  }
}
