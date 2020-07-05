import 'package:flutter/material.dart';

import '../screens/admin_home_screen.dart';

class AdminLoginScreen extends StatelessWidget {
  static const routeName = '/adminAuthScreen';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body:Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/adminScreenImage2.jpg'),
            fit: BoxFit.cover,
          )
        ),
        child: SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.2),
                ]
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: deviceSize.height*0.08),
                Container(
                  width: double.infinity,
                  height: deviceSize.height*0.24,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/adminScreenImage.png'),
                    )
                  ),
                ),
                SizedBox(height: deviceSize.height*0.025),
                Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(0,10),
                        )
                      ]
                    ),
                  ),
                ),
                FormWidget(deviceSize: deviceSize),
                SizedBox(height: deviceSize.height*0.073,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({
    Key key,
    @required this.deviceSize,
  }) : super(key: key);

  final Size deviceSize;

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future <void> _submit () async {
    if(!_formKey.currentState.validate()){
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(AdminHomeScreen.routeName, (Route<dynamic> route)=>false);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height:widget.deviceSize.height*0.023),
            Container(
              padding: EdgeInsets.all(10),
              width:widget.deviceSize.width*0.74,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.pink[50],
                boxShadow: [
                  BoxShadow(
                  blurRadius: 10,
                  color: Colors.black,
                  offset: Offset(0, 8),
                 )
                ]
              ),
              child: TextFormField(
                
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Username',
                  border: InputBorder.none,
                ),
                validator: (value){
                  if(value != 'admin'){
                    return 'Invalid Username.!';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height:widget.deviceSize.height*0.023),
            Container(
              padding: EdgeInsets.all(10),
              width:widget.deviceSize.width*0.74,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.pink[50],
                boxShadow: [
                  BoxShadow(
                  blurRadius: 10,
                  color: Colors.black,
                  offset: Offset(0, 8),
                 )
                ],
              ),
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'Password',
                  border: InputBorder.none
                ),
                validator: (value){
                  if(value!='admin123'){
                    return 'Invalid Password.!';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height:widget.deviceSize.height*0.023),
            Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.centerRight,
              child: Container(
                height: widget.deviceSize.height*0.065,
                width: widget.deviceSize.width*0.37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.orange,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black,
                      offset: Offset(0, 5),
                    )
                  ]
                ),
                child: MaterialButton(
                  onPressed: _submit,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Icon(Icons.arrow_forward),
                    ],
                  )
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}