import 'package:meta/meta.dart';

FooditemList foodItemList = FooditemList(foodItems: [
  FoodItem(
      id: 1,
      title: 'Ragada Samosa',
      price: 30,
      imgloc: 'assets/FoodItems/Ragada_Samosa.png'),
  FoodItem(
      id: 2,
      title: 'Bread Pakoda',
      price: 30,
      imgloc: 'assets/FoodItems/Bread_Pakoda.png'),
  FoodItem(
      id: 3,
      title: 'Fried Rice',
      price: 30,
      
      imgloc: 'assets/FoodItems/Fried_Rice.png'),
  FoodItem(
      id: 4,
      title: 'Gobi Chilli',
      price: 30,
      imgloc: 'assets/FoodItems/Gobbi_Chilli.png'),
      FoodItem(
      id: 5,
      title: 'Papdi Chaat',
      price: 15,
      imgloc: 'assets/FoodItems/Papdi_Chart.png'),
]);

class FooditemList {
  List<FoodItem> foodItems;
  FooditemList({@required this.foodItems});
}

class FoodItem {
  int id;
  String title;
  double price;
  int quantity;
  String imgloc;
  FoodItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.imgloc,
      this.quantity = 1});
  void incrementQuantity() {
    this.quantity++;
  }

  void decrementQuantity() {
    this.quantity--;
  }
}
