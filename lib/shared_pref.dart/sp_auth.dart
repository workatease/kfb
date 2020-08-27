import 'package:kfb/helpers/shared_pref.dart';

const keyAuthCheck = "DEFAULT_SP_AUTHCHECK";

authUser(String v) async {
  SharedPref sharedPref = SharedPref();
  await sharedPref.save(keyAuthCheck, v);
}

Future<String> readAuthToken() async {
  SharedPref sharedPref = SharedPref();
  dynamic val = await sharedPref.read(keyAuthCheck);
  return val.toString();
}

Future<bool> authCheck() async {
  SharedPref sharedPref = SharedPref();
  String val = await sharedPref.read(keyAuthCheck);
  return val != null ? true : false;
}
// Future<bool> get hasToken  {}
