import 'package:flutter/material.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/widgets/buttons.dart';

class ErrorPage extends StatefulWidget {
  ErrorPage();

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  _ErrorPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.black54,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Sorry, something went wrong",
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
              wsLinkButton(context,
                  title: "Back", action: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}
