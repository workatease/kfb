import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showDialogMethod(context,
    {Key key,
    bool onWillPop = false,
    bool barrierDismissible = true,
    Color color}) async {
  print("barrierDismissible $barrierDismissible");
  print(barrierDismissible);
  await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          key: key,
          onWillPop: () async => true,
          child: Center(child: CircularProgressIndicator()),
        );
      });
}

showDialogMethodTranpaent(context,
    {Key key,
    bool onWillPop = true,
    bool barrierDismissible = false,
    double height,
    double width}) {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: WillPopScope(
            key: key,
            onWillPop: () async => onWillPop,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    height: height ?? 25,
                    width: width ?? 25,
                    child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      });
}
