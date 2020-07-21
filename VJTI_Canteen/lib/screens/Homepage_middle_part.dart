import 'package:VJTI_Canteen/providers/cart_item_list.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../models/fooditem.dart';
import 'package:provider/provider.dart';

class HomePageMiddlePart extends StatelessWidget {
  final String imgloc;
  final String itemName;
  final double itemPrice;
  final FoodItem foodItem;
  final int availability;

  HomePageMiddlePart(this.imgloc, this.itemName, this.itemPrice, this.foodItem,
      this.availability);

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
                height: MediaQuery.of(context).size.height * 0.21,
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
            bottom: MediaQuery.of(context).size.height * 0.02,
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
            top: MediaQuery.of(context).size.width * 0.17,
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
  final String itemName;
  final double itemPrice;
  final FoodItem foodItem;

  IncrementDecrement(this.itemName, this.itemPrice, this.foodItem);

  @override
  _IncrementDecrementState createState() => _IncrementDecrementState();
}

class _IncrementDecrementState extends State<IncrementDecrement> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: MediaQuery.of(context).size.width * 0.1,
      top: MediaQuery.of(context).size.height * 0.14,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300], width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 45,
          width: 120,
          child: 
              // Provider.of<CartItemList>(context, listen: false)
              //             .quantityOfItem(widget.foodItem) <
              //         1
              //     ?
              FlatButton(
            color: Colors.amber,
            child: Text('Add'),
            onPressed: () {
              Provider.of<CartItemList>(context, listen: false)
                  .addToCart(widget.foodItem);
              setState(() {
                // if (widget.foodItem.availability > widget.foodItem.quantity) {
                final snackBar = SnackBar(
                  content: Text(
                    '${widget.itemName} is added to the cart',
                    style: TextStyle(color: Colors.amber, fontSize: 20),
                  ),
                  duration: Duration(milliseconds: 300),
                );
                Scaffold.of(context).showSnackBar(snackBar);
                // } else {
                //   setState(() {
                //     final snackBar = SnackBar(
                //       content: Text(
                //         'Sorry Only ${widget.foodItem.availability} units of ${widget.itemName} is available',
                //         style: TextStyle(color: Colors.amber, fontSize: 20),
                //       ),
                //       duration: Duration(milliseconds: 3000),
                //     );
                //     Scaffold.of(context).showSnackBar(snackBar);
                //   });
                // }
              });
            },
          )
          // : IncrementDecrementBar(
          //     foodItem: widget.foodItem,
          //   ),
          ),
    );
  }
}

class IncrementDecrementBar extends StatelessWidget {
  final FoodItem foodItem;
  IncrementDecrementBar({this.foodItem});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300], width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 45,
      width: 120,
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              color: Colors.amber,
              child: Icon(
                Icons.remove,
                color: Colors.black,
              ),
              onPressed: () {
                Provider.of<CartItemList>(context, listen: false)
                    .removeFromCart(foodItem.id);
              },
            ),
          ),
          Container(
            width: 40,
            child: FittedBox(
              child: Text(
                Provider.of<CartItemList>(context, listen: true)
                    .quantityOfItem(foodItem)
                    .toString(),
                style: TextStyle(),
              ),
            ),
          ),
          Expanded(
            child: FlatButton(
              color: Colors.amber,
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                Provider.of<CartItemList>(context, listen: false)
                    .addToCart(foodItem);
              },
            ),
          ),
        ],
      ),
    );
  }
}
