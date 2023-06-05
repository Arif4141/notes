import 'package:flutter/material.dart';

class AnimatedContainerProvider extends ChangeNotifier {
  double _value = 210;
  bool expandC = false;
  double get value => _value;

  void expandCont() {
    _value = 510;
    expandC = true;
    notifyListeners();
  }

  void shrinkCont() {
    _value = 210;
    expandC = false;
    notifyListeners();
  }
}
