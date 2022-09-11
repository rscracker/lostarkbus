import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/colors.dart';

class CustomedCircular extends StatelessWidget {
  String text;
  CustomedCircular({
    this.text
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text ?? "등록 중", style: TextStyle(color: Colors.white, fontSize: 17),),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Container(
                child: CircularProgressIndicator(
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
