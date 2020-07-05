import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../providers/order.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orderscreen';
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String uid;
  getuid() async {
    final user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      uid = getuid();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: Orders(uid).orderItems,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.active) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                print(index);
                return OrderListItem(snapshot.data.documents[index]);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final DocumentSnapshot document;
  OrderListItem(this.document);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Total: Rs ${document.data['amount']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              'status: ${document.data['status']}',
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
    );
  }
}
