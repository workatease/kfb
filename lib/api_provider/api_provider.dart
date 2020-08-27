import 'package:kfb/config/woo_config.dart';
import 'package:kfb/models/response/product_variation.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class ApiProvider {
  WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
      url: WooConfig.siteUrl,
      consumerKey: WooConfig.consumerKey,
      consumerSecret: WooConfig.consumerSecret);

  Future<List<ProductVariation>> getProductVariations(int productId,
      {int page,
      int perPage,
      String search,
      String after,
      String before,
      List<int> exclude,
      List<int> include,
      int offset,
      String order,
      String orderBy,
      List<int> parent,
      List<int> parentExclude,
      String slug,
      String status,
      String sku,
      String taxClass,
      bool onSale,
      String minPrice,
      String maxPrice,
      String stockStatus}) async {
    Map<String, dynamic> payload = {};
    if (page != null) payload["page"] = page;
    if (perPage != null) payload["per_page"] = perPage;
    if (search != null) payload["search"] = search;
    if (after != null) payload["after"] = after;
    if (before != null) payload["before"] = before;
    if (exclude != null) payload["exclude"] = exclude;
    if (include != null) payload["include"] = include;
    if (offset != null) payload["offset"] = offset;
    if (order != null) payload["order"] = order;
    if (orderBy != null) payload["orderby"] = orderBy;
    if (parent != null) payload["parent"] = parent;
    if (parentExclude != null) payload["parent_exclude"] = parentExclude;
    if (slug != null) payload["slug"] = slug;
    if (status != null) payload["status"] = status;
    if (sku != null) payload["sku"] = sku;
    if (taxClass != null) payload["tax_class"] = taxClass;
    if (onSale != null) payload["on_sale"] = onSale;
    if (minPrice != null) payload["min_price"] = minPrice;
    if (maxPrice != null) payload["max_price"] = maxPrice;
    if (stockStatus != null) payload["stock_status"] = stockStatus;

    // _printLog(payload.toString());
    // payload = _standardPayload(
    //     "get", payload, "products/" + productId.toString() + "/variations");

    List<ProductVariation> productVariations = [];
    // await _apiProvider.post("/request", payload).then((json) {
    //   productVariations =
    //       (json as List).map((i) => ProductVariation.fromJson(i)).toList();
    // });
    await wooCommerceAPI
        .getAsync("products/" +
            productId.toString() +
            "/variations?" +
            payload.toString())
        .then((json) {
      productVariations =
          (json as List).map((i) => ProductVariation.fromJson(i)).toList();
    });
    _printLog(productVariations.toString());
    return productVariations;
  }

  List<ProductVariation> parseVariations(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();

    return parsed
        .map<ProductVariation>((json) => ProductVariation.fromJson(json))
        .toList();
  }

  Future<List<ProductVariation>> fetchProductVariations(int productId,
      {int perPage, int page}) async {
    final responseBody = await wooCommerceAPI.getAsync("products/" +
        productId.toString() +
        "/variations?per_page=" +
        perPage.toString() +
        "&page=" +
        page.toString());
    return parseVariations(responseBody);
  }
}

void _printLog(String message) {
  print("App LOG: " + message);
}
