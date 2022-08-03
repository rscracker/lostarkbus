import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/lostarkList.dart';

class ClassSelectDialog extends StatelessWidget {

  List classList = LostArkList.classList;

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
                itemCount: classList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Get.back(result: classList[index]),
                    child: Container(
                      height: 40,
                      child: Center(child: Text(classList[index])),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
