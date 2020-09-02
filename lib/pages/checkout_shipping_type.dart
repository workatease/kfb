import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:kfb/api_provider/shipping_methods_api_provider.dart';
import 'package:kfb/app_country_options.dart';
import 'package:kfb/app_state_options.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/models/checkout_session.dart';
import 'package:kfb/models/customer_address.dart';
import 'package:kfb/models/shipping_method.dart';
import 'package:kfb/models/shipping_type.dart';
import 'package:kfb/providers/cart_provider.dart';
import 'package:kfb/widgets/app_loader.dart';
import 'package:kfb/widgets/buttons.dart';

import '../api_provider/shipping_methods_api_provider.dart';
import '../models/shipping_method.dart';

class CheckoutShippingTypePage extends StatefulWidget {
  CheckoutShippingTypePage();

  @override
  _CheckoutShippingTypePageState createState() =>
      _CheckoutShippingTypePageState();
}

class _CheckoutShippingTypePageState extends State<CheckoutShippingTypePage> {
  _CheckoutShippingTypePageState();

  bool _isShippingSupported;
  bool _isLoading;
  List<Map<String, dynamic>> _wsShippingOptions;
  WSShipping _shipping = WSShipping();
  ShippingMethodsApiProvider _shippingMethodsApiProvider =
      ShippingMethodsApiProvider();

  @override
  void initState() {
    super.initState();

    _isShippingSupported = false; // we change the
    _wsShippingOptions = [];

    _isLoading = true;
    //_isLoading = false;
    _getShippingMethods();
  }

  _getShippingMethods() async {
    final wsShipping = await _shippingMethodsApiProvider.getShippingMethods();

    wsShipping.forEach((e) {
      Map<String, dynamic> tmpShippingOption = {};
      tmpShippingOption = {
        "id": e['id'],
        "title": e['title'],
        "method_id": e['method_id'],
        "cost": 0.toString(),
        "object": e
      };
      _wsShippingOptions.add(tmpShippingOption);
    });

    print(_wsShippingOptions);

    CustomerAddress customerAddress =
        CheckoutSession.getInstance.billingDetails.shippingAddress;
    String postalCode = customerAddress.postalCode;
    String location = customerAddress.addressLine;
    String country = customerAddress.country;
    String state = customerAddress.state;
    String countryCode = appCountryOptions
        .firstWhere((c) => c['name'] == country, orElse: () => null)["code"];

    Map<String, dynamic> stateMap = appStateOptions
        .firstWhere((c) => c['name'] == state, orElse: () => null);

    // if (_shipping != null && _shipping.methods != null) {
    //   if (_shipping.methods.flatRate != null) {
    //     _shipping.methods.flatRate
    //         .where((t) => t != null)
    //         .toList()
    //         .forEach((flatRate) {
    //       Map<String, dynamic> tmpShippingOption = {};
    //       tmpShippingOption = {
    //         "id": flatRate.id,
    //         "title": flatRate.title,
    //         "method_id": "flat_rate",
    //         "cost": flatRate.cost,
    //         "object": flatRate
    //       };
    //       _wsShippingOptions.add(tmpShippingOption);
    //     });
    //   }
    //   if (_shipping.methods.distanceRate != null) {
    //     log("Distance rate shipping");
    //     _shipping.methods.distanceRate
    //         .where((t) => t != null)
    //         .toList()
    //         .forEach((distanceRate) {
    //       Map<String, dynamic> tmpShippingOption = {};
    //       tmpShippingOption = {
    //         "id": distanceRate.id,
    //         "title": distanceRate.title,
    //         "method_id": "distance_rate",
    //         "cost": distanceRate.cost,
    //         "object": distanceRate
    //       };
    //       _wsShippingOptions.add(tmpShippingOption);
    //     });
    //   }

    //   if (_shipping.methods.localPickup != null) {
    //     _shipping.methods.localPickup
    //         .where((t) => t != null)
    //         .toList()
    //         .forEach((localPickup) {
    //       Map<String, dynamic> tmpShippingOption = {};
    //       tmpShippingOption = {
    //         "id": localPickup.id,
    //         "method_id": "local_pickup",
    //         "title": localPickup.title,
    //         "cost": localPickup.cost,
    //         "object": localPickup
    //       };
    //       _wsShippingOptions.add(tmpShippingOption);
    //     });
    //   }

    //   if (_shipping.methods.freeShipping != null) {
    //     _shipping.methods.freeShipping
    //         .where((t) => t != null)
    //         .toList()
    //         .forEach((freeShipping) {
    //       if (isNumeric(freeShipping.cost)) {
    //         Map<String, dynamic> tmpShippingOption = {};
    //         tmpShippingOption = {
    //           "id": freeShipping.id,
    //           "method_id": "free_shipping",
    //           "title": freeShipping.title,
    //           "cost": freeShipping.cost,
    //           "object": freeShipping
    //         };
    //         _wsShippingOptions.add(tmpShippingOption);
    //         // print(_wsShippingOptions);
    //       }
    //     });
    // }
    // }

    if (_wsShippingOptions.length != 0) {
      _isShippingSupported = true;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _getShippingPrice(int index) async {
    double total = 0;
    List<CartItem> cartLineItem = await CartProvider.getInstance.getCart();

    total +=
        await workoutShippingCostWC(sum: _wsShippingOptions[index]['cost']);

    switch (_wsShippingOptions[index]['method_id']) {
      case "flat_rate":
        FlatRate flatRate = (_wsShippingOptions[index]['object'] as FlatRate);

        if (cartLineItem.firstWhere(
                (t) => t.shippingClassId == null || t.shippingClassId == "0",
                orElse: () => null) !=
            null) {
          total += await workoutShippingClassCostWC(
              sum: flatRate.classCost,
              cartLineItem: cartLineItem
                  .where((t) =>
                      t.shippingClassId == null || t.shippingClassId == "0")
                  .toList());
        }

        List<CartItem> cItemsWithShippingClasses = cartLineItem
            .where((t) => t.shippingClassId != null && t.shippingClassId != "0")
            .toList();
        for (int i = 0; i < cItemsWithShippingClasses.length; i++) {
          ShippingClasses shippingClasses = flatRate.shippingClasses.firstWhere(
              (d) => d.id == cItemsWithShippingClasses[i].shippingClassId,
              orElse: () => null);
          if (shippingClasses != null) {
            double classTotal = await workoutShippingClassCostWC(
                sum: shippingClasses.cost,
                cartLineItem: cartLineItem
                    .where((g) => g.shippingClassId == shippingClasses.id)
                    .toList());
            total += classTotal;
          }
        }

        break;
      default:
        break;
    }
    return (total).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Shipping Methods",
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
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
                    child: Image(
                        color: Colors.red,
                        image: AssetImage("assets/images/shipping_icon.png"),
                        height: 150,
                        fit: BoxFit.fitHeight),
                  ),
                  padding: EdgeInsets.only(top: 20),
                ),
                SizedBox(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        (_isLoading
                            ? Expanded(child: showAppLoader())
                            : (_isShippingSupported
                                ? Expanded(
                                    child: ListView.separated(
                                      itemCount: _wsShippingOptions.length,
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                        color: Colors.black12,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          contentPadding: EdgeInsets.only(
                                              left: 16, right: 16),
                                          title: Text(
                                              _wsShippingOptions[index]
                                                  ['title'],
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .subtitle1),
                                          selected: true,
                                          subtitle: FutureBuilder<String>(
                                            future: _getShippingPrice(index),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              switch (
                                                  snapshot.connectionState) {
                                                case ConnectionState.none:
                                                  return Text('');
                                                case ConnectionState.active:
                                                case ConnectionState.waiting:
                                                  return Text('');
                                                case ConnectionState.done:
                                                  if (snapshot.hasError)
                                                    return Text('');
                                                  return Text("Price" +
                                                      ": " +
                                                      formatStringCurrency(
                                                          total:
                                                              snapshot.data));
                                              }
                                              return null; // unreachable
                                            },
                                          ),
                                          trailing: (CheckoutSession.getInstance
                                                          .shippingType !=
                                                      null &&
                                                  CheckoutSession
                                                          .getInstance
                                                          .shippingType
                                                          .object ==
                                                      _wsShippingOptions[index]
                                                          ["object"]
                                              ? Icon(Icons.check)
                                              : null),
                                          onTap: () async {
                                            ShippingType shippingType =
                                                ShippingType();
                                            shippingType.object =
                                                _wsShippingOptions[index]
                                                    ['object'];
                                            shippingType.methodId =
                                                _wsShippingOptions[index]
                                                    ['method_id'];
                                            shippingType.cost =
                                                await _getShippingPrice(index);

                                            CheckoutSession.getInstance
                                                .shippingType = shippingType;

                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ),
                                  )
                                : Text(
                                    "Shipping is not supported for your country, sorry",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline6,
                                    textAlign: TextAlign.center))),
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
