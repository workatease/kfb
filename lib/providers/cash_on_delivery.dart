import 'package:flutter/material.dart';
import 'package:kfb/api_provider/orders_api_provider.dart';
import 'package:kfb/helpers/data/order_wc.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/models/checkout_session.dart';
import 'package:kfb/models/payload/order_wc.dart';
import 'package:kfb/models/response/order.dart';
import 'package:kfb/models/response/tax_rate.dart';
import 'package:kfb/pages/checkout_confirmation.dart';
import 'package:kfb/providers/cart_provider.dart';

cashOnDeliveryPay(context,
    {@required CheckoutConfirmationPageState state, TaxRate taxRate}) async {
  OrdersApiProvider ordersApiProvider;
  try {
    OrderWC orderWC = await buildOrderWC(taxRate: taxRate, markPaid: false);

    Order order = await ordersApiProvider.createOrder(orderWC);

    if (order != null) {
      CartProvider.getInstance.clear();
      CheckoutSession.getInstance.clear();
      Navigator.pushNamed(context, "/checkout-status", arguments: order);
    } else {
      showEdgeAlertWith(
        context,
        title: "Error",
        desc: "Something went wrong, please contact our store",
      );
      state.reloadState(showLoader: false);
    }
  } catch (ex) {
    showEdgeAlertWith(
      context,
      title: "Error",
      desc: "Something went wrong, please contact our store",
    );
    state.reloadState(showLoader: false);
  }
}
