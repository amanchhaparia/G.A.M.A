import 'package:VJTI_Canteen/screens/admin_login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const Color color1 = Colors.blue;
const Color color2 = Colors.green;
const Color color3 = Colors.redAccent;

class AdminHomeScreen extends StatelessWidget {
  static const routeName = '/adminHomeScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              return OrderItems(
                snapshot.data.documents[index],
                index,
                document.data['spiciness'],
                document.data['sweetiness'],
                document.data['isOnionPresent'],
                document.data['isJain'],
              );
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
  final double spiciness;
  final double sweetness;
  final bool isOnionPresent;
  final bool jain;
  final int ind;
  OrderItems(this.document, this.ind, this.spiciness, this.sweetness,
      this.isOnionPresent, this.jain);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ind % 3 == 0 ? color1 : ind % 3 == 1 ? color2 : color3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 10.0, top: 10.0),
                          child: Text(
                            document.data['items'][index]['title'],
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 20.0, top: 10.0),
                          child: Text(
                            '${document.data['items'][index]['quantity']}',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: document.data['items'].length),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Spice level:${spiciness.toString()}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Sweetness :${sweetness.toString()}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  jain? Container():Text(
                    isOnionPresent ? 'Onions allowed' : 'Onions not allowed',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    jain ? 'Jain' : 'non-Jain',
                    style: TextStyle(fontSize: 15),
                  ),
                ]),
          ),
          ExpansionTile(
            title: Text(
              'More Information',
              style: TextStyle(color: Colors.amber),
            ),
            backgroundColor: Colors.white,
            children: <Widget>[
              Text('Total:₹${document.data['amount']}'),
              FlatButton(
                onPressed: () {
                  if (document.data['status'] == 'pending') {
                    _showDialogue(context, document);
                  }
                },
                child: Text('status: ${document.data['status']}'),
              ),
            ],
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
