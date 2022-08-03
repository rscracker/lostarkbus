import 'package:flutter/material.dart';
import 'package:lostarkbus/util/colors.dart';

class baseInputForm extends StatelessWidget {

  int width;
  TextEditingController controller;
  int height = 60;
  String text;

  baseInputForm({
    this.width,
    this.controller,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.mainColor3,
          borderRadius: BorderRadius.all(
              Radius.circular(8.0)
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(text, style: TextStyle(color: Colors.white, fontSize: 15,)),
            ),
            // Expanded(
            //   child: Form(
            //       key: nickKey,
            //       child: TextFormField(
            //         onChanged: (text){
            //           _characterModel.nick = text;
            //         },
            //         textAlign: TextAlign.center,
            //         cursorColor: AppColor.mainColor5,
            //         controller: nickController,
            //         decoration: InputDecoration(
            //           disabledBorder: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(8.0),
            //               borderSide: BorderSide(color: Colors.transparent)
            //           ),
            //           focusColor: AppColor.mainColor,
            //           enabledBorder: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(8.0),
            //               borderSide: BorderSide(color: Colors.transparent)
            //           ),
            //           focusedBorder: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(8.0),
            //               borderSide: BorderSide(color: Colors.transparent)
            //           ),
            //         ),
            //       )
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
