import 'package:kfb/config/woo_config.dart';
import 'package:kfb/models/shipping_method.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class ShippingMethodsApiProvider {
  WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
      url: WooConfig.siteUrl,
      consumerKey: WooConfig.consumerKey,
      consumerSecret: WooConfig.consumerSecret);

  List<WSShipping> parseShippingMethods(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();

    return parsed.map<WSShipping>((json) => WSShipping.fromJson(json)).toList();
  }

  Future<List<WSShipping>> getShippingMethods() async {
    final responseBody = await wooCommerceAPI.getAsync("shipping_methods/");
    print(responseBody.toString());
    return parseShippingMethods(responseBody);
  }
}
