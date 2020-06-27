import 'package:VJTI_Canteen/widgets/app_drawer.dart';

import '../models/fooditem.dart';
import '../models/Homepage_middle_part.dart';
import 'package:flutter/material.dart';
import '../bloc/cartListBloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import '../models/cart.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [Bloc((i) => CartListBloc())],
      child: MaterialApp(
        title: 'VJTI CANTEEN',
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: <Widget>[
              FirstHalf(),
              SizedBox(height: 45),
              for (var foodItem in foodItemList.foodItems)
                ItemContainer(foodItem: foodItem),
            ],
          ),
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
      height: MediaQuery.of(context).size.height *0.4,
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
        Icon(
          Icons.search,
          color: Colors.black45,
        ),
        SizedBox(width: 20),
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

class CustomAppBar extends StatelessWidget {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.menu),
            ),
            StreamBuilder(
              initialData: null,
              stream: bloc.listStream,
              builder: (context, snapshot) {
             List<FoodItem> foodItems = [];
             if(snapshot.hasData){
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
      ),
    );
  }

  GestureDetector buildGestureDetector(
      int sum, BuildContext context, List<FoodItem> foodItems) {
    return GestureDetector(
      onTap: () {
        if (sum > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Cart(),
            ),
          );
        } else {
          return;
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 30.0),
        child: sum == 0
            ? Text(
                '0',
              )
            : Text(
                sum.toString(),
              ),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
