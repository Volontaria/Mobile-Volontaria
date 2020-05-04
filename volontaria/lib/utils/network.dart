import 'dart:async';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/utils/constants.dart';

class Network {
  // Singleton
  static Network _instance = new Network.internal();
  Network.internal();
  factory Network() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url, {Map headers}) {
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = Utf8Decoder().convert(response.bodyBytes);
      final int statusCode = response.statusCode;
      final bool intercepted = _interceptor(statusCode);
      if (!intercepted) {
        if (statusCode < 100 || statusCode == 400 || statusCode > 401) {
          throw new Exception(_decoder.convert(res));
        }
        return _decoder.convert(res);
      }
    }).catchError((onError) {
      _errorToast();
      return '{}';
    });
  }

  Future<void> delete(String url, {Map headers}) {
    return http.delete(url, headers: headers).then((http.Response response) {
      final String res = Utf8Decoder().convert(response.bodyBytes);
      final int statusCode = response.statusCode;
      final bool intercepted = _interceptor(statusCode);
      if (!intercepted){
        if (statusCode < 100 || statusCode == 400 || statusCode > 401) {
          throw new Exception(_decoder.convert(res));
        }
        return _decoder.convert(res);
      }
    }).catchError((onError) {
      _errorToast();
      return '{}';
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http.post(url, body: body, headers: headers, encoding: encoding).then((http.Response response) {
      final String res = Utf8Decoder().convert(response.bodyBytes);
      final int statusCode = response.statusCode;
      final bool intercepted = _interceptor(statusCode);
      if (!intercepted){
        if (statusCode < 100 || statusCode == 400 || statusCode > 401) {
          throw new Exception(_decoder.convert(res));
        }
        return _decoder.convert(res);
      }
    }).catchError((onError) {
      _errorToast();
      return '{}';
    });
  }

  bool _interceptor(int statusCode) {
    if (statusCode == 401) {
      _out();
      Fluttertoast.showToast(
        msg: "Votre session a expirée.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: defaultErrorColor,
      );
      return true;
    } else {
      return false;
    }
  }

  void _errorToast(){
    Fluttertoast.showToast(
      msg: "L'application ne peut pas accéder à internet.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: defaultErrorColor,
    );
  }

  void _out(){
    SharedPreferences.getInstance().then((
        SharedPreferences sharedPreferences) =>
        sharedPreferences.setString("token", null));
    NavigationService().pushReplacementNamed('/app/login');
  }
}