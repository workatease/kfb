import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kfb/config/app_themes.dart';
import 'package:kfb/config/woo_config.dart';
import 'package:kfb/models/billing_details.dart';
import 'package:kfb/models/response/order.dart';
import 'package:kfb/models/woo_models.dart';
import 'package:kfb/pages/about.dart';
import 'package:kfb/pages/add_edit_billing_address.dart';
import 'package:kfb/pages/add_edit_shipping_address.dart';
import 'package:kfb/pages/billing_details.dart';
import 'package:kfb/pages/account_detail.dart';
import 'package:kfb/pages/account_landing.dart';
import 'package:kfb/pages/account_register.dart';
import 'package:kfb/pages/checkout_payment_type.dart';
import 'package:kfb/pages/checkout_status.dart';
import 'package:kfb/pages/shipping_details.dart';
import 'package:kfb/pages/account_update.dart';
import 'package:kfb/pages/browse_category.dart';
import 'package:kfb/pages/cart.dart';
import 'package:kfb/pages/checkout_confirmation.dart';
import 'package:kfb/pages/error_page.dart';
import 'package:kfb/pages/home_menu.dart';
import 'package:kfb/pages/landing.dart';
import 'package:kfb/pages/privacy.dart';
import 'package:kfb/pages/product_detail.dart';
import 'package:kfb/pages/splash_screen.dart';
import 'package:kfb/pages/terms.dart';
import 'package:kfb/providers/paymentgatway.dart';
import 'package:kfb/providers/products_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wp_json_api/wp_json_api.dart';

import 'pages/checkout_details.dart';
import 'pages/checkout_shipping_type.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  String initialRoute = "/splash-screen";

  // For Authentication
  if (use_wp_login == true) {
    WPJsonAPI.instance.initWith(
        baseUrl: app_base_url,
        // shouldDebug: app_debug,
        wpJsonPath: app_wp_api_path);
  }

  runApp(
    ChangeNotifierProvider(
      create: (ctx) => ProductsProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: WooConfig.appName,
        color: Colors.black,
        initialRoute: initialRoute,
        routes: <String, WidgetBuilder>{
          '/landing': (BuildContext context) => LandingPage(),
          '/splash-screen': (BuildContext context) => new SplashScreen(),
          '/cart': (BuildContext context) => new CartPage(),
          '/account-landing': (BuildContext context) =>
              new AccountLandingPage(),
          '/account-register': (BuildContext context) =>
              new AccountRegistrationPage(),
          '/account-detail': (BuildContext context) => new AccountDetailPage(),
          '/account-update': (BuildContext context) => new AccountUpdate(),
          '/account-shipping-details': (BuildContext context) =>
              new ShippingDetails(),
          '/account-billing-details': (BuildContext context) =>
              new AccountBillingDetails(),
          '/checkout': (BuildContext context) => new CheckoutConfirmationPage(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/account-landing':
              return PageTransition(
                child: AccountLandingPage(),
                type: PageTransitionType.downToUp,
              );

            case '/add-edit-shipping-address':
              return PageTransition(
                child: AddEditShippingAddressForm(
                  mode: settings.arguments,
                ),
                type: PageTransitionType.downToUp,
              );

            case '/add-edit-billing-address':
              return PageTransition(
                child: AddEditBillingAddressForm(
                  mode: settings.arguments,
                ),
                type: PageTransitionType.downToUp,
              );

            case '/landing':
              return PageTransition(
                child: LandingPage(),
                type: PageTransitionType.downToUp,
              );
            case '/browse-category':
              if (settings.arguments != null) {
                final int categoryId = settings.arguments as int;
                return PageTransition(
                  child: BrowseCategoryPage(categoryId: categoryId),
                  type: PageTransitionType.fade,
                );
              }
              return PageTransition(
                child: ErrorPage(),
                type: PageTransitionType.fade,
              );
            case '/home-menu':
              return PageTransition(
                child: HomeMenuPage(),
                type: PageTransitionType.leftToRightWithFade,
              );
            case '/checkout-details':
              return PageTransition(
                child: CheckoutDetailsPage(),
                type: PageTransitionType.downToUp,
              );
            case '/checkout-shipping-type':
              return PageTransition(
                child: CheckoutShippingTypePage(),
                type: PageTransitionType.downToUp,
              );
            case '/about':
              return PageTransition(
                child: AboutPage(),
                type: PageTransitionType.leftToRightWithFade,
              );
            case '/terms':
              return PageTransition(
                child: Terms(),
                type: PageTransitionType.leftToRightWithFade,
              );
            case '/privacy':
              return PageTransition(
                child: Privacy(),
                type: PageTransitionType.leftToRightWithFade,
              );

            case '/product-detail':
              if (settings.arguments != null) {
                final Product product = settings.arguments as Product;
                return PageTransition(
                  child: ProductDetailPage(product: product),
                  type: PageTransitionType.rightToLeftWithFade,
                );
              }
              break;
            case '/checkout_status':
              if (settings.arguments != null) {
                final Order order = settings.arguments as Order;
                return PageTransition(
                  child: CheckoutStatusPage(order: order),
                  type: PageTransitionType.rightToLeftWithFade,
                );
              }
              break;
            case '/checkout-payment-type':
              return PageTransition(
                child: CheckoutPaymentTypePage(),
                type: PageTransitionType.rightToLeftWithFade,
              );
              break;
            case '/paymentgatway':
              return PageTransition(
                child: PaymentGatway(),
                type: PageTransitionType.leftToRight,
              );
              return PageTransition(
                child: ErrorPage(),
                type: PageTransitionType.fade,
              );
            default:
              return null;
          }
        },
        theme: ThemeData(
          primaryColor: Color(0xff2f4ffe),
          backgroundColor: Colors.white,
          buttonTheme: ButtonThemeData(
            hoverColor: Colors.transparent,
            buttonColor: Color(0xff529cda),
            colorScheme: colorSchemeButton(),
            minWidth: double.infinity,
            height: 70,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
            ),
          ),
          appBarTheme: AppBarTheme(
            color: Colors.white,
            textTheme: textThemeAppBar(),
            elevation: 0.0,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            actionsIconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          accentColor: Colors.black,
          accentTextTheme: textThemeAccent(),
          textTheme: textThemeMain(),
          primaryTextTheme: textThemePrimary(),
        ),
      ),
    ),
  );
}
