import '../models/fooditem.dart';

class CartProvider {
  //counterProvider only consists of a counter and a method which is responsible for increasing the value of count
  List<FoodItem> foodItems = [];

  List<FoodItem> addToList(FoodItem foodItem) {
    bool isPresent = false;

    if (foodItems.length > 0) {
      for (int i = 0; i < foodItems.length; i++) {
        if (foodItems[i].id == foodItem.id) {
          increaseItemQuantity(foodItem);
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }

      if (!isPresent) {
        foodItems.add(foodItem);
        increaseItemQuantity(foodItem);
      }
    } else {
      foodItems.add(foodItem);
      increaseItemQuantity(foodItem);
    }

    return foodItems;
  }

  List<FoodItem> removeFromList(FoodItem foodItem) {
    if (foodItem.quantity > 1) {
      decreaseItemQuantity(foodItem);
    } else if (foodItem.quantity == 1) {
      foodItem.quantity = 0;
      foodItems.remove(foodItem);
    } else {
      foodItems.remove(foodItem);
    }
    return foodItems;
  }

  emptyTheCart() {
    foodItems.clear();
    return foodItems;
  }

  void increaseItemQuantity(FoodItem foodItem) => foodItem.incrementQuantity();
  void decreaseItemQuantity(FoodItem foodItem) => foodItem.decrementQuantity();
}
