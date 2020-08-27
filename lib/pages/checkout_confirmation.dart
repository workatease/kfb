import 'package:flutter/material.dart';
import 'package:kfb/api_provider/tax_rate_api_provider.dart';
import 'package:kfb/app_country_options.dart';
import 'package:kfb/app_payment_methods.dart';
import 'package:kfb/app_state_options.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/models/checkout_session.dart';
import 'package:kfb/models/customer_address.dart';
import 'package:kfb/models/response/tax_rate.dart';
import 'package:kfb/shared_pref.dart/sp_auth.dart';
import 'package:kfb/widgets/app_loader.dart';
import 'package:kfb/widgets/buttons.dart';
import 'package:wp_json_api/models/responses/wc_customer_info_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class CheckoutConfirmationPage extends StatefulWidget {
  CheckoutConfirmationPage({Key key}) : super(key: key);

  @override
  CheckoutConfirmationPageState createState() =>
      CheckoutConfirmationPageState();
}

class CheckoutConfirmationPageState extends State<CheckoutConfirmationPage> {
  CheckoutConfirmationPageState();

  bool _showFullLoader;
  TaxRateApiProvider _taxRateApiProvider;

  List<TaxRate> _taxRates;
  TaxRate _taxRate;
  bool _isProcessingPayment;

  @override
  void initState() {
    super.initState();
    _taxRateApiProvider = TaxRateApiProvider();
    _taxRates = [];
    _showFullLoader = true;
    _isProcessingPayment = false;
    if (CheckoutSession.getInstance.paymentType == null) {
      CheckoutSession.getInstance.paymentType = arrPaymentMethods.first;
    }

    _getTaxes();
    _fetchWpUserShippingData();
  }

  WCCustomerInfoResponse _wcCustomerInfoResponse;

  _fetchWpUserShippingData() async {
    _wcCustomerInfoResponse = await WPJsonAPI.instance.api((request) async {
      return request.wcCustomerInfo(await readAuthToken());
    });
    setState(() {
      _showFullLoader = false;
    });
  }

  void reloadState({bool showLoader}) {
    setState(() {
      _showFullLoader = showLoader ?? false;
    });
  }

  _getTaxes() async {
    int pageIndex = 1;
    bool fetchMore = true;
    while (fetchMore == true) {
      List<TaxRate> tmpTaxRates =
          await _taxRateApiProvider.getTaxRates(page: pageIndex, perPage: 100);
      if (tmpTaxRates != null && tmpTaxRates.length > 0) {
        _taxRates.addAll(tmpTaxRates);
      }
      if (tmpTaxRates.length >= 100) {
        pageIndex += 1;
      } else {
        fetchMore = false;
      }
    }

    if (_taxRates == null || _taxRates.length == 0) {
      setState(() {
        _showFullLoader = false;
      });
      return;
    }

    if (CheckoutSession.getInstance.billingDetails.shippingAddress == null) {
      setState(() {
        _showFullLoader = false;
      });
      return;
    }
    String country =
        CheckoutSession.getInstance.billingDetails.shippingAddress.country;
    String state =
        CheckoutSession.getInstance.billingDetails.shippingAddress.state;
    String postalCode =
        CheckoutSession.getInstance.billingDetails.shippingAddress.postalCode;

    Map<String, dynamic> countryMap = appCountryOptions
        .firstWhere((c) => c['name'] == country, orElse: () => null);

    if (countryMap == null) {
      _showFullLoader = false;
      setState(() {});
      return;
    }

    TaxRate taxRate;

    Map<String, dynamic> stateMap;
    if (state != null) {
      stateMap = appStateOptions.firstWhere((c) => c['name'] == state,
          orElse: () => null);
    }

    if (stateMap != null) {
      taxRate = _taxRates.firstWhere(
          (t) =>
              t.country == countryMap["code"] &&
              t.state == stateMap["code"] &&
              t.postcode == postalCode,
          orElse: () => null);

      if (taxRate == null) {
        taxRate = _taxRates.firstWhere(
            (t) =>
                t.country == countryMap["code"] && t.state == stateMap["code"],
            orElse: () => null);
      }
    }

    if (taxRate == null) {
      taxRate = _taxRates.firstWhere(
          (t) => t.country == countryMap["code"] && t.postcode == postalCode,
          orElse: () => null);

      if (taxRate == null) {
        taxRate = _taxRates.firstWhere((t) => t.country == countryMap["code"],
            orElse: () => null);
      }
    }

    if (taxRate != null) {
      _taxRate = taxRate;
    }
    // setState(() {
    //   _showFullLoader = false;
    // });
  }

  _actionCheckoutDetails() {
    Navigator.pushNamed(context, "/checkout-details").then((e) {
      setState(() {
        _showFullLoader = true;
      });
      _getTaxes();
    });
  }

  _actionPayWith() {
    Navigator.pushNamed(context, "/checkout-payment-type")
        .then((value) => setState(() {}));
    print("check out payment type"); //chp
  }

  _actionSelectShipping() {
    CustomerAddress shippingAddress =
        CheckoutSession.getInstance.billingDetails.shippingAddress;
    if (shippingAddress == null || shippingAddress.country == "") {
      showEdgeAlertWith(context,
          title: "Oops",
          desc: "Add your shipping details first",
          icon: Icons.local_shipping);
      return;
    }
    Navigator.pushNamed(context, "/checkout-shipping-type").then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: storeLogo(height: 50),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: !_showFullLoader
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Checkout",
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: wBoxShadow(),
                      ),
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ((CheckoutSession.getInstance.billingDetails
                                      .billingAddress !=
                                  null)
                              ? wsCheckoutRow(context,
                                  heading: "Billing/shipping details",
                                  leadImage: Icon(Icons.home),
                                  leadTitle: (CheckoutSession.getInstance
                                          .billingDetails.billingAddress
                                          .hasMissingFields()
                                      ? "Billing address is incomplete"
                                      : CheckoutSession.getInstance
                                          .billingDetails.billingAddress
                                          .addressFull()),
                                  action: _actionCheckoutDetails,
                                  showBorderBottom: true)
                              : wsCheckoutRow(context,
                                  heading: "Billing/shipping details",
                                  leadImage: Icon(Icons.home),
                                  leadTitle: "Add billing & shipping details",
                                  action: _actionCheckoutDetails,
                                  showBorderBottom: true)),
                          (CheckoutSession.getInstance.paymentType != null
                              ? wsCheckoutRow(context,
                                  heading: "Payment method",
                                  leadImage: Image(
                                      image: AssetImage("assets/images/" +
                                          CheckoutSession.getInstance
                                              .paymentType.assetImage),
                                      width: 70),
                                  leadTitle: CheckoutSession
                                      .getInstance.paymentType.desc,
                                  action:
                                      _actionPayWith, // this is change part chp
                                  showBorderBottom: true)
                              : wsCheckoutRow(context,
                                  heading: "Pay with",
                                  leadImage: Icon(Icons.payment),
                                  leadTitle: "Select a payment method",
                                  action: _actionPayWith,
                                  showBorderBottom: true)),
                          (CheckoutSession.getInstance.shippingType != null
                              ? wsCheckoutRow(context,
                                  heading: "Shipping selected",
                                  leadImage: Icon(Icons.local_shipping),
                                  leadTitle: CheckoutSession
                                      .getInstance.shippingType
                                      .getTitle(),
                                  action: _actionSelectShipping)
                              : wsCheckoutRow(
                                  context,
                                  heading: "Select shipping",
                                  leadImage: Icon(Icons.local_shipping),
                                  leadTitle: "Select a shipping option",
                                  action: _actionSelectShipping,
                                )),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Divider(
                        color: Colors.black12,
                        thickness: 1,
                      ),
                      wsCheckoutSubtotalWidgetFB(title: "Subtotal"),
                      widgetCheckoutMeta(context,
                          title: "Shipping fee",
                          amount:
                              CheckoutSession.getInstance.shippingType == null
                                  ? "Select shipping"
                                  : CheckoutSession.getInstance.shippingType
                                      .getTotal(withFormatting: true)),
                      (_taxRate != null
                          ? wsCheckoutTaxAmountWidgetFB(taxRate: _taxRate)
                          : null),
                      wsCheckoutTotalWidgetFB(
                          title: "Total", taxRate: _taxRate),
                      Divider(
                        color: Colors.black12,
                        thickness: 1,
                      ),
                    ].where((e) => e != null).toList(),
                  ),
                  wsPrimaryButton(
                    context,
                    title: _isProcessingPayment ? "PROCESSING..." : "CHECKOUT",
                    action: _isProcessingPayment ? null : _handleCheckout,
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    showAppLoader(),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "One moment" + "...",
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  _handleCheckout() async {
    if (CheckoutSession.getInstance.billingDetails.billingAddress == null) {
      showEdgeAlertWith(
        context,
        title: "Oops",
        desc: "Please select add your billing/shipping address to proceed",
        style: EdgeAlertStyle.WARNING,
        duration: 2,
        icon: Icons.local_shipping,
      );
      return;
    }

    if (CheckoutSession.getInstance.billingDetails.billingAddress
        .hasMissingFields()) {
      showEdgeAlertWith(
        context,
        title: "Oops",
        desc: "Your billing/shipping details are incomplete",
        style: EdgeAlertStyle.WARNING,
        icon: Icons.local_shipping,
      );
      return;
    }

    if (CheckoutSession.getInstance.shippingType == null) {
      showEdgeAlertWith(
        context,
        title: "Oops",
        desc: "Please select a shipping method to proceed",
        style: EdgeAlertStyle.WARNING,
        icon: Icons.local_shipping,
      );
      return;
    }

    if (CheckoutSession.getInstance.paymentType == null) {
      showEdgeAlertWith(
        context,
        title: "Oops",
        desc: "Please select a payment method to proceed",
        style: EdgeAlertStyle.WARNING,
        icon: Icons.payment,
      );
      return;
    }

    if (_isProcessingPayment == true) {
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    CheckoutSession.getInstance.paymentType
        .pay(context, state: this, taxRate: _taxRate);

    Future.delayed(Duration(milliseconds: 5000), () {
      setState(() {
        _isProcessingPayment = false;
      });
    });
  }
}
