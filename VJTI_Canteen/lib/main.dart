import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import './screens/auth_screen.dart';
import './screens/admin_login_screen.dart';
import './screens/wrapper_screen.dart';
import './screens/admin_home_screen.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        )
      ] ,
      child: Consumer<Auth>(builder: (ctx,auth,_)=>
        MaterialApp(
          title: 'VJTI_CANTEEN',
          routes: {
            AuthScreen.route: (ctx) => AuthScreen(),
            AdminLoginScreen.routeName: (ctx) => AdminLoginScreen(),
            AdminHomeScreen.routeName: (ctx) => AdminHomeScreen(),
          },
          home:// AdminLoginScreen(),
          WrapperScreen(auth: auth),
        ),
      ),
    );
  }
}
