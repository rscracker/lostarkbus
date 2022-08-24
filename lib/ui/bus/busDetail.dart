import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/payDialog.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:lostarkbus/widget/flushbar.dart';
import 'package:lostarkbus/widget/title.dart';

class BusDetail extends StatefulWidget {
  Map<String, dynamic> bus;

  BusDetail({
    this.bus,
  });

  @override
  State<BusDetail> createState() => _BusDetailState();
}

class _BusDetailState extends State<BusDetail> {

  MainController _mainController = Get.find();
  UserModel get _user => _mainController.user.value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              title(widget.bus['partyName'], widget.bus['busName']),
              driver(),
              widget.bus['type'] == 0 ? passenger() : apply(),
            ],
          ),
        ),
      ),
    );
  }

  Widget title(String text1, text2) {
    return Center(
      child: Column(
        children: [
          TitleText(text1),
          TitleText(text2),
        ],
      ),
    );
  }

  Widget driver() {
    var column1 = <Padding>[];
    var column2 = <Padding>[];
    for (int i = 0;
        i <
            ((widget.bus['driverList'].length >= 2)
                ? 2
                : widget.bus['driverList'].length);
        i++) {
      column1.add(box(widget.bus['driverList'][i]['server'],
          widget.bus['driverList'][i]['nick'],
          widget.bus['driverList'][i]['lostArkClass'],
      widget.bus['driverList'][i]['level'].toString(),)
      );
    }
    if (widget.bus['driverList'].length > 2) {
      for (int i = 2; i < widget.bus['driverList'].length; i++) {
        column2.add(box(widget.bus['driverList'][i]['server'],
            widget.bus['driverList'][i]['nick'],
            widget.bus['driverList'][i]['lostArkClass'],
            widget.bus['driverList'][i]['level'].toString(),

        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        categoryText("기사"),
        Container(
          height: 250,
          child: Row(
            children: [
              Container(
                width: Get.width / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: column1,
                ),
              ),
              Container(
                width: Get.width / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: column2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget passenger() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        categoryText("승객"),
        StreamBuilder<DocumentSnapshot>(
            stream: DatabaseService.instance.getBusDetail(widget.bus['docId']),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              List passengerList = [];
              var column1 = <Padding>[];
              var column2 = <Padding>[];
              if (snapshot.connectionState == ConnectionState.waiting)
                return Container(
                  height: 200,
                  child: CircularProgressIndicator(),
                );
              passengerList = snapshot.data.data()['passengerList'];
              for (int i = 0; i < passengerList.length; i++) {
                if(i % 2 == 0){
                  column1.add(box2(
                    passengerList[i]['server'],
                    passengerList[i]['nick'],
                    passengerList[i]['payment']
                    , i,
                    isMine: passengerList[i]['uid'] == _user.uid ? true : false,
                  ));
                } else {
                  column2.add(box2(
                    passengerList[i]['server'],
                    passengerList[i]['nick'],
                    passengerList[i]['payment']
                    , i,
                    isMine: passengerList[i]['uid'] == _user.uid ? true : false,
                  )
                  );
                }
              }
              return Container(
                height: 300,
                child: Row(
                  children: [
                    Container(
                      width: Get.width / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: column1,
                      ),
                    ),
                    Container(
                      width: Get.width / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: column2,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

  Widget apply() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        categoryText("지원자"),
        StreamBuilder<DocumentSnapshot>(
            stream: DatabaseService.instance.getBusDetail(widget.bus['docId']),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              List applyList = [];
              var column1 = <Padding>[];
              var column2 = <Padding>[];
              if (snapshot.connectionState == ConnectionState.waiting)
                return Container(
                  height: 200,
                  child: CircularProgressIndicator(),
                );
              applyList = snapshot.data.data()['applyList'];
              for (int i = 0; i < applyList.length; i++) {
                (i % 2 == 0)
                    ? column1.add(applicantBox(
                    applyList[i]['server'],
                    applyList[i]['nick'],
                    applyList[i]['lostArkClass'],
                    applyList[i]['level'].toString(),
                    i
                )
                )
                    : column2.add(applicantBox(
                    applyList[i]['server'],
                    applyList[i]['nick'],
                    applyList[i]['lostArkClass'],
                    applyList[i]['level'].toString(),
                    i
                )
                );
              }
              return Container(
                height: 300,
                child: Row(
                  children: [
                    Container(
                      width: Get.width / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: column1,
                      ),
                    ),
                    Container(
                      width: Get.width / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: column2,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

  Widget categoryText(String text) {
    return Container(
      height: 55,
      width: Get.width,
      //color: AppColor.mainColor3,
      child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(text,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                height: 1,
                width: Get.width - 10,
                color: Colors.white70,
              ),
            ],
          )),
    );
  }

  Widget box(String text1, String text2, String text3, String text4) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: AppColor.blue2,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              text1,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              text2,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                  overflow: TextOverflow.ellipsis),
            ),
            Text(
              text3,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis),
            ),
            Text(
              text4,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget box2(String text1, String text2, List payment, int index, {bool isMine = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: payment.length == 0 ? () {
          Get.dialog(PayDialog(widget.bus['driverList'],
            widget.bus['docId'],
            index));
        } : payment[1] == "우편" ? null
        : () => Get.dialog(jewelInfo(payment[1], payment[2]))
        ,
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: AppColor.mainColor4,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(
              color: isMine ? AppColor.lightBlue : Colors.transparent,
              width: 1
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                text1,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                text2,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    overflow: TextOverflow.ellipsis),
              ),
              payment.length == 0 ? Container() : Text(
                payment[1] == "우편" ? "우편" : "보석 거래",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueAccent,
                    overflow: TextOverflow.ellipsis),
              ),
              payment.length == 0 ? Container() :Text(
                payment[0],
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueAccent,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget applicantBox(String text1, String text2, String text3, String text4, int index){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: AppColor.blue2,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              text1,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              text2,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                  overflow: TextOverflow.ellipsis),
            ),
            Text(
              text3,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  overflow: TextOverflow.ellipsis),
            ),
            Text(
              text4,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget jewelInfo(String jewel, String price){
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(jewel, style: TextStyle(color: Colors.white70),),
          SizedBox(height: 25,),
          Text(price, style: TextStyle(color: AppColor.yellow)),
        ],
      ),
    );
  }

}
