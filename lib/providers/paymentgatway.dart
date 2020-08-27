import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentGatway extends StatefulWidget {
  @override
  _PaymentGatwayState createState() => _PaymentGatwayState();
}

class _PaymentGatwayState extends State<PaymentGatway> {
  Razorpay razorpay;
  @override
  void initState() {
    super.initState();
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckOut() {
    var options = {
      "key": "rzp_live_9pE6B99RxXUj2B",
      "amount": 200,
      "name": "CHp pandey",
      "desc": "fghjkl;kjhgf",
      "prefil": {
        "contact": "",
        "email": "",
      },
      "external": {
        "wallet": ["payment"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess() {
    print("Payment succss");
  }

  void handlerErrorFailure() {
    print("Payment Erroe");
  }

  void handlerExternalWallet() {
    print("External wallet");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("panyment"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: FlatButton(
          child: Text("Procid to pay"),
          onPressed: () {
            openCheckOut();
          },
        ),
      ),
    );
  }
}
