import 'package:flutter/material.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:get/get.dart';

import 'dialog/busCharacterSel.dart';

class Trade extends StatefulWidget {

  @override
  State<Trade> createState() => _TradeState();
}

class _TradeState extends State<Trade> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          title(),
          filterwidget(),
          tradeList(),
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
            child: Text("거래",
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
            filter("물품"),
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

  Widget tradeList(){
    return Flexible(
      fit: FlexFit.tight,
      child: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index){
            return tradeContainer();
          }),
    );
  }

  Widget tradeContainer(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
      child: Container(
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
    );
  }
}
