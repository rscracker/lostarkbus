import 'package:flutter/material.dart';
import 'package:lostarkbus/util/colors.dart';

class TitleText extends StatelessWidget {
  String text;

  TitleText(
      this.text
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(text, style: TextStyle(color: AppColor.mainColor5, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
