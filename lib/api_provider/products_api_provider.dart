import 'dart:convert';

import 'package:kfb/config/woo_config.dart';
import 'package:kfb/models/woo_models.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class ProductsApiProvider {
  WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
      url: WooConfig.siteUrl,
      consumerKey: WooConfig.consumerKey,
      consumerSecret: WooConfig.consumerSecret);

  // List<Product> parseProducts(String responseBody) {
  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  //   return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  // }
  List<Product> parseProducts(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();

    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> fetchAndSetProducts(
      {int perPage = 20, int page = 1}) async {
    final response = await wooCommerceAPI.getAsync(
        "products?per_page=" + perPage.toString() + "&page=" + page.toString());
    return parseProducts(response.body);
  }

  Future getProducts({int perPage = 20, int page = 1}) async {
    // Get data using the "products" endpoint
    var products = await wooCommerceAPI.getAsync(
        "products?per_page=" + perPage.toString() + "&page=" + page.toString());
    return products;
  }

  Future getProductsByCategory({int perPage = 20, int category}) async {
    var products = await wooCommerceAPI.getAsync("products?per_page=" +
        perPage.toString() +
        "&category=" +
        category.toString());
    return products;
  }

  Future<List<Product>> fetchProductsByCategory(
      {int perPage = 20, int category}) async {
    var responseBody = await wooCommerceAPI.getAsync("products?per_page=" +
        perPage.toString() +
        "&category=" +
        category.toString() +
        "&stock_status=instock");
    // print(response);
    // final parsed = response.cast<Map<String, dynamic>>();
    // return parsed.map<Product>((json) => Product.fromJson(json)).toList();
    return parseProducts(responseBody);
    // return parseProducts((response.toString()));
  }

  Future getProductById({int id}) async {
    var product = await wooCommerceAPI.getAsync("products/" + id.toString());
    return product;
  }

  Future<Product> getProductById2({int id}) async {
    final response = await wooCommerceAPI.getAsync("products/" + id.toString());

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Product.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load product');
    }
  }
}
