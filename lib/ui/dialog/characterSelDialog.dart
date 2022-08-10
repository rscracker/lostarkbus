import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/util/colors.dart';

class CharacterSelDialog extends StatefulWidget {

  @override
  State<CharacterSelDialog> createState() => _CharacterSelDialogState();
}

class _CharacterSelDialogState extends State<CharacterSelDialog> {
  MainController _mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      title: Text("내 캐릭터", style: TextStyle(color: Colors.white),),
      content: Container(
        height: 250,
        width: 200,
        child: ListView.builder(
            itemCount: _mainController.characterList.length,
            itemBuilder: (BuildContext context, int index){
              return selectTile(_mainController.characterList[index]["server"], _mainController.characterList[index]["nick"], index);
            }),
      ),
    );
  }

  Widget selectTile(String server, String nick, int index){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: (){
          Get.back(result: _mainController.characterList[index]);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.mainColor4,
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)
            ),
          ),
          height: 45,
          width: 150,
          child: Center(child: Text("$server/ $nick ", style: TextStyle(
              color: Colors.white
          ),)),
        ),
      ),
    );
  }
}
