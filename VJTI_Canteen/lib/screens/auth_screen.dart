import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../Animations/fade_animation.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const route = '/authScreen';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/food_image.jpg'),
            fit: BoxFit.fill),
      ),
      child: AuthCard(deviceSize: deviceSize),
    ));
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
    @required this.deviceSize,
  }) : super(key: key);

  final Size deviceSize;

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<double> _opacityAnimation;

  void _showDialogue(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        //await Provider.of<Auth>(context, listen: false).login(_authData['email'], _authData['password']);
        await Provider.of<Auth>(context, listen: false)
            .signInWithEmailAndPassword(
                _authData['email'], _authData['password']);
        Navigator.of(context).pop();
      } else {
        //await Provider.of<Auth>(context, listen: false).signup(_authData['email'], _authData['password']);
        await Provider.of<Auth>(context, listen: false)
            .registerWithEmailAndPassword(
                _authData['email'], _authData['password']);
        Navigator.of(context).pop();
      }
    } catch (error) {
      var errorMessage = 'Authenticate Failed!';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.!';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address.!';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.!';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      _showDialogue(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
        _formKey.currentState.reset();
        _controller.forward();
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _formKey.currentState.reset();
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: widget.deviceSize.height * 0.25,
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeIn(
                        1,
                        Text(
                          _authMode == AuthMode.Signup ? 'SIGNUP' : 'login',
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeIn(
                        1,
                        Text(
                          'Welcome',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: widget.deviceSize.height * 0.029,
                ),
                FadeIn(
                  1,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ]),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                            height: _authMode == AuthMode.Signup ? 400 : 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ]),
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      height: 100,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          border: InputBorder.none,
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              !value.contains('@')) {
                                            return 'Invalid email!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _authData['email'] = value;
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          border: InputBorder.none,
                                        ),
                                        obscureText: true,
                                        controller: _passwordController,
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              value.length < 5) {
                                            return 'Password is too short!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _authData['password'] = value;
                                        },
                                      ),
                                    ),
                                    FadeTransition(
                                      opacity: _opacityAnimation,
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        height: _authMode == AuthMode.Signup
                                            ? 100
                                            : 0,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[200]))),
                                        child: TextFormField(
                                          enabled: _authMode == AuthMode.Signup,
                                          decoration: InputDecoration(
                                              labelText: 'Confirm Password',
                                              border: InputBorder.none),
                                          obscureText: true,
                                          validator:
                                              _authMode == AuthMode.Signup
                                                  ? (value) {
                                                      if (value !=
                                                          _passwordController
                                                              .text) {
                                                        return 'Passwords do not match!';
                                                      }
                                                      return null;
                                                    }
                                                  : null,
                                        ),
                                      ),
                                    ),
                                    FadeTransition(
                                      opacity: _opacityAnimation,
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        height: _authMode == AuthMode.Signup
                                            ? 100
                                            : 0,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[200]))),
                                        child: TextFormField(
                                          enabled: _authMode == AuthMode.Signup,
                                          decoration: InputDecoration(
                                              labelText: 'VJTI ID',
                                              border: InputBorder.none),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: widget.deviceSize.height * 0.29 / 15,
                          ),
                          if (_isLoading)
                            CircularProgressIndicator()
                          else if (_authMode == AuthMode.Login)
                            Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey),
                            ),
                          SizedBox(
                            height: widget.deviceSize.height * 0.29 / 8,
                          ),
                          GestureDetector(
                            onTap: _submit,
                            child: Container(
                              height: widget.deviceSize.height * (0.285) / 5,
                              width: 200,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                color: Colors.orange[900],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                  child: Text(
                                _authMode == AuthMode.Login
                                    ? 'LOGIN'
                                    : 'SIGNUP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Divider(),
                          Text(
                            'OR',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          GestureDetector(
                            onTap: _switchAuthMode,
                            child: Container(
                              height: widget.deviceSize.height * (0.285) / 5,
                              width: 200,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                color: Colors.orange[900],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                  child: Text(
                                _authMode == AuthMode.Login
                                    ? 'SIGNUP'
                                    : 'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
