import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Terms & Conditions",
              style: Theme.of(context).primaryTextTheme.headline6),
          centerTitle: true,
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Text(
                "Account & Registration Obligations",
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline6
                    .copyWith(color: Color(0xff829112)),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "All shoppers have to register and login for placing orders on the Site. You have to keep your account and registration details current and correct for communications related to your purchases from the site.",
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Pricing",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline6
                    .copyWith(color: Color(0xff829112)),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "All the products listed on the Site will be sold at MRP unless otherwise specified. The prices mentioned at the time of ordering will be the prices charged on the date of the delivery. Although prices of most of the products do not fluctuate on a daily basis. Some of the commodities and fresh food prices do change on a daily basis. In case the prices are higher or lower on the date of delivery, no additional charges will be collected or refunded as the case may be at the time of the delivery of the order. If you shop above 999/- you’ll be eligible for free shipping.",
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Refund",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline6
                    .copyWith(color: Color(0xff829112)),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "If unfortunately, you have to cancel an order please do so 6 hours before the delivery & hence you’ll get the entire amount refunded.",
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "You Agree and Confirm",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline6
                    .copyWith(color: Color(0xff829112)),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "That in the event that a non-delivery occurs on account of a mistake by you (i.e. wrong name or address or any other wrong information) any extra cost incurred by KFB for redelivery shall be claimed from you. That you will use the services provided by the Site, its affiliates, consultants and contracted companies, for lawful purposes only and comply with all applicable laws and regulations while using and transacting on the Site. You will provide authentic and true information in all instances where such information is requested of you. KFB reserves the right to confirm and validate the information and other details provided by you at any point in time. If upon confirmation your details are found not to be true (wholly or partly), it has the right in its sole discretion to reject the registration and debar you from using the Services and / or other affiliated websites without prior intimation whatsoever. You authorize KFB to contact you for any transactional purposes related to your order/account. That you are accessing the services available on this Site and transacting at your sole risk and are using your best and prudent judgment before entering into any transaction through this Site. That the address at which delivery of the product ordered by you is to be made will be correct and proper in all respects. That before placing an order you will check the product description carefully. By placing an order for a product you agree to be bound by the conditions of sale included in the item's description.",
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
