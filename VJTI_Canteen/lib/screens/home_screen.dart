import '../models/fooditem.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../bloc/cartListBloc.dart';
import '../bloc/provider.dart';
import '../widgets/app_drawer.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

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
      body: SafeArea(
        child: Container(
          child: ListView(
            children: <Widget>[
              FirstHalf(),
              SizedBox(height: 45),
              for (var foodItem in foodItemList.foodItems)
                ItemContainer(foodItem: foodItem)
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
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  addToCart(FoodItem foodItem) {
    bloc.addToList(foodItem);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Items(
        itemName: foodItem.title,
        itemPrice: foodItem.price,
        imgloc: foodItem.imgloc,
        addToCart: addToCart(foodItem),
      ),
    );
  }
}

class Items extends StatelessWidget {
  Items({
    @required this.imgloc,
    @required this.itemName,
    @required this.itemPrice,
    @required this.addToCart(),
  });
  final Function addToCart;
  final String imgloc;
  final String itemName;
  final double itemPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      height: 270,
      width: 400,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            right: 10,
            left: 50,
            bottom: 30,
            child: Container(
              height: 250,
              width: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                color: Colors.amberAccent.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            right: 190,
            left: 0,
            top: 5,
            child: Container(
              height: 181,
              width: 181,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.amber.withOpacity(0.4)),
            ),
          ),
          Positioned(
            right: 40.0,
            bottom: 0.0,
            top: 170,
            child: Text(
              '₹${itemPrice.toStringAsFixed(0)}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.grey[800],
                  //color: Color.fromRGBO(102, 102, 0, 1),
                  fontFamily: 'GiazaPro'),
            ),
          ),
          Positioned(
              height: 200,
              width: 600,
              bottom: 10,
              child: Icon(
                Icons.remove_circle_outline,
                size: 40.0,
                color: Colors.amber,
              )),
          Positioned(
            height: 200,
            width: 725,
            bottom: 10,
            child: GestureDetector(
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.amber,
                size: 40.0,
              ),
              onTap: () {
                addToCart(FoodItem);
                final snackbar= SnackBar(
                  content:Text("$itemName added to the cart"),
                  duration: Duration(milliseconds: 550),
                );
                Scaffold.of(context).showSnackBar(snackbar);
              },
              
            ),
          ),
          Positioned(
            right: 20.0,
            bottom: 130,
            child: Container(
              height: 100,
              width: 170,
              child: AutoSizeText(
                '$itemName',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey[800],
                    fontFamily: 'Dealers'),
                textAlign: TextAlign.end,
                maxLines: 1,
              ),
            ),
          ),
          Container(
            height: 181,
            width: 181,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imgloc),
                  fit: BoxFit.fitWidth,
                )),
          ),
        ],
      ),
    );
  }
}

class FirstHalf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(35, 25, 0, 0),
      child: Column(children: <Widget>[
        CustomAppBar(),
        SizedBox(height: 30),
        title(),
        SizedBox(height: 30),
        searchBar(),
      ]),
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
                  hintText: 'Search...',
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  hintStyle: TextStyle(
                    color: Colors.black87,
                  ))),
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
                fontWeight: FontWeight.w700,
                fontSize: 30.0,
              ),
            ),
            Text(
              'CANTEEN',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w300,
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
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.menu),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AppDrawer()));
              },
              child: Container(
                margin: EdgeInsets.only(right: 30.0),
                child: Text('0'),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.yellow[800],
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            )
          ],
        ));
  }
}
