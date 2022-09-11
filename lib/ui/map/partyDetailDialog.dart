import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/colors.dart';

class PartyDetailDialog extends StatefulWidget {

  Map<String, dynamic> map;

  PartyDetailDialog(
      this.map,
      );

  @override
  State<PartyDetailDialog> createState() => _PartyDetailDialogState();
}

class _PartyDetailDialogState extends State<PartyDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              child: Column(
                children: [
                  //Text(widget.map["type"], style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("${widget.map["loc1"]}", style: TextStyle(fontSize: 20,
                      color: widget.map['type'] == "희귀" ? AppColor.lightBlue
                          : widget.map['type'] == "영웅" ? AppColor.purple
                          : widget.map['type'] == "전설" ? AppColor.yellow: Colors.deepOrange[800],
                      fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  Text("${widget.map["loc2"]}", style: TextStyle(fontSize: 20,
                      color: widget.map['type'] == "희귀" ? AppColor.lightBlue
                          : widget.map['type'] == "영웅" ? AppColor.purple
                          : widget.map['type'] == "전설" ? AppColor.yellow: Colors.deepOrange[800],
                      fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColor.mainColor4,
                  width: 2
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            height: 160,
            width: 200,
            child: ListView.builder(
              itemCount: widget.map['participation'].length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    height: 40,
                    child: Center(child: Text(widget.map['participation'][index]['nick'], style: TextStyle(color: Colors.white70),)),
                  );
                }),
          )
        ],
      ),
    );
  }
}
