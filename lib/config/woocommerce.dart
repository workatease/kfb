import 'package:kfb/config/woo_config.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class WooCommerce {
  static final WooCommerceAPI api = WooCommerceAPI(
    url: WooConfig.siteUrl,
    consumerKey: WooConfig.consumerKey,
    consumerSecret: WooConfig.consumerSecret,
  );
}
