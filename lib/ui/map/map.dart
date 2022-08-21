import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/baseSelectDialog.dart';
import 'package:lostarkbus/ui/dialog/characterSelDialog.dart';
import 'package:lostarkbus/ui/map/addmapDialog.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/lostarkList.dart';
import 'package:lostarkbus/util/utils.dart';
import 'package:lostarkbus/widget/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog/busCharacterSel.dart';

class MapPage extends StatefulWidget {

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  MainController _mainController = Get.find();

  String server_filter = "전섭";
  String type_filter = "전체(종류)";
  String region_filter = "전체(지역)";

  @override
  void initState(){
    super.initState();
    getFilter();
  }

  void getFilter() async{
    final prefs = await SharedPreferences.getInstance();
    server_filter = prefs.getString('mapServerFilter') ?? "전섭";
    type_filter = prefs.getString('mapTypeFilter')?? "전체(종류)";
    region_filter = prefs.getString('regionFilter')?? "전체(지역)";
    setState(() {});
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
            filter(server_filter,0),
            filter(type_filter,1),
            filter(region_filter,2)
          ],
        ),
      ),
    );
  }
  Widget filter(String text, int type) {
    return GestureDetector(
      onTap: (type == 0) ? () async{
        await Get.dialog(BaseSelectDialog(List.from(["전섭"])..addAll(LostArkList.serverList), save: true, saveKey: "mapServerFilter",)).then((e){
          if(e!=null){
            setState(() {
              server_filter = e;
            });
          }
        });
      } : (type ==1) ? () async{
        await Get.dialog(BaseSelectDialog(['전체(종류)', '희귀', '영웅', '전설'], save: true, saveKey: "mapTypeFilter", )).then((e){
          if(e!=null){
            setState(() {
              type_filter = e;
            });
          }
        });
      } : () async{
        await Get.dialog(BaseSelectDialog(['전체(지역)', '파푸니카', '베른 남부'], save: true, saveKey: "regionFilter",)).then((e){
          if(e!=null){
            setState(() {
              region_filter = e;
            });
          }
        });
      },
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

  Widget mapList(){
    return Flexible(
      fit: FlexFit.tight,
      child: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.instance.getMapData(
            server_filter == "전섭" ? null : server_filter,
            type_filter == "전체(종류)" ? null : type_filter,
            region_filter == "전체(지역)" ? null: region_filter,
        ),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(
              color: Colors.white,
            ),);
          if(snapshot.data.size == 0 || !snapshot.hasData){
            return Center(child: Text("등록된 지도가 없습니다", style: TextStyle(color: Colors.white70),),);
          }
          List<Padding> mapList = List.generate(snapshot.data.docs.length, (index) {
            return mapContainer(snapshot.data.docs[index].data());
          });
          return GridView.count(
                crossAxisCount: 2,
                children: mapList,
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
            onTap:
            (mapData['participation'].length < 4) ? () async{
              Map<String, dynamic> character = await Get.dialog(CharacterSelDialog());
              // if(mapData['participation'].contains(character)){
              //   CustomedFlushBar(context, "이미 참여한 캐릭터입니다");
              // }
              if(character != null && !mapData['participation'].contains(character)){
                if(character['server'] == mapData['uploader']['server']){
                  await DatabaseService.instance.participationMap(mapData['docId'], character); 
                } else {
                  CustomedFlushBar(context, "서버가 다릅니다");
                }
              }
            } : () => CustomedFlushBar(context, "인원이 다 찼습니다")
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
                  customedText(mapData['loc1']),
                  customedText(mapData['loc2']),
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
