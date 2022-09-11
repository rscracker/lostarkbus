import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/baseSelectDialog.dart';
import 'package:lostarkbus/ui/dialog/characterSelDialog.dart';
import 'package:lostarkbus/ui/map/addmapDialog.dart';
import 'package:lostarkbus/ui/map/partyDetailDialog.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/lostarkList.dart';
import 'package:lostarkbus/util/utils.dart';
import 'package:lostarkbus/widget/circularProgress.dart';
import 'package:lostarkbus/widget/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog/busCharacterSel.dart';

class MapPage extends StatefulWidget {

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  MainController _mainController = Get.find();

  UserModel get _user => _mainController.user.value;

  String server_filter = "전체 서버";
  String type_filter = "전체(종류)";
  String region_filter = "전체(지역)";

  @override
  void initState(){
    super.initState();
    getFilter();
  }

  void getFilter() async{
    final prefs = await SharedPreferences.getInstance();
    server_filter = prefs.getString('mapServerFilter') ?? "전체 서버";
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
            //onPressed: () => Get.dialog(CustomedCircular()),
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
        await Get.dialog(BaseSelectDialog(List.from(["전체 서버"])..addAll(LostArkList.serverList), save: true, saveKey: "mapServerFilter",)).then((e){
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
        await Get.dialog(BaseSelectDialog(LostArkList.region1, save: true, saveKey: "regionFilter",)).then((e){
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
            server_filter == "전체 서버" ? null : server_filter,
            type_filter == "전체(종류)" ? null : type_filter,
            region_filter == "전체(지역)" ? null: region_filter,
        ),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(
              color: Colors.white,
            ),);
          if(!snapshot.hasData || snapshot.data.size == 0){
            return Center(child: Text("등록된 지도가 없습니다", style: TextStyle(color: Colors.white70),),);
          }
          return GridView.builder(
              itemCount: snapshot.data.size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,),
              itemBuilder: (context, int index){
                if(snapshot.data.docs[index] != null)
                 return mapContainer(snapshot.data.docs[index].data());
          },
          );
        }
      ),
    );
  }

  Widget mapContainer(Map<String, dynamic> mapData){
    List participationUid = [];
    mapData['participation'].forEach((e){
      participationUid.add(e['uid']);
    });
    return Padding(
      padding: const EdgeInsets.only(top : 15, left : 20.0, right: 20),
      child: Stack(
        children: [
          GestureDetector(
            onTap: (participationUid.contains(_user.uid)) ? () => Get.dialog(PartyDetailDialog(mapData)): 
            (mapData['participation'].length < 4) ? () async{
              Map<String, dynamic> character = await Get.dialog(CharacterSelDialog());
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
              color: mapData['type'] == "희귀" ? Colors.lightBlue.withOpacity(0.1)
                  : mapData['type'] == "영웅" ? Colors.purple.withOpacity(0.1)
                  : mapData['type'] == "전설" ? Colors.yellow.withOpacity(0.1) : Colors.deepOrange[800].withOpacity(0.1),
              // color: AppColor.mainColor4,
              border: Border.all(
                  color: mapData['type'] == "희귀" ? AppColor.lightBlue
                      : mapData['type'] == "영웅" ? AppColor.purple
                      : mapData['type'] == "전설" ? AppColor.yellow : Colors.deepOrange[800],
                // color: AppColor.mainColor5,
                width: 1.5
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
                  Container(height: 1, color: AppColor.mainColor3,),
                  customedText(mapData['loc1']),
                  customedText(mapData['loc2']),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time_sharp, color: Colors.white70, size: 15,),
                      SizedBox(width: 6,),
                      customedText(Utils.timeinvert(mapData['time'])),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.supervisor_account_rounded, color: Colors.white70, size: 16,),
                      SizedBox(width: 4,),
                      customedText('${mapData['participation'].length.toString()} / 4'),
                    ],
                  ),
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
                    //color: Colors.white
                  color: mapData['type'] == "희귀" ? AppColor.lightBlue
                      : mapData['type'] == "영웅" ? AppColor.purple
                      : mapData['type'] == "전설" ? AppColor.yellow : Colors.deepOrange[800],
                ),
              )),
            )),
        ]
      ),
    );
  }

  Widget customedText(String text, {Color color}){
    return Text(text, style: TextStyle(color: color ?? Colors.white),);
  }
}
