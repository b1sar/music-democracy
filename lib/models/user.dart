import 'package:flutter/material.dart';

class MyUser {
  final String username;
  final String email;
  final bool is_admin;
  List<String> lobbyCodes = [];

  MyUser({
    @required this.username,
    @required this.email,
    @required this.is_admin,
    this.lobbyCodes
  });
}