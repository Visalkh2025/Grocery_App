import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final int duration;

  VoidCallback? action;
  Timer? _timer;
  Debouncer({this.duration = 500});
  startSearch(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: duration), action);
  }
}
