import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/characterModel.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/addcharacterDialog.dart';
import 'package:lostarkbus/ui/myPage/addCharacter.dart';
import 'package:lostarkbus/ui/myPage/test.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:lostarkbus/util/utils.dart';
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
            myCharacter(),
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
    String url = "https://lostark.game.onstove.com/Profile/Character/${searchController.text}";
    //String url = "https://lostark.game.onstove.com/Profile/Character/동막골호랭이";
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

  Widget characterInfoDialog(String body, String nick){
    return FutureBuilder<CharacterModel>(
      future: DatabaseService.instance.getCharacterData(body, nick),
      builder: (context, snapshot) {
        if(snapshot.data == null || snapshot.connectionState != ConnectionState.done)
          return Center(child: CircularProgressIndicator(),);
        return AlertDialog(
          backgroundColor: AppColor.mainColor2,
          content: Column(
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
        onTap: (){
          print(_mainController.characterList.contains(character.toJson()));
          if(type == 0 && _mainController.characterList.contains(character.toJson())){
            CustomedFlushBar(context, "이미 등록한 캐릭터입니다.");
            Get.back();
          } else {
            _mainController.addCharacter(character, type);
            Get.back();
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
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                ) : ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: _mainController.characterList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          //border: Border.all(color: Colors.blue),
                          color: AppColor.mainColor3
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
                    );
                  }),
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
                List participation = [];
                if(!snapshot.hasData)
                  return Container(height: 20, child: Center(child: Text("파티가 없습니다")),);
                snapshot.data.docs.forEach((e) {
                  participation.add(e.data());
                });
                participation = participation..addAll(_mainController.myUpload);
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: participation.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              //border: Border.all(color: Colors.blue),
                              color: AppColor.mainColor3
                          ),
                          height: 110,
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                participation[index]["busName"],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColor.lightBlue,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              // Text(
                              //   participation[index]["busName"],
                              //   style: TextStyle(
                              //       fontSize: 15,
                              //       color: AppColor.lightBlue,
                              //   ),
                              // ),
                              Text(
                                Utils.timeinvert(participation[index]["time"]),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white70,
                                ),
                              ),

                            ],
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
            //border: Border.all(color: Colors.blue),
            color: AppColor.mainColor3
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
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: _mainController.favoriteList.length,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          //border: Border.all(color: Colors.blue),
                          color: AppColor.mainColor3
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
                  );
                }),
          ),
        ],
      ),
    );
  }
}
