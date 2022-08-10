import 'package:flutter/material.dart';

class test extends StatelessWidget {

  String a;

  test(this.a);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              children: [
                Text(a, style: TextStyle(color: Colors.white),),
                // Text(a.split('<span class="profile-character-info__lv">')[1].split('</span')[0],
                //     style: TextStyle(color: Colors.white)
                // ),
                // Text(a.split('<span class="profile-character-info__server" title="@')[1].split('</span')[0],
                //     style: TextStyle(color: Colors.white)
                // ),
                // Text(a.split('<span class="profile-character-info__lv">')[1].split('</span')[0],
                //     style: TextStyle(color: Colors.white)
                // ),
              ],
            )),
      ),
    );
  }
}
