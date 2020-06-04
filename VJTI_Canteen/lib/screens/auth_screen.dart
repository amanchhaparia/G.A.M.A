import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.orange[900],
          //     Colors.orange[800],
          //     Colors.orange[400],
          //   ],
          //   begin: Alignment.topCenter,
          // ),
          image: DecorationImage(
            image: AssetImage('assets/images/food_image.jpg'),
            fit: BoxFit.fill
          ),
        ),
        child: Container(
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 250,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Login', style: TextStyle(color: Colors.white,fontSize: 40),),
                    SizedBox(height: 10,),
                    Text('Welcome Back!', style: TextStyle(color: Colors.white,fontSize: 18),),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      )
                    ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25,),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text('Forgot Password?',style: TextStyle(color:Colors.grey),),
                        SizedBox(height: 30,),
                        Container(
                          height: 50,
                          width: 200,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            color: Colors.orange[900],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              'login',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          ),
                        ),
                        SizedBox(height: 25,),
                        Text('Continue with Social Media',style: TextStyle(color:Colors.grey),),
                        SizedBox(height: 25,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue
                                ),
                                child: Center(
                                  child: Text(
                                    'facebook',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  )
                                ),
                              ),
                            ),
                            SizedBox(width: 30,),
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black
                                ),
                                child: Center(
                                  child: Text(
                                    'GitHub',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  )
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}