import 'package:flutter/material.dart';
import 'package:kfb/api_provider/customers_api_provider.dart';
import 'package:kfb/config/woo_config.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/models/response/customer.dart';
import 'package:kfb/shared_pref.dart/sp_auth.dart';
import 'package:kfb/shared_pref.dart/sp_user_id.dart';
import 'package:kfb/widgets/buttons.dart';
import 'package:woocommerce_api/woocommerce_api.dart';
import 'package:wp_json_api/models/responses/wp_user_login_response.dart';
import 'package:wp_json_api/wp_json_api.dart';
import 'package:wp_json_api/enums/wp_auth_type.dart';

class AccountLandingPage extends StatefulWidget {
  AccountLandingPage();

  @override
  _AccountLandingPageState createState() => _AccountLandingPageState();
}

class _AccountLandingPageState extends State<AccountLandingPage> {
  bool _hasTappedLogin;
  TextEditingController _tfEmailController;
  TextEditingController _tfPasswordController;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    _hasTappedLogin = false;
    _tfEmailController = TextEditingController();
    _tfPasswordController = TextEditingController();
  }

  final emailKey = GlobalKey<FormState>();
  final passKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  storeLogo(height: 100),
                  Flexible(
                    child: Container(
                      height: 70,
                      padding: EdgeInsets.only(bottom: 20),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Login",
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            .copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: wBoxShadow(),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        wTextEditingRow(context,
                            heading: "Email or Phone",
                            controller: _tfEmailController,
                            keyboardType: TextInputType.emailAddress),
                        wTextEditingRow(context,
                            heading: "Password",
                            controller: _tfPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true),
                        wsPrimaryButton(
                          context,
                          title: "Login",
                          action: _hasTappedLogin == true ? null : _loginUser,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FlatButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    color: Colors.black38,
                  ),
                  Padding(
                    child: Text(
                      "Create an account",
                      style: Theme.of(context).primaryTextTheme.bodyText1,
                    ),
                    padding: EdgeInsets.only(left: 8),
                  )
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/account-register");
              },
            ),
            // wsLinkButton(context, title: "Forgot Password",
            //     action: () {
            //   launch(app_forgot_password_url);
            // }),
            Divider(),
            // wsLinkButton(context,
            //     title: "Back", action: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  _loginUser() async {
    String emailOrPhone = _tfEmailController.text;
    String password = _tfPasswordController.text;
    String email;
    CustomersApiProvider customersApiProvider = CustomersApiProvider();

    if (_hasTappedLogin == false) {
      setState(() {
        _hasTappedLogin = true;
      });
      try {
        if (isEmail(emailOrPhone)) {
          email = emailOrPhone;
        } else {
          Customer customer;
          int phone = int.parse(_tfEmailController.text);
          customer =
              await customersApiProvider.getCustomerByPhone(phone: phone);
          email = customer.email;
        }
        WPUserLoginResponse wpUserLoginResponse =
            await WPJsonAPI.instance.api((request) => request.wpLogin(
                  email: email,
                  password: password,
                  authType: WPAuthType.WpEmail,
                ));
        _hasTappedLogin = false;

        if (wpUserLoginResponse != null) {
          String token = wpUserLoginResponse.data.userToken;
          authUser(token);
          storeUserId(wpUserLoginResponse.data.userId.toString());

          showEdgeAlertWith(context,
              title: "Hello",
              desc: "Welcome back",
              style: EdgeAlertStyle.SUCCESS,
              icon: Icons.account_circle);
          navigatorPush(context,
              routeName: UserAuth.instance.redirect, forgetLast: 1);
        } else {
          showEdgeAlertWith(context,
              title: "Oops!",
              desc: "Invalid login credentials",
              style: EdgeAlertStyle.WARNING,
              icon: Icons.account_circle);
          setState(() {
            _hasTappedLogin = false;
          });
        }
      } catch (e) {
        showEdgeAlertWith(context,
            title: "Oops!",
            desc: "Invalid login credentials",
            style: EdgeAlertStyle.WARNING,
            icon: Icons.account_circle);
        setState(() {
          _hasTappedLogin = false;
        });
        setState(() {
          _hasTappedLogin = false;
        });
      }
    }
  }
}
