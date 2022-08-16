import 'package:json_annotation/json_annotation.dart';

part 'busModel.g.dart';

@JsonSerializable(nullable: true)

class BusModel{
  String docId;
  String uploader;
  String busName;
  String partyName;
  List server;
  int time;
  List price1;
  List price2;
  List driverList;
  List passengerList;
  int type;
  int numDriver;
  List numPassenger;

  BusModel({
    this.docId,
    this.uploader,
    this.busName,
    this.partyName,
    this.server,
    this.time,
    this.price1,
    this.price2,
    this.driverList,
    this.passengerList,
    this.type, // 0 : 버스등록 1: 기사모집
    this.numDriver,
    this.numPassenger,
  });

  static BusModel initBusForm(){
    return new BusModel(
      docId: "",
      uploader: "",
      busName: "",
      partyName: "",
      server: [],
      time: 0,
      price1: [],
      price2: [],
      driverList: [],
      passengerList: [],
      type: 0,
      numDriver: 1,
      numPassenger: [],
    );
  }

  factory BusModel.fromJson(Map<String, dynamic> json) => _$BusModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusModelToJson(this);

}