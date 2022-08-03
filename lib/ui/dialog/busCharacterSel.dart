import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/busController.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/busModel.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/ui/bus/addBus.dart';
import 'package:lostarkbus/util/colors.dart';

class BusCharacterSelDialog extends StatefulWidget {

  @override
  State<BusCharacterSelDialog> createState() => _BusCharacterSelDialogState();
}

class _BusCharacterSelDialogState extends State<BusCharacterSelDialog> {
  final BusController _busController = Get.put(BusController());

  MainController _mainController = Get.find();

  UserModel get _user => _mainController.user.value;

  @override
  void initState() {
    _busController.busForm = BusModel.initBusForm();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      title: Text("내 캐릭터", style: TextStyle(color: Colors.white),),
      content: Container(
        height: 250,
        width: 200,
        child: ListView.builder(
            itemCount: _mainController.characterList.length,
            itemBuilder: (BuildContext context, int index){
              return selectTile(_mainController.characterList[index]["server"], _mainController.characterList[index]["nick"], index);
            }),
      ),
    );
  }

  Widget selectTile(String server, String nick, int index){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: (){
          print(_mainController.characterList[index]);
          _busController.driverList.add(_mainController.characterList[index]);
          _busController.myCharacter.value = _mainController.characterList[index];
          _busController.server.add(server);
          Get.back();
          Get.to(() => AddBus());
        },
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.mainColor4,
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0)
              ),
            ),
            height: 45,
            width: 150,
            child: Center(child: Text("$server/ $nick ", style: TextStyle(
                color: Colors.white
            ),)),
          ),
      ),
    );
  }
}
