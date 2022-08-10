import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/characterSelDialog.dart';
import 'package:lostarkbus/ui/map/addmapDialog.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/utils.dart';
import 'package:lostarkbus/widget/flushbar.dart';

import '../dialog/busCharacterSel.dart';

class MapPage extends StatefulWidget {

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          title(),
          filterwidget(),
          mapList(),
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
            child: Text("보물지도",
              style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          // Text(DateTime.now().hour.toString() + " : " + DateTime.now().minute.toString(),
          //   style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
          // ),
          TextButton(
            onPressed: () => Get.dialog(AddMap()),
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
            filter("지도 종류"),
            filter("시간순")
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

  Widget mapList(){
    return Flexible(
      fit: FlexFit.tight,
      child: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.instance.getMapData(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          List mapList = [];
          if(snapshot.hasData)
            for(int i=0; i < snapshot.data.size; i++){
              mapList.add(snapshot.data.docs[i].data());
            }
          if(mapList.length != 0)
            return GridView.count(
                crossAxisCount: 2,
                //childAspectRatio: 1, //item 의 가로 1, 세로 2 의 비율
                //mainAxisSpacing: 10, //수평 Padding
                //crossAxisSpacing: 10,
                children: List.generate(mapList.length, (index){
                  return mapContainer(mapList[index]);
                }),
            );
        }
      ),
    );
  }

  Widget mapContainer(Map<String, dynamic> mapData){
    return Padding(
      padding: const EdgeInsets.only(top : 15, left : 20.0, right: 20),
      child: Stack(
        children: [
          GestureDetector(
            onTap: (mapData['participation'].length < 4) ? () async{
              Map<String, dynamic> character = await Get.dialog(CharacterSelDialog());
              if(character != null){
                await DatabaseService.instance.participationMap(mapData['docId'], character);
              }
            } : () => CustomedFlushBar(context, "text")
            ,
            child: Container(
            decoration: BoxDecoration(
              color: AppColor.mainColor4,
              border: Border.all(
                  color: mapData['type'] == "희귀" ? AppColor.lightBlue
                      : mapData['type'] == "영웅" ? AppColor.purple : AppColor.yellow,
                width: 1
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(8.0)
              ),
              // border: Border.all(
              //   color: Colors.purple,
              //   width: 1
              // ),
            ),
            width: 150,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 20,),
                  customedText(mapData['loc'][0]),
                  customedText(mapData['loc'][1]),
                  customedText(Utils.timeinvert(mapData['time'])),
                  customedText('${mapData['participation'].length.toString()} / 4'),
                ],
            ),
        ),
          ),
        Positioned(
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                // color: mapData['type'] == "희귀" ? AppColor.lightBlue
                //     : mapData['type'] == "영웅" ? AppColor.purple : AppColor.yellow,
                // color: AppColor.mainColor5,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))
              ),
          height: 40, width: 150,
              child: Center(child: Text(mapData['uploader']['server'] ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Colors.white70
                  color: mapData['type'] == "희귀" ? AppColor.lightBlue
                      : mapData['type'] == "영웅" ? AppColor.purple : AppColor.yellow,
                ),
              )),
            )),
        ]
      ),
    );
  }

  Widget customedText(String text){
    return Text(text, style: TextStyle(color: Colors.white70),);
  }
}
