import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:lostarkbus/widget/circularProgress.dart';
import 'package:lostarkbus/widget/flushbar.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:get/get.dart';

class BuyController extends GetxController{
  RxBool error = false.obs;
  RxString errorMessage = "".obs;
  RxInt maxQuantity = 0.obs;

}

class BuyDialog extends StatefulWidget {
  Map<String, dynamic> trade;

  BuyDialog(this.trade);

  @override
  State<BuyDialog> createState() => _BuyDialogState();
}

class _BuyDialogState extends State<BuyDialog> {
  BuyController buyController = Get.put(BuyController());
  final TextEditingController quantityController = TextEditingController();

  @override
  void initState(){
    quantityController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buyController.maxQuantity.value = widget.trade['quantity'] - widget.trade['buy'];
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   width: 160,
          //   height: 50,
          //   color: AppColor.mainColor4,
          //   child: Center(
          //     child: Text(buyerNick, style: TextStyle(color: Colors.white70),),
          //   ),
          // ),
          // SizedBox(height: 12,),
          StreamBuilder<DocumentSnapshot>(
            stream: DatabaseService.instance.buyableQuantity(widget.trade['docId']),
            builder: (context, snapshot) {
              if(snapshot.hasData)
                buyController.maxQuantity.value = snapshot.data.data()['quantity'] - snapshot.data.data()['buy'];
              return Obx(() => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Center(
                    child: Text(
                  "???????????? ?????? : ${buyController.maxQuantity.value.toString()}",
                  style: TextStyle(color: Colors.white70),
                )),
              ));
            }
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColor.mainColor4,
              border: Border.all(
                  color: buyController.error.isTrue ? Colors.red : Colors.transparent, width: 1),
            ),
            width: 160,
            height: 50,
            child: TextField(
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
              cursorColor: AppColor.mainColor5,
              controller: quantityController,
              onChanged: (text) {
                print(quantityController.text);
                print(quantityController.text.length);
                if(text == ""){
                  buyController.errorMessage.value = "";
                  buyController.error.value = false;
                } else if(int.parse(text) > buyController.maxQuantity.value) {
                  buyController.error.value = true;
                  buyController.errorMessage.value = "???????????? ????????? ??????????????????";
                } else {
                  buyController.error.value = false;
                  buyController.errorMessage.value = "";
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "??????",
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.transparent)),
                focusColor: AppColor.mainColor,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.transparent)),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Obx(() => buyController.errorMessage.value != "" ?
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(buyController.errorMessage.value, style: TextStyle(color: Colors.red[300]),),
          )
              : Container()
          ),
          Obx(() => GestureDetector(
            onTap: (buyController.error.isFalse) ? () async {
                  if(quantityController.text == "" || quantityController.text.length == 0){
                    buyController.errorMessage.value = "??????????????? ??????????????????";
                    buyController.error.value = true;
                  } else {
                    Get.dialog(CustomedCircular());
                    await DatabaseService.instance.buyItem(
                        widget.trade['docId'],
                        int.parse(quantityController.text));
                    Get.back();
                    Get.back();
                    Get.dialog(buyInfo(widget.trade['uploader']['nick'],widget.trade['price'], int.parse(quantityController.text)));
                  }
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                  color: buyController.error.isFalse ? AppColor.blue3 : AppColor.blue4,
                  borderRadius: BorderRadius.circular(6.0)),
              width: 160,
              height: 50,
              child: Center(
                child: Text(
                  "?????? ??????",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget buyInfo(String nick, int price, int quantity){
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("???????????? : $nick", style: TextStyle(color: AppColor.lightBlue, fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(height: 25,),
          Text("????????? : ${price.toString()}", style: TextStyle(color: Colors.white70)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("?????? : ${quantity.toString()}", style: TextStyle(color: Colors.white70)),
          ),
          Text("??? ?????? : ${(price * quantity).toString()}", style: TextStyle(color: AppColor.yellow))
        ],
      ),
    );
  }
}
