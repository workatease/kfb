import 'package:flutter/material.dart';
import 'package:kfb/app_country_options.dart';
import 'package:kfb/app_state_options.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/models/billing_details.dart';
import 'package:kfb/models/checkout_session.dart';
import 'package:kfb/models/customer_address.dart';
import 'package:kfb/widgets/buttons.dart';

class CheckoutDetailsPage extends StatefulWidget {
  CheckoutDetailsPage();

  @override
  _CheckoutDetailsPageState createState() => _CheckoutDetailsPageState();
}

class _CheckoutDetailsPageState extends State<CheckoutDetailsPage> {
  _CheckoutDetailsPageState();

  bool _valDifferentShippingAddress = false;
  int activeTabIndex = 0;

  // BILLING TEXT CONTROLLERS
  TextEditingController _txtBillingFirstName;
  TextEditingController _txtBillingLastName;
  TextEditingController _txtBillingAddressLine;
  TextEditingController _txtBillingCity;
  TextEditingController _txtBillingPostalCode;
  TextEditingController _txtBillingEmailAddress;

  TextEditingController _txtShippingFirstName;
  TextEditingController _txtShippingLastName;
  TextEditingController _txtShippingAddressLine;
  TextEditingController _txtShippingCity;
  TextEditingController _txtShippingPostalCode;
  TextEditingController _txtShippingEmailAddress;

  String _strBillingCountry;
  String _strBillingState;

  String _strShippingCountry;
  String _strShippingState;

  var valRememberDetails = true;
  Widget activeTab;

  Widget tabShippingDetails() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _valDifferentShippingAddress
              ? Divider(
                  height: 0,
                )
              : null,
          Flexible(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: wTextEditingRow(
                    context,
                    heading: "First Name",
                    controller: _txtShippingFirstName,
                    shouldAutoFocus: true,
                  ),
                ),
                Flexible(
                  child: wTextEditingRow(
                    context,
                    heading: "Last Name",
                    controller: _txtShippingLastName,
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: wTextEditingRow(
                    context,
                    heading: "Address Line",
                    controller: _txtShippingAddressLine,
                  ),
                ),
                Flexible(
                  child: wTextEditingRow(
                    context,
                    heading: "City",
                    controller: _txtShippingCity,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: wTextEditingRow(
                    context,
                    heading: "Postal code",
                    controller: _txtShippingPostalCode,
                  ),
                ),
                Flexible(
                  child: wTextEditingRow(context,
                      heading: "Email address",
                      keyboardType: TextInputType.emailAddress,
                      controller: _txtShippingEmailAddress),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                // (_strShippingCountry == "United States"
                (_strShippingCountry == "India"
                    ? Flexible(
                        child: Padding(
                          child: wsSecondaryButton(
                            context,
                            title: (_strShippingState != null &&
                                    _strShippingState.isNotEmpty
                                ? "Selected" + "\n" + _strShippingState
                                : "Select state"),
                            action: () => _showSelectStateModal("shipping"),
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                      )
                    : null),
                Flexible(
                  child: Padding(
                    child: wsSecondaryButton(
                      context,
                      title: (_strShippingCountry != null &&
                              _strShippingCountry.isNotEmpty
                          ? "Selected" + "\n" + _strShippingCountry
                          : "Select country"),
                      action: () => _showSelectCountryModal("shipping"),
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                ),
              ].where((element) => element != null).toList(),
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
        ].where((e) => e != null).toList(),
      ),
    );
  }

  Widget tabBillingDetails() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _valDifferentShippingAddress
              ? Divider(
                  height: 0,
                )
              : null,
          Flexible(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: wTextEditingRow(
                    context,
                    heading: "First Name",
                    controller: _txtBillingFirstName,
                    shouldAutoFocus: true,
                  ),
                ),
                Flexible(
                  child: wTextEditingRow(
                    context,
                    heading: "Last Name",
                    controller: _txtBillingLastName,
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: wTextEditingRow(
                    context,
                    heading: "Address Line",
                    controller: _txtBillingAddressLine,
                  ),
                ),
                Flexible(
                  child: wTextEditingRow(
                    context,
                    heading: "City",
                    controller: _txtBillingCity,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: wTextEditingRow(
                    context,
                    heading: "Postal code",
                    controller: _txtBillingPostalCode,
                  ),
                ),
                Flexible(
                  child: wTextEditingRow(context,
                      heading: "Email address",
                      keyboardType: TextInputType.emailAddress,
                      controller: _txtBillingEmailAddress),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                (_strBillingCountry == "United States"
                    ? Flexible(
                        child: Padding(
                          child: wsSecondaryButton(
                            context,
                            title: (_strBillingState != null &&
                                    _strBillingState.isNotEmpty
                                ? "Selected" + "\n" + _strBillingState
                                : "Select state"),
                            action: () => _showSelectStateModal("billing"),
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                      )
                    : null),
                Flexible(
                  child: Padding(
                    child: wsSecondaryButton(
                      context,
                      title: (_strBillingCountry != null &&
                              _strBillingCountry.isNotEmpty
                          ? "Selected" + "\n" + _strBillingCountry
                          : "Select country"),
                      action: () => _showSelectCountryModal("billing"),
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                ),
              ].where((element) => element != null).toList(),
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
        ].where((e) => e != null).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // SHIPPING
    _txtShippingFirstName = TextEditingController();
    _txtShippingLastName = TextEditingController();
    _txtShippingAddressLine = TextEditingController();
    _txtShippingCity = TextEditingController();
    _txtShippingPostalCode = TextEditingController();
    _txtShippingEmailAddress = TextEditingController();

    // BILLING
    _txtBillingFirstName = TextEditingController();
    _txtBillingLastName = TextEditingController();
    _txtBillingAddressLine = TextEditingController();
    _txtBillingCity = TextEditingController();
    _txtBillingPostalCode = TextEditingController();
    _txtBillingEmailAddress = TextEditingController();

    if (CheckoutSession.getInstance.billingDetails.billingAddress == null) {
      CheckoutSession.getInstance.billingDetails.initSession();
      CheckoutSession.getInstance.billingDetails.shippingAddress.initAddress();
      CheckoutSession.getInstance.billingDetails.billingAddress.initAddress();
    }
    BillingDetails billingDetails = CheckoutSession.getInstance.billingDetails;
    _txtBillingFirstName.text = billingDetails.billingAddress.firstName;
    _txtBillingLastName.text = billingDetails.billingAddress.lastName;
    _txtBillingAddressLine.text = billingDetails.billingAddress.addressLine;
    _txtBillingCity.text = billingDetails.billingAddress.city;
    _txtBillingPostalCode.text = billingDetails.billingAddress.postalCode;
    _txtBillingEmailAddress.text = billingDetails.billingAddress.emailAddress;
    _strBillingCountry = billingDetails.billingAddress.country;
    _strBillingState = billingDetails.billingAddress.state;

    _txtShippingFirstName.text = billingDetails.shippingAddress.firstName;
    _txtShippingLastName.text = billingDetails.shippingAddress.lastName;
    _txtShippingAddressLine.text = billingDetails.shippingAddress.addressLine;
    _txtShippingCity.text = billingDetails.shippingAddress.city;
    _txtShippingPostalCode.text = billingDetails.shippingAddress.postalCode;
    _txtShippingEmailAddress.text = billingDetails.shippingAddress.emailAddress;
    _strShippingCountry = billingDetails.shippingAddress.country;
    _strShippingState = billingDetails.shippingAddress.state;

    _valDifferentShippingAddress =
        CheckoutSession.getInstance.shipToDifferentAddress;
    valRememberDetails = billingDetails.rememberDetails ?? true;
    _sfCustomerAddress();
  }

  _sfCustomerAddress() async {
    CustomerAddress sfCustomerBillingAddress =
        await CheckoutSession.getInstance.getBillingAddress();
    if (sfCustomerBillingAddress != null) {
      CustomerAddress customerAddress = sfCustomerBillingAddress;
      _txtBillingFirstName.text = customerAddress.firstName;
      _txtBillingLastName.text = customerAddress.lastName;
      _txtBillingAddressLine.text = customerAddress.addressLine;
      _txtBillingCity.text = customerAddress.city;
      _txtBillingPostalCode.text = customerAddress.postalCode;
      _txtBillingEmailAddress.text = customerAddress.emailAddress;
      _strBillingState = customerAddress.state;
      _strBillingCountry = customerAddress.country;
    }

    CustomerAddress sfCustomerShippingAddress =
        await CheckoutSession.getInstance.getShippingAddress();
    if (sfCustomerShippingAddress != null) {
      CustomerAddress customerAddress = sfCustomerShippingAddress;
      _txtShippingFirstName.text = customerAddress.firstName;
      _txtShippingLastName.text = customerAddress.lastName;
      _txtShippingAddressLine.text = customerAddress.addressLine;
      _txtShippingCity.text = customerAddress.city;
      _txtShippingPostalCode.text = customerAddress.postalCode;
      _txtShippingEmailAddress.text = customerAddress.emailAddress;
      _strShippingCountry = customerAddress.country;
      _strShippingState = customerAddress.state;
    }
  }

  _showSelectCountryModal(String type) {
    wModalBottom(
      context,
      title: "Select a country",
      bodyWidget: ListView.separated(
        itemCount: appCountryOptions.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, String> strName = appCountryOptions[index];

          return InkWell(
            child: Container(
              child: Text(strName["name"],
                  style: Theme.of(context).primaryTextTheme.bodyText1),
              padding: EdgeInsets.only(top: 25, bottom: 25),
            ),
            splashColor: Colors.grey,
            highlightColor: Colors.black12,
            onTap: () => setState(() {
              if (type == "shipping") {
                _strShippingCountry = strName["name"];
                activeTab = tabShippingDetails();
                Navigator.of(context).pop();
                if (strName["code"] == "US") {
                  _showSelectStateModal(type);
                } else {
                  _strShippingState = "";
                }
              } else if (type == "billing") {
                _strBillingCountry = strName["name"];
                Navigator.of(context).pop();
                activeTab = tabBillingDetails();
                if (strName["code"] == "IN") {
                  _showSelectStateModal(type);
                } else {
                  _strBillingState = "";
                }
              }
            }),
          );
        },
        separatorBuilder: (cxt, i) => Divider(
          height: 0,
          color: Colors.black12,
        ),
      ),
    );
  }

  _showSelectStateModal(String type) {
    wModalBottom(
      context,
      title: "Select a state",
      bodyWidget: ListView.separated(
        itemCount: appStateOptions.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, String> strName = appStateOptions[index];

          return InkWell(
            child: Container(
              child: Text(
                strName["name"],
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              padding: EdgeInsets.only(top: 25, bottom: 25),
            ),
            splashColor: Colors.grey,
            highlightColor: Colors.black12,
            onTap: () => setState(() {
              if (type == "shipping") {
                _strShippingState = strName["name"];
                Navigator.of(context).pop();
                activeTab = tabShippingDetails();
              } else if (type == "billing") {
                _strBillingState = strName["name"];
                Navigator.of(context).pop();
                activeTab = tabBillingDetails();
              }
            }),
          );
        },
        separatorBuilder: (cxt, i) => Divider(
          height: 0,
          color: Colors.black12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Billing & Shipping Details",
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _valDifferentShippingAddress
                            ? Padding(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Flexible(
                                      child: InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          child: Text(
                                            "Billing Details",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(
                                                    color: activeTabIndex == 0
                                                        ? Colors.white
                                                        : Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: activeTabIndex == 0
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 4),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            activeTabIndex = 0;
                                            activeTab = tabBillingDetails();
                                          });
                                        },
                                      ),
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          child: Text(
                                            "Shipping Address",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(
                                                    color: activeTabIndex == 1
                                                        ? Colors.white
                                                        : Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: activeTabIndex == 1
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            activeTabIndex = 1;
                                            activeTab = tabShippingDetails();
                                          });
                                        },
                                      ),
                                    )
                                  ].where((e) => e != null).toList(),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 8),
                              )
                            : null,
                        activeTab ?? tabBillingDetails(),
                      ].where((e) => e != null).toList(),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: wBoxShadow(),
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                  height:
                      (constraints.maxHeight - constraints.minHeight) * 0.62,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Ship to a different address?",
                          style: Theme.of(context).primaryTextTheme.bodyText2,
                        ),
                        Checkbox(
                          value: _valDifferentShippingAddress,
                          onChanged: _onChangeShipping,
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Remember my details",
                          style: Theme.of(context).primaryTextTheme.bodyText2,
                        ),
                        Checkbox(
                          value: valRememberDetails,
                          onChanged: (bool value) {
                            setState(() {
                              valRememberDetails = value;
                            });
                          },
                        )
                      ],
                    ),
                    wsPrimaryButton(context,
                        title: "USE DETAILS",
                        action: () => _useDetailsTapped()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _useDetailsTapped() {
    CustomerAddress customerBillingAddress = new CustomerAddress();
    customerBillingAddress.firstName = _txtBillingFirstName.text;
    customerBillingAddress.lastName = _txtBillingLastName.text;
    customerBillingAddress.addressLine = _txtBillingAddressLine.text;
    customerBillingAddress.city = _txtBillingCity.text;
    customerBillingAddress.postalCode = _txtBillingPostalCode.text;
    customerBillingAddress.state = _strBillingState;
    customerBillingAddress.country = _strBillingCountry;
    customerBillingAddress.emailAddress = _txtBillingEmailAddress.text;

    if (!_valDifferentShippingAddress) {
      CheckoutSession.getInstance.billingDetails.shippingAddress =
          customerBillingAddress;

      CheckoutSession.getInstance.billingDetails.billingAddress =
          customerBillingAddress;

      if (valRememberDetails == true) {
        CheckoutSession.getInstance.saveBillingAddress();
      }
    } else {
      CustomerAddress customerShippingAddress = new CustomerAddress();
      customerShippingAddress.firstName = _txtShippingFirstName.text;
      customerShippingAddress.lastName = _txtShippingLastName.text;
      customerShippingAddress.addressLine = _txtShippingAddressLine.text;
      customerShippingAddress.city = _txtShippingCity.text;
      customerShippingAddress.postalCode = _txtShippingPostalCode.text;
      customerShippingAddress.state = _strShippingState;
      customerShippingAddress.country = _strShippingCountry;
      customerShippingAddress.emailAddress = _txtShippingEmailAddress.text;

      if (customerShippingAddress.hasMissingFields()) {
        showEdgeAlertWith(context,
            title: "Oops",
            desc:
                "Invalid shipping address, please check your shipping details",
            style: EdgeAlertStyle.WARNING);
        return;
      }

      CheckoutSession.getInstance.billingDetails.billingAddress =
          customerBillingAddress;

      CheckoutSession.getInstance.billingDetails.shippingAddress =
          customerShippingAddress;

      if (valRememberDetails == true) {
        CheckoutSession.getInstance.saveBillingAddress();
        CheckoutSession.getInstance.saveShippingAddress();
      }
    }

    CheckoutSession.getInstance.billingDetails.rememberDetails =
        valRememberDetails;

    if (valRememberDetails != true) {
      CheckoutSession.getInstance.clearBillingAddress();
      CheckoutSession.getInstance.clearShippingAddress();
    }

    CheckoutSession.getInstance.shipToDifferentAddress =
        _valDifferentShippingAddress;

    CheckoutSession.getInstance.shippingType = null;
    Navigator.pop(context);
  }

  _onChangeShipping(bool value) async {
    _valDifferentShippingAddress = value;
    activeTabIndex = 1;
    if (value == true) {
      activeTab = tabShippingDetails();
    } else {
      activeTab = tabBillingDetails();
    }
    CustomerAddress sfCustomerShippingAddress =
        await CheckoutSession.getInstance.getShippingAddress();
    if (sfCustomerShippingAddress == null) {
      _txtShippingFirstName.text = "";
      _txtShippingLastName.text = "";
      _txtShippingAddressLine.text = "";
      _txtShippingCity.text = "";
      _txtShippingPostalCode.text = "";
      _txtShippingEmailAddress.text = "";
      _strShippingState = "";
      _strShippingCountry = "";
    }
    setState(() {});
  }
}
