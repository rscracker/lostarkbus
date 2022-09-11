import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/baseSelectDialog.dart';
import 'package:lostarkbus/ui/dialog/characterSelDialog.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:lostarkbus/util/lostarkList.dart';
import 'package:lostarkbus/widget/flushbar.dart';

class AddMap extends StatefulWidget {

  @override
  State<AddMap> createState() => _AddMapState();
}

class _AddMapState extends State<AddMap> {

  Map<String, dynamic> character =
  {"nick" : "캐릭터 선택",
    "server" : "서버",
  };
  String mapType = "희귀";
  String loc1 = "파푸니카";
  String loc2 = "별모래 해변";
  String hour = "00";
  String minute = "00";

  bool hourError = false;
  bool minuteError = false;

  final GlobalKey<FormState> hourKey = GlobalKey<FormState>();
  final TextEditingController hourController = TextEditingController();

  final GlobalKey<FormState> minuteKey = GlobalKey<FormState>();
  final TextEditingController minuteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            form("캐릭터", 0),
            form("종류", 1),
            form("지역", 2),
            timeSelect(),
            button()
          ],
        ),
      ),
    );
  }

  Widget form(String text, int type){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: AppColor.mainColor4
        ),
        height: type == 2 ? 121 : 60,
        width: 230,
        child: Row(
          children: [
            Container(
              height: 60,
              width: 70,
              child: Center(
                child: Text(text,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            type == 2 ?
            Column(
              children: [
                GestureDetector(
                  onTap: () async{
                    await(Get.dialog(BaseSelectDialog(['파푸니카', '베른 남부']))).then((e) {
                      if(e != null && e == "파푸니카"){
                        setState(() {
                          loc1 = e;
                          loc2 = LostArkList.region2['파푸니카'][0];
                        });
                      } else {
                        setState(() {
                          loc1 = e;
                          loc2 = LostArkList.region2['베른 남부'][0];
                        });
                      }
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 160,
                    child: Center(child: Text(loc1,
                       style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
                Container(height: 1, color: Colors.white70,
                width: 130,
                ),
                GestureDetector(
                  onTap: () async{
                    await(Get.dialog(BaseSelectDialog(
                        (loc1 == "파푸니카") ?
                        LostArkList.region2['파푸니카'] :
                        LostArkList.region2['베른 남부']
                    ))).then((e) {
                      if(e != null)
                        setState(() {
                          loc2 = e;
                        });
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 160,
                    child: Center(child: Text(loc2,
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ],
            ) :
            GestureDetector(
              onTap: (type == 1) ?
              () async{
                await Get.dialog(BaseSelectDialog(["희귀", "영웅", "전설", "유물"])).then((e){
                  if(e != null)
                    setState(() {
                      mapType = e;
                    });
                }
                );
              } :
              () async{
                await Get.dialog(CharacterSelDialog()).then((e){
                  if(e != null)
                    setState(() {
                      character = e;
                    });
                });
              }
              ,
              child: Container(
                height: 60,
                width: 160,
                child: type == 0 ? Center(child: Text(character['nick'] ?? "",
                  style: TextStyle(color: Colors.white),
                )) : Center(child: Text(mapType,
                  style : TextStyle(color:
                    mapType == "희귀" ? Colors.blue
                        : mapType == "영웅" ? Colors.purple
                        : mapType == "전설" ? AppColor.lightYellow
                        : Colors.deepOrange[800],),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget timeSelect() {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        height: 60,
        width: 230,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(
            color: (hourError || minuteError) ? Colors.red : Colors.transparent,
            width: 1
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(
                child: Center(
                    child: Text(
                      "시간",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )),
                width: 50,
              ),
              SizedBox(
                child: Form(
                    key: hourKey,
                    child: TextFormField(
                      style: TextStyle(
                          color: Colors.white70
                      ),
                      onChanged: (text){
                        if(int.parse(hourController.text == "" ? "0" : hourController.text) > 23){
                          setState(() {
                            hourError = true;
                          });
                        } else {
                          setState(() {
                            hourError = false;
                          });
                        }
                        hour = text;
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      cursorColor: AppColor.mainColor5,
                      controller: hourController,
                      decoration: InputDecoration(
                        hintText: "00",
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
                    )
                ),
                width: 80,
              ),
              Text(":", style: TextStyle(color: Colors.white70
              ),),
              SizedBox(
                child: Form(
                    key: minuteKey,
                    child: TextFormField(
                      style: TextStyle(
                          color: Colors.white70
                      ),
                      onChanged: (text){
                        if(int.parse(minuteController.text == "" ? "0" : minuteController.text) > 59){
                          setState(() {
                            minuteError = true;
                          });
                        } else {
                          setState(() {
                            minuteError = false;
                          });
                        }
                        minute = text;
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      cursorColor: AppColor.mainColor5,
                      controller: minuteController,
                      decoration: InputDecoration(
                        hintText: "00",
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
                    )
                ),
                width: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button(){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: () async{
          if(character['nick'] != "캐릭터 선택" && hourController.text.length != 0 && minuteController.text.length != 0
            && !hourError && !minuteError
          ){
            await DatabaseService.instance.addMap(character, mapType, loc1, loc2, int.parse(hour) * 100 + int.parse(minute));
            Get.back();
          } else if(character['nick'] == "캐릭터 선택"){
            CustomedFlushBar(context, "캐릭터를 선택해주세요.");
          } else if(hourController.text.length == 0 || minuteController.text.length == 0){
            CustomedFlushBar(context, "시간을 입력해주세요");
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            color: AppColor.blue2,
          ),
          width: 230,
          height: 50,
          child: Center(
            child: Text("확인",
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),
        ),
      ),
    );
  }
}
