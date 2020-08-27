import 'dart:convert';

import 'package:kfb/config/woo_config.dart';
import 'package:kfb/models/payload/order_wc.dart';
import 'package:kfb/models/response/order.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class OrdersApiProvider {
  WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
    url: WooConfig.siteUrl,
    consumerKey: WooConfig.consumerKey,
    consumerSecret: WooConfig.consumerSecret,
  );

  List<Order> parseOrders(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();

    return parsed.map<Order>((json) => Order.fromJson(json)).toList();
  }

  Future<List<Order>> getOrders({int page, int perPage, int customer}) async {
    final responseBody = await wooCommerceAPI.getAsync("orders?page=" +
        page.toString() +
        "&per_page=" +
        perPage.toString() +
        "&customer=" +
        customer.toString());

    return parseOrders(responseBody);
  }

  Future<Order> getOrderById(int orderId) async {
    final responseBody =
        await wooCommerceAPI.getAsync("orders/" + orderId.toString());

    if (responseBody.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Order.fromJson(json.decode(responseBody));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load product');
    }
  }

  Future<Order> createOrder(OrderWC orderWC) async {
    Map<String, dynamic> payload = orderWC.toJson();

    final response = await wooCommerceAPI.postAsync("orders", payload);
    if (response.body.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Order.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to create order');
    }
  }
}
