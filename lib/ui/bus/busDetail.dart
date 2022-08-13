import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/util/colors.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              title(widget.bus['partyName'], widget.bus['busName']),
              driver(),
              passenger(),
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
          widget.bus['driverList'][i]['nick']));
    }
    if (widget.bus['driverList'].length > 2) {
      for (int i = 2; i < widget.bus['driverList'].length; i++) {
        column2.add(box(widget.bus['driverList'][i]['server'],
            widget.bus['driverList'][i]['nick']));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        categoryText("기사"),
        Container(
          height: 200,
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
                return GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    height: 200,
                    child: CircularProgressIndicator(),
                  ),
                );
              passengerList = snapshot.data.data()['passengerList'];
              for (int i = 0; i < passengerList.length; i++) {
                (i ~/ 2 == 0)
                    ? column1.add(box2(
                        passengerList[i]['server'],
                        passengerList[i]['nick'],
                        (widget.bus['driverList'].every((e) =>
                                e['server'] != passengerList[i]['server']))
                            ? "보석 교환"
                            : "우편"))
                    : column2.add(box2(
                        passengerList[i]['server'],
                        passengerList[i]['nick'],
                        (widget.bus['driverList'].every((e) =>
                                e['server'] == passengerList[i]['server']))
                            ? "보석 교환"
                            : "우편"));
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

  Widget box(String text1, String text2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Container(
        height: 70,
        width: 100,
        decoration: BoxDecoration(
          color: AppColor.blue2,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text1,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              text2,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget box2(String text1, String text2, String text3) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text1,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              text2,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  overflow: TextOverflow.ellipsis),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              text3,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget jewelDialog(){
    return AlertDialog(

    );
  }
}
