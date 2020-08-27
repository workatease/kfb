import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kfb/contants/constants.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/pages/add_edit_shipping_address.dart';
import 'package:kfb/shared_pref.dart/sp_auth.dart';
import 'package:kfb/theme/theme.dart';
import 'package:kfb/widgets/app_loader.dart';
import 'package:wp_json_api/models/responses/wc_customer_info_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class AccountBillingDetails extends StatefulWidget {
  @override
  _AccountBillingDetailsState createState() => _AccountBillingDetailsState();
}

class _AccountBillingDetailsState extends State<AccountBillingDetails> {
  bool _isLoading;
  WCCustomerInfoResponse _wcCustomerInfoResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    _fetchWpUserBillingData();
  }

  _fetchWpUserBillingData() async {
    WCCustomerInfoResponse wcCustomerInfoResponse =
        await WPJsonAPI.instance.api((request) async {
      return request.wcCustomerInfo(await readAuthToken());
    });

    if (wcCustomerInfoResponse != null) {
      _wcCustomerInfoResponse = wcCustomerInfoResponse;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:
            _wcCustomerInfoResponse?.data?.billing?.address1 != null &&
                    _wcCustomerInfoResponse?.data?.billing?.address1 == ""
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    backgroundColor: bottomColor,
                    onPressed: () {
                      print("Navigate to add address screen..!!");
                      Navigator.pushNamed(context, '/add-edit-billing-address',
                              arguments: Screen.ADD)
                          .then((value) => {_fetchWpUserBillingData()});
                    })
                : null,
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
            "Billing Details",
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
          centerTitle: true,
        ),
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            minimum: safeAreaDefault(),
            child: _isLoading
                ? showAppLoader()
                : _wcCustomerInfoResponse.data.billing.address1 != null &&
                        _wcCustomerInfoResponse.data.billing.address1 != ""
                    ? Column(
                        children: <Widget>[
                          Text(
                              "The following addresses will be used on the checkout page by default.",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal)),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(0),
                            height: 220,
                            width: double.maxFinite,
                            child: Card(
                                elevation: 5,
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              "${_wcCustomerInfoResponse.data.billing.firstName} + ${_wcCustomerInfoResponse.data.billing.lastName}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text(
                                              "${_wcCustomerInfoResponse.data.billing.company}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text(
                                              "${_wcCustomerInfoResponse.data.billing.city} ${_wcCustomerInfoResponse.data.billing.postcode}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text(
                                              "${_wcCustomerInfoResponse.data.billing.state}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        icon: new Icon(Icons.edit),
                                        alignment: Alignment.center,
                                        padding: new EdgeInsets.all(0.0),
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                                  '/add-edit-billing-address',
                                                  arguments: Screen.EDIT)
                                              .then((value) =>
                                                  {_fetchWpUserBillingData()});
                                        },
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Text(
                            "You have not set up this type of address yet.",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal)),
                      )));
  }
}
