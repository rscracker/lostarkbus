import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/lostarkList.dart';

class ServerDialog extends StatelessWidget {
  List serverList = LostArkList.serverList;

  var content = <Container>[];

  @override
  Widget build(BuildContext context) {
    // serverList.forEach((e) {
    //   content.add(new Container(height: 40, child: Text(e),));
    // });
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 300,
            width: 200,
            child: ListView.builder(
                itemCount: serverList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Get.back(result: serverList[index]),
                    child: Container(
                      height: 40,
                      child: Center(child: Text(serverList[index])),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
