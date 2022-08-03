import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/lostarkList.dart';

class TypeSelDialog extends StatelessWidget {

  List typeList = LostArkList.type;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 300,
            width: 200,
            child: ListView.builder(
                itemCount: typeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Get.back(result: typeList[index]),
                    child: Container(
                      height: 40,
                      child: Center(child: Text(typeList[index])),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
