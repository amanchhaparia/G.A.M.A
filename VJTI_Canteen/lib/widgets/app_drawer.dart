import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            CircleAvatar(
              backgroundColor: Colors.blueGrey,
              radius: MediaQuery.of(context).size.width * 0.2,
                          child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.17,
                backgroundImage: NetworkImage(
                    'https://thumbs.gfycat.com/ConsiderateFlamboyantHawaiianmonkseal-size_restricted.gif'),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width * 0.4,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Customer Mail',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            menuMaker(context, iconname: Icons.fastfood, text: 'Your Orders'),
            Divider(
              color: Colors.white,
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context)=>WalletScreen(),)
                );
              },
                          child: menuMaker(context,
                  iconname: Icons.account_balance_wallet, text: 'Your Wallet'),
            ),
            Divider(
              color: Colors.white,
            ),
            menuMaker(context, iconname: Icons.settings, text: 'Settings'),
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
            size: MediaQuery.of(context).size.width *0.16,
            color: Colors.blueGrey,
            
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.redAccent,fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}
