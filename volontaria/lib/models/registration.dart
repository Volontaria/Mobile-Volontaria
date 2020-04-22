import 'package:volontaria/data/cell.dart';
import 'package:volontaria/data/event.dart';
import 'package:volontaria/models/auth.dart';

class Registration {
  Auth auth;
  Cell cell;
  Event event;

  Registration(Auth auth, Cell cell){
    this.auth = auth;
    this.cell = cell;
  }

  Registration.event(Auth auth, Cell cell, Event event){
    this.auth = auth;
    this.cell = cell;
    this.event = event;
  }
}