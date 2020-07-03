import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  static const routeName = '/adminHomeScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ORDERS'),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('Users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return UserContainer(snapshot.data.documents[index]);
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class UserContainer extends StatelessWidget {
  final DocumentSnapshot document;
  UserContainer(this.document);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: document.reference.collection('Orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return OrderItems(snapshot.data.documents[index]);
            },
          );
        } else {
          return Container(
            height: 0,
            width: 0,
          );
        }
      },
    );
  }
}

class OrderItems extends StatelessWidget {
  final DocumentSnapshot document;
  OrderItems(this.document);
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
            onTap: () {
              if (document.data['status'] == 'pending') {
                _showDialogue(context, document);
              }
            },
          ),
        ],
      ),
    );
  }
}

void _showDialogue(BuildContext context, DocumentSnapshot document) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text('CONFIRM'),
        content: Text('Is Order Delivered?'),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              document.reference.updateData({
                'status': 'Done',
              }).then((_) => Navigator.of(context).pop());
            },
          ),
        ],
      );
    },
  );
}
