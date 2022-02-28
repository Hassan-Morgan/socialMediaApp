import 'package:shared_preferences/shared_preferences.dart';

class CashHelper{

  static late SharedPreferences _sharedPreferences;

  static Future<void>init()async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putData({
    required String key,
    required dynamic value ,
  }) {
    if (value is bool) return _sharedPreferences.setBool(key, value);
    if (value is String) return _sharedPreferences.setString(key, value);
    if (value is int) return _sharedPreferences.setInt(key, value);
    return _sharedPreferences.setDouble(key, value);
  }

  static dynamic getData({
    required String key,
  }){
    return _sharedPreferences.get(key);
  }

  static Future<bool> removeData({
    required String key,
  }){
    return _sharedPreferences.remove(key);
  }

}