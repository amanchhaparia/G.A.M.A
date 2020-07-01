import 'package:VJTI_Canteen/bloc/cartListBloc.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../models/fooditem.dart';
import '../bloc/cartListBloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class HomePageMiddlePart extends StatelessWidget {
  String imgloc;
  String itemName;
  double itemPrice;
  FoodItem foodItem;
  HomePageMiddlePart(this.imgloc, this.itemName, this.itemPrice, this.foodItem);

  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  addToCart(FoodItem foodItem) {
    bloc.addToList(foodItem);
  }

  removeFromCart(FoodItem foodItem) {
    bloc.removeFromList(foodItem);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(34.0),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  color: Colors.amberAccent.withOpacity(0.15),
                ),
              ),
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.56,
            top: MediaQuery.of(context).size.height * 0.001,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.amber.withOpacity(0.4)),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imgloc),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.07,
            right: MediaQuery.of(context).size.width * 0.15,
            child: AutoSizeText(
              '₹${itemPrice.toStringAsFixed(0)}',
              maxFontSize: 40,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  //color: Color.fromRGBO(102, 102, 0, 1),
                  fontFamily: 'GiazaPro'),
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.07,
            top: MediaQuery.of(context).size.width * 0.15,
            child: Container(
              height: 100,
              width: 170,
              child: AutoSizeText(
                itemName,
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey[800],
                    fontFamily: 'Dealers'),
                textAlign: TextAlign.end,
                maxLines: 1,
              ),
            ),
          ),
          IncrementDecrement(itemName, itemPrice, foodItem),
        ],
      ),
    );
  }
}

class IncrementDecrement extends StatefulWidget {
  String itemName;
  double itemPrice;
  FoodItem foodItem;
  IncrementDecrement(this.itemName, this.itemPrice, this.foodItem);
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  @override
  _IncrementDecrementState createState() => _IncrementDecrementState();
}

class _IncrementDecrementState extends State<IncrementDecrement> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  @override
  Widget build(BuildContext context) {
    addToCart(FoodItem foodItem) {
      bloc.addToList(foodItem);
    }

    removeFromCart(FoodItem foodItem) {
      bloc.removeFromList(foodItem);
    }

    return widget.foodItem.quantity == 0
        ? Positioned(
            right: MediaQuery.of(context).size.width * 0.1,
            top: MediaQuery.of(context).size.height * 0.15,
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300], width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 45,
                width: 120,
                child: FlatButton(
                  color: Colors.amber,
                  child: Text('Add'),
                  onPressed: () {
                    setState(() {
                      addToCart(widget.foodItem);
                    });
                  },
                )),
          )
        : Positioned(
            right: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.height * 0.15,
            child: Container(
              margin: EdgeInsets.only(right: 25),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300], width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 5),
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: FlatButton(
                      color: Colors.amber,
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          removeFromCart(widget.foodItem);
                        });
                      },
                      child: Container(
                        child: Text(
                          "-",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.foodItem.quantity.toString(),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: FlatButton(
                      color: Colors.amber,
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          addToCart(widget.foodItem);
                        });

                        final snackBar = SnackBar(
                          content: Text(
                            '${widget.itemName} is added to the cart',
                            style: TextStyle(color: Colors.amber, fontSize: 20),
                          ),
                          duration: Duration(milliseconds: 300),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      child: Text(
                        "+",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}