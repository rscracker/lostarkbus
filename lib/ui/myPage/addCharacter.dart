import 'package:flutter/material.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:smart_select/smart_select.dart';
import 'package:get/get.dart';

class AddCharacter extends StatefulWidget {

  @override
  State<AddCharacter> createState() => _AddCharacterState();
}

class _AddCharacterState extends State<AddCharacter> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            title(),
            Container(height: 2, color: Colors.white70,),
            characterSelect(),
            serverSelect(),
            guardianSelect(),
            busNumSelect(),
            priceSelect(),
            Flexible(fit : FlexFit.tight, child: SizedBox()),
            registerButton(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("등록",
              style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectWidget(String text){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(text, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
        filter(),
      ],
    );
  }

  Widget filter(){
    return Container(
      height: 40,
      width: 150,
      child: Center(child: Text("실리안")),
      color: Colors.white,
    );
  }

  Widget characterSelect(){
    return Padding(
      padding: const EdgeInsets.only(top : 20.0, left: 15),
      child: Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(
              Radius.circular(8.0)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(child: Center(child: Text("닉네임" , style: TextStyle(color: Colors.white, fontSize: 15,), )), width: 50,),
              SizedBox(child: Center(child: TextFormField(

              )), width: 120,),
            ],
          ),
        ),
      ),
    );
  }

  Widget serverSelect(){
    return Padding(
      padding: const EdgeInsets.only(top : 15.0, left: 15),
      child: Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(
              Radius.circular(8.0)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(child: Center(child: Text("서버" , style: TextStyle(color: Colors.white, fontSize: 15,), )), width: 50,),
              SizedBox(child: Center(child: Text("아브렐슈드" , style: TextStyle(color: AppColor.mainColor5, fontSize: 15,) )), width: 120,),
            ],
          ),
        ),
      ),
    );
  }

  Widget guardianSelect(){
    return Padding(
      padding: const EdgeInsets.only(top : 15.0, left: 15),
      child: Container(
        height: 60,
        width: 250,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(
              Radius.circular(8.0)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(child: Center(child: Text("가디언/군단장" , style: TextStyle(color: Colors.white, fontSize: 15,), )), width: 100,),
              SizedBox(child: Center(child: Text("발탄(노말)" , style: TextStyle(color: AppColor.mainColor5, fontSize: 15,) )), width: 120,),
            ],
          ),
        ),
      ),
    );
  }

  Widget busNumSelect(){
    return Padding(
      padding: const EdgeInsets.only(top : 15.0, left: 15),
      child: Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(
              Radius.circular(8.0)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(child: Center(child: Text("기사" , style: TextStyle(color: Colors.white, fontSize: 15,), )), width: 50,),
              SizedBox(child: Center(child: Text("1인" , style: TextStyle(color: AppColor.mainColor5, fontSize: 15,) )), width: 120,),
            ],
          ),
        ),
      ),
    );
  }

  Widget priceSelect(){
    return Padding(
      padding: const EdgeInsets.only(top : 15.0, left: 15),
      child: Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(
              Radius.circular(8.0)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(child: Center(child: Text("가격" , style: TextStyle(color: Colors.white, fontSize: 15,), )), width: 50,),
              SizedBox(child: Center(child: Text("1500" , style: TextStyle(color: AppColor.mainColor5, fontSize: 15,) )), width: 120,),
            ],
          ),
        ),
      ),
    );
  }

  Widget registerButton(){
    return GestureDetector(
      onTap: (){},
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey
        ),
        height: 60,
        width: Get.width,
        child: Center(child: Text("등록", style: TextStyle(color: AppColor.mainColor5, fontSize: 18, fontWeight: FontWeight.bold) )),
      ),
    );
  }
}
