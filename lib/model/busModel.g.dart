// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'busModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusModel _$BusModelFromJson(Map<String, dynamic> json) {
  return BusModel(
    docId: json['docId'] as String,
    uploader: json['uploader'] as String,
    busName: json['busName'] as String,
    partyName: json['partyName'] as String,
    server: json['server'] as List,
    time: json['time'] as int,
    price1: json['price1'] as List,
    price2: json['price2'] as List,
    driverList: json['driverList'] as List,
    passengerList: json['passengerList'] as List,
    type: json['type'] as int,
    numDriver: json['numDriver'] as int,
    numPassenger: json['numPassenger'] as List,
  );
}

Map<String, dynamic> _$BusModelToJson(BusModel instance) => <String, dynamic>{
      'docId': instance.docId,
      'uploader': instance.uploader,
      'busName': instance.busName,
      'partyName': instance.partyName,
      'server': instance.server,
      'time': instance.time,
      'price1': instance.price1,
      'price2': instance.price2,
      'driverList': instance.driverList,
      'passengerList': instance.passengerList,
      'type': instance.type,
      'numDriver': instance.numDriver,
      'numPassenger': instance.numPassenger,
    };
