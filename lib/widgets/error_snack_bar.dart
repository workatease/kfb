import 'package:flutter/material.dart';

final errorSnackBar2 = (e, {int duration}) =>
    SnackBar(duration: Duration(seconds: duration ?? 3), content: Text('$e'));
final addItemSnackbar = (e) => SnackBar(
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 2),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('$e'),
      ],
    ));
