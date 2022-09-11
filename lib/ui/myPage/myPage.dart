import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/busModel.dart';
import 'package:lostarkbus/model/characterModel.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/bus/busDetail.dart';
import 'package:lostarkbus/ui/dialog/addcharacterDialog.dart';
import 'package:lostarkbus/ui/myPage/addCharacter.dart';
import 'package:lostarkbus/ui/myPage/characterDialog.dart';
import 'package:lostarkbus/ui/myPage/test.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:lostarkbus/util/utils.dart';
import 'package:lostarkbus/widget/circularProgress.dart';
import 'package:lostarkbus/widget/flushbar.dart';
import 'package:reorderables/reorderables.dart';
import 'package:lostarkbus/ui/dialog/lostarkList.dart';
import 'package:smart_select/smart_select.dart';
import 'package:http/http.dart' as http;
import 'package:jsonml/html2jsonml.dart';

class Mypage extends StatefulWidget {
  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  MainController _mainController = Get.find();

  UserModel get _user => _mainController.user.value;

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            searchBar(),
            Obx(() => myCharacter()),
            horDivider(),
            myParty(),
            horDivider(),
            Obx(() => favoriteList()),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.only(top : 8.0),
      child: Center(
        child: Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
            color: AppColor.mainColor3,
            borderRadius: BorderRadius.all(
                Radius.circular(8.0)
            ),
          ),
          child: TextField(
            onSubmitted: (text){
              if(text == ""){
                CustomedFlushBar(context, "닉네임을 입력해주세요");
              } else {
                submit(text);
              }
            },
            controller: searchController,
            cursorColor: Colors.white70,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.search_outlined),
                color: Colors.white,
                onPressed: (){
                  if(searchController.text == ""){
                    CustomedFlushBar(context, "닉네임을 입력해주세요");
                  } else {
                    submit(searchController.text);
                  }
                },
              ),
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
      ),
    );
  }

  void submit(String nick) async{
    List nickList = [];
    if(_mainController.characterList.length != 0){
      _mainController.characterList.forEach((e) {
        nickList.add(e['nick']);
      });
    }
    if(_mainController.favoriteList.length != 0){
      _mainController.favoriteList.forEach((e) {
        nickList.add(e['nick']);
      });
    }
    if(nickList.contains(nick)){
      CustomedFlushBar(context, "이미 등록되어있는 캐릭터입니다.");
      searchController.text = "";
    } else {
      String url = "https://lostark.game.onstove.com/Profile/Character/${searchController.text}";
      var response = await http.get(url);
      String responseBody = utf8.decode(response.bodyBytes);
      if(response.statusCode == 200){
        if(responseBody.contains("캐릭터 정보가 없습니다.")){
          CustomedFlushBar(context, "캐릭터 정보가 없습니다");
        } else {
          Get.dialog(characterInfoDialog(responseBody, searchController.text));
        }
      }
    }
  }

  Widget characterInfoDialog(String body, String nick){
    return FutureBuilder<CharacterModel>(
      future: DatabaseService.instance.getCharacterData(body, nick),
      builder: (context, snapshot) {
        if(!snapshot.hasData || snapshot.data == null || snapshot.connectionState != ConnectionState.done)
          return CustomedCircular();
        return AlertDialog(
          backgroundColor: AppColor.mainColor2,
          content: SingleChildScrollView(
            child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Center(child: Text("캐릭터 정보",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),),
                    ),
                    textForm("닉네임", snapshot.data.nick),
                    textForm("서버", snapshot.data.server),
                    textForm("레벨", snapshot.data.level.toString()),
                    textForm("직업", snapshot.data.lostArkClass),
                    button(0, snapshot.data),
                    button(1, snapshot.data),
                  ],
                ),
          )
        );
      }
    );
  }

  Widget textForm(String category, String text){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColor.mainColor3,
          borderRadius: BorderRadius.all(
              Radius.circular(8.0)
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(category, style: TextStyle(color: Colors.white, fontSize: 15,)),
            ),
            Flexible(
                fit: FlexFit.tight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.mainColor3,
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)
                      ),
                    ),
                    child: Center(child: Text(text,
                      style: TextStyle(
                        color: Colors.white70
                      ),
                    ),
                    ),
                  ),
            )
          ],
        ),
      ),
    );
  }

  Widget button(int type, CharacterModel character){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () async{
            if((type == 0 && _mainController.characterList.length == 10) ||(type == 1 && _mainController.favoriteList.length == 10)){
              CustomedFlushBar(context, "캐릭터를 더이상 등록할 수 없습니다.");
              searchController.text = "";
              Get.back();
            } else {
              Get.dialog(CustomedCircular());
              await DatabaseService.instance.addCharacter(character, type);
              searchController.text = "";
              Get.back();
              Get.back();
              CustomedFlushBar(context, "등록이 완료되었습니다");
            }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.blue3,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          width: 240,
          height: 50,
          child: Center(
            child: Text(
              type == 0 ? "내 캐릭터 추가" : "기사 추가",
              style: TextStyle(
                color: Colors.white70
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget myCharacter() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0))
          //color: AppColor.mainColor5
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("내 캐릭터", style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),),
            ),
            Container(
              height: 110,
              child: _mainController.characterList.length == 0 ? Container(
                  height: 100,
                  child: Center(child: Text("등록된 캐릭터가 없습니다", style: TextStyle(color: Colors.white),)),
                ) : Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: _mainController.characterList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: GestureDetector(
                        onTap: () => Get.dialog(CharacterDialog(CharacterModel.fromJson(_mainController.characterList[index]), index, 0)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: AppColor.mainColor3, width: 1.5),
                              color: AppColor.mainColor4
                          ),
                          height: 110,
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                _mainController.characterList[index]["server"],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.lightBlue,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                _mainController.characterList[index]["nick"],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                _mainController.characterList[index]["level"].toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                _mainController.characterList[index]["lostArkClass"],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white70,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  })),
            ),
          ],
        ),
      ),
    );
  }

  Widget myParty() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left : 8.0, bottom: 8.0),
            child: Text("내 파티", style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),),
          ),
          Container(
            height: 110,
            child: StreamBuilder<QuerySnapshot>(
              stream: DatabaseService.instance.getmyParty(),
              builder: (context, snapshot) {
                if(!snapshot.hasData || snapshot.data.size == 0)
                  return Container(height: 20, child: Center(child: Text("파티가 없습니다")),);
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      BusModel bus = BusModel.fromJson(snapshot.data.docs[index].data());
                      return GestureDetector(
                        onTap: () => Get.to(() => BusDetail(bus: bus.toJson(),)),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: AppColor.mainColor3, width: 1.5),
                                color: AppColor.mainColor4
                            ),
                            height: 110,
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  bus.busName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColor.lightBlue,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                // Text(
                                //   bus.passengerList[bus.passengerUidList.indexOf(_user.uid)]['server'],
                                //   overflow: TextOverflow.ellipsis,
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     color: Colors.white,
                                //     //fontWeight: FontWeight.bold
                                //   ),
                                // ),
                                Text(
                                  bus.passengerList[bus.passengerUidList.indexOf(_user.uid)]['nick'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: AppColor.blue4,
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      Utils.timeinvert(bus.time),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: AppColor.blue4,
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            ),
          ),
          horDivider2(),
          Container(
            height: 110,
            child: StreamBuilder<QuerySnapshot>(
                stream: DatabaseService.instance.getmyParty2(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData)
                    return Container(height: 20, child: Center(child: Text("파티가 없습니다")),);
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        String nick;
                        BusModel bus = BusModel.fromJson(snapshot.data.docs[index].data());
                        bus.driverList.forEach((e) {
                          if(_mainController.uidList.contains(e['characterid'])){
                            nick = e['nick'];
                          }
                        });
                        return GestureDetector(
                          onTap: () => Get.to(() => BusDetail(bus: bus.toJson(),)),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: AppColor.mainColor3, width: 1.5),
                                  color: AppColor.mainColor4
                              ),
                              height: 110,
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    bus.busName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: AppColor.lightBlue,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  (bus.type == 0) ?
                                  Text(
                                    "$nick",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Text(
                                    "지원자 : ${bus.applyList.length.toString()}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: AppColor.blue4,
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                        Utils.timeinvert(bus.time),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: AppColor.blue4,
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryText(String text, int type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        width: Get.width,
        height: 60,
        //color: AppColor.mainColor4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left : 8.0),
              child: Text(text,
                  style: TextStyle(
                      fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget characterContainer(Map<String, dynamic> character){
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColor.mainColor3, width: 1.5),
            color: AppColor.mainColor4
        ),
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              character["server"],
              style: TextStyle(
                fontSize: 15,
                color: AppColor.lightBlue,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              character["nick"],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
            Text(
              character["level"].toString(),
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
            Text(
              character["lostArkClass"],
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget horDivider(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:  8.0),
      child: Center(
        child: Container(
          width: Get.width-40,
          height: 1,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget horDivider2(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:  8.0),
      child: Center(
        child: Container(
          width: Get.width-80,
          height: 1,
          color: AppColor.mainColor5,
        ),
      ),
    );
  }

  String value = "서버";

  Widget characterSelect() => SmartSelect.single(
      tileBuilder: (context, state) {
        state.value = "서버";
        return InkWell(
          onTap: state.showModal,
          child: Container(
            color: Colors.red,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(value),
                  ),
                )
              ],
            ),
          ),
        );
      },
      title: "서버",
      value: value,
      modalType: S2ModalType.popupDialog,
      choiceItems: List.generate(LostArkDialog().server.length + 1, (index) {
        if (index == 0)
          return S2Choice(value: '서버', title: '서버');
        else
          return LostArkDialog().server[index - 1];
      }),
      onChange: (state) => setState(() => value = state.value));

  Widget favoriteList() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("고정기사", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold , fontSize: 23),),
          ),
          Container(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: _mainController.favoriteList.length,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: () => Get.dialog(CharacterDialog(CharacterModel.fromJson(_mainController.favoriteList[index]), index, 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: AppColor.mainColor3, width: 1.5),
                            color: AppColor.mainColor4
                        ),
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _mainController.favoriteList[index]["server"],
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColor.lightBlue,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              _mainController.favoriteList[index]["nick"],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              _mainController.favoriteList[index]["level"].toString(),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              _mainController.favoriteList[index]["lostArkClass"],
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white70,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
