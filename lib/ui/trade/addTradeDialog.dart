import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/baseSelectDialog.dart';
import 'package:lostarkbus/ui/dialog/characterSelDialog.dart';
import 'package:lostarkbus/util/colors.dart';

class AddTrade extends StatefulWidget {

  @override
  State<AddTrade> createState() => _AddTradeState();
}

class _AddTradeState extends State<AddTrade> {

  Map<String, dynamic> character =
  {"nick" : "admin",
    "server" : "서버",
  };
  String tradeItem = "각성돌";
  String server = '서버';
  int price = 0;
  int quantity = 0;

  final GlobalKey<FormState> priceKey = GlobalKey<FormState>();
  final TextEditingController priceController = TextEditingController();

  final GlobalKey<FormState> quantityKey = GlobalKey<FormState>();
  final TextEditingController quantityController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          form("캐릭터", 0),
          form("종류", 1),
          priceSel(),
          quantitySel(),
          button()
        ],
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
            GestureDetector(
              onTap: (type == 1) ?
                  () async{
                await Get.dialog(BaseSelectDialog(["각성돌", "수호석 결정"])).then((e){
                  if(e != null)
                    setState(() {
                      tradeItem = e;
                    });
                }
                );
              } :
                  () async{
                  await Get.dialog(CharacterSelDialog()).then((e){
                  if(e!=null){
                    setState(() {
                      character = e;
                    });
                  }
                });

              }
              ,
              child: Container(
                height: 60,
                width: 160,
                child: type == 0 ? Center(child: Text(character['nick'] ?? "",
                  style: TextStyle(color: Colors.white),
                )) : Center(child: Text(tradeItem,
                  style : TextStyle(color: Colors.white70,),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget priceSel() {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        height: 60,
        width: 230,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(
                child: Center(
                    child: Text(
                      "가격",
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
                    key: priceKey,
                    child: TextFormField(
                      style: TextStyle(
                          color: Colors.white70
                      ),
                      onChanged: (text){
                        price = int.parse(text);
                      },
                      textAlign: TextAlign.center,
                      cursorColor: AppColor.mainColor5,
                      controller: priceController,
                      decoration: InputDecoration(
                        hintText: "0",
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
                width: 140,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quantitySel() {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        height: 60,
        width: 230,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(
                child: Center(
                    child: Text(
                      "수량",
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
                    key: quantityKey,
                    child: TextFormField(
                      style: TextStyle(
                          color: Colors.white70
                      ),
                      onChanged: (text){
                        quantity = int.parse(text);
                      },
                      textAlign: TextAlign.center,
                      cursorColor: AppColor.mainColor5,
                      controller: quantityController,
                      decoration: InputDecoration(
                        hintText: "0",
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
                width: 140,
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
          Map<String, dynamic> form = {
            "uploader" : character,
            "item" : tradeItem,
            "price" : price,
            "quantity" : quantity,
          };
          await DatabaseService.instance.addTrade(character, form);
          Get.back();
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
