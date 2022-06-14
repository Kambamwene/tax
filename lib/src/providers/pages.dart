import 'package:flutter/material.dart';

class PagesWrapper with ChangeNotifier {
  int page = 0;
  void changePage(int value) {
    page = value;
    notifyListeners();
  }
}
