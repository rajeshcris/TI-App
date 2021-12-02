import 'dart:convert';

import 'package:flutter/physics.dart';

class User {
  final String status;
  User({this.status});

  factory User.fromJson(Map<String, dynamic> data) {
    // casting as a nullable String so we can do an explicit null check
    final status = data['status'] as String;
    if (status == null) {
      throw UnsupportedError('Invalid data: $data -> "status" is missing');
    }
    return User(status: status);
  }
}
