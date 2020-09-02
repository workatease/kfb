import 'package:flutter/material.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/models/checkout_session.dart';
import 'package:kfb/widgets/buttons.dart';

class CheckoutPaymentTypePage extends StatefulWidget {
  CheckoutPaymentTypePage();

  @override
  _CheckoutPaymentTypePageState createState() =>
      _CheckoutPaymentTypePageState();
}

class _CheckoutPaymentTypePageState extends State<CheckoutPaymentTypePage> {
  _CheckoutPaymentTypePageState();

  @override
  void initState() {
    super.initState();
    print(getPaymentTypes().length); //for test the code.

    if (CheckoutSession.getInstance.paymentType == null) {
      if (getPaymentTypes() != null && getPaymentTypes().length > 0) {
        CheckoutSession.getInstance.paymentType = getPaymentTypes().first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Payment Method",
            style: Theme.of(context).primaryTextTheme.headline6),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  child: Center(
                    child: Image.asset(
                      'assets/images/cradit_cards.jpg',
                      width: 280.0,
                    ),
                  ),
                  padding: EdgeInsets.only(top: 20),
                ),
                SizedBox(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: ListView.separated(
                            itemCount: getPaymentTypes().length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                contentPadding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 8, right: 8),
                                leading: Image(
                                    image: AssetImage("assets/images/" +
                                        getPaymentTypes()[index].assetImage),
                                    width: 60,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center),
                                title: Text(getPaymentTypes()[index].desc,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .subtitle1),
                                selected: true,
                                trailing:
                                    (CheckoutSession.getInstance.paymentType ==
                                            getPaymentTypes()[index]
                                        ? Icon(Icons.check)
                                        : null),
                                onTap: () {
                                  print("Pree to back screen");
                                  CheckoutSession.getInstance.paymentType =
                                      getPaymentTypes()[index];
                                  //Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, "/paymentgatway");
                                },
                              );
                            },
                            separatorBuilder: (cxt, i) => Divider(
                              color: Colors.black12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: getPaymentTypes().length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                contentPadding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 8, right: 8),
                                leading: Icon(Icons.credit_card),
                                title: Text(
                                  "Case on Delivery",
                                  style: TextStyle(fontSize: 20.0),
                                ),

                                /*trailing:
                                    (CheckoutSession.getInstance.paymentType ==
                                            getPaymentTypes()[index]
                                        ? Icon(Icons.check)
                                        : null), */
                                onTap: () {
                                  print("Pree to back screen from cod");
                                  CheckoutSession.getInstance.paymentType =
                                      getPaymentTypes()[index];
                                  Navigator.pop(context);
                                },
                              );
                            },
                            separatorBuilder: (cxt, i) => Divider(
                              color: Colors.black12,
                            ),
                          ),
                        ),

                        //this is chandrshekhar pandey
                        wsLinkButton(
                          context,
                          title: "CANCEL",
                          action: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: wBoxShadow(),
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                  height: (constraints.maxHeight - constraints.minHeight) * 0.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
