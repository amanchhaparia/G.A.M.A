import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title:Text('Customer name'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Your Orders'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment Options'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: (){
                        Navigator.of(ctx).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: (){
                        Navigator.of(ctx).pop();
                        Navigator.of(ctx).pushReplacementNamed('/');
                        Provider.of<Auth>(ctx,listen:false).logout();
                      },
                    ),
                ],), 
              );
            },
          ),
        ],
      ),
    );
  }
}