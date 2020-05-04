import 'package:shared_preferences/shared_preferences.dart';

class Token {
  String _tokenValue;

  Token(String token){
    setValue(token);
  }

  Future<String> getValue() async {
    if (this._tokenValue.isEmpty) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      this._tokenValue = sharedPreferences.getString("token");
    }
    return this._tokenValue;
  }

  setValue(String token) {
    this._tokenValue = token;
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) => sharedPreferences.setString("token", this._tokenValue));
  }

  clearValue() {
    this._tokenValue = null;
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) => sharedPreferences.setString("token", this._tokenValue));
  }
}