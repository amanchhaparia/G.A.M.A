import 'package:VJTI_Canteen/providers/cart_item_list.dart';

import 'package:VJTI_Canteen/screens/orders_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import '../bloc/listTileColorBloc.dart';
import '../providers/auth.dart';
import '../providers/order.dart';
import '../models/cartItem.dart';

class Cart extends StatelessWidget {
  final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
        builder: Builder(
      builder: (context) => MainScreen(),
      // StreamBuilder(
      //   stream: Provider.of<FoodItemList>(context),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       foodItems = snapshot.data;
      //       return MainScreen(foodItems: foodItems);
      //     } else {
      //       return Container();
      //     }
      //   },
      // ),
    ));
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey _backButton = GlobalKey();
  GlobalKey _deleteButton = GlobalKey();
  GlobalKey _nextButton = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final cartListItem = Provider.of<CartItemList>(context);
    SharedPreferences cartPreferences;
    displayShowcase() async {
      cartPreferences = await SharedPreferences.getInstance();

      bool showCaseVisibilityStatus =
          cartPreferences.getBool("displaycartShowcase");
      if (showCaseVisibilityStatus == null) {
        return true;
      }
      return false;
    }

    displayShowcase().then((status) {
      if (status) {
        cartPreferences.setBool("displaycartShowcase", false);
        ShowCaseWidget.of(context).startShowCase([
          _deleteButton,
          _nextButton,
          _backButton,
        ]);
      }
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ShowCaseWidget.of(context)
    //       .startShowCase([_deleteButton, _nextButton, _backButton]);
    // });

    return KeysToBeInherited(
      backButtonIndicatorKey: _backButton,
      deleteIndicatorKey: _deleteButton,
      nextIndicatorKey: _nextButton,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: CartBody(
              cartItemList: cartListItem.cartFoodItem,
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(cartListItem.cartFoodItem),
      ),
    );
  }
}

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey backButtonIndicatorKey;
  final GlobalKey deleteIndicatorKey;
  final GlobalKey nextIndicatorKey;
  KeysToBeInherited({
    this.backButtonIndicatorKey,
    this.deleteIndicatorKey,
    this.nextIndicatorKey,
    Widget child,
  }) : super(child: child);

  static KeysToBeInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // ignore: todo
    // TODO: implement updateShouldNotify
    return true;
  }
}

class BottomBar extends StatefulWidget {
  final List<CartItem> cartItem;
  BottomBar(this.cartItem);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    funct() async {
      final user =
          await Provider.of<Auth>(context, listen: false).currentUser();
      return user.uid;
    }

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            margin: EdgeInsets.only(left: 35, bottom: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                totalAmount(widget.cartItem),
                Divider(
                  height: 0.8,
                  color: Colors.grey[700],
                ),
                Container(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    if (widget.cartItem.length == 0) {
                      _showAlert(context, 'Cart is empty.!');
                    } else {
                      var uid;
                      await funct().then((value) => (uid = value));
                      setState(() {
                        _isLoading = true;
                      });
                      Orders(uid)
                          .updateUserOrder(widget.cartItem,
                              returnTotalAmount(widget.cartItem), context)
                          .then((_) =>
                              Provider.of<CartItemList>(context, listen: false)
                                  .clearCart())
                          .then((_) {
                        setState(() {
                          _isLoading = false;
                        });
                      }).whenComplete(() {
                        _showAlert(context, 'Order placed successfully.!');
                      });
                    }
                  },
                  child: Showcase(
                    key: KeysToBeInherited.of(context).nextIndicatorKey,
                    description: "Click here to Place the Order",
                    showcaseBackgroundColor: Colors.redAccent,
                    descTextStyle: TextStyle(fontSize: 25),
                    child: nextButtonBar(),
                  ),
                ),
              ],
            ),
          );
  }

  void _showAlert(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title:
              errorMessage == 'Cart is empty.!' ? Text('Alert') : Text('Done'),
          content: Text(errorMessage),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                if (errorMessage == 'Cart is empty.!') {
                  Navigator.of(ctx).pop();
                } else {
                  Navigator.of(ctx).pushReplacementNamed(OrderScreen.routeName);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

Container nextButtonBar() {
  return Container(
    margin: EdgeInsets.only(right: 25),
    padding: EdgeInsets.all(25),
    decoration: BoxDecoration(
      color: Color(0xfffeb324),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '15-25 min',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        Text("Order Now",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ))
      ],
    ),
  );
}

Container totalAmount(List<CartItem> cartItem) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Total:',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
        ),
        Text(
          '₹${returnTotalAmount(cartItem).toStringAsFixed(2)}',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

double returnTotalAmount(List<CartItem> cartItem) {
  double totalAmount = 0;
  for (int i = 0; i < cartItem.length; i++) {
    totalAmount = totalAmount + cartItem[i].price * cartItem[i].quantity;
  }
  return totalAmount;
}

class CartBody extends StatelessWidget {
  final List<CartItem> cartItemList;
  CartBody({@required this.cartItemList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(35, 40, 25, 0),
      child: Column(
        children: <Widget>[
          CustomAppBar(),
          title(),
          Expanded(
            flex: 1,
            child: cartItemList.length > 0
                ? ListView.builder(
                    itemCount: cartItemList != null ? cartItemList.length : 0,
                    itemBuilder: (builder, index) {
                      return CartListItem(cartItemList[index]);
                    })
                : noItemContainer(),
          )
        ],
      ),
    );
  }

  Container noItemContainer() {
    return Container(
      child: Center(
        child: Text("Your Cart Is Empty",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              fontSize: 20,
            )),
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'MY',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                ),
              ),
              Text(
                'Order',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 35),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
              child: Showcase(
                key: KeysToBeInherited.of(context).backButtonIndicatorKey,
                description: "Click here to go back to menu page",
                showcaseBackgroundColor: Colors.redAccent,
                descTextStyle: TextStyle(fontSize: 25),
                child: Icon(
                  CupertinoIcons.back,
                  size: 30,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              }),
        ),
        DragTargetWidget(),
      ],
    );
  }
}

class DragTargetWidget extends StatefulWidget {
  @override
  _DragTargetWidgetState createState() => _DragTargetWidgetState();
}

class _DragTargetWidgetState extends State<DragTargetWidget> {
  final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();
  @override
  Widget build(BuildContext context) {
    return DragTarget<CartItem>(
      onWillAccept: (CartItem cartItem) {
        colorBloc.setColor(Colors.red);
        return true;
      },
      onAccept: (CartItem cartItem) {
        Provider.of<CartItemList>(context, listen: false)
            .removeFromCart(cartItem.id);
        colorBloc.setColor(Colors.white);
      },
      onLeave: (_) {
        colorBloc.setColor(Colors.white);
      },
      builder: (context, incoming, rejected) {
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: Showcase(
            key: KeysToBeInherited.of(context).deleteIndicatorKey,
            showcaseBackgroundColor: Colors.redAccent,
            description: 'Drag the food Items here to remove it ',
            descTextStyle: TextStyle(fontSize: 25),
            child: Icon(
              CupertinoIcons.delete,
              size: 35,
            ),
          ),
        );
      },
    );
  }
}

class CartListItem extends StatelessWidget {
  final CartItem cartItem;
  CartListItem(this.cartItem);
  @override
  Widget build(BuildContext context) {
    return Draggable(
        data: cartItem,
        maxSimultaneousDrags: 1,
        child: DraggableChild(cartItem: cartItem),
        feedback: DraggableChildFeedback(cartItem: cartItem),
        childWhenDragging: cartItem.quantity > 1
            ? DraggableChild(
                cartItem: cartItem,
              )
            : Container());
  }
}

class DraggableChild extends StatelessWidget {
  const DraggableChild({
    Key key,
    @required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: EdgeInsets.only(bottom: 25),
        child: ItemContent(cartItem),
      ),
    );
  }
}

class DraggableChildFeedback extends StatelessWidget {
  const DraggableChildFeedback({
    Key key,
    @required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();
    return Opacity(
      opacity: 0.7,
      child: StreamBuilder<Object>(
          stream: colorBloc.colorStream,
          builder: (context, snapshot) {
            return Material(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: snapshot.hasData ? snapshot.data : Colors.white,
                ),
                margin: EdgeInsets.only(bottom: 25),
                child: ItemContent(cartItem),
              ),
            );
          }),
    );
  }
}

class ItemContent extends StatelessWidget {
  final CartItem cartItem;
  ItemContent(this.cartItem);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              cartItem.imgloc,
              fit: BoxFit.fitHeight,
              height: 55,
              width: 80,
            ),
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
              children: [
                TextSpan(
                  text: cartItem.quantity.toString(),
                ),
                TextSpan(
                  text: 'x',
                ),
                TextSpan(
                  text: cartItem.title.toString(),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                '₹${cartItem.quantity * cartItem.price}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
