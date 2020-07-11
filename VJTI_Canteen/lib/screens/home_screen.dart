import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:VJTI_Canteen/widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fooditem.dart';
import '../models/Homepage_middle_part.dart';
import 'package:showcaseview/showcaseview.dart';
import '../bloc/cartListBloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import '../models/cart.dart';
import '../bloc/listTileColorBloc.dart';

var isCollapsed = ValueNotifier<bool>(true);
List<FoodItem> foodItems = [];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Duration duration = const Duration(milliseconds: 700);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        if(isCollapsed.value==false){
            isCollapsed.value=true;
        }
        }
      },
      child: BlocProvider(
        blocs: [
          Bloc((i) => CartListBloc()),
          Bloc((i) => ColorBloc()),
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
                          child: ShowCaseWidget(
                            builder: Builder(
                              builder: (context) => Home(),
                            ),
                          )),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey dashboardIndicatorKey;
  final GlobalKey searchBarIndicatorKey;
  final GlobalKey cartIndicatorKey;

  KeysToBeInherited({
    this.dashboardIndicatorKey,
    this.searchBarIndicatorKey,
    this.cartIndicatorKey,
    Widget child,
  }) : super(child: child);

  static KeysToBeInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController editingController = TextEditingController();
  List<FoodItem> duplicateFoodItems = foodItems;

  void filterSearchResults(String query) {
    List<FoodItem> dummySearchList = [];
    if (query.isNotEmpty) {
      query = query.toLowerCase();
      for (int i = 0; i < foodItems.length; i++) {
        if (foodItems[i].title.toLowerCase().contains(query)) {
          dummySearchList.add(foodItems[i]);
        }
      }
      setState(() {
        duplicateFoodItems.clear();
        duplicateFoodItems.addAll(dummySearchList);
      });
    } else {
      setState(() {
        duplicateFoodItems.clear();
        duplicateFoodItems.addAll(foodItems);
      });
    }
  }

  GlobalKey _dashboardKey = GlobalKey();
  GlobalKey _searchBarKey = GlobalKey();
  GlobalKey _cartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;
    displayShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool showCaseVisibilityStatus = preferences.getBool("displayShowcase");
      if (showCaseVisibilityStatus == null) {
        return true;
      }
      return false;
    }

    displayShowcase().then((status) {
      if (status) {
        preferences.setBool("displayShowcase", false);
        ShowCaseWidget.of(context).startShowCase([
          _dashboardKey,
          _cartKey,
          _searchBarKey,
        ]);
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ShowCaseWidget.of(context).startShowCase([
    //     _dashboardKey,
    //     _cartKey,
    //     _searchBarKey,
    //   ]);
    // });
    return KeysToBeInherited(
      cartIndicatorKey: _cartKey,
      dashboardIndicatorKey: _dashboardKey,
      searchBarIndicatorKey: _searchBarKey,
      child: Scaffold(
        body: Container(
          child: ListView(
            children: <Widget>[
              FirstHalf(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Showcase(
                  showcaseBackgroundColor: Colors.redAccent,
                  key: _searchBarKey,
                  description: "Search for FoodItems here",
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    cursorColor: Colors.amber,
                    controller: editingController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey,
                        labelText: "Search for Food Item",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
              ),
              SizedBox(height: 15),
              StreamBuilder(
                stream: Firestore.instance.collection('FoodItem').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    print('yes');
                    foodItems = List<FoodItem>.generate(
                      snapshot.data.documents.length,
                      (index) => FoodItem(
                        id: snapshot.data.documents[index]['id'],
                        title: snapshot.data.documents[index]['name'],
                        imgloc: snapshot.data.documents[index]['imageUrl'],
                        price: (snapshot.data.documents[index]['price'])
                            .toDouble(),
                        availability: snapshot.data.documents[index]
                            ['availability'],
                      ),
                    );

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: duplicateFoodItems.isEmpty
                          ? foodItems.length
                          : duplicateFoodItems.length,
                      itemBuilder: (context, index) =>
                          duplicateFoodItems.isEmpty
                              ? ItemContainer(
                                  foodItem: foodItems[index],
                                )
                              : ItemContainer(
                                  foodItem: duplicateFoodItems[index],
                                ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
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
        availability: foodItem.availability,
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
    @required this.availability,
  });

  final String imgloc;
  final String itemName;
  final double itemPrice;
  final int availability;
  final FoodItem foodItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        child: HomePageMiddlePart(
          imgloc,
          itemName,
          itemPrice,
          foodItem,
          availability,
        ));
  }
}

class FirstHalf extends StatelessWidget {
  final TextEditingController editingController = TextEditingController();
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
        SizedBox(height: 20.0),
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
            child: Showcase(
              showcaseBackgroundColor: Colors.redAccent,
              key: KeysToBeInherited.of(context).dashboardIndicatorKey,
              description: "Click here to open the options drawer",
              child: Icon(Icons.menu),
            ),
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
              child: Showcase(
                key: KeysToBeInherited.of(context).cartIndicatorKey,
                description: "Click here to review the items in your cart",
                showcaseBackgroundColor: Colors.redAccent,
                child: Icon(
                  Icons.shopping_cart,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
