import 'package:volontaria/data/event.dart';
import 'package:volontaria/data/participation.dart';

class Schedule {
  Participation participation;
  Event event;

  Schedule(Participation participation, Event event){
    this.participation = participation;
    this.event = event;
  }
}