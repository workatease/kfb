import 'package:flutter/material.dart';
import 'package:kfb/api_provider/customers_api_provider.dart';
import 'package:kfb/api_provider/otp_api_provider.dart';
import 'package:kfb/config/woo_config.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/shared_pref.dart/sp_auth.dart';
import 'package:kfb/shared_pref.dart/sp_user_id.dart';
import 'package:kfb/widgets/buttons.dart';
import 'package:wp_json_api/models/responses/wp_user_register_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class AccountRegistrationPage extends StatefulWidget {
  AccountRegistrationPage();

  @override
  _AccountRegistrationPageState createState() =>
      _AccountRegistrationPageState();
}

class _AccountRegistrationPageState extends State<AccountRegistrationPage> {
  _AccountRegistrationPageState();

  bool _hasTappedRegister;
  bool _otpSend;
  bool _otpVerified;
  TextEditingController _tfEmailAddressController;
  TextEditingController _tfPasswordController;
  TextEditingController _tfFirstNameController;
  TextEditingController _tfLastNameController;
  TextEditingController _tfPhoneNumberController;
  TextEditingController _tfOtpController;
  OtpApiProvider _otpApiProvider = OtpApiProvider();
  CustomersApiProvider _customersApiProvider = CustomersApiProvider();

  @override
  void initState() {
    super.initState();

    _hasTappedRegister = false;
    _otpSend = false;
    _otpVerified = false;
    _tfEmailAddressController = TextEditingController();
    _tfPasswordController = TextEditingController();
    _tfFirstNameController = TextEditingController();
    _tfLastNameController = TextEditingController();
    _tfPhoneNumberController = TextEditingController();
    _tfOtpController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Register",
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: wTextEditingRow(context,
                            heading: "First Name",
                            controller: _tfFirstNameController,
                            shouldAutoFocus: true,
                            keyboardType: TextInputType.text),
                      ),
                      Flexible(
                        child: wTextEditingRow(context,
                            heading: "Last Name",
                            controller: _tfLastNameController,
                            shouldAutoFocus: false,
                            keyboardType: TextInputType.text),
                      ),
                    ],
                  )),
              wTextEditingRow(
                context,
                heading: "Email address",
                controller: _tfEmailAddressController,
                shouldAutoFocus: false,
                keyboardType: TextInputType.emailAddress,
              ),
              wTextEditingRow(
                context,
                heading: "Password",
                controller: _tfPasswordController,
                shouldAutoFocus: true,
                obscureText: true,
              ),
              wTextEditingRow(
                context,
                heading: "Phone Number",
                controller: _tfPhoneNumberController,
                shouldAutoFocus: false,
                keyboardType: TextInputType.number,
                readOnly: _otpVerified ? true : false,
              ),
              Padding(
                child: wsDarkButton(
                  context,
                  title: "Send OTP",
                  // action: () {},
                  action: _sendOtp,
                ),
                padding: EdgeInsets.only(top: 10),
              ),
              Padding(
                child: wsPrimaryButton(context,
                    title: "Sign up",
                    action: _hasTappedRegister ? null : _signUpTapped),
                padding: EdgeInsets.only(top: 10),
              ),
              Padding(
                child: InkWell(
                  child: RichText(
                    text: TextSpan(
                      text: "By tapping Sign Up you are agreeing to " +
                          app_name +
                          '\'s ',
                      children: <TextSpan>[
                        TextSpan(
                            text: "terms and conditions",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '  ' + "and" + '  '),
                        TextSpan(
                            text: "privacy policy",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                      style: TextStyle(color: Colors.black45),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: _viewTOSModal,
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendOtp() async {
    int mobileNumber = int.parse(_tfPhoneNumberController.text);
    int otp = generateRandom();

    var response = await _otpApiProvider.sendOtp(mobileNumber, otp);
    // if (response.statusCode == "success") {
    _showVerifyOtpPopUp(context);
    setState(() {
      _otpSend = true;
    });
    // } else {
    //   print(response["type"]);
    // }
    return;
  }

  _verifyOtp() async {
    int otp = int.parse(_tfOtpController.text);
    var response = await _otpApiProvider.verifyOtp(
        int.parse(_tfPhoneNumberController.text), otp);
    // if (responseData.type == "success") {
    // _showVerifyOtpPopUp(context);
    if (response.statusCode == 200) {
      setState(() {
        _otpVerified = true;
      });
      Navigator.pop(context);
    }

    // } else {
    //   print(responseData.type);
    // }
    return;
  }

  _showVerifyOtpPopUp(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Center(
              child: Column(
                children: <Widget>[
                  wTextEditingRow2(
                    context,
                    heading: "OTP",
                    controller: _tfOtpController,
                    shouldAutoFocus: true,
                    keyboardType: TextInputType.number,
                  ),
                  Padding(
                    child: wsDarkButton(
                      context,
                      title: "Verify OTP",
                      // action: () {},
                      action: _verifyOtp,
                    ),
                    padding: EdgeInsets.only(top: 10),
                  ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
          );
        });
  }

  // _showVerifyOtpPopUp2(context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: Center(
  //             child: Stack(overflow: Overflow.visible, children: <Widget>[
  //               Positioned(
  //                 right: -40.0,
  //                 top: -40.0,
  //                 child: InkResponse(
  //                   onTap: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: CircleAvatar(
  //                     child: Icon(Icons.close),
  //                     backgroundColor: Colors.red,
  //                   ),
  //                 ),
  //               ),
  //               Column(
  //                 children: <Widget>[
  //                   wTextEditingRow(
  //                     context,
  //                     heading: "OTP",
  //                     controller: _tfOtpController,
  //                     shouldAutoFocus: true,
  //                     keyboardType: TextInputType.number,
  //                   ),
  //                   Padding(
  //                     child: wsDarkButton(
  //                       context,
  //                       title: "Verify OTP",
  //                       // action: () {},
  //                       action: _verifyOtp(int.parse(_tfOtpController.text)),
  //                     ),
  //                     padding: EdgeInsets.only(top: 10),
  //                   ),
  //                 ],
  //               ),
  //             ]),
  //           ),
  //           contentPadding: EdgeInsets.all(0),
  //           backgroundColor: Colors.transparent,
  //         );
  //       });
  // }

  _signUpTapped() async {
    if (!_otpVerified) {
      showEdgeAlertWith(context,
          title: "Oops",
          desc: "Please verify the OTP first",
          style: EdgeAlertStyle.DANGER);
      return;
    }
    String email = _tfEmailAddressController.text;
    String password = _tfPasswordController.text;
    String firstName = _tfFirstNameController.text;
    String lastName = _tfLastNameController.text;
    String phoneNumber = _tfPhoneNumberController.text;

    if (!isEmail(email)) {
      showEdgeAlertWith(context,
          title: "Oops",
          desc: "That email address is not valid",
          style: EdgeAlertStyle.DANGER);
      return;
    }

    if (password.length <= 5) {
      showEdgeAlertWith(context,
          title: "Oops",
          desc: "Password must be a min 6 characters",
          style: EdgeAlertStyle.DANGER);
      return;
    }

    if (phoneNumber.length < 10 && phoneNumber.length > 10) {
      showEdgeAlertWith(context,
          title: "Oops",
          desc: "Phone number must be of ten digits",
          style: EdgeAlertStyle.DANGER);
      return;
    }

    if (_hasTappedRegister == false) {
      setState(() {
        _hasTappedRegister = true;
      });

      String username =
          (email.replaceAll(new RegExp(r'(@|\.)'), "")) + randomStr(4);

      WPUserRegisterResponse wpUserRegisterResponse =
          await WPJsonAPI.instance.api((request) => request.wpRegister(
                email: email.toLowerCase(),
                password: password,
                username: username,
              ));

      if (wpUserRegisterResponse != null) {
        String token = wpUserRegisterResponse.data.userToken;
        print("User Token: " + token);

        authUser(token);
        int userId = wpUserRegisterResponse.data.userId;
        storeUserId(wpUserRegisterResponse.data.userId.toString());

        try {
          await WPJsonAPI.instance
              .api((request) => request.wcUpdateCustomerInfo(
                    // token,
                    wpUserRegisterResponse.data.userToken,
                    firstName: firstName,
                    lastName: lastName,
                    billingFirstName: firstName,
                    billingLastName: lastName,
                    billingPhone: phoneNumber,
                  ));
          // await _customersApiProvider.updateCustomerDetails(
          //     wpUserRegisterResponse.data.userId,
          //     firstName,
          //     lastName,
          //     int.parse(phoneNumber));
        } catch (e) {
          print("wcUpdateCustomerInfo Exception: $e");
        }

        showEdgeAlertWith(context,
            title: "Hello" + " $firstName",
            desc: "you're now logged in",
            style: EdgeAlertStyle.SUCCESS,
            icon: Icons.account_circle);
        navigatorPush(context,
            routeName: UserAuth.instance.redirect, forgetLast: 2);
      } else {
        setState(() {
          showEdgeAlertWith(context,
              title: "Invalid",
              desc: "Please check your details",
              style: EdgeAlertStyle.WARNING);
          _hasTappedRegister = false;
        });
      }
    }
  }

  _viewTOSModal() {
    showPlatformAlertDialog(context,
        title: "Actions",
        subtitle: "View Terms and Conditions or Privacy policy",
        actions: [
          dialogAction(context,
              title: "Terms and Conditions", action: _viewTermsConditions),
          dialogAction(context,
              title: "Privacy Policy", action: _viewPrivacyPolicy),
        ]);
  }

  void _viewTermsConditions() {
    Navigator.pop(context);
    // openBrowserTab(url: app_terms_url);
  }

  void _viewPrivacyPolicy() {
    Navigator.pop(context);
    // openBrowserTab(url: app_privacy_url);
  }
}
