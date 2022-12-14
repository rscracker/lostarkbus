import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/busModel.dart';
import 'package:lostarkbus/model/characterModel.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/bus/addBus.dart';
import 'package:lostarkbus/ui/bus/busDetail.dart';
import 'package:lostarkbus/ui/bus/recruitDialog.dart';
import 'package:lostarkbus/ui/dialog/baseSelectDialog.dart';
import 'package:lostarkbus/ui/dialog/busCharacterSel.dart';
import 'package:lostarkbus/ui/dialog/characterSelDialog.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:lostarkbus/util/lostarkList.dart';
import 'package:lostarkbus/util/utils.dart';
import 'package:lostarkbus/widget/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bus extends StatefulWidget {
  @override
  State<Bus> createState() => _BusState();
}

class _BusState extends State<Bus> {

  MainController _mainController = Get.find();

  UserModel get _user => _mainController.user.value;

  String server_filter = "전체 서버";
  String type_filter = "버스 종류";
  String sort_filter = "시간순";

  @override
  void initState(){
    super.initState();
    getFilter();
  }

  void getFilter() async{
      final prefs = await SharedPreferences.getInstance();
      server_filter = prefs.getString('serverFilter') ?? "전체 서버";
      type_filter = prefs.getString('typeFilter')?? "버스 종류";
      sort_filter = prefs.getString('sortFilter')?? "시간순";
      //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          title(),
          filterwidget(),
          divider(),
          busList(),
        ],
      ),
    );
  }
  Widget divider(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        height: 1,
        //color: AppColor.mainColor3,
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
            onPressed: () => Get.dialog(BusCharacterSelDialog()), //Todo => characterSelDialog로 바꾸기
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
            filter(server_filter,0),
            filter(type_filter,1),
            filter(sort_filter,2)
          ],
        ),
      ),
    );
  }
  Widget filter(String text, int type) {
    return GestureDetector(
      onTap: (type == 0) ? () async{
        await Get.dialog(BaseSelectDialog(List.from(["전체 서버"])..addAll(LostArkList.serverList), save: true, saveKey: "serverFilter",)).then((e){
          if(e!=null){
            setState(() {
              server_filter = e;
            });
          }
        });
      } : (type ==1) ? () async{
        await Get.dialog(BaseSelectDialog(List.from(["전체"])..addAll(LostArkList.type),save: true, saveKey: "typeFilter", )).then((e){
          if(e!=null){
            setState(() {
              type_filter = e;
            });
          }
        });
      } : null,
      //     () async{
      //   await Get.dialog(BaseSelectDialog(['시간순', '가격순'], save: true, saveKey: "sortFilter",)).then((e){
      //     if(e!=null){
      //       setState(() {
      //         sort_filter = e;
      //       });
      //     }
      //   });
      // },
      child: Container(
        height: 50,
        width: Get.width / 4,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white70,
            width: 1
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(10.0) // POINT
          ),
          color: AppColor.mainColor2,
        ),
        child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 13, overflow: TextOverflow.ellipsis),)),
      ),
    );
  }

  Widget busList() {
    return Flexible(
      fit: FlexFit.tight,
      child: StreamBuilder<QuerySnapshot>(
                stream: DatabaseService.instance.getBusData(server_filter,
                    type: (type_filter == "전체" || type_filter == "버스 종류") ? null : type_filter,),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List busList = [];
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(color: Colors.white,),);
          if(!snapshot.hasData || snapshot.data.size == 0)
            return Container(child: Center(child: Text("버스가 없습니다", style: TextStyle(color: Colors.white70, fontSize: 16),)),);
          return Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index){
                  Map data = snapshot.data.docs[index].data();
                  BusModel busData= BusModel.fromJson(snapshot.data.docs[index].data());
                  if(busData.type == 0){
                    return GestureDetector(
                        onTap: () {
                          if((LostArkList.fourMemType.contains(busData.busName))){
                            if(busData.driverList.length + busData.passengerList.length <= 4){
                              (data['passengerUidList'].length == 0) ? Get.dialog(participationDialog(busData.docId, busData.server)) :
                              (data['passengerUidList'].contains(_user.uid)) ?
                              Get.to(() => BusDetail(bus: data,)) :
                              Get.dialog(participationDialog(busData.docId, busData.server));
                            } else {
                              CustomedFlushBar(context, "정원이 모두 찼습니다.");
                            }
                          } else {
                            if(data["driverList"].length + data["passengerList"].length <= 8){
                              (data['passengerUidList'].length == 0) ? Get.dialog(participationDialog(busData.docId, busData.server)) :
                              (data['passengerUidList'].contains(_user.uid)) ?
                              Get.to(() => BusDetail(bus: data,)) :
                              Get.dialog(participationDialog(data['docId'], data['server']));
                            } else {
                              CustomedFlushBar(context, "정원이 모두 찼습니다.");
                            }
                          }
                        },
                        child: busTile(data));
                  } else {
                    return recruitTile(busData);
                  }
                }),
          );
        }
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
    var numInfo = <Padding>[];
    if(bus['price1'].length == 0){
      price.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("무료", style: TextStyle(color: AppColor.yellow, fontSize: 13,), overflow: TextOverflow.clip),
      ));
    } else {
      for(int i = 0; i < bus["price1"].length; i++){
        if(bus["numPassenger"][i] != 0){
          bus["price1"][i].forEach((key, value){
            price.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(value != 0 ? "$key : ${value}g" : "무료", style: TextStyle(color: AppColor.yellow, fontSize: 13,), overflow: TextOverflow.clip),
            ));
          });
        }
      }
    }
    if(bus["price2"].length != 0){
      if(bus["numPassenger"][bus["numPassenger"].length-1] != 0){
        price.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("독식 : ${bus["price2"][0]}g", style: TextStyle(color: AppColor.dark_pink, fontSize: 13,), overflow: TextOverflow.ellipsis,),
        ));
      }
    }
    // else if(bus["price2"].length == 0 && LostArkList.specificType.contains(bus["busName"])){
    //   price.add(Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Text("자율", style: TextStyle(color: AppColor.dark_pink, fontSize: 13,), overflow: TextOverflow.ellipsis,),
    //   ));
    // }
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
    ///Todo GestureDetector
    return GestureDetector(
      onTap: (bus['passengerUidList'].length == 0) ? () => Get.dialog(participationDialog(bus['docId'], bus['server'])) :
      (bus['passengerUidList'].contains(_user.uid)) ? () => Get.to(() => BusDetail(bus: bus,)) : () => Get.dialog(participationDialog(bus['docId'], bus['server'])),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: Container(
          //height: 120,
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: Colors.white70,
            //   width: 1.5
            // ),
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)
            ),
            color: AppColor.blue4.withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tileTop(bus["busName"], bus["server"], bus["time"]),
                Padding(
                  padding: const EdgeInsets.only(top : 8.0),
                  child: Container(height: 1, color: Colors.white70,),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: price,
                      ),
                    ),
                    // Flexible(
                    //     fit: FlexFit.tight,
                    //     child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.only(top : 2.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: (Get.width - 195) / 2,
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: column1,
                            ),
                          ),
                          SizedBox(
                            width: (Get.width - 195) / 2,
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
                ),
                // Container(
                //   height: 15,
                //   child: Center(
                //     child: Row(
                //       children: numInfo,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool checkApply(List applyList, List driverList){
    for(int i = 0; i < applyList.length; i++){
      print(applyList[i]['uid']);
      if(applyList[i]['uid'] == _user.uid){
        return true;
      }
    }
    for(int i = 0; i < driverList.length; i++){
      if(driverList[i]['uid'] == _user.uid){
        return true;
      }
    }
    return false;
  }

  Widget recruitTile(BusModel bus){
    bool _checkApply = true;
    return GestureDetector(
      onTap: () async{
        if(checkApply(bus.applyList, bus.driverList)){
          Get.to(() => BusDetail(bus : bus.toJson()));
        } else if(bus.driverList.length < bus.numDriver){
          Get.dialog(RecruitDialog(bus));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)
            ),
            color: AppColor.mainColor4,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                tileTop(bus.busName, bus.server, bus.time),
                Padding(
                  padding: const EdgeInsets.only(top : 8.0),
                  child: Container(height: 1, color: Colors.white70,),
                ),
                Container(height: 50,
                  child: Center(
                    child: Text("기사모집 (${bus.driverList.length.toString()} / ${bus.numDriver.toString()})", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                  )
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

  Widget participationDialog(String docId, List server){
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      title: Text("내 캐릭터", style: TextStyle(color: Colors.white),),
      content: Container(
        height: 250,
        width: 200,
        child: ListView.builder(
            itemCount: _mainController.characterList.length,
            itemBuilder: (BuildContext context, int index){
              return selectTile(_mainController.characterList[index], index, docId, server);
            }),
      ),
    );
  }

  Widget selectTile(Map<String, dynamic> character, int index, String docId, List server){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: (server.contains(_mainController.characterList[index]["server"])) ? () async{
          await DatabaseService.instance.participationBus(docId, character, server.length == LostArkList.serverList.length ? 0 : server.indexOf(character['server']));
          Get.back();
        } : () {
          Get.back();
          CustomedFlushBar(context, "버스의 서버와 일치하지 않는 캐릭터입니다");
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.only(left : 8.0 , top : 8.0),
            child: Text(boss, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
          ),
        ),
        // Container(
        //   width: 150,
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(10,10,8.0,0),
        //     child: Text((server.length != 0) ? server.toString().replaceAll("[", "").replaceAll("]", "") : "전체 서버"
        //         , style: TextStyle(color: AppColor.mainColor5, fontSize: 16, overflow: TextOverflow.ellipsis)),
        //   ),
        // ),
        Flexible(
            fit: FlexFit.tight,
            child: SizedBox()),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Icon(
            Icons.access_time_rounded,
            color: Colors.white70,
            size: 17,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0),
          child: Text(Utils.timeinvert(time),style: TextStyle(color: AppColor.mainColor5, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }


}


