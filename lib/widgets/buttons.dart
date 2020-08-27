import 'package:flutter/material.dart';

Widget wsPrimaryButton(BuildContext context,
    {@required String title, void Function() action}) {
  return Container(
    height: 55,
    child: RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      padding: EdgeInsets.all(8),
      child: Text(
        title,
        style: Theme.of(context).primaryTextTheme.button.copyWith(fontSize: 16),
      ),
      onPressed: action ?? null,
      elevation: 0,
      color: Color(0xff829112),
    ),
  );
}

Widget wsDarkButton(BuildContext context,
    {@required String title, void Function() action}) {
  return Container(
    height: 55,
    child: RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      padding: EdgeInsets.all(8),
      child: Text(
        title,
        style: Theme.of(context).primaryTextTheme.button.copyWith(fontSize: 16),
      ),
      onPressed: action ?? null,
      elevation: 0,
      color: Colors.grey[800],
    ),
  );
}

Widget wsSecondaryButton(BuildContext context,
    {String title, void Function() action}) {
  return Container(
    height: 60,
    margin: EdgeInsets.only(top: 10),
    child: RaisedButton(
      child: Text(
        title,
        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
              color: Colors.black87,
            ),
        textAlign: TextAlign.center,
      ),
      onPressed: action,
      color: Color(0xfff6f6f9),
      elevation: 1,
    ),
  );
}

Widget wsLinkButton(BuildContext context,
    {String title, void Function() action}) {
  return Container(
    height: 60,
    margin: EdgeInsets.only(top: 10),
    child: MaterialButton(
      padding: EdgeInsets.all(10),
      child: Text(
        title,
        style: Theme.of(context).primaryTextTheme.bodyText1,
        textAlign: TextAlign.left,
      ),
      onPressed: action,
      elevation: 0,
    ),
  );
}
