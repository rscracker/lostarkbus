import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/characterModel.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/ui/dialog/classSelectDialog.dart';
import 'package:lostarkbus/ui/dialog/serverSelectDialog.dart';
import 'package:lostarkbus/util/colors.dart';

class AddCharacterDialog extends StatefulWidget {

  final int type;
  const AddCharacterDialog(this.type);

  @override
  State<AddCharacterDialog> createState() => _AddCharacterDialogState();
}

class _AddCharacterDialogState extends State<AddCharacterDialog> {
  final GlobalKey<FormState> nickKey = GlobalKey<FormState>();
  final TextEditingController nickController = TextEditingController();

  final GlobalKey<FormState> levelKey = GlobalKey<FormState>();
  final TextEditingController levelController = TextEditingController();

  MainController _mainController = Get.find();

  UserModel get _user => _mainController.user.value;

  CharacterModel _characterModel = CharacterModel.initCharacterForm();

  String server = "실리안";
  String lostarkClass = "도화가";

  @override
  void initState() {
    nickController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          nickField(),
          serverField(),
          levelField(),
          classField(),
        ],
      ),
      actions: [
        Center(
          child: GestureDetector(
            onTap: (){
              // _mainController.user.value.characterList.add(value)
              _characterModel.server = server;
              _characterModel.lostArkClass = lostarkClass;
              _characterModel.uid = _user.uid;
              _mainController.addCharacter(_characterModel, widget.type);
              Get.back();
            },
            child: Container(
              height: 50,
              width: 230,
              decoration: BoxDecoration(
                color: AppColor.blue2,
                borderRadius: BorderRadius.all(
                    Radius.circular(8.0)
                ),
              ),
              child: Center(child: Text("등록", style: TextStyle(color: AppColor.blue4, fontSize: 15,))),
            ),
          ),
        )

      ],
    );
  }

  Widget nickField(){
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
              child: Text("닉네임", style: TextStyle(color: Colors.white, fontSize: 15,)),
            ),
            Expanded(
              child: Form(
                  key: nickKey,
                  child: TextFormField(
                    onChanged: (text){
                      _characterModel.nick = text;
                    },
                    textAlign: TextAlign.center,
                    cursorColor: AppColor.mainColor5,
                    controller: nickController,
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.transparent)
                  ),
                      focusColor: AppColor.mainColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
}

  Widget serverField(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        height: 60,
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
              child: Text("서버", style: TextStyle(color: Colors.white, fontSize: 15,)),
            ),
            //Container(width: 1, color: Colors.white,),
            Flexible(
              fit: FlexFit.tight,
              child: GestureDetector(
                onTap: () async{
                  server =  await Get.dialog(ServerDialog());
                  setState(() {
                    server = server;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.mainColor3,
                    borderRadius: BorderRadius.all(
                        Radius.circular(8.0)
                    ),
                  ),
                  child: Center(child: Text(server),),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget levelField(){
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
              child: Text("템렙", style: TextStyle(color: Colors.white, fontSize: 15,)),
            ),
            Expanded(
              child: Form(
                  key: levelKey,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    onChanged: (text){
                      _characterModel.level = int.parse(text);
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(

                    ),
                    cursorColor: AppColor.mainColor5,
                    controller: levelController,
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                      focusColor: AppColor.mainColor,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget classField(){
    return Container(
      height: 60,
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("직업", style: TextStyle(color: Colors.white, fontSize: 15,)),
          ),
          Flexible(
              fit: FlexFit.tight,
              child: GestureDetector(
                onTap: () async{
                  lostarkClass = await Get.dialog(ClassSelectDialog());
                  setState(() {
                    lostarkClass = lostarkClass;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.mainColor3,
                    borderRadius: BorderRadius.all(
                        Radius.circular(8.0)
                    ),
                  ),
                  child: Center(child: Text(lostarkClass),),
                ),
              )
          )
        ],
      ),
    );
  }

}
