import 'package:flutter/material.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseSelectDialog extends StatefulWidget {

  int width;
  int height;
  List content;
  bool save;
  String saveKey;
  //String title;

  BaseSelectDialog(
      //this.title,
      this.content,
      {
    this.width,
    this.height,
        this.save,
        this.saveKey,
  });

  @override
  State<BaseSelectDialog> createState() => _BaseSelectDialogState();
}

class _BaseSelectDialogState extends State<BaseSelectDialog> {
  @override
  Widget build(BuildContext context) {
    var content = <Padding>[];
    widget.content.forEach((e) {
      content.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async{
            Get.back(result: e);
            if(widget.save){
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString(widget.saveKey, e);
            }
          },
          child: Container(
            height: 40,
            width: 200,
            child: Center(
              child: Text(e,
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ),
      ));
    });
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      //title: Center(child: Text(widget.title, style: TextStyle(color: Colors.white70),),),
      content: Container(
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: content,
        ),
      ),
    );
  }
}
