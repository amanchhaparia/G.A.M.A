import 'package:flutter/material.dart';

import '../Animations/fade_animation.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/admin_login_screen.dart';
import '../providers/auth.dart';

class WrapperScreen extends StatefulWidget {
  final Auth auth;
  WrapperScreen({@required this.auth});
  @override
  _WrapperScreenState createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: widget.auth.onAuthStateChanged,
      initialData: null,
      builder: (context, snapshot) {
       print('${snapshot.data}'); 
       if(snapshot.connectionState == ConnectionState.active){
         if(snapshot.data!=null){
           return HomeScreen();
         }
         else{
           return StarterPage();
         }
       }
       else{
         return LoadingPage();
       }
      }
    );
  }
}

class StarterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/starter-image.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.2),
              ]
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FadeIn(
                  0.5,
                  Text(
                    'Hello,\nWelcome to VJTI Canteen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Container(
                  child: FadeIn(
                    0.5,
                    Text(
                      'Continue as',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                FadeIn(
                  0.5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow,
                                Colors.orange,
                              ],
                            ),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(AdminLoginScreen.routeName);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.person
                                ),
                                SizedBox(width:20),
                                Text(
                                  'Admin',
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width:20),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow,
                                Colors.orange,
                              ],
                            ),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(AuthScreen.route);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.people
                                ),
                                SizedBox(width:20),
                                Text(
                                  'User',
                                  style: TextStyle(
                                    color: Colors.black
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height:70)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}