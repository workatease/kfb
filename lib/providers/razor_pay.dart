import 'package:flutter/material.dart';
import 'package:kfb/api_provider/orders_api_provider.dart';
import 'package:kfb/config/woo_config.dart';
import 'package:kfb/helpers/data/order_wc.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/models/checkout_session.dart';
import 'package:kfb/models/payload/order_wc.dart';
import 'package:kfb/models/response/order.dart';
import 'package:kfb/models/response/tax_rate.dart';
import 'package:kfb/pages/checkout_confirmation.dart';
import 'package:kfb/providers/cart_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

razorPay(context,
    {@required CheckoutConfirmationPageState state, TaxRate taxRate}) async {
  OrdersApiProvider ordersApiProvider = OrdersApiProvider();
  Razorpay _razorpay = Razorpay();

  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
      (PaymentSuccessResponse response) async {
    OrderWC orderWC = await buildOrderWC(taxRate: taxRate);

    Order order = await ordersApiProvider.createOrder(orderWC);

    if (order != null) {
      CartProvider.getInstance.clear();
      CheckoutSession.getInstance.clear();
      _razorpay.clear();
      Navigator.pushNamed(context, "/checkout-status", arguments: order);
    } else {
      showEdgeAlertWith(context,
          title: "Error",
          desc: "Something went wrong, please contact our store",
          style: EdgeAlertStyle.WARNING);
      _razorpay.clear();
      state.reloadState(showLoader: false);
    }
  });

  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
    showEdgeAlertWith(context,
        title: "Error", desc: response.message, style: EdgeAlertStyle.WARNING);
    _razorpay.clear();
    state.reloadState(showLoader: false);
  });

  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
      (ExternalWalletResponse response) {
    showEdgeAlertWith(context,
        title: "Error",
        desc: "Not supported, try a card payment",
        style: EdgeAlertStyle.WARNING);
    _razorpay.clear();
    state.reloadState(showLoader: false);
  });

  // CHECKOUT HELPER
  await checkout(taxRate, (total, billingDetails, cart) async {
    var options = {
      'key': app_razor_id,
      'amount': (parseWcPrice(total) * 100).toInt(),
      'name': app_name,
      'description': await cart.cartShortDesc(),
      'prefill': {
        "name": [
          billingDetails.billingAddress.firstName,
          billingDetails.billingAddress.lastName
        ].where((t) => t != null || t != "").toList().join(" "),
        "method": "card",
        'email': billingDetails.billingAddress.emailAddress
      }
    };

    state.reloadState(showLoader: true);

    _razorpay.open(options);
  });
}
