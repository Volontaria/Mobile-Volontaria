import 'package:volontaria/data/user.dart';
import 'package:volontaria/models/token.dart';

class Auth {
  User user;
  Token token;

  Auth(User user, Token token){
    this.user = user;
    this.token = token;
  }

}