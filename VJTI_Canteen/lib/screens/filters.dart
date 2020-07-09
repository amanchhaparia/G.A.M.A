import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  Future<void> setFilters() async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance
        .collection('Users')
        .document(user.uid)
        .get()
        .then((value) {
      setState(() {
        isOnionsPresent = value.data['isOnionPresent'];
        sweetness = (value.data['sweetiness']).toDouble();
        spiciness = (value.data['spiciness']).toDouble();
      });
    }).whenComplete(() => print('done'));
    // Firestore.instance
    //     .collection('Users')
    //     .document(uid)
    //     .snapshots()
    //     .listen((event) {
    //   isOnionsPresent = event.data['isOnionPresent'];
    //   sweetness = (event.data['sweetiness']).toDouble();
    //   spiciness = (event.data['spiciness']).toDouble();
    // }).onDone(() {
    //   setState(() {});
    // });
  }

  @override
  void initState() {
    setFilters();
    super.initState();
  }

  bool isOnionsPresent;
  bool isJain = true;
  double sweetness;
  double spiciness;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isOnionsPresent == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            CupertinoIcons.back,
                            color: Colors.black,
                            size: 40,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      IconButton(
                        icon: Icon(
                          Icons.save,
                          size: 40.0,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          final user =
                              await FirebaseAuth.instance.currentUser();
                          Firestore.instance
                              .collection('Users')
                              .document(user.uid)
                              .updateData({
                            'isOnionPresent': isOnionsPresent,
                            'sweetiness': sweetness,
                            'spiciness': spiciness,
                          }).whenComplete(() {
                            showAlert(context, 'Updated Successfully!');
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'MY',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Flavours',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 35),
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Card(
                      elevation: 10.0,
                      color: Colors.redAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                'ONIONS ',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.amber),
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                            activeColor: Colors.green,
                            trackColor: Colors.grey[100],
                            onChanged: (value) {
                              setState(() {
                                isOnionsPresent = !isOnionsPresent;
                              });
                            },
                            value: isOnionsPresent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Card(
                      elevation: 10.0,
                      color: Colors.purple,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                'JAIN',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.amber),
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                            activeColor: Colors.green,
                            trackColor: Colors.grey[100],
                            onChanged: (value) {
                              setState(() {
                                isJain = !isJain;
                              });
                            },
                            value: isJain,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.blue,
                      elevation: 10.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'SPICINESS',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.yellow),
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.red[700],
                              inactiveTrackColor: Colors.red[100],
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 4.0,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12.0),
                              thumbColor: Colors.redAccent,
                              overlayColor: Colors.red.withAlpha(32),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 28.0),
                              tickMarkShape: RoundSliderTickMarkShape(),
                              activeTickMarkColor: Colors.red[700],
                              inactiveTickMarkColor: Colors.red[100],
                              valueIndicatorShape:
                                  PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: Colors.redAccent,
                              valueIndicatorTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: Slider(
                                min: 0,
                                max: 10,
                                divisions: 10,
                                value: spiciness,
                                label: '${spiciness.toStringAsFixed(0)}',
                                onChanged: (value) {
                                  setState(() {
                                    spiciness = value;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Card(
                      color: Colors.green,
                      elevation: 10.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'SWEETNESS',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.yellow),
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.blue[700],
                              inactiveTrackColor: Colors.blue[100],
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 4.0,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12.0),
                              thumbColor: Colors.blueAccent,
                              overlayColor: Colors.blue.withAlpha(32),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 28.0),
                              tickMarkShape: RoundSliderTickMarkShape(),
                              activeTickMarkColor: Colors.blue[700],
                              inactiveTickMarkColor: Colors.blue[100],
                              valueIndicatorShape:
                                  PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: Colors.blueAccent,
                              valueIndicatorTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: Slider(
                                max: 10,
                                min: 0,
                                divisions: 10,
                                value: sweetness,
                                label: '${sweetness.toStringAsFixed(0)}',
                                onChanged: (value) {
                                  setState(() {
                                    sweetness = value;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  void showAlert(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Successfull'),
          content: Text(errorMessage),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
