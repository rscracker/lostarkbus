import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/addcharacterDialog.dart';
import 'package:lostarkbus/ui/myPage/addCharacter.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:reorderables/reorderables.dart';
import 'package:lostarkbus/ui/dialog/lostarkList.dart';
import 'package:smart_select/smart_select.dart';

class Mypage extends StatefulWidget {
  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  MainController _mainController = Get.find();

  UserModel get _user => _mainController.user.value;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          myCharacter(),
          myParty(),
          Obx(() => favoriteList()),
        ],
      ),
    );
  }

  Widget myCharacter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            categoryText("내 캐릭터", 0),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            height: 100,
            child: Obx(() => ListView.builder(
                itemCount: _mainController.characterList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 20,
                      //color: AppColor.mainColor2,
                      child: Text(
                        "${_mainController.characterList[index]["server"]} / ${_mainController.characterList[index]["nick"]} / ${_mainController.characterList[index]["level"]} / ${_mainController.characterList[index]["lostArkClass"]}",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColor.mainColor5,
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ),
      ],
    );
  }

  Widget myParty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            categoryText("내 파티",2),
            //Container(height: 100, width: 200, child: characterSelect(),)
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            height: 100,
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
                    itemCount: participation.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 20,
                          //color: AppColor.mainColor2,
                          child: Text(
                           "${participation[index]["busName"
                            ]} ${participation[index]["time"]}",
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColor.mainColor5,
                            ),
                          ),
                        ),
                      );
                    });
              }
            ),
          ),
        ),
      ],
    );
  }

  Widget categoryText(String text, int type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        width: Get.width,
        height: 60,
        color: AppColor.mainColor4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left : 8.0),
              child: Text(text,
                  style: TextStyle(
                      fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            type != 2 ? (IconButton(
                onPressed: () {
                  print(_user.characterList);
                  Get.dialog(AddCharacterDialog(type));
                },
                icon: Icon(Icons.add,
                  color: Colors.white70,
                ))
            ) : Container()
          ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            categoryText("고정 기사", 1),
            // IconButton(
            //     onPressed: () {
            //       print(_mainController.favoriteList);
            //       Get.dialog(AddCharacterDialog(1));
            //     },
            //     icon: Icon(Icons.add, color: Colors.white70,))
          ],
        ),
        Container(
          height: 100,
          child: ListView.builder(
              itemCount: _mainController.favoriteList.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(title: Text("${_mainController.favoriteList[index]['nick']}/${_mainController.favoriteList[index]['server']}", style: TextStyle(color: Colors.white70),),);
              }),
        ),
      ],
    );
  }
}
