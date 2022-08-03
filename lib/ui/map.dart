import 'package:flutter/material.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:get/get.dart';

import 'dialog/busCharacterSel.dart';

class Map extends StatefulWidget {

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
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
      child: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index){
            return mapContainer();
          }),
    );
  }

  Widget mapContainer(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
      child: Stack(
        children: [Container(
          decoration: BoxDecoration(
            color: AppColor.mainColor4,
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)
            ),
            // border: Border.all(
            //   color: Colors.purple,
            //   width: 1
            // ),
          ),
          height: 80,
          child: Row(

          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.lightYellow,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0))
              ),
          height: 30, width: 100,
              child: Center(child: Text("전설",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.yellow),
              )),

            ))
        ]
      ),
    );
  }
}
