import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/characterModel.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:lostarkbus/widget/circularProgress.dart';
import 'package:lostarkbus/widget/flushbar.dart';
import 'package:http/http.dart' as http;

class MyPageMenu extends StatefulWidget {

  @override
  State<MyPageMenu> createState() => _MyPageMenuState();
}

class _MyPageMenuState extends State<MyPageMenu> {

  MainController _mainController = Get.find();

  UserModel get _user => _mainController.user.value;

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            searchBar(),
            InfoBox(),
            divider(),
            menu(),

          ],
        ));
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

  Widget InfoBox(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        width: Get.width - 50,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: AppColor.mainColor3.withOpacity(0.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10.0),
            //   child: Text("내 정보", style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold, fontSize: 20),),
            // ),
            characterBox(),
            Flexible(
                fit: FlexFit.tight,
                child: Container()),
            partyBox()
          ],
        ),
      ),
    );
  }

  Widget box(String title, int num){
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: AppColor.mainColor3
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title, style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold, fontSize: 17),),
          Text(num.toString(), style: TextStyle(color: Colors.white , fontSize: 15))
        ],
      ),
    );
  }
  
  Widget characterBox(){
    return Container(
      height: 100,
      width: Get.width - 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          // border: Border.all(
          //     color: AppColor.mainColor3
          // ),
          //color: AppColor.mainColor3.withOpacity(0.2)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("내 캐릭터", style: TextStyle(color: Colors.lightBlue, fontSize: 18 , fontWeight: FontWeight.bold),),
              Text("5 / 10", style: TextStyle(color: Colors.white, fontSize: 16))
            ],
          ),
          Container(
            height: 70,
            width: 1,
            color: Colors.white70,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("고정 기사", style: TextStyle(color: Colors.lightBlue, fontSize: 18 , fontWeight: FontWeight.bold)),
              Text("5 / 10", style: TextStyle(color: Colors.white, fontSize: 16))
            ],
          ),
        ],
      )
    );
  }

  Widget partyBox(){
    return Container(
      height: 140,
      width: Get.width - 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          // border: Border.all(
          //   color: AppColor.mainColor3
          // ),
          //color: AppColor.mainColor3.withOpacity(0.2)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Column(
        children: [
          Container(
              height: 30,
              child: Text("파티", style: TextStyle(color: Colors.lightBlue, fontSize: 18 , fontWeight: FontWeight.bold),)),
          Container(
            height: 90,
            width: (Get.width - 60) / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("생성 : 3", style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text("참여 : 3", style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text("신청 중 : 3", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          )
        ],
      ),
          Container(
            height: 100,
            width: 1,
            color: Colors.white70,
          ),
          Column(
            children: [
              Container(
                  height: 30,
                  child: Text("지도", style: TextStyle(color: Colors.lightBlue, fontSize: 18 , fontWeight: FontWeight.bold),)),
              Container(
                height: 90,
                width: (Get.width - 60) / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("희귀 : 3", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text("영웅 : 3", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text("전설 : 3", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text("유물 : 3", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              )
            ],
          ),
          Container(
            height: 100,
            width: 1,
            color: Colors.white70,
          ),
          Column(
            children: [
              Container(
                  height: 30,
                  child: Text("거래", style: TextStyle(color: Colors.lightBlue, fontSize: 18 , fontWeight: FontWeight.bold),)),
              Column(
                children: [
                  Container(
                      height: 90,
                      width: (Get.width - 60) / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("구매 중 : 3", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          Text("구매 완료 : 3", style: TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      )),

                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget textBox(String title, String text){
   return Column(
     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
     children: [
       Text(title, style: TextStyle(color: Colors.white, fontSize: 18 , fontWeight: FontWeight.bold),),
       Text(text, style: TextStyle(color: Colors.white70, fontSize: 16))
     ],
   );
  }


  Widget menu(){
    return Container(
      child: Column(
        children: [
          menuContainer("공지사항"),
          divider(),
          menuContainer("문의하기"),
        ],
      ),
    );
  }

  Widget menuContainer(String menuText){
    return Container(
      height: 20,
      width: Get.width - 60,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          menuText,
          style: TextStyle(color: Colors.white,  fontSize: 17),
        ),
      ),
    );
  }

  Widget divider(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(child: Container(height: 1.5, width: Get.width - 20, color: Colors.white,),),
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
      padding: const EdgeInsets.symmetric(vertical: 15.0),
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
}
