// Otp Api Provider For sms.auxous.com
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kfb/helpers/shared_pref.dart';

class OtpApiProvider {
  final String _keyOtp = "OTP";
  final String _authKey = "337688AblJo1l2i5f263e69P1";
  final String _senderId = "KFBKOL";
  final String _baseURL = "http://sms.auxous.com/api/";

  // Future<Response<dynamic>> sendOtp(int mobileNumber, int otp) async {
  Future<dynamic> sendOtp(int mobileNumber, int otp) async {
    String mobileNumberWithCountryCode = "91" + mobileNumber.toString();

    // Save the otp to local storage
    SharedPref sharedPref = SharedPref();
    sharedPref.save(_keyOtp, otp.toString());

    try {
      Response response = await Dio().get(_baseURL +
          "otp.php?authkey=" +
          _authKey +
          "&mobile=" +
          mobileNumberWithCountryCode +
          "&message=Your%20otp%20is%20" +
          otp.toString() +
          "&sender=" +
          _senderId +
          "&otp=" +
          otp.toString());
      print(response);
      print("Response Status: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        // print("Response Status: " + response.statusCode.toString());
        // print("Response Data(String): " +
        //     json.decode(response.data["type"]).toString());
        // var responseData = json.decode(response.data);
        // print("Response Data Type(String): " + responseData.type.toString());
        // print("Response Data Type(json.decode): " + responseData.type);
        return response;
      }
      print(response.statusCode);
      return;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<dynamic> verifyOtp(int mobileNumber, int otpToVerify) async {
    // Retrieve otp from local Storage
    SharedPref sharedPref = SharedPref();
    String otp = (await sharedPref.read(_keyOtp) as String);

    String mobileNumberWithCountryCode = "91" + mobileNumber.toString();
    try {
      Response response = await Dio().get(_baseURL +
          "verifyRequestOTP.php?authkey=" +
          _authKey +
          "&mobile=" +
          mobileNumberWithCountryCode +
          "&otp=" +
          otpToVerify.toString());
      print(response);
      print("OTP Verify Response Status: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        // Remove otp from local storage
        sharedPref.remove(_keyOtp);

        return response;
      }
      print(response.statusCode);
      return;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<dynamic> verifyOtpOld(int mobileNumber, int otpToVerify) async {
    // Retrieve otp from local Storage
    SharedPref sharedPref = SharedPref();
    String otp = sharedPref.read(_keyOtp);

    String mobileNumberWithCountryCode = "91" + mobileNumber.toString();
    try {
      Response response = await Dio().get(_baseURL +
          "/verifyRequestOTP.php?authkey=" +
          _authKey +
          "&mobile=" +
          mobileNumberWithCountryCode +
          "&otp=" +
          otpToVerify.toString());
      print(response);
      if (response.statusCode == 200) {
        // Remove otp from local storage
        sharedPref.remove(_keyOtp);

        return json.decode(response.data);
      }
      print(response.statusCode);
      return;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
