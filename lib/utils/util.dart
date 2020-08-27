import 'package:kfb/config/woo_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce_api/woocommerce_api.dart';
import 'package:wp_json_api/wp_json_api.dart';

class Util {
   SharedPreferences sharedPreferences;
  WooCommerceAPI wooCommerceAPI;
  WPJsonAPI wpJsonAPI;
  Util _util;
  Util(){
    
  }
  static Future<Util> get instance async {
    return await Util()._getInstance();
  }

  Future<Util> _getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
    wooCommerceAPI = WooCommerceAPI(
      url: WooConfig.siteUrl,
      consumerKey: WooConfig.consumerKey,
      consumerSecret: WooConfig.consumerSecret,
    );
    wpJsonAPI=WPJsonAPI.instance;
    return _util;
  }
 
}
