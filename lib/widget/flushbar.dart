import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/util/colors.dart';

void CustomedFlushBar(BuildContext context, String text){
  Get.rawSnackbar(
    message: text,
    backgroundColor: AppColor.mainColor2,
    margin: EdgeInsets.all(8),
    borderWidth: 8,
    borderRadius: 8,
    duration: Duration(seconds: 2),
  );
}