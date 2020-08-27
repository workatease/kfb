import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kfb/api_provider/categories_api_provider.dart';
import 'package:kfb/api_provider/products_api_provider.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/models/woo_models.dart';
import 'package:kfb/widgets/buttons.dart';
import 'package:kfb/helpers/ui.dart';

class BrowseCategoryPage extends StatefulWidget {
  final int categoryId;
  const BrowseCategoryPage({Key key, @required this.categoryId})
      : super(key: key);

  @override
  _BrowseCategoryPageState createState() =>
      _BrowseCategoryPageState(categoryId);
}

class _BrowseCategoryPageState extends State<BrowseCategoryPage> {
  int categoryId;

  _BrowseCategoryPageState(this.categoryId);

  bool _isLoading;
  bool _isProductLoading;
  bool _isSubcategoryLoading;
  int _page;
  bool _shouldStopRequests;
  bool waitForNextRequest;

  CategoriesApiProvider categoriesApiProvider = CategoriesApiProvider();
  ProductsApiProvider productsApiProvider = ProductsApiProvider();

  final List<int> _hasSubcategories = [63, 64, 65, 66, 67, 68, 69, 71, 72, 73];

  @override
  void initState() {
    super.initState();

    _isLoading = true;
    _isProductLoading = true;
    _isSubcategoryLoading = true;

    _page = 1;
    _shouldStopRequests = false;
    waitForNextRequest = false;
    // _fetchMoreProducts(categoryId);

    // _fetchSubcategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildChild() {
    if (_hasSubcategories.contains(categoryId)) {
      return FutureBuilder(
        future: categoriesApiProvider.getSubcategories(parent: categoryId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: EdgeInsets.only(top: 16),
              child: GridView.count(
                crossAxisCount: 2,
                // childAspectRatio: calAspectRatio(context),
                shrinkWrap: true,
                children: List.generate(
                  snapshot.data.length,
                  (index) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/browse-category",
                          arguments: snapshot.data[index]["id"]);
                    },
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data[index]["image"]["src"],
                      imageBuilder: (context, imageProvider) => Container(
                        height: 200,
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.6),
                                BlendMode.multiply),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            parseHtmlString(snapshot.data[index]["name"]),
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              // fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                        height: 10,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }
    return FutureBuilder(
      future: productsApiProvider.fetchProductsByCategory(
          category: categoryId, perPage: 50),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.only(top: 4),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: calAspectRatio(context),
                shrinkWrap: true,
                children: List.generate(
                  snapshot.data.length,
                  (index) => wCardProductItem(
                      snapshot.data[index], index, context, _showProduct),
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return wNoResults(context);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _showProduct(Product product) {
    Navigator.pushNamed(context, "/product-detail", arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Browse", style: Theme.of(context).primaryTextTheme.subtitle1),
            FutureBuilder(
                future: categoriesApiProvider.getCategoryById(id: categoryId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text(parseHtmlString(snapshot.data["name"]),
                        style: Theme.of(context).primaryTextTheme.headline6);
                  }
                  return Text('');
                  // return Center(
                  //   child: CircularProgressIndicator(),
                  // );
                })
          ],
        ),
      ),
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: _buildChild(),
      ),
    );
  }
}
