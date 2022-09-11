import 'package:flutter/material.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/baseSelectDialog.dart';
import 'package:lostarkbus/ui/dialog/jewelDialog.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/widget/flushbar.dart';

class PayDialog extends StatefulWidget {
  List driverList;
  String docId;
  int index;
  PayDialog(
      this.driverList,
      this.docId,
      this.index
      );
  @override
  State<PayDialog> createState() => _PayDialogState();
}

class _PayDialogState extends State<PayDialog> {
  String receiver = "캐릭터 선택";
  List nickList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.driverList.forEach((e) {
      nickList.add(e['nick']);
    });
  }

  @override
  Widget build(BuildContext context) {
    receiver = widget.driverList[0]['nick'];
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppColor.mainColor4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 70,
                  child: Center(child: Text("대상",
                    style: TextStyle(color: Colors.white70),
                  )),
                ),
                GestureDetector(
                  onTap: () async{
                    await Get.dialog(BaseSelectDialog(nickList)).then((e) {
                      if(e != null){
                        setState(() {
                          receiver = e;
                        });
                      }
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 130,
                    child: Center(
                      child: Text(receiver,
                        style: TextStyle(
                          color: (receiver == "캐릭터 선택") ? Colors.black87 : AppColor.lightBlue
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap:  (receiver != "캐릭터 선택") ? (){
                      DatabaseService.instance.registerPay1(widget.docId, widget.index, receiver);
                      Get.back();
                    } : () => CustomedFlushBar(context, "대금을 받을 캐릭터를 선택해주세요"),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: AppColor.mainColor4
                      ),
                      height: 60,
                      width: 90,
                      child: Center(child: Text("우편",
                        style: TextStyle(color: Colors.white70),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: (receiver != "캐릭터 선택") ? (){
                      Get.dialog(JewelDialog(
                        driverList: widget.driverList,
                        docId: widget.docId,
                        index: widget.index,
                        receiver: receiver,
                      ));
                    }: () => CustomedFlushBar(context, "대금을 받을 캐릭터를 선택해주세요"),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColor.mainColor4
                      ),
                      height: 60,
                      width: 90,
                      child: Center(child: Text("보석 거래",
                        style: TextStyle(color: Colors.white70),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }

}
