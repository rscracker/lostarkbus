import 'package:flutter/material.dart';

class SearchedDialog extends StatelessWidget {
  
  String body;
  SearchedDialog(this.body);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          Text("닉네임 : "),
          Text("서버 : "),
          Text("템 레벨 : "),
          Text("레벨 : "),
        ],
      ),
    );
  }
  
  String findNick(String text){
    return text.split('<span class="profile-character-info__lv">')[1].split('</span')[0];
  }


}
