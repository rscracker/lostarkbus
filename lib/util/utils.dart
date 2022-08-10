import 'package:flutter/material.dart';

class Utils{
  static timeinvert(int time){
    String _time = "";
    int hour = time ~/ 100;
    int minute = time - (hour * 100);
    hour < 10 ? _time += "0${hour.toString()}" : _time += hour.toString();
    _time += " : ";
    minute < 10 ? _time += "0${minute.toString()}" : _time += minute.toString();
    return _time;
  }

}