import 'package:flutter/material.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/baseSelectDialog.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/lostarkList.dart';

// Todo receiver =>  driverList[index][nick]

class JewelDialog extends StatefulWidget {

  List driverList;
  String docId;
  int index;
  String receiver;
  JewelDialog({
    this.driverList,
    this.docId,
    this.index,
    this.receiver,
  });
  @override
  State<JewelDialog> createState() => _JewelDialogState();
}

class _JewelDialogState extends State<JewelDialog> {
  String lostArkClass = "직업";
  String type = "종류";
  String skill = "스킬";

  TextEditingController price1Controller = TextEditingController();
  TextEditingController price2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    lostArkClass = widget.driverList[widget.index]['lostArkClass'];
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap : () => Get.dialog(BaseSelectDialog(LostArkList.jewel1)).then((e){
                      if(e!= null){
                        setState(() {
                          type = e;
                        });

                      }
                    }),
                  child: Container(
                    color: AppColor.mainColor4,
                    height: 50,
                    width: 180,
                    child: Center(child: Text(type,
                      style: TextStyle(color: Colors.white70),
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: GestureDetector(
                    onTap: () => Get.dialog(BaseSelectDialog(LostArkList.classList)).then((e){
                      if(e!= null){
                        setState(() {
                          lostArkClass = e;
                        });

                      }
                    }),
                    child: Container(
                      color: AppColor.mainColor4,
                      height: 50,
                      width: 180,
                      child: Center(child: Text(lostArkClass,
                        style: TextStyle(color: Colors.white70),
                      )),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()=> Get.dialog(BaseSelectDialog(LostArkList.skill[lostArkClass])).then((e){
                    if(e!= null){
                      setState(() {
                        skill = e;
                      });
                    }
                  }),
                  child: Container(
                    color: AppColor.mainColor4,
                    height: 50,
                    width: 180,
                    child: Center(child: Text(skill,
                      style: TextStyle(color: Colors.white70),
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    color: AppColor.mainColor4,
                    height: 50,
                    width: 180,
                    child: Center(child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 50,
                            child: TextField(
                              style: TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                              cursorColor: AppColor.mainColor5,
                              controller: price1Controller,
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.transparent)
                                ),
                                focusColor: AppColor.mainColor,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.transparent)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.transparent)
                                ),
                              ),
                            ),
                          ),
                          Text("/", style: TextStyle(color: Colors.white70),),
                          Container(
                            width: 80,
                            height: 50,
                            child: TextField(
                              style: TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                              cursorColor: AppColor.mainColor5,
                              controller: price2Controller,
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.transparent)
                                ),
                                focusColor: AppColor.mainColor,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.transparent)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.transparent)
                                ),
                              ),
                            ),
                          )

                        ],
                      )
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async{
                    List jewel = [lostArkClass+ " "  + type + " " + skill,
                      price1Controller.text + "/" + price2Controller.text,
                    ];
                    await DatabaseService.instance.registerPay2(widget.docId, widget.index, widget.receiver, jewel);
                    Get.back();
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColor.blue3,
                    ),
                    height: 50,
                    width: 180,
                    child: Center(child: Text("확인",
                      style: TextStyle(color: Colors.white70),
                    )),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 12.0),
                //   child: Container(
                //     color: AppColor.mainColor4,
                //     height: 50,
                //     width: 180,
                //     child: Center(child: Text(skill,
                //       style: TextStyle(color: Colors.white70),
                //     )),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}