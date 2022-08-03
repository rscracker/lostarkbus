import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/characterModel.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/bus/addBus.dart';
import 'package:lostarkbus/ui/bus/busDetail.dart';
import 'package:lostarkbus/ui/dialog/busCharacterSel.dart';
import 'package:lostarkbus/util/colors.dart';

class Bus extends StatefulWidget {
  @override
  State<Bus> createState() => _BusState();
}

class _BusState extends State<Bus> {

  MainController _mainController = Get.find();

  UserModel get _user => _mainController.user.value;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          title(),
          filterwidget(),
          busList(),
        ],
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("버스",
              style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          // Text(DateTime.now().hour.toString() + " : " + DateTime.now().minute.toString(),
          //   style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
          // ),
          TextButton(
            onPressed: () => Get.dialog(BusCharacterSelDialog()),
            child: Text("등록",
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget filterwidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            filter("서버"),
            filter("버스 종류"),
            filter("가격순")
          ],
        ),
      ),
    );
  }
  Widget filter(String text) {
    return Container(
      height: 50,
      width: Get.width / 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) // POINT
        ),
        color: AppColor.mainColor2,
      ),
      child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 13),)),
    );
  }

  Widget busList() {
    return Flexible(
      fit: FlexFit.tight,
      child: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.instance.getBusData(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List busList = [];
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          snapshot.data.docs.forEach((e) {
            busList.add(e.data());
          });
          if(busList.length == 0)
            return Container(child: Center(child: Text("버스가 없습니다")),);
          return Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: busList.length,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                      onTap: () => Get.dialog(participationDialog(busList[index]["docId"])),
                      child: busTile(busList[index]));
                }),
          );
        }
      ),
    );
  }

  Widget tile() {
    return ListTile(
      shape: RoundedRectangleBorder(
        //side: BorderSide(color: AppColor.mainColor3, width: 1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      //tileColor: AppColor.mainColor2,
      //tileColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top : 8.0, bottom: 5.0),
            child: Text("발탄(하드)", style: TextStyle(color: AppColor.mainColor5, fontSize: 20, fontWeight: FontWeight.bold) ,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text("실리안", style: TextStyle(color: AppColor.mainColor5, fontSize: 15,)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text("15:00",style: TextStyle(color: AppColor.mainColor5, fontSize: 15,)),
          ),
          Text("참여 2/5 뼈독 0/1", style: TextStyle(color: AppColor.mainColor5, fontSize: 15,)),
          SizedBox(height: 5,)
        ],
      ),
    );
  }

  Widget busTile(Map<String, dynamic> bus){
    var member = List.from(bus["driverList"])..addAll(bus["passengerList"]);
    if(bus["driverList"].length + bus["passengerList"].length< 8){
      while(member.length != 8){
        member.add({"nick" : ""});
      }
    }
    var column1 = <Container>[];
    var column2 = <Container>[];
    for(int i = 0; i < 4; i++){
      (i < bus["driverList"].length) ?
      column1.add(Container(height: 15 , child: Text(member[i]["nick"], style: const TextStyle(color: Colors.lightBlue, fontSize: 12,overflow: TextOverflow.ellipsis))))
      : column1.add(Container(height: 15 ,child: Text(member[i]["nick"], style: const TextStyle(color: Colors.white70, fontSize: 12,overflow: TextOverflow.ellipsis))))
      ;
    }
    for(int i = 4; i < 8; i++){
      column2.add(Container(height: 15 ,child: Text(member[i]["nick"], style: const TextStyle(color: Colors.white70, fontSize: 12,overflow: TextOverflow.ellipsis))));
    }


    var price = <Padding>[];
    for(int i = 0; i < bus["price1"].length; i++){
      bus["price1"][i].forEach((key, value){
        price.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value != 0 ? "$key : ${value}g" : "무료", style: TextStyle(color: AppColor.yellow, fontSize: 13,)),
        ));
      });

    }
    // driverList.forEach((e) {
    //   return column1.add(new Text(e['nick']));
    // });
    // int i = 4 - driverList.length;
    // if(passengerList.length != 0){
    //   for(int j = 0; j < i; j++){
    //     column1.add(new Text(passengerList[j]['nick']));
    //     passengerList.removeAt(j);
    //   }
    //   passengerList.forEach((e) {
    //     return column2.add(Text(e['nick']));
    //   });
    // }
    // list.forEach((i) {
    //   var textEditingController = new TextEditingController(text: "test $i");
    //   textEditingControllers.add(textEditingController);
    //   return textFields.add(new TextField(controller: textEditingController));
    // });

    return GestureDetector(
      onTap: !(bus['passengerList'].every((e) => _mainController.characterList.contains(e))) ? () => Get.to(() => BusDetail(bus: bus,)) : () => Get.dialog(participationDialog(bus['docId'])),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: Container(
          //height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)
            ),
            color: AppColor.mainColor2,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tileTop(bus["busName"], bus["server"], bus["time"]),
                Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: price,
                      ),
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.only(top : 10.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: column1,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: column2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerDialog(){
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Get.back();
              Get.to(() => AddBus());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text("1인 버스", style: TextStyle(color: AppColor.mainColor5, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text("기사 보유", style: TextStyle(color: AppColor.mainColor5, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text("기사 모집", style: TextStyle(color: AppColor.mainColor5, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget participationDialog(String docId){
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      title: Text("내 캐릭터", style: TextStyle(color: Colors.white),),
      content: Container(
        height: 250,
        width: 200,
        child: ListView.builder(
            itemCount: _mainController.characterList.length,
            itemBuilder: (BuildContext context, int index){
              return selectTile(_mainController.characterList[index], index, docId);
            }),
      ),
    );
  }

  Widget selectTile(Map<String, dynamic> character, int index, String docId){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: () async{
          await DatabaseService.instance.participationBus(docId, character);
          Get.back();
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.mainColor4,
            borderRadius: BorderRadius.all(
                  Radius.circular(5.0)
            ),
          ),
          height: 45,
          width: 150,
          child: Center(child: Text("${_mainController.characterList[index]["server"]} / ${_mainController.characterList[index]["nick"]} ", style: TextStyle(
            color: Colors.white
          ),)),
        ),
      ),
    );
  }

  Widget tileTop(String boss, List server, int time){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(top : 8.0),
          child: Text(boss, style: TextStyle(color: AppColor.mainColor5, fontSize: 18, fontWeight: FontWeight.bold) ,),
        ),
        Container(
          width: 130,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0),
            child: Center(
              child: Text((server.length != 0) ? server.toString().replaceAll("[", "").replaceAll("]", "") : "전섭"
                  , style: TextStyle(color: AppColor.mainColor5, fontSize: 16, overflow: TextOverflow.ellipsis)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0),
          child: Text("${(time~/100).toString()} : ${(time - (time~/100)*100).toString()}",style: TextStyle(color: AppColor.mainColor5, fontSize: 16,)),
        ),
      ],
    );
  }


}


