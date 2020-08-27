import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kfb/helpers/shared_pref.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/models/checkout_session.dart';
import 'package:kfb/models/response/tax_rate.dart';
import 'package:kfb/models/shipping_method.dart';
import 'package:kfb/models/shipping_type.dart';

class CartItem {
  String name;
  int productId;
  int variationId;
  int quantity;
  bool isManagedStock;
  int stockQuantity;
  String shippingClassId;
  String taxStatus;
  String taxClass;
  bool shippingIsTaxable;
  String subtotal;
  String total;
  String imageSrc;
  String variationOptions;
  bool inStock;
  Object metaData = {};

  CartItem(
      {this.name,
      this.productId,
      this.variationId,
      this.isManagedStock,
      this.stockQuantity,
      this.quantity,
      this.inStock,
      this.shippingClassId,
      this.taxStatus,
      this.taxClass,
      this.shippingIsTaxable,
      this.variationOptions,
      this.imageSrc,
      this.subtotal,
      this.total,
      this.metaData});

  String getCartTotal() {
    return (quantity * parseWcPrice(subtotal)).toString();
  }

  CartItem.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        productId = json['product_id'],
        variationId = json['variation_id'],
        quantity = json['quantity'],
        shippingClassId = json['shipping_class_id'].toString(),
        taxStatus = json['tax_status'],
        stockQuantity = json['stock_quantity'],
        isManagedStock = (json['is_managed_stock'] != null &&
                json['is_managed_stock'] is bool)
            ? json['is_managed_stock']
            : false,
        shippingIsTaxable = json['shipping_is_taxable'],
        subtotal = json['subtotal'],
        total = json['total'],
        taxClass = json['tax_class'],
        inStock = json['in_stock'],
        imageSrc = json['image_src'],
        variationOptions = json['variation_options'],
        metaData = json['metaData'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'product_id': productId,
        'variation_id': variationId,
        'quantity': quantity,
        'shipping_class_id': shippingClassId,
        'tax_status': taxStatus,
        'tax_class': taxClass,
        'in_stock': inStock,
        'is_managed_stock': isManagedStock,
        'stock_quantity': stockQuantity,
        'shipping_is_taxable': shippingIsTaxable,
        'image_src': imageSrc,
        'variation_options': variationOptions,
        'subtotal': subtotal,
        'total': total,
        'meta_data': metaData,
      };
}

class CartProvider with ChangeNotifier {
  Map<int, CartItem> _items;
  String _keyCart = "CART_SESSION";
  // Previous Code
  CartProvider._privateConstructor();
  static final CartProvider getInstance = CartProvider._privateConstructor();
  // Previous Code END

  Map<int, CartItem> get items {
    return {..._items};
  }

  void addItems(int productId, String name, int quantity) {
    if (_items.containsKey(productId)) {
      // Change the quantity
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          productId: existingCartItem.productId,
          name: existingCartItem.name,
          quantity: existingCartItem.quantity += quantity,
        ),
      );
    } else {
      _items.putIfAbsent(productId,
          () => CartItem(productId: productId, name: name, quantity: quantity));
    }
  }

  // Previous Code
  void addToCart({CartItem cartItem}) async {
    List<CartItem> cartItems = await getCart();

    if (cartItem.variationId != null) {
      if (cartItems.firstWhere(
              (i) => (i.productId == cartItem.productId &&
                  i.variationId == cartItem.variationId),
              orElse: () => null) !=
          null) {
        return;
      }
    } else {
      var firstCartItem = cartItems.firstWhere(
          (i) => i.productId == cartItem.productId,
          orElse: () => null);
      if (firstCartItem != null) {
        return;
      }
    }
    cartItems.add(cartItem);
    saveCartToPref(cartItems: cartItems);
  }

  Future<List<CartItem>> getCart() async {
    List<CartItem> cartItems = [];
    SharedPref sharedPref = SharedPref();
    String currentCartArrJSON = (await sharedPref.read(_keyCart) as String);
    if (currentCartArrJSON == null) {
      cartItems = List<CartItem>();
    } else {
      cartItems = (jsonDecode(currentCartArrJSON) as List<dynamic>)
          .map((i) => CartItem.fromJson(i))
          .toList();
    }
    return cartItems;
  }

  Future<String> getTotal({bool withFormat}) async {
    List<CartItem> cartItems = await getCart();
    double total = 0;
    cartItems.forEach((cartItem) {
      total += (parseWcPrice(cartItem.total) * cartItem.quantity);
    });

    if (withFormat != null && withFormat == true) {
      return formatDoubleCurrency(total: total);
    }
    return total.toStringAsFixed(2);
  }

  Future<String> getSubtotal({bool withFormat}) async {
    List<CartItem> cartItems = await getCart();
    double subtotal = 0;
    cartItems.forEach((cartItem) {
      subtotal += (parseWcPrice(cartItem.subtotal) * cartItem.quantity);
    });
    if (withFormat != null && withFormat == true) {
      return formatDoubleCurrency(total: subtotal);
    }
    return subtotal.toStringAsFixed(2);
  }

  void updateQuantity({CartItem cartItem, int incrementQuantity}) async {
    List<CartItem> cartItems = await getCart();
    List<CartItem> tmpCartItem = new List<CartItem>();
    cartItems.forEach((cartItem) {
      if (cartItem.variationId == cartItem.variationId &&
          cartItem.productId == cartItem.productId) {
        if ((cartItem.quantity + incrementQuantity) > 0) {
          cartItem.quantity += incrementQuantity;
        }
      }
      tmpCartItem.add(cartItem);
    });
    saveCartToPref(cartItems: tmpCartItem);
  }

  Future<String> cartShortDesc() async {
    List<CartItem> cartItems = await getCart();
    var tmpShortItemDesc = [];
    cartItems.forEach((cartItem) {
      tmpShortItemDesc
          .add(cartItem.quantity.toString() + " x | " + cartItem.name);
    });
    return tmpShortItemDesc.join(",");
  }

  void removeCartItemForIndex({int index}) async {
    List<CartItem> cartItems = await getCart();
    cartItems.removeAt(index);
    saveCartToPref(cartItems: cartItems);
  }

  void clear() {
    SharedPref sharedPref = SharedPref();
    List<CartItem> cartItems = new List<CartItem>();
    String jsonArrCartItems =
        jsonEncode(cartItems.map((i) => i.toJson()).toList());
    sharedPref.save(_keyCart, jsonArrCartItems);
  }

  void saveCartToPref({List<CartItem> cartItems}) {
    SharedPref sharedPref = SharedPref();
    String jsonArrCartItems =
        jsonEncode(cartItems.map((i) => i.toJson()).toList());
    sharedPref.save(_keyCart, jsonArrCartItems);
  }
  // Previous Code END

  Future<String> taxAmount(TaxRate taxRate) async {
    double subtotal = 0;
    double shippingTotal = 0;

    List<CartItem> cartItems = await CartProvider.getInstance.getCart();

    if (cartItems.every((c) => c.taxStatus == 'none')) {
      return "0";
    }
    List<CartItem> taxableCartLines =
        cartItems.where((c) => c.taxStatus == 'taxable').toList();
    double cartSubtotal = 0;

    if (taxableCartLines.length > 0) {
      cartSubtotal = taxableCartLines
          .map<double>((m) => parseWcPrice(m.subtotal))
          .reduce((a, b) => a + b);
    }

    subtotal = cartSubtotal;

    ShippingType shippingType = CheckoutSession.getInstance.shippingType;

    if (shippingType != null) {
      switch (shippingType.methodId) {
        case "flat_rate":
          FlatRate flatRate = (shippingType.object as FlatRate);
          if (flatRate.taxable != null && flatRate.taxable) {
            shippingTotal += parseWcPrice(
                shippingType.cost == null || shippingType.cost == ""
                    ? "0"
                    : shippingType.cost);
          }
          break;
        case "distance_rate":
          DistanceRate distanceRate = (shippingType.object as DistanceRate);
          if (distanceRate.taxable != null && distanceRate.taxable) {
            shippingTotal += parseWcPrice(
                shippingType.cost == null || shippingType.cost == ""
                    ? "0"
                    : shippingType.cost);
          }
          break;
        case "local_pickup":
          LocalPickup localPickup = (shippingType.object as LocalPickup);
          if (localPickup.taxable != null && localPickup.taxable) {
            shippingTotal += parseWcPrice(
                (localPickup.cost == null || localPickup.cost == ""
                    ? "0"
                    : localPickup.cost));
          }
          break;
        default:
          break;
      }
    }

    double total = 0;
    if (subtotal != 0) {
      total += ((parseWcPrice(taxRate.rate) * subtotal) / 100);
    }
    if (shippingTotal != 0) {
      total += ((parseWcPrice(taxRate.rate) * shippingTotal) / 100);
    }
    return (total).toStringAsFixed(2);
  }
}
