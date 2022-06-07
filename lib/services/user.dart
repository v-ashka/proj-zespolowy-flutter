import 'dart:convert';

import 'package:flutter/material.dart';

class User{
  String login;
  String password;
  String name;
  String surname;

  User({ required this.login, required this.password, required this.name, required this.surname});

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
    'name': name,
    'surname': surname,
  };

}

class Car{
  String name;
  String engine;
  String productionDate;
  String imageUrl;

  Car({ required this.name, required this.engine, required this.productionDate, required this.imageUrl});

  Map<String, dynamic> toJson() => {
    'name': name,
    'engine': engine,
    'productionDate': productionDate,
    'imageUrl': imageUrl,
  };

  @override
  String toString(){
    return "{carName: $name, engine: $engine, productionDate: $productionDate, imageUrl: $imageUrl}";
  }
}