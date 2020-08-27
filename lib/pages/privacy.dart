import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
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
          title: Text("Privacy Policy",
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
                "KFB respects your privacy. This Privacy Policy provides succinctly the manner your data is collected and used by KFB on the Site. As a visitor to the Site/ Customer, you are advised to please read the Privacy Policy carefully. By accessing the services provided by the Site you agree to the collection and use of your data by KFB in the manner provided in this Privacy Policy.",
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "What information is, or maybe, collected form you?",
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
                "As part of the registration process on the Site, KFB may collect the following personally identifiable information about you: Name including first and last name, alternate email address, mobile phone number, and contact details, Postal code, Demographic profile (like your age, gender, occupation, education, address, etc.) and information about the pages on the site you visit/access, the links you click on the site, the number of times you access the page and any such browsing information.",
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "How is the information used?",
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
                "KFB will use your personal information to provide personalized features to you on the Site and to provide for promotional offers to you through the Site and other channels. KFB will also provide this information to its business associates and partners to get in touch with you when necessary to provide the services requested by you. KFB will use this information to preserve transaction history as governed by existing law or policy. KFB may also use contact information internally to direct its efforts for product improvement, to contact you as a survey respondent, to notify you if you win any contest; and to send you promotional materials from its contest sponsors or advertisers.",
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "With whom your information will be shared?",
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
                "KFB will not use your financial information for any purpose other than to complete a transaction with you. KFB does not rent, sell, or share your personal information and will not disclose any of your personally identifiable information to third parties. In cases where it has your permission to provide products or services, you've requested and such information is necessary to provide these products or services the information may be shared with KFB’s business associates and partners. KFB may, however, share consumer information on an aggregate with its partners or third parties where it deems necessary. In addition, KFB may use this information for promotional offers, to help investigate, prevent or take action regarding unlawful and illegal activities, suspected fraud, potential threat to the safety or security of any person, violations of the Site’s terms of use or to defend against legal claims; special circumstances such as compliance with subpoenas, court orders, requests/order from legal authorities or law enforcement agencies requiring such disclosure.",
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
