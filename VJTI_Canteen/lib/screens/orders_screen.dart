import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../providers/order.dart';

const Color color1 = Colors.blue;
const Color color2 = Colors.green;
const Color color3 = Colors.redAccent;

class OrderScreen extends StatefulWidget {
  static const routeName = '/orderscreen';
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String uid;

  getUID() async {
    final user = await FirebaseAuth.instance.currentUser();
    setState(() {
      uid = user.uid;
    });
  }

  @override
  void initState() {
    getUID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    CupertinoIcons.back,
                    size: 40,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'MY',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 35,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Orders',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 35),
                  ),
                ),
              ),
              StreamBuilder(
                stream: Orders(uid).orderItems,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  if (snapshot.connectionState == ConnectionState.active) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        print(index);
                        return OrderListItem(
                            snapshot.data.documents[index], index);
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final DocumentSnapshot document;
  int ind;
  OrderListItem(this.document, this.ind);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10.0,
        color: ind % 3 == 0 ? color1 : ind % 3 == 1 ? color2 : color3,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Total: ₹${document.data['amount']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'status: ${document.data['status']}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            ExpansionTile(
              backgroundColor: Colors.white,
              title: Text(
                'Order List',
                style: TextStyle(
                  color: Colors.amber,
                ),
              ),
              children: <Widget>[
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: document.data['items'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            document.data['items'][index]['title'],
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text(
                            document.data['items'][index]['quantity']
                                .toString(),
                            style: TextStyle(fontSize: 20.0),
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
