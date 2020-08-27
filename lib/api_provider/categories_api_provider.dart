import 'package:kfb/config/woo_config.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class CategoriesApiProvider {
  WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
      url: WooConfig.siteUrl,
      consumerKey: WooConfig.consumerKey,
      consumerSecret: WooConfig.consumerSecret);
  Future getCategories({int perPage = 20}) async {
    // Get data using the "products" endpoint
    var categories = await wooCommerceAPI.getAsync(
        "products/categories?per_page=" +
            perPage.toString() +
            "&parent=0&orderby=id");
    return categories;
  }

  Future getCategoryById({int id}) async {
    var category =
        await wooCommerceAPI.getAsync("products/categories/" + id.toString());
    print(category);
    return category;
  }

  Future getSubcategories({int perPage = 20, int parent}) async {
    var subcategories = await wooCommerceAPI.getAsync(
        "products/categories?per_page=" +
            perPage.toString() +
            "&parent=" +
            parent.toString() +
            "&orderby=id");
    return subcategories;
  }
}
