import 'package:flutter/material.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:get/get.dart';

class BaseSelectDialog extends StatefulWidget {

  int width;
  int height;
  List content;
  //String title;

  BaseSelectDialog(
      //this.title,
      this.content,
      {
    this.width,
    this.height,
  });

  @override
  State<BaseSelectDialog> createState() => _BaseSelectDialogState();
}

class _BaseSelectDialogState extends State<BaseSelectDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      //title: Center(child: Text(widget.title, style: TextStyle(color: Colors.white70),),),
      content: Container(
        height: 300,
        width: 300,
        child: ListView.builder(
            itemCount: widget.content.length,
            itemBuilder: (context, index){
              return InkWell(
                onTap: () => Get.back(result: widget.content[index]),
                child: Container(
                  height: 40,
                  width: 200,
                  child: Center(
                    child: Text(widget.content[index],
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
