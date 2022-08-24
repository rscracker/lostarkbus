import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/busModel.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:lostarkbus/widget/flushbar.dart';


class RecruitController extends GetxController{
  RxMap<dynamic, dynamic> selectedCharacter = {}.obs;

}

class RecruitDialog extends StatefulWidget {
  BusModel bus;

  RecruitDialog(
      this.bus
      );
  @override
  State<RecruitDialog> createState() => _RecruitDialogState();
}

class _RecruitDialogState extends State<RecruitDialog> {

  MainController _mainController = Get.find();
  RecruitController recruitController = Get.put(RecruitController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("현재 기사(${widget.bus.driverList.length}/${widget.bus.numDriver})", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColor.mainColor4,
                  width: 2
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            height: 150,
            width: 200,
            child: ListView.builder(
                itemCount: widget.bus.driverList.length,
                itemBuilder: (BuildContext context, int index){
                  print(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child:
                    Container(
                        decoration: BoxDecoration(
                          borderRadius : BorderRadius.all(Radius.circular(6.0)),
                        ),
                        height: 60,
                        child: Center(child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top : 3.0),
                              child: Text("${widget.bus.driverList[index]['nick']}",
                                style: TextStyle(color: Colors.lightBlue, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 3,),
                            Text("${widget.bus.driverList[index]['server']} ${widget.bus.driverList[index]['level']}  ${widget.bus.driverList[index]['lostArkClass']} ",
                              style: TextStyle(color: Colors.white70, fontSize: 14
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ))),
                  );
                })),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(" 내 캐릭터", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColor.mainColor4,
                  width: 2
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            height: 150,
            width: 200,
            child: _mainController.characterList.length == 0 ? Center(child: Text("등록된 기사가 없습니다"),)
                : Obx(() => ListView.builder(
                itemCount: _mainController.characterList.length,
                itemBuilder: (BuildContext context, int index){
                  return Obx(() => GestureDetector(
                    onTap: () {
                      if(recruitController.selectedCharacter.value != _mainController.characterList[index]){
                        recruitController.selectedCharacter.value = _mainController.characterList[index];
                      } else {
                        recruitController.selectedCharacter.value = {};
                      }
                    }
                    ,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius : BorderRadius.all(Radius.circular(6.0)),
                          color: recruitController.selectedCharacter == _mainController.characterList[index] ? AppColor.blue3 : Colors.transparent
                        ),
                        height: 40,
                        child: Center(child: Text("${_mainController.characterList[index]['server']} / ${_mainController.characterList[index]['nick']}",
                          style: TextStyle(color: Colors.white70),
                        ))),
                  ));
                })),
          ),
          GestureDetector(
            onTap: () async{
              if(recruitController.selectedCharacter.value.isNotEmpty){
                await DatabaseService.instance.applyBus(widget.bus.docId, recruitController.selectedCharacter.value);
                Get.back();
              } else {
                CustomedFlushBar(context, "지원할 캐릭터를 선택해주세요.");
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.blue2,
                  border: Border.all(
                      color: AppColor.blue2,
                      width: 2
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                height: 50,
                width: 200,
                child: Center(
                  child: Text("신청", style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
