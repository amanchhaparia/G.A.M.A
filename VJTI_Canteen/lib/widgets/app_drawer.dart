import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:VJTI_Canteen/screens/filters.dart';
import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/wallet_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              CircleAvatar(
                backgroundColor: Colors.blueGrey,
                radius: MediaQuery.of(context).size.width * 0.22,
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.2,
                  backgroundImage: NetworkImage(
                      'https://thumbs.gfycat.com/ConsiderateFlamboyantHawaiianmonkseal-size_restricted.gif'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                width: MediaQuery.of(context).size.width * 0.4,
                child: Align(
                  alignment: Alignment.center,
                  child: CustomerMail(),
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderScreen.routeName);
                  },
                  child: menuMaker(context,
                      iconname: Icons.fastfood, text: 'Your Orders')),
              Divider(
                color: Colors.white,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => WalletScreen(),
                  ));
                },
                child: menuMaker(context,
                    iconname: Icons.account_balance_wallet,
                    text: 'Your Wallet'),
              ),
              Divider(
                color: Colors.white,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) => Filters()));
                },
                child: menuMaker(context,
                    iconname: Icons.settings, text: 'Filters'),
              ),
              Divider(
                color: Colors.white,
              ),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.grey,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure?'),
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
                            Navigator.of(ctx).pop();
                            Navigator.of(ctx).pushReplacementNamed('/');
                            Provider.of<Auth>(ctx, listen: false).signOut();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerMail extends StatefulWidget {
  @override
  _CustomerMailState createState() => _CustomerMailState();
}

class _CustomerMailState extends State<CustomerMail> {
  var email = 'customer mail';

  getemail() async {
    final user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('Users')
        .document(user.uid)
        .get()
        .then((value) {
      setState(() {
        email = value.data['email'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getemail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        email,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}

Widget menuMaker(BuildContext context, {IconData iconname, String text}) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.4,
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            iconname,
            size: MediaQuery.of(context).size.width * 0.16,
            color: Colors.blueGrey,
          ),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 20,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}
