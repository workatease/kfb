import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kfb/config/woo_config.dart';
import 'package:kfb/models/response/customer.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class CustomersApiProvider {
  WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
    url: WooConfig.siteUrl,
    consumerKey: WooConfig.consumerKey,
    consumerSecret: WooConfig.consumerSecret,
  );

  List<Customer> parseCustomers(dynamic responseBody) {
    // final parsed = responseBody.cast<Map<String, dynamic>>();
    //  var json= jsonEncode(responseBody);
    // var json=jsonDecode(responseBody);
    print(responseBody is List);
    var data = responseBody as List;
    List<Customer> custmers = [];
    data.forEach((element) {
      custmers.add(Customer.fromJson(element));
    });
    return custmers;
// data.map((e) => null);
    // return data.map<Customer>((json) => Customer.fromJson(json)).toList();
  }

  Future<Customer> getCustomerById(int customerId) async {
    final responseBody =
        await wooCommerceAPI.getAsync("customers/" + customerId.toString());

    if (responseBody.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Customer.fromJson(json.decode(responseBody));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load customer');
    }
  }

  Future<List<Customer>> fetchCustomers({int perPage = 100}) async {
     final responseBody =
        await wooCommerceAPI.getAsync("customers/?per_page=$perPage");
    return parseCustomers(responseBody);
  }

  Future<Customer> getCustomerByPhone({int phone}) async {
    Customer customer;
    try {
      List<Customer> customers = await fetchCustomers();
      for (var i = 0; i < customers.length; i++) {
        if (customers[i].billing.phone == phone.toString()) {
          customer = customers[i];
          break;
        }
      }
    } catch (e) {}
    return customer;
  }

  Future updateCustomerPhone(int customerId, int phone) async {
    String path = WooConfig.siteUrl +
        "/wp-json/wc/v3/customers/" +
        customerId.toString() +
        "?consumer_key=" +
        WooConfig.consumerKey +
        "&consumer_secret=" +
        WooConfig.consumerSecret;
    var data = {
      "billing": {"phone": phone.toString()}
    };
    var response = await Dio().put(path, data: data);
    return response;
  }

  Future updateCustomerDetails(
      int customerId, String firstName, String lastName, int phone) async {
    String path = WooConfig.siteUrl +
        "/wp-json/wc/v3/customers/" +
        customerId.toString() +
        "?consumer_key=" +
        WooConfig.consumerKey +
        "&consumer_secret=" +
        WooConfig.consumerSecret;
    var data = {
      "billing": {
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone.toString(),
      }
    };
    var response = await Dio().put(path, data: data);
    return response;
  }
}
