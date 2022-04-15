import 'package:flutter/material.dart';

class valueProvider with ChangeNotifier {
  double? value1;
  double? value2;
  int valuestep = 0;
  int count = 0;
  notifyListeners();
  // สร้างฟังก์ชันการนับ counter
  increment(value1PRO, value2PRO) {
    value1 = value1PRO;
    value2 = value2PRO;
    notifyListeners();
  }

  value(value) {
    count = value;
    notifyListeners();
  }

  valuespeed(step) {
    valuestep = step;

    notifyListeners();
  }
}
