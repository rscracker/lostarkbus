import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/baseSelectDialog.dart';
import 'package:lostarkbus/ui/trade/buyDialog.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/lostarkList.dart';
import 'package:lostarkbus/widget/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog/busCharacterSel.dart';
import 'addTradeDialog.dart';

class Trade extends StatefulWidget {

  @override
  State<Trade> createState() => _TradeState();
}

class _TradeState extends State<Trade> {

  String server_filter = "전섭";
  String item_filter = "물품";
  String sort_filter = "가격순";

  String buyerNick = "구매할 닉네임";
  String quantity = "수량";

  @override
  void initState(){
    super.initState();
    getFilter();
  }

  void getFilter() async{
    final prefs = await SharedPreferences.getInstance();
    server_filter = prefs.getString('tradeServerFilter') ?? "전섭";
    item_filter = prefs.getString('itemFilter')?? "물품 전체";
    sort_filter = prefs.getString('tradeSortFilter')?? "가격순";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          title(),
          filterwidget(),
          tradeList(),
        ],
      ),
    );
  }
  Widget title() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("거래",
              style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          // Text(DateTime.now().hour.toString() + " : " + DateTime.now().minute.toString(),
          //   style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
          // ),
          TextButton(
            onPressed: () => Get.dialog(AddTrade()),
            child: Text("등록",
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }


  Widget filterwidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            filter(server_filter,0),
            filter(item_filter,1),
            filter(sort_filter,2)
          ],
        ),
      ),
    );
  }
  Widget filter(String text, int type) {
    return GestureDetector(
      onTap: (type == 0) ? () async{
        await Get.dialog(BaseSelectDialog(List.from(["전섭"])..addAll(LostArkList.serverList), save: true, saveKey: "tradeServerFilter",)).then((e){
          if(e!=null){
            setState(() {
              server_filter = e;
            });
          }
        });
      } : (type ==1) ? () async{
        await Get.dialog(BaseSelectDialog(List.from(["물품 전체"])..addAll(LostArkList.item),save: true, saveKey: "itemFilter", )).then((e){
          if(e!=null){
            setState(() {
              item_filter = e;
            });
          }
        });
      } : () async{
        await Get.dialog(BaseSelectDialog(['가격순', '남은 수량'], save: true, saveKey: "tradeSortFilter",)).then((e){
          if(e!=null){
            setState(() {
              sort_filter = e;
            });
          }
        });
      },
      child: Container(
        height: 50,
        width: Get.width / 4,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white70,
              width: 1
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(10.0) // POINT
          ),
          color: AppColor.mainColor2,
        ),
        child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 13, overflow: TextOverflow.ellipsis),)),
      ),
    );
  }

  Widget tradeList(){
    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.instance.getTradeData(
            server_filter,
            item: (item_filter == "물품 전체") ? null : item_filter,
            sort: sort_filter,
        ),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
            return Expanded(child: Center(child: CircularProgressIndicator(),));
          if(snapshot.data.size == 0){
            return Expanded(child: Center(child: Text("등록된 물품이 없습니다", style:  TextStyle(color: Colors.white70),),));
          }
          return Flexible(
            fit: FlexFit.tight,
            child: GridView.builder(
                itemCount: snapshot.data.size,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 5,
                ),
                itemBuilder: (context, int index){
                  if(snapshot.data.docs[index] != null)
                    return tradeContainer(snapshot.data.docs[index].data());
                },
              ),
          );
        }
      );
  }

  Widget tradeContainer(Map<String, dynamic> trade){
    return GestureDetector(
      onTap: () => Get.dialog(BuyDialog(trade)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.mainColor4,
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)
            ),
            // border: Border.all(
            //   color: Colors.purple,
            //   width: 1
            // ),
          ),
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                  trade['uploader'] != null ? trade['uploader']['server'] : "",
                  style: TextStyle(color: AppColor.lightBlue, fontWeight: FontWeight.bold, ),
              ),
              customedText(trade['item']  ?? ""),
              Text(
                trade['price'].toString() + "g"  ?? "",
                style: TextStyle(color: AppColor.yellow, ),
              ),
              customedText(trade['buy'].toString() + " / " + trade['quantity'].toString()  ?? "" ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customedText(String text, {int colType}){
    return Text(text, style: TextStyle(color: Colors.white70),);
  }

  Widget buyDialog(Map<String, dynamic> trade){
    TextEditingController quantityController =TextEditingController();
    int maxQuantity = trade['quantity'] - trade['buy'];
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Center(child: Text("구매가능 수량 : ${maxQuantity.toString()}", style: TextStyle(color: Colors.white70),)),
          ),
          Container(
            color: AppColor.mainColor4,
            width: 160,
            height: 50,
            child: TextField(
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
              cursorColor: AppColor.mainColor5,
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "수량",
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
          SizedBox(height: 15,),
          GestureDetector(
            onTap: (quantityController.text != "") ?
                () async{
              if(int.parse(quantityController.text) > maxQuantity){
                CustomedFlushBar(context, "주문가능한 수량을 확인해주세요");
              } else {
                await DatabaseService.instance.buyItem(trade['docId'], int.parse(quantityController.text));
                quantityController.text = "";
                Get.back();
              }
            } : () => CustomedFlushBar(context, "수량을 입력해주세요."),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.blue3,
                borderRadius: BorderRadius.circular(6.0)
              ),
              width: 160,
              height: 50,
              child: Center(
                child: Text("구매 신청", style: TextStyle(color: Colors.white70),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
