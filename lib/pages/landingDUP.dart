import 'package:flutter/material.dart';
import 'package:kfb/api_provider/categories_api_provider.dart';
import 'package:kfb/api_provider/products_api_provider.dart';
import 'package:kfb/helpers/tools.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  ProductsApiProvider productsApiProvider = ProductsApiProvider();

  CategoriesApiProvider categoriesApiProvider = CategoriesApiProvider();
  // var _isInit = true;
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     Provider.of<ProductsProvider>(context).fetchAndSetProducts();
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Landing Page"),
      ),
      body: FutureBuilder(
        // future: productsApiProvider.getProducts(),
        future: categoriesApiProvider.getCategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // Create a list of products
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    parseHtmlString(snapshot.data[index]["name"]) +
                        " id: ${snapshot.data[index]["id"]}",
                  ),
                );
              },
            );
          }

          // Show a circular progress indicator while loading products
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
