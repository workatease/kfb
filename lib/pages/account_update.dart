import 'package:flutter/material.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/shared_pref.dart/sp_auth.dart';
import 'package:kfb/widgets/buttons.dart';
import 'package:wp_json_api/models/responses/wc_customer_info_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class AccountUpdate extends StatefulWidget {
  @override
  _AccountUpdateState createState() => _AccountUpdateState();
}

class _AccountUpdateState extends State<AccountUpdate> {
  TextEditingController _tfEmailAddressController;
  TextEditingController _tfPasswordController;
  TextEditingController _tfFirstNameController;
  TextEditingController _tfLastNameController;
  TextEditingController _tfPhoneNumberController;
  WCCustomerInfoResponse _wcCustomerInfoResponse;
  bool _isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWpUserData();
  }

  _fetchWpUserData() async {
    WCCustomerInfoResponse wcCustomerInfoResponse =
        await WPJsonAPI.instance.api((request) async {
      return request.wcCustomerInfo(await readAuthToken());
    });
    if (wcCustomerInfoResponse != null) {
      _wcCustomerInfoResponse = wcCustomerInfoResponse;
    }
    if(this.mounted)
    setState(() {
      _isLoading = false;
    });
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
            "Update Details",
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
                  heading: "Address",
                  controller: _tfPasswordController,
                  shouldAutoFocus: true,
                  // obscureText: true,
                ),
                wTextEditingRow(
                  context,
                  heading: "Phone Number",
                  controller: _tfPhoneNumberController,
                  shouldAutoFocus: false,
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  child:
                      wsPrimaryButton(context, title: "Update", action: () {
                        
                      }),
                  padding: EdgeInsets.only(top: 10),
                ),
              ],
            ),
          ),
        ));
  }
}
