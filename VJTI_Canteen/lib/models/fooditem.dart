import 'package:flutter/material.dart';

class FoodItem {
  int id;
  String title;
  double price;
  String imgloc;
  int availability;
  int quantity;
  FoodItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.imgloc,
    this.availability,
  });
}
