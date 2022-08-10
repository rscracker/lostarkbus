import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/busModel.dart';
import 'package:lostarkbus/model/characterModel.dart';
import 'package:lostarkbus/model/userModel.dart';

import 'package:get/get.dart';
class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService _instance = DatabaseService._privateConstructor();

  static DatabaseService get instance => _instance;

  MainController _mainController = Get.find();

  UserModel get _user => _mainController.user.value;

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  final CollectionReference busCollection = FirebaseFirestore.instance.collection('bus');

  final CollectionReference tradeCollection = FirebaseFirestore.instance.collection('trade');

  final CollectionReference mapCollection = FirebaseFirestore.instance.collection('map');

  final CollectionReference characterCollection = FirebaseFirestore.instance.collection('character');

  getInitData(List myCharacter) async{
    List myParty = [];
    List characterList = [];
    QuerySnapshot snapshot1 = await busCollection.where("uploader", isEqualTo: _user.uid).get();
    snapshot1.docs.forEach((e) {
      myParty.add(e.data());
    });
    _mainController.myUpload.assignAll(myParty);
    print(_mainController.myUpload);
    for(int i = 0; i < myCharacter.length ; i++){
      Map<String, dynamic> character;
      await characterCollection.doc(myCharacter[i]).get().then((e) => character = e.data());
      characterList.add(character);
    }
    _mainController.characterList.assignAll(characterList);
  }

  Future<bool> setUser(String uid) async{
    print(uid);
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    print("aaa : ${snapshot.data()}");
    if(snapshot.data() == null) { //앱 처음
      UserModel initUser = UserModel.initUser();
      initUser.uid = uid;
      _mainController.updateUser(initUser);
      print("first login");
      saveUserData(uid);
      return Future.value(false);
    } else {
      Map<String, dynamic> userdata = snapshot.data();
      userdata['uid'] = uid;
      _mainController.updateUser(UserModel.fromJson(userdata));
      //_mainController.characterList.assignAll(userdata['characterList']);
      getInitData(userdata['characterList']);
      _mainController.favoriteList.assignAll(userdata['favoriteList']);
      print("second login");

      return Future.value(true);
    }
  }

  saveUserData(String uid) async{
    await userCollection.doc(uid).set(_user.toJson());
  }
  
  addCharacter(CharacterModel character, int type) async{
    String id;
    await characterCollection.add({}).then((e) => id = e.id);
    character.characterid = id;
    character.uid = _user.uid;
    await characterCollection.doc(id).update(character.toJson());
    if(type == 0){
      _user.characterList.add(id);
      await userCollection.doc(_user.uid).update({"characterList" : _user.characterList});
    } else{
      _user.favoriteList.add(character.toJson());
      await userCollection.doc(_user.uid).update({"favoriteList" : _user.favoriteList});
    }
  }

  addTrade(Map<String, dynamic> character, Map<String, dynamic> form) async{
    String id;
    await tradeCollection.add({}).then((value){
      id = value.id;
    });
    form["docId"] = id;
    form['buy'] = 0;
    await tradeCollection.doc(id).set(form);
  }

  registerBus(BusModel busForm) async{
    String id;
    await busCollection.add({}).then((e) => id = e.id);
    busForm.docId = id;
    await busCollection.doc(id).set(busForm.toJson());
    _mainController.myUpload.add(busForm.toJson());
  }

  participationBus(String docId, Map<String,dynamic> character) async{
    await busCollection.doc(docId).update({"passengerList" : FieldValue.arrayUnion([character])});
  }

  participationMap(String docId, Map<String,dynamic> character) async{
    await mapCollection.doc(docId).update({"participation" : FieldValue.arrayUnion([character])});
  }

  addMap(Map<String, dynamic> character, String type, List loc, int time) async{
    Map<String, dynamic> mapData = {
      "docId" : "",
      "uploader" : character,
      "type" : type,
      "loc" : loc,
      "time" : time,
      "participation" : [character],
    };
    String id;
    await mapCollection.add({}).then((value){
      id = value.id;
    });
    mapData["docId"] = id;
    await mapCollection.doc(id).set(mapData);
  }

  Stream<QuerySnapshot> getmyParty(){
    if(_mainController.characterList.isNotEmpty)
      return busCollection.where("passengerList" , arrayContainsAny: _mainController.characterList).snapshots();
    return null;
  }

  Stream<QuerySnapshot> getBusData(String server, {String type, String sort}){
    if(server == "전섭"){
      if(type != null){
        return busCollection.orderBy('time', descending: false).where("busName", isEqualTo: type).snapshots();
      }
      return busCollection.orderBy("time", descending: false).snapshots();
    } else {
      if(type != null){
        return busCollection.orderBy('time', descending: false).where("server", arrayContains: server).where("busName", isEqualTo: type).snapshots();
      }
      return busCollection.orderBy("time", descending: false).where("server", arrayContains: server).snapshots();
    }
  }

  Stream<DocumentSnapshot> getBusDetail(String uid){
    return busCollection.doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getMapData(){
    return mapCollection.snapshots();
  }

  Stream<QuerySnapshot> getTradeData(){
    return tradeCollection.snapshots();
  }
}