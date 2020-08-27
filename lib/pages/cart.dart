import 'package:flutter/material.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/models/checkout_session.dart';
import 'package:kfb/models/customer_address.dart';
import 'package:kfb/shared_pref.dart/sp_auth.dart';
import 'package:kfb/widgets/app_loader.dart';
import 'package:kfb/widgets/buttons.dart';
import '../providers/cart_provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isLoading = false;
  bool _isCartEmpty = false;
  List<CartItem> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = [];
    _isLoading = true;
    _cartCheck();
  }

  _cartCheck() async {
    List<CartItem> cartItems = await CartProvider.getInstance.getCart();

    if (cartItems.length <= 0) {
      setState(() {
        _isLoading = false;
        _isCartEmpty = (cartItems.length <= 0) ? true : false;
      });
      return [];
    }

    _cartItems = cartItems;
    setState(() {
      _isLoading = false;
    });
  }

  void _clearCart() {
    CartProvider.getInstance.clear();
    _cartItems = [];
    showEdgeAlertWith(context,
        title: "Success",
        desc: "Cart cleared",
        style: EdgeAlertStyle.SUCCESS,
        icon: Icons.delete_outline);
    _isCartEmpty = true;
    setState(() {});
  }

  actionIncrementQuantity({CartItem cartItem}) {
    if (cartItem.isManagedStock &&
        cartItem.quantity + 1 > cartItem.stockQuantity) {
      showEdgeAlertWith(
        context,
        title: "Cart",
        desc: "Maximum stock reached",
        style: EdgeAlertStyle.WARNING,
        icon: Icons.shopping_cart,
      );
      return;
    }
    CartProvider.getInstance
        .updateQuantity(cartItem: cartItem, incrementQuantity: 1);
    cartItem.quantity += 1;
    setState(() {});
  }

  actionDecrementQuantity({CartItem cartItem}) {
    if (cartItem.quantity - 1 <= 0) {
      return;
    }
    CartProvider.getInstance
        .updateQuantity(cartItem: cartItem, incrementQuantity: -1);
    cartItem.quantity -= 1;
    setState(() {});
  }

  actionRemoveItem({int index}) {
    CartProvider.getInstance.removeCartItemForIndex(index: index);
    _cartItems.removeAt(index);
    showEdgeAlertWith(
      context,
      title: "Updated",
      desc: "Item removed",
      style: EdgeAlertStyle.WARNING,
      icon: Icons.remove_shopping_cart,
    );
    if (_cartItems.length == 0) {
      _isCartEmpty = true;
    }
    setState(() {});
  }

  // void _actionProceedToCheckout() async {
  //   List<CartLineItem> cartLineItems = await Cart.getInstance.getCart();
  //   if (_isLoading == true) {
  //     return;
  //   }
  //   if (cartLineItems.length <= 0) {
  //     showEdgeAlertWith(context,
  //         title: trans(context, "Cart"),
  //         desc: trans(context,
  //             trans(context, "You need items in your cart to checkout")),
  //         style: EdgeAlertStyle.WARNING,
  //         icon: Icons.shopping_cart);
  //     return;
  //   }
  //   if (!cartLineItems.every(
  //       (c) => c.stockStatus == 'instock' || c.stockStatus == 'onbackorder')) {
  //     showEdgeAlertWith(context,
  //         title: trans(context, "Cart"),
  //         desc: trans(context, trans(context, "There is an item out of stock")),
  //         style: EdgeAlertStyle.WARNING,
  //         icon: Icons.shopping_cart);
  //     return;
  //   }
  //   CheckoutSession.getInstance.initSession();
  //   CustomerAddress sfCustomerAddress =
  //       await CheckoutSession.getInstance.getBillingAddress();
  //   if (sfCustomerAddress != null) {
  //     CheckoutSession.getInstance.billingDetails.billingAddress =
  //         sfCustomerAddress;
  //     CheckoutSession.getInstance.billingDetails.shippingAddress =
  //         sfCustomerAddress;
  //   }
  //   if (use_wp_login == true && !(await authCheck())) {
  //     UserAuth.instance.redirect = "/checkout";
  //     Navigator.pushNamed(context, "/account-landing");
  //     return;
  //   }
  //   Navigator.pushNamed(context, "/checkout");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      // resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: Text(
          "Shopping Cart",
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        textTheme: Theme.of(context).textTheme,
        elevation: 1,
        actions: <Widget>[
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Align(
              child: Padding(
                child: Text("Clear Cart",
                    style: Theme.of(context).primaryTextTheme.bodyText1),
                padding: EdgeInsets.only(right: 8),
              ),
              alignment: Alignment.centerLeft,
            ),
            onTap: _clearCart,
          )
        ],
        centerTitle: true,
      ),

      body: SafeArea(
        minimum: safeAreaDefault(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _isCartEmpty
                ? Expanded(
                    child: FractionallySizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            Icons.shopping_cart,
                            size: 100,
                            color: Colors.black45,
                          ),
                          Padding(
                            child: Text("Empty Basket",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText2),
                            padding: EdgeInsets.only(top: 10),
                          )
                        ],
                      ),
                      heightFactor: 0.5,
                      widthFactor: 1,
                    ),
                  )
                : (_isLoading
                    ? Expanded(
                        child: showAppLoader(),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _cartItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            CartItem cartItem = _cartItems[index];

                            return wCardCartItem(
                              context,
                              cartItem: cartItem,
                              actionIncrementQuantity: () =>
                                  actionIncrementQuantity(cartItem: cartItem),
                              actionDecrementQuantity: () =>
                                  actionDecrementQuantity(cartItem: cartItem),
                              actionRemoveItem: () =>
                                  actionRemoveItem(index: index),
                            );
                          },
                        ),
                        flex: 3,
                      )),
            Divider(
              color: Colors.black45,
            ),
            FutureBuilder<String>(
              future: CartProvider.getInstance.getTotal(withFormat: true),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text("");
                  default:
                    if (snapshot.hasError)
                      return Text("");
                    else
                      return new Padding(
                        child: wRow2Text(context,
                            text1: "Total",
                            text2: (_isLoading ? "" : snapshot.data)),
                        padding: EdgeInsets.only(bottom: 15, top: 15),
                      );
                }
              },
            ),
            wsPrimaryButton(
              context,
              title: "PROCEED TO CHECKOUT",
              action: _actionProceedToCheckout,
            ),
          ],
        ),
      ),
    );
  }

  void _actionProceedToCheckout() async {
    List<CartItem> cartLineItems = await CartProvider.getInstance.getCart();
    
    if (_isLoading == true) {
      return;
    }
    if (cartLineItems.length <= 0) {
      showEdgeAlertWith(context,
          title: "Cart",
          desc: "You need items in your cart to checkout",
          style: EdgeAlertStyle.WARNING,
          icon: Icons.shopping_cart);
      return;
    }
    if (cartLineItems.every((c) => c.inStock??false)) {
      showEdgeAlertWith(context,
          title: "Cart",
          desc: "There is an item out of stock",
          style: EdgeAlertStyle.WARNING,
          icon: Icons.shopping_cart);
      return;
    }
    CheckoutSession.getInstance.initSession();
    CustomerAddress sfCustomerAddress =
        await CheckoutSession.getInstance.getBillingAddress();
    if (sfCustomerAddress != null) {
      CheckoutSession.getInstance.billingDetails.billingAddress =
          sfCustomerAddress;
      CheckoutSession.getInstance.billingDetails.shippingAddress =
          sfCustomerAddress;
    }
    if (!(await authCheck())) {
      UserAuth.instance.redirect = "/checkout";
      Navigator.pushNamed(context, "/account-landing");
      return;
    }
    Navigator.pushNamed(context, "/checkout");
  }
}
