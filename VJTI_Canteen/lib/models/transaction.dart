import 'package:flutter/foundation.dart';


class Transaction {
  String id;
  String title;
  double amount;
  bool isCredit;
  DateTime date;
  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
    @required this.isCredit,
  });
}