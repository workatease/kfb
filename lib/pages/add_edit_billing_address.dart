import 'package:flutter/material.dart';
import 'package:kfb/contants/constants.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/shared_pref.dart/sp_auth.dart';
import 'package:kfb/widgets/buttons.dart';
import 'package:kfb/widgets/error_snack_bar.dart';
import 'package:kfb/widgets/show_loader.dart';
import 'package:wp_json_api/models/responses/wc_customer_info_response.dart';
import 'package:wp_json_api/models/responses/wc_customer_updated_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class AddEditBillingAddressForm extends StatefulWidget {
  final Screen mode;
  AddEditBillingAddressForm({this.mode});
  @override
  _AddEditBillingAddressFormState createState() =>
      _AddEditBillingAddressFormState();
}

class _AddEditBillingAddressFormState extends State<AddEditBillingAddressForm> {
  TextEditingController _tfCompanyNameController;
  TextEditingController _tfAddressController;
  TextEditingController _tfFirstNameController;
  TextEditingController _tfLastNameController;
  TextEditingController _tfTownController;
  TextEditingController _tfStateController;
  TextEditingController _tfPostCodeController;
  TextEditingController _tfPhoneController;
  TextEditingController _tfEmailController;

  final _progressKey = GlobalKey<State>();
  WCCustomerInfoResponse _wcCustomerInfoResponse;
  bool _isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tfCompanyNameController = TextEditingController();
    _tfAddressController = TextEditingController();
    _tfFirstNameController = TextEditingController();
    _tfLastNameController = TextEditingController();
    _tfTownController = TextEditingController();
    _tfStateController = TextEditingController();
    _tfPostCodeController = TextEditingController();
    _tfPhoneController = TextEditingController();
    _tfEmailController = TextEditingController();
    _fetchWpUserData();
  }

  _fetchWpUserData() async {
    WCCustomerInfoResponse wcCustomerInfoResponse =
        await WPJsonAPI.instance.api((request) async {
      return request.wcCustomerInfo(await readAuthToken());
    });
    if (wcCustomerInfoResponse != null) {
      _wcCustomerInfoResponse = wcCustomerInfoResponse;

      if (widget.mode == Screen.EDIT) {
        _tfCompanyNameController.text =
            _wcCustomerInfoResponse.data.billing.company;
        _tfAddressController.text =
            _wcCustomerInfoResponse.data.billing.address1;
        _tfFirstNameController.text =
            _wcCustomerInfoResponse.data.billing.firstName;
        _tfLastNameController.text =
            _wcCustomerInfoResponse.data.billing.lastName;
        _tfTownController.text = _wcCustomerInfoResponse.data.billing.city;
        _tfStateController.text = _wcCustomerInfoResponse.data.billing.state;
        _tfPostCodeController.text =
            _wcCustomerInfoResponse.data.billing.postcode;
        _tfPhoneController.text = _wcCustomerInfoResponse.data.billing.phone;
        _tfEmailController.text = _wcCustomerInfoResponse.data.billing.email;
      }
    }
    if (this.mounted)
      setState(() {
        _isLoading = false;
      });
  }

  _addEditAddress() async {
    if (_tfCompanyNameController.text != null &&
        _tfAddressController.text != null &&
        _tfFirstNameController.text != null &&
        _tfLastNameController.text != null &&
        _tfTownController.text != null &&
        _tfStateController.text != null &&
        _tfPostCodeController.text != null &&
        _tfPhoneController.text != null &&
        _tfEmailController.text != null) {
      showDialogMethod(context, key: _progressKey, barrierDismissible: false);

      var token = await readAuthToken();

      try {
        WCCustomerUpdatedResponse wpCustomerUpdatedResponse = await WPJsonAPI
            .instance
            .api((request) => request.wcUpdateCustomerInfo(
                  token,
                  firstName: _tfFirstNameController.text,
                  lastName: _tfLastNameController.text,
                  billingFirstName: _tfFirstNameController.text,
                  billingLastName: _tfLastNameController.text,
                  billingCompany: _tfCompanyNameController.text,
                  billingCity: _tfTownController.text,
                  billingState: _tfStateController.text,
                  billingPostcode: _tfPostCodeController.text,
                  billingAddress1: _tfAddressController.text,
                  billingPhone: _tfPhoneController.text,
                  billingEmail: _tfEmailController.text,
                ));

        if (wpCustomerUpdatedResponse != null) {
          if (_progressKey.currentState?.mounted) Navigator.pop(context);
          Navigator.of(context).pop();
          showEdgeAlertWith(context,
              title: "Hello" + " ${_tfFirstNameController.text}",
              desc:
                  "Address ${widget.mode == Screen.ADD ? "Added" : "Updated"} succefully",
              style: EdgeAlertStyle.SUCCESS,
              icon: Icons.account_circle);
        }
      } catch (e) {
        print("wcUpdateCustomerInfo Exception: $e");
        Scaffold.of(context).showSnackBar(
            errorSnackBar2("Error occured, please try again later"));
      }
    } else {
      print("Show snackbar..!!");
      Scaffold.of(context)
          .showSnackBar(errorSnackBar2("All fields are mandatory"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            margin: EdgeInsets.only(left: 0),
          ),
          title: Text(
            widget.mode == Screen.ADD ? "Add" : "Update" + "Billing Address",
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
                              heading: "First Name*",
                              controller: _tfFirstNameController,
                              shouldAutoFocus: true,
                              keyboardType: TextInputType.text),
                        ),
                        Flexible(
                          child: wTextEditingRow(context,
                              heading: "Last Name*",
                              controller: _tfLastNameController,
                              shouldAutoFocus: false,
                              keyboardType: TextInputType.text),
                        ),
                      ],
                    )),
                wTextEditingRow(
                  context,
                  heading: "Company name*",
                  controller: _tfCompanyNameController,
                  shouldAutoFocus: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                wTextEditingRow(
                  context,
                  heading: "Address*",
                  controller: _tfAddressController,
                  shouldAutoFocus: true,
                  // obscureText: true,
                ),
                wTextEditingRow(
                  context,
                  heading: "Town*",
                  controller: _tfTownController,
                  shouldAutoFocus: true,
                  // obscureText: true,
                ),
                wTextEditingRow(
                  context,
                  heading: "State*",
                  controller: _tfStateController,
                  shouldAutoFocus: true,
                  // obscureText: true,
                ),
                wTextEditingRow(
                  context,
                  heading: "Postcode*",
                  controller: _tfPostCodeController,
                  shouldAutoFocus: true,
                  // obscureText: true,
                ),
                wTextEditingRow(
                  context,
                  heading: "Phone*",
                  controller: _tfPhoneController,
                  shouldAutoFocus: true,
                  // obscureText: true,
                ),
                wTextEditingRow(
                  context,
                  heading: "Email*",
                  controller: _tfEmailController,
                  shouldAutoFocus: true,
                  // obscureText: true,
                ),
                Padding(
                  child: wsPrimaryButton(context,
                      title: widget.mode == Screen.ADD ? "Add" : "Update",
                      action: _addEditAddress),
                  padding: EdgeInsets.only(top: 10),
                ),
              ],
            ),
          ),
        ));
  }
}
