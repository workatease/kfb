import 'package:flutter/foundation.dart';
import 'package:kfb/config/woocommerce.dart';
import 'package:kfb/models/woo_models.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await WooCommerce.api.getAsync("products?per_page=15");
      _items = response;
      // print(response);
    } catch (err) {
      throw (err);
    }
    notifyListeners();
  }
}
