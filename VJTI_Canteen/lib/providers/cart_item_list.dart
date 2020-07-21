import 'package:VJTI_Canteen/models/fooditem.dart';
import 'package:flutter/material.dart';
import '../models/cartItem.dart';

class CartItemList extends ChangeNotifier {
  List<CartItem> _cartFoodItem = [];

  List<CartItem> get cartFoodItem {
    return [..._cartFoodItem];
  }

  // to add the items to the cart
  void addToCart(FoodItem foodItem) {
    bool isPresent = false;

    if (_cartFoodItem.length > 0) {
      for (int i = 0; i < _cartFoodItem.length; i++) {
        if (_cartFoodItem[i].id == foodItem.id) {
          _cartFoodItem[i].quantity++;
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }

      if (!isPresent) {
        _cartFoodItem.add(CartItem(
          id: foodItem.id,
          title: foodItem.title,
          imgloc: foodItem.imgloc,
          price: foodItem.price,
          quantity: 1,
        ));
      }
    } else {
      _cartFoodItem.add(CartItem(
        id: foodItem.id,
        title: foodItem.title,
        imgloc: foodItem.imgloc,
        price: foodItem.price,
        quantity: 1,
      ));
    }
    notifyListeners();
  }

  //To get the total number of items in the cart
  int get totalItem {
    int sum = 0;
    for (int i = 0; i < _cartFoodItem.length; i++) {
      sum += _cartFoodItem[i].quantity;
    }
    // notifyListeners();
    ChangeNotifier();
    return sum;
  }

  //to remove a single quantity from the cart
  void removeFromCart(int id) {
    if (_cartFoodItem.isNotEmpty) {
      for (int i = 0; i < _cartFoodItem.length; i++) {
        if (_cartFoodItem[i].id == id) {
          if (_cartFoodItem[i].quantity > 1) {
            _cartFoodItem[i].quantity--;
          } else {
            _cartFoodItem.remove(_cartFoodItem[i]);
          }
        }
      }
    }
    notifyListeners();
  }

  //to get the quantity of particular FoodItem
  int quantityOfItem(FoodItem foodItem) {
    int quantity;
    bool _isPresent = false;
    if (_cartFoodItem.isNotEmpty) {
      for (int i = 0; i < _cartFoodItem.length; i++) {
        if (foodItem.id == _cartFoodItem[i].id) {
          _isPresent = true;
        }
        if (_isPresent) {
          quantity = _cartFoodItem[i].quantity;
        } else {
          quantity = 0;
        }
      }
    } else {
      quantity = 0;
    }
    ChangeNotifier();
    // notifyListeners();
    return quantity;
  }

  //to clear the cart after ordering
  void clearCart() {
    _cartFoodItem.clear();
    ChangeNotifier();
  }
}
