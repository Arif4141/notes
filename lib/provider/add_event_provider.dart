import 'package:flutter/material.dart';

class AddEventProvider extends ChangeNotifier {
  double _currentPage = 0;
  double get currentPage => _currentPage;
  int _dynamicList = 1;
  int get dynamicList => _dynamicList;
  List<String> _taskList = [''];
  List<String> get taskList => _taskList;

  set setCurrentPage(val) {
    _currentPage = val;
    notifyListeners();
  }

  set resetWidget(val) {
    _taskList = val;
    notifyListeners();
  }

  void addWidget() {
    _taskList.add('');
    notifyListeners();
  }

  void removeWidget(index) {
    _taskList.removeAt(index);
    notifyListeners();
  }
}
