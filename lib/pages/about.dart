import 'package:flutter/material.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/widgets/menu_item.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  AboutPage();

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  _AboutPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            Text("About", style: Theme.of(context).primaryTextTheme.headline6),
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: storeLogo(),
              flex: 2,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  wsMenuItem(
                    context,
                    title: "Privacy policy",
                    leading: Icon(Icons.people),
                    action: _actionPrivacy,
                  ),
                  wsMenuItem(
                    context,
                    title: "Terms and conditions",
                    leading: Icon(Icons.description),
                    action: _actionTerms,
                  ),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (BuildContext context,
                        AsyncSnapshot<PackageInfo> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text("");
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return Text("");
                        case ConnectionState.done:
                          if (snapshot.hasError) return Text("");
                          return Padding(
                            child: Text(
                                "Version" + ": " + snapshot.data.version,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1),
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                          );
                      }
                      return null; // unreachable
                    },
                  ),
                ],
              ),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }

  // void _actionTerms() {
  //   openBrowserTab(url: app_terms_url);
  // }
  void _actionTerms() {
    Navigator.pushNamed(context, '/terms');
  }

  // void _actionPrivacy() {
  //   openBrowserTab(url: app_privacy_url);
  // }
  void _actionPrivacy() {
    Navigator.pushNamed(context, '/privacy');
  }
}
