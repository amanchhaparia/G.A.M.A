import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/orders_screen.dart';

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
  final dynamic uid;
  Orders(this.uid);

  List<OrderItem> _orders = [];
  final CollectionReference orderCollection =
      Firestore.instance.collection('Users');

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future updateUserOrder(
      List<FoodItem> cartItems, double total, BuildContext context) async {
    var balance;
    await orderCollection
        .document(uid)
        .get()
        .then((value) => balance = value.data['balance']);
    print(balance);
    if (balance < total) {
      _showAlert(context, 'Insufficent balance');
    } else {
      try {
        await orderCollection
            .document(uid)
            .updateData({'balance': (balance - total)});
        await orderCollection.document(uid).collection('Orders').add({
          'status': 'pending',
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'items': cartItems
              .map((cp) =>
                  {'id': cp.id, 'title': cp.title, 'quantity': cp.quantity})
              .toList()
        }).whenComplete(
            () => Navigator.of(context).pushNamed(OrderScreen.routeName));
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Stream<QuerySnapshot> get orderItems {
    return orderCollection.document(uid).collection('Orders').snapshots();
  }

  void _showAlert(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(errorMessage),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
