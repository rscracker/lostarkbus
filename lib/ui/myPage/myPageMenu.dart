import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/colors.dart';

class MyPageMenu extends StatefulWidget {

  @override
  State<MyPageMenu> createState() => _MyPageMenuState();
}

class _MyPageMenuState extends State<MyPageMenu> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Text("내 정보",
                  style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    //   color: AppColor.mainColor4,
                    // // border: Border.all(
                    // //   width: 1.5,
                    // //   color: Colors.white54
                    // // ),
                    // borderRadius: BorderRadius.circular(8.0)
                  ),
                  height: 250,
                  width: Get.width - 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           box("내 캐릭터", 3),
                           box("내 캐릭터", 3),
                         ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            box("내 캐릭터", 3),
                            box("내 캐릭터", 3),
                          ],
                        ),
                      ],
                    ),
                  ),

                ),
              ),
            ),
            divider(),
            menu(),

          ],
        ));
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
    return             Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(child: Container(height: 1.5, width: Get.width - 20, color: Colors.white,),),
    );
  }
}
