import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/model/characterModel.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:lostarkbus/widget/circularProgress.dart';
import 'package:http/http.dart' as http;
import 'package:lostarkbus/widget/flushbar.dart';

class CharacterDialog extends StatelessWidget {
  CharacterModel character;
  int index;
  int type;
  CharacterDialog(
      this.character,
      this.index,
      this.type,
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 200,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: AppColor.mainColor3,
              ),
              color: AppColor.mainColor3.withOpacity(0.1)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(character.nick, style: TextStyle(color: Colors.lightBlue, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(character.server, style: TextStyle(color: Colors.white),),
                Text("${character.level.toString()}", style: TextStyle(color: Colors.white),),
                Text(character.lostArkClass, style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top : 20.0),
            child: GestureDetector(
              onTap: () async{
                Get.dialog(CustomedCircular(text: "업데이트 중",));
                String url = "https://lostark.game.onstove.com/Profile/Character/${character.nick}";
                var response = await http.get(url);
                String responseBody = utf8.decode(response.bodyBytes);
                await DatabaseService.instance.updateCharacterLevel(responseBody, character, index, type);
                Get.back();
                Get.back();
                CustomedFlushBar(context, "업데이트가 완료되었습니다");
              },
              child: Container(
                height: 45,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.blue3,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColor.blue2
                ),
                child: Center(child: Text("레벨 업데이트", style: TextStyle(color: AppColor.blue4),)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: GestureDetector(
              onTap: () async {
                Get.dialog(CustomedCircular(text: "삭제 중",));
                await DatabaseService.instance.deleteCharacter(character.characterid, index, type);
                Get.back();
                Get.back();
              },
              child: Container(
                height: 45,
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.blue3,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    color: AppColor.blue2
                ),
                child: Center(child: Text("캐릭터 삭제", style: TextStyle(color: AppColor.blue4),)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
