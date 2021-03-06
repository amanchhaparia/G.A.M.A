import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import './screens/auth_screen.dart';
import './screens/admin_login_screen.dart';
import './screens/wrapper_screen.dart';
import './screens/admin_home_screen.dart';
import './screens/orders_screen.dart';
import './providers/auth.dart';
import 'providers/cart_item_list.dart';
import './providers/food_item_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: CartItemList(),
        ),
        ChangeNotifierProvider.value(
          value: FoodItemList(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'VJTI_CANTEEN',
          routes: {
            AuthScreen.route: (ctx) => AuthScreen(),
            AdminLoginScreen.routeName: (ctx) => AdminLoginScreen(),
            AdminHomeScreen.routeName: (ctx) => AdminHomeScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
          },
          home: // AdminLoginScreen(),
              WrapperScreen(auth: auth),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
