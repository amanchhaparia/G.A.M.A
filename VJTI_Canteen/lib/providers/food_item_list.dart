import 'package:flutter/material.dart';
import '../models/fooditem.dart';

class FoodItemList with ChangeNotifier {
  List<FoodItem> _foodItems = [];

  List<FoodItem> get foodItems {
    return [..._foodItems];
  }

  void addToList(FoodItem foodItem) {
    bool _isPresent = false;
    for (int i = 0; i < _foodItems.length; i++) {
      if (_foodItems[i].id == foodItem.id) {
        _isPresent = true;
        _foodItems[i] = foodItem;
      }
    }
    if (!_isPresent) {
      _foodItems.add(foodItem);
    }
   // notifyListeners();
    ChangeNotifier();
  }

  notifyListeners();
}
