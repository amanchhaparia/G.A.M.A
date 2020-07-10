import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/order.dart';

const Color color1 = Colors.blue;
const Color color2 = Colors.green;
const Color color3 = Colors.redAccent;

var balance;

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final amountController = TextEditingController();

  Future<void> addbalance() async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance
        .collection('Users')
        .document(user.uid)
        .updateData({
      'balance': double.parse(amountController.text) + balance,
    }).whenComplete(() {
      setState(() {
        balance = double.parse(amountController.text) + balance;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellow[500],
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          CupertinoIcons.back,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Add Balance'),
                                    content: TextField(
                                      controller: amountController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                          hintText: 'Type amount here'),
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                        onPressed: () {
                                          if (amountController == null)
                                            return;
                                          else {
                                            addbalance().whenComplete(() =>
                                                Navigator.of(context).pop());
                                          }
                                        },
                                        child: Text('Submit'),
                                      )
                                    ],
                                  );
                                });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Balance(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TransactionListOfOrders(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Balance extends StatefulWidget {
  const Balance({
    Key key,
  }) : super(key: key);
  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  getbalance() async {
    final user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    Firestore.instance.collection('Users').document(uid).get().then((value) {
      setState(() {
        balance = value.data['balance'];
      });
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getbalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Balance : ₹${balance.toString()}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40.0,
        color: Colors.black,
      ),
    );
  }
}

class TransactionListOfOrders extends StatefulWidget {
  @override
  _TransactionListOfOrdersState createState() =>
      _TransactionListOfOrdersState();
}

class _TransactionListOfOrdersState extends State<TransactionListOfOrders> {
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
    return StreamBuilder(
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
              return OrderListItem(snapshot.data.documents[index], index);
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

class OrderListItem extends StatelessWidget {
  final DocumentSnapshot document;
  final int ind;
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
