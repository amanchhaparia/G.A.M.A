import 'package:VJTI_Canteen/models/fooditem.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<FoodItem> foodItems = [];

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SearchBar(
            onCancelled: () {
              Navigator.of(context).pop();
            },
            onSearch: search,
            onItemFound: (dynamic foodItems, int index) {
              return ListTile(
                title: Text(foodItems.title),
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<List<FoodItem>> search(String search) async {
  await Future.delayed(Duration(seconds: 2));
  return List.generate(search.length, (int index) {
    return foodItems[index];
  });
}

Future<List<FoodItem>> fetchFoodItems() async {
  Firestore.instance.collection('FoodItem').snapshots().listen((data) {
    data.documents.forEach((element) {
      foodItems.add(FoodItem(
          id: element['id'],
          title: element['name'],
          price: element['price'].toDouble(),
          imgloc: 'assets/FoodItems/Papdi_Chart.png',
          quantity: element['availability']));
    });
  });
  return foodItems;
}
