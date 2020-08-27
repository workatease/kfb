import 'package:kfb/helpers/tools.dart';
import 'package:kfb/models/payment_type.dart';
import 'package:kfb/providers/razor_pay.dart';

List<PaymentType> arrPaymentMethods = [
  //  addPayment(
  //     PaymentType(
  //       id: 2,
  //      name: "CashOnDelivery",
  //       desc: "Cash on delivery",
  //       assetImage: "cash_on_delivery.jpeg",
  //       pay: cashOnDeliveryPay,
  //     ),
  //   ),

  addPayment(
    PaymentType(
      id: 1,
      name: "RazorPay",
      desc: "Debit or Credit Card",
      assetImage: "razorpay.png",
      pay: razorPay,
    ),
  ),

  // e.g. add more here

//  addPayment(
//    PaymentType(
//      id: 4,
//      name: "MyNewPaymentMethod",
//      desc: "Debit or Credit Card",
//      assetImage: "add icon image to assets/images/myimage.png",
//      pay: myCustomPaymentFunction
//    ),
//  ),
].where((e) => e != null).toList();
