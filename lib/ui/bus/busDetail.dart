import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/busModel.dart';
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
  List driverList = [];
  @override
  Widget build(BuildContext context) {
    driverList = widget.bus['driverList'];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              title(widget.bus['driverList'][0]["nick"], widget.bus['busName']),
              driver(driverList),
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
          TitleText("방 제목 : $text1"),
          TitleText(text2),
        ],
      ),
    );
  }

  Widget driver(List driverList) {
    var column1 = <Padding>[];
    var column2 = <Padding>[];
    for (int i = 0;
        i <
            ((driverList.length >= 2)
                ? 2
                : driverList.length);
        i++) {
      column1.add(box(driverList[i]['server'],
        driverList[i]['nick'],
        driverList[i]['lostArkClass'],
        driverList[i]['characterid'],
          driverList[i]['level']
      )
      );
    }
    if (driverList.length > 2) {
      for (int i = 2; i < driverList.length; i++) {
        column2.add(box(driverList[i]['server'],
          driverList[i]['nick'],
          driverList[i]['lostArkClass'],
          driverList[i]['characterid'],
            driverList[i]['level']
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

  Widget box(String text1, String text2, String text3, String characterId, int savedLevel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: AppColor.blue2.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(
            width: 2,
            color: AppColor.blue3,
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
            StreamBuilder<DocumentSnapshot>(
              stream: DatabaseService.instance.getCharacter(characterId),
              builder: (context, snapshot) {
                String level = savedLevel.toString();
                if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
                  return Text("");
                level = snapshot.data.data() != null ? snapshot.data.data()['level'].toString() : savedLevel.toString();
                return Text(
                  level,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis),
                );
              }
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
      child: GestureDetector(
        onTap: () => Get.dialog(acceptDialog(text1, text2, text3, text4, index)),
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
      ),
    );
  }

  Widget acceptDialog(String text1, String text2, String text3, String text4, int index){
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${text2}", style: TextStyle(color: Colors.lightBlue, fontSize: 18),),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text("$text1 $text4 $text3", style: TextStyle(color: Colors.white70),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Container(height: 1, color: AppColor.mainColor5,),
          ),
          Text("지원을 수락하시겠습니까?", style: TextStyle(color: Colors.white),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () async{
                    Map<String, dynamic> character = widget.bus['applyList'][index];
                    await DatabaseService.instance.acceptApply(widget.bus['docId'], index, character);
                    setState(() {
                      driverList.add(character);
                    });
                    Get.back();
                  },
                  child: Text("수락")),
              TextButton(
                  onPressed: () async{
                    await DatabaseService.instance.refuseApply(widget.bus['docId'], index);
                    Get.back();
                  },
                  child: Text("거절")),
            ],
          )
        ],
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
