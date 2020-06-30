import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/fooditem.dart';

class OrderItem {
  final int total;
  final List<FoodItem> cartItems;
  final DateTime dateTime;
  final String id;

  OrderItem(
      {@required this.id,
      @required this.cartItems,
      @required this.dateTime,
      @required this.total});
}

class Orders with ChangeNotifier {
  final String uid;
  Orders(this.uid);

  List<OrderItem> _orders = [];
  final CollectionReference orderCollection =
      Firestore.instance.collection('users');

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future updateUserOrder(List<FoodItem> cartItems, int total) async {
    try {
      await orderCollection.document(uid).collection('orders').add({
        'amount': total,
        'dateTime': DateTime.now().toIso8601String(),
        'items': cartItems
            .map((cp) =>
                {'id': cp.id, 'title': cp.title, 'quantity': cp.quantity})
            .toList()
      });
    } catch (e) {
      throw e;
    }
  }
}
