import 'package:kfb/helpers/shared_pref.dart';

const keyUserId = "DEFAULT_SP_USERID";

storeUserId(String v) async {
  SharedPref sharedPref = SharedPref();
  await sharedPref.save(keyUserId, v);
}

Future<String> readUserId() async {
  SharedPref sharedPref = SharedPref();
  String val = await sharedPref.read(keyUserId);
  return val;
}
