import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kfb/api_provider/categories_api_provider.dart';
import 'package:kfb/api_provider/products_api_provider.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/models/woo_models.dart' as W;
import 'package:kfb/widgets/cart_icon.dart';
import 'package:kfb/widgets/product_card_item.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();

  ProductsApiProvider productsApiProvider = ProductsApiProvider();

  CategoriesApiProvider categoriesApiProvider = CategoriesApiProvider();
  // Banner Slider Mapping Function
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  TabController _featuredTabsController;
  TabController _secondTabsController;
  TabController _thirdTabsController;

  @override
  void initState() {
    super.initState();

    _featuredTabsController = TabController(length: 2, vsync: this);
    _secondTabsController = TabController(length: 3, vsync: this);
    _thirdTabsController = TabController(length: 2, vsync: this);
  }

  // Banner Slider Images List
  int _current = 0;
  List imgList = [
    'assets/images/slide_1.jpg',
    'assets/images/slide_2.jpg',
    'assets/images/slide_3.jpg',
    'assets/images/slide_4.jpg',
    'assets/images/slide_5.jpg',
    'assets/images/slide_6.jpg',
  ];

  // Category ids Number
  int _grocery = 63;
  int _fruits = 64;
  int _household = 65;
  int _bakery = 66;
  int _snacks = 67;
  int _personal = 68;
  int _meat = 69;
  int _kitchen = 70;
  int _beverages = 71;
  int _pets = 72;
  int _mother = 73;
  int covid = 74;
  bool firstBuild = true;

  Widget _bannerCarousel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CarouselSlider(
          items: imgList.map((imgUrl) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    switch (_current) {
                      case 0:
                        Navigator.pushNamed(context, "/home");
                        break;
                      case 1:
                        Navigator.pushNamed(context, "/browse-category",
                            arguments: _pets);
                        break;
                      case 2:
                        Navigator.pushNamed(context, "/home");
                        break;
                      case 3:
                        Navigator.pushNamed(context, "/browse-category",
                            arguments: _personal);
                        break;
                      case 4:
                        Navigator.pushNamed(context, "/browse-category",
                            arguments: _mother);
                        break;
                      case 5:
                        // Navigator.pushNamed(context, "/browse-category",
                        //     arguments: 4]);
                        Navigator.pushNamed(context, "/home");
                        break;
                      default:
                        Navigator.pushNamed(context, "/home");
                        break;
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                    ),
                    child: Image.asset(
                      imgUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            aspectRatio: 2.1,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            initialPage: 0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(imgList, (index, url) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _current == index ? Color(0xff829112) : Color(0xfffa4a33),
              ),
            );
          }),
        )
      ],
    );
  }

  Widget _categoryListWithImage() {
    var size = MediaQuery.of(context).size;

    // _key.currentState.setState(() {});
    return Container(
      // height: 50,
      margin: EdgeInsets.only(
        top: 30,
        bottom: 30,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
            ),
            child: Text(
              "What would you like to order today".toUpperCase(),
              style: TextStyle(
                  color: Color(0xfffa4a33),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);

                        Navigator.pushNamed(context, "/browse-category",
                            arguments: _grocery);
                      },
                      child: Container(
                        height: 110,
                        width: size.width / 2 - 12,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: new AssetImage('assets/images/cat1.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/browse-category",
                            arguments: _fruits);
                      },
                      child: Container(
                        height: 110,
                        width: size.width / 2 - 12,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage('assets/images/cat2.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/browse-category",
                        arguments: _household);
                  },
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage('assets/images/cat3.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);

                        Navigator.pushNamed(context, "/browse-category",
                            arguments: _bakery);
                      },
                      child: Container(
                        height: 110,
                        width: size.width / 2 - 12,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: new AssetImage('assets/images/cat4.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/browse-category",
                            arguments: _snacks);
                      },
                      child: Container(
                        height: 110,
                        width: size.width / 2 - 12,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage('assets/images/cat5.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/browse-category",
                        arguments: _personal);
                  },
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage('assets/images/cat6.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);

                        Navigator.pushNamed(context, "/browse-category",
                            arguments: _meat);
                      },
                      child: Container(
                        height: 110,
                        width: size.width / 2 - 12,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: new AssetImage('assets/images/cat7.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/browse-category",
                            arguments: _kitchen);
                      },
                      child: Container(
                        height: 110,
                        width: size.width / 2 - 12,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage('assets/images/cat8.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/browse-category",
                        arguments: _beverages);
                  },
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage('assets/images/cat9.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);

                        Navigator.pushNamed(context, "/browse-category",
                            arguments: _pets);
                      },
                      child: Container(
                        height: 110,
                        width: size.width / 2 - 12,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: new AssetImage('assets/images/cat10.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/browse-category",
                            arguments: _mother);
                      },
                      child: Container(
                        height: 110,
                        width: size.width / 2 - 12,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage('assets/images/cat11.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _modalBottomSheetMenu() {
    // print("Num Of Categories ${_categories.length}");
    _key.currentState.setState(() {});
    wModalBottom(
      context,
      title: "Categories",
      bodyWidget: FutureBuilder(
        future: categoriesApiProvider.getCategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (cxt, i) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(parseHtmlString(snapshot.data[index]["name"])),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/browse-category",
                            arguments: snapshot.data[index]["id"])
                        .then((value) => setState(() {}));
                  },
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _noProductsInThisCategory() {
    return Container(
      child: Center(
        child: Text("Refilling soon"),
      ),
    );
  }

  Widget _featuredTabs() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: Container(
        color: Colors.transparent,
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Color(0xff323232),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: Color(0xFFFA4A33),
          ),
          controller: _featuredTabsController,
          tabs: [
            Tab(
              text: "Vegetables & Fruits",
            ),
            Tab(
              text: "Grocery & Staples",
            ),
          ],
        ),
      ),
    );
  }

  Widget _featuredTabsView() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: TabBarView(
        controller: _featuredTabsController,
        children: [
          _createCarousel(_fruits),
          _createCarousel(_grocery),
        ],
      ),
    );
  }

  Widget _createCarousel(int categoryId) {
    return FutureBuilder(
      future: productsApiProvider.fetchProductsByCategory(category: categoryId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return CarouselSlider.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) => Container(
              child: wProductCardItem(
                  snapshot.data[index], index, context, _showProduct),
            ),
            options: CarouselOptions(
              height: 416,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _showProduct(W.Product product) {
    Navigator.pushNamed(context, "/product-detail", arguments: product);
  }

  Widget _banner1() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/browse-category", arguments: _personal);
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/banner_1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _secondTabs() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: Container(
        color: Colors.transparent,
        child: TabBar(
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Color(0xff323232),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: Color(0xFFFA4A33),
          ),
          controller: _secondTabsController,
          tabs: [
            Tab(
              text: "Dairy & Bakery",
            ),
            Tab(
              text: "Pet Products",
            ),
            Tab(
              text: "Beverages",
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondTabsView() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: TabBarView(
        controller: _secondTabsController,
        children: [
          // _tabbedDairyProducts.isEmpty
          //     ? _noProductsInThisCategory()
          //     : _createCarousel(_tabbedDairyProducts),
          _createCarousel(_bakery),
          _createCarousel(_pets),
          _createCarousel(_beverages),
        ],
      ),
    );
  }

  Widget _thirdTabs() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: Container(
        color: Colors.transparent,
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Color(0xff323232),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: Color(0xFFFA4A33),
          ),
          controller: _thirdTabsController,
          tabs: [
            Tab(
              text: "Baby Care",
            ),
            Tab(
              text: "Personal Care",
            ),
          ],
        ),
      ),
    );
  }

  Widget _thirdTabsView() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: TabBarView(
        controller: _thirdTabsController,
        children: [
          _createCarousel(_mother),
          _createCarousel(_personal),
        ],
      ),
    );
  }

  Widget _banner2() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/browse-category", arguments: _fruits);
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/banner_2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _banner3() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/browse-category", arguments: _bakery);
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/banner_3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showPopUp2(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Image.asset('assets/images/popup_new.jpg'),
            contentPadding: EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (firstBuild) {
        firstBuild = false;
        _showPopUp2(context);
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Navigator.pushNamed(context, "/home-menu"),
            ),
            margin: EdgeInsets.only(left: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
          ),
          title: storeLogo(height: 50),
          centerTitle: true,
          actions: <Widget>[
            // IconButton(
            //   alignment: Alignment.centerLeft,
            //   icon: Icon(
            //     Icons.search,
            //     color: Colors.black,
            //     size: 35,
            //   ),
            //   onPressed: () => Navigator.pushNamed(context, "/home-search")
            //       .then((value) => _key.currentState.setState(() {})),
            // ),
            wCartIcon(context, key: _key),
          ],
        ),
        body: SafeArea(
          left: false,
          right: false,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Home",
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                      maxLines: 1,
                    ),
                    Flexible(
                      child: MaterialButton(
                        minWidth: 100,
                        height: 60,
                        child: AutoSizeText(
                          "Browse categories",
                          style: Theme.of(context).primaryTextTheme.bodyText1,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                        ),
                        onPressed: _modalBottomSheetMenu,
                      ),
                    ),
                  ],
                ),
              ),
              _bannerCarousel(),
              _categoryListWithImage(),
              _featuredTabs(),
              Container(
                height: 512,
                child: _featuredTabsView(),
              ),
              _banner1(),
              Padding(padding: EdgeInsets.only(top: 24)),
              _secondTabs(),
              Container(
                height: 512,
                child: _secondTabsView(),
              ),
              _banner2(),
              Padding(padding: EdgeInsets.only(top: 24)),
              _thirdTabs(),
              Container(
                height: 512,
                child: _thirdTabsView(),
              ),
              _banner3(),
              Padding(padding: EdgeInsets.only(top: 24)),
            ],
          ),
        ));
  }
}
