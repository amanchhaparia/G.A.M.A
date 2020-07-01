// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:VJTI_Canteen/widgets/app_drawer.dart';
// import 'package:provider/provider.dart';

import '../models/fooditem.dart';
import '../models/Homepage_middle_part.dart';

import '../bloc/cartListBloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import '../models/cart.dart';

var isCollapsed = ValueNotifier<bool>(true);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Duration duration = const Duration(milliseconds: 700);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [Bloc((i) => CartListBloc())],
      child: Scaffold(
        backgroundColor: Colors.amber[300],
        body: ValueListenableBuilder(
            valueListenable: isCollapsed,
            builder: (context, value, widget) {
              return Stack(
                children: <Widget>[
                  AppDrawer(),
                  AnimatedPositioned(
                    duration: duration,
                    top: isCollapsed.value
                        ? 0
                        : MediaQuery.of(context).size.height * 0.1,
                    bottom: isCollapsed.value
                        ? 0
                        : MediaQuery.of(context).size.height * 0,
                    left: isCollapsed.value
                        ? 0
                        : MediaQuery.of(context).size.width * 0.5,
                    right: isCollapsed.value
                        ? 0
                        : MediaQuery.of(context).size.height * -0.25,
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      animationDuration: Duration(milliseconds: 700),
                      elevation: 20.0,
                      child: Home(context),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class Home extends StatelessWidget {
  BuildContext context;
  Home(this.context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            FirstHalf(),
            SizedBox(height: 45),
            StreamBuilder(
              stream: Firestore.instance.collection('FoodItem').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  print('yes');
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) => ItemContainer(
                          foodItem: FoodItem(
                        id: snapshot.data.documents[index]['id'],
                        title: snapshot.data.documents[index]['name'],
                        imgloc: 'assets/FoodItems/Bread_Pakoda.png',
                        price: (snapshot.data.documents[index]['price'])
                            .toDouble(),
                      )),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class ItemContainer extends StatelessWidget {
  final FoodItem foodItem;
  ItemContainer({@required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Items(
        itemName: foodItem.title,
        itemPrice: foodItem.price,
        imgloc: foodItem.imgloc,
        foodItem: foodItem,
      ),
    );
  }
}

class Items extends StatelessWidget {
  Items({
    @required this.imgloc,
    @required this.itemName,
    @required this.itemPrice,
    @required this.foodItem,
  });

  final String imgloc;
  final String itemName;
  final double itemPrice;
  final FoodItem foodItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      child: HomePageMiddlePart(imgloc, itemName, itemPrice, foodItem),
    );
  }
}

class FirstHalf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 260.0,
          width: 2000.0,
          child: Stack(children: <Widget>[
            Container(
              height: 230.0,
              width: 2000.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Canteen.jpeg'),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.blueAccent.withOpacity(0.95), BlendMode.dstATop),
                ),
                borderRadius: BorderRadius.all(Radius.circular(200.0)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: CustomAppBar(),
            ),
            Positioned(
              top: 170,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 15, 0, 0),
                child: title(),
              ),
            ),
          ]),
        ),
        SizedBox(height: 10.0),
        searchBar(),
      ],
    );
  }

  Widget searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Icon(
            Icons.search,
            color: Colors.black45,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              hintStyle: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'VJTI',
              style: TextStyle(
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(3.0, 3.0),
                    blurRadius: 0.1,
                    color: Colors.black,
                  ),
                  Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 0.1,
                      color: Colors.amberAccent),
                  Shadow(
                      offset: Offset(2.0, 1.0),
                      blurRadius: 0.1,
                      color: Colors.amberAccent),
                ],
                fontWeight: FontWeight.w700,
                fontSize: 35.0,
                color: Colors.grey[800],
              ),
            ),
            Text(
              'CANTEEN',
              style: TextStyle(
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(3.0, 3.0),
                    blurRadius: 0.1,
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 0.1,
                    color: Colors.amberAccent,
                  ),
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 0.1,
                    color: Colors.amberAccent,
                  ),
                ],
                fontSize: 30.0,
                color: Colors.grey[800],
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        )
      ],
    );
  }
}

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            child: Icon(Icons.menu),
            onTap: () {
              setState(() {
                isCollapsed.value = !isCollapsed.value;
              });
            },
          ),
          StreamBuilder(
            initialData: null,
            stream: bloc.listStream,
            builder: (context, snapshot) {
              List<FoodItem> foodItems = [];
              if (snapshot.hasData) {
                foodItems = snapshot.data;
              }

              int sum = 0;

              for (int i = 0; i < foodItems.length; i++) {
                sum = sum + foodItems[i].quantity;
              }
              return buildGestureDetector(
                sum,
                context,
                foodItems,
              );
            },
          )
        ],
      ),
    );
  }

  GestureDetector buildGestureDetector(
      int sum, BuildContext context, List<FoodItem> foodItems) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Cart(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: MediaQuery.of(context).size.width * 0.02,
              top: MediaQuery.of(context).size.height * 0.01,
              child: CircleAvatar(
                backgroundColor: Colors.yellow[800],
                child: sum == 0
                    ? Text(
                        '0',
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        sum.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.06,
              top: MediaQuery.of(context).size.width * 0.08,
              child: Icon(
                Icons.shopping_cart,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
