import 'package:kfb/config/woo_config.dart';
import 'package:kfb/models/response/tax_rate.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class TaxRateApiProvider {
  WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
      url: WooConfig.siteUrl,
      consumerKey: WooConfig.consumerKey,
      consumerSecret: WooConfig.consumerSecret);

  List<TaxRate> parseTaxRates(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();

    return parsed.map<TaxRate>((json) => TaxRate.fromJson(json)).toList();
  }

  Future<List<TaxRate>> getTaxRates({int page, int perPage}) async {
    final responseBody = await wooCommerceAPI.getAsync(
        "taxes?page=" + page.toString() + "&per_page=" + perPage.toString());
    return parseTaxRates(responseBody);
  }
}
