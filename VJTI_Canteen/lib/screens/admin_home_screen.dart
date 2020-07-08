import 'package:VJTI_Canteen/screens/admin_login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  static const routeName = '/adminHomeScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellow,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AdminLoginScreen(),
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Orders',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              SizedBox(height: 20.0),
              OrderList(),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  UserContainer(snapshot.data.documents[index]),
                ],
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
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
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return OrderItems(snapshot.data.documents[index]);
            },
          );
        } else {
          return Container();
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      shadowColor: Colors.red,
      elevation: 10.0,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              document.data['items'][index]['title'],
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
                            ),
                            Text(
                              'x${document.data['items'][index]['quantity']}',
                              style: TextStyle(fontSize: 30.0),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: document.data['items'].length),
          ListTile(
            title: Text(
              'Total:₹${document.data['amount']}',
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
