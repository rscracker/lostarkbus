import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/busController.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/busModel.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/dialog/addcharacterDialog.dart';
import 'package:lostarkbus/ui/dialog/baseSelectDialog.dart';
import 'package:lostarkbus/ui/dialog/serverSelectDialog.dart';
import 'package:lostarkbus/ui/dialog/typeSelDialog.dart';
import 'package:lostarkbus/ui/navigation.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:lostarkbus/util/lostarkList.dart';
import 'package:lostarkbus/widget/circularProgress.dart';
import 'package:lostarkbus/widget/flushbar.dart';

class AddBus extends StatefulWidget {
  @override
  State<AddBus> createState() => _AddBusState();
}

class _AddBusState extends State<AddBus> {
  BusController _busController = Get.find();
  MainController _mainController = Get.find();
  UserModel get _user => _mainController.user.value;

  final GlobalKey<FormState> priceKey = GlobalKey<FormState>();
  final TextEditingController priceController = TextEditingController();

  final GlobalKey<FormState> price2Key = GlobalKey<FormState>();
  final TextEditingController price2Controller = TextEditingController();


  final GlobalKey<FormState> hourKey = GlobalKey<FormState>();
  final TextEditingController hourController = TextEditingController();

  final GlobalKey<FormState> minuteKey = GlobalKey<FormState>();
  final TextEditingController minuteController = TextEditingController();

  String type = "";
  int price = 0;
  String errorMessage = "";

  //FocusNode myFocus;

  bool numCheck = true;
  bool hourError = false;
  bool minuteError = false;
  bool bossCheck = false;
  bool priceCheck = false;


  @override
  void initState() {
    priceController.text = "";
    hourController.text = "";
    minuteController.text = "";
    _busController.price1.assignAll([{_busController.server[0] : 0}]);
    //myFocus = FocusNode();

    print(_busController.numdriver);
    print(_busController.driverList.length);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    //myFocus.dispose();
    //_busController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomNavigationBar: Obx(() => registerButton()),
        resizeToAvoidBottomInset : true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    title(),
                    Container(
                      height: 2,
                      color: Colors.white70,
                    ),
                    Obx(() => busNumSelect()),
                    timeSelect(),
                    (_busController.busForm.numDriver != 0)
                        ? characterSelect()
                        : Container(),
                    guardianSelect(),
                    serverSelect(),
                    Obx(() => priceSelect()),
                    //Flexible(fit : FlexFit.tight, child : SizedBox()),
                  ],
                ),
          ),
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
            child: Text(
              "??????",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectWidget(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        filter(),
      ],
    );
  }

  Widget filter() {
    return Container(
      height: 40,
      width: 150,
      child: Center(child: Text("?????????")),
      color: Colors.white,
    );
  }

  Widget characterSelect() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15),
      child: Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(
                child: Center(
                    child: Text(
                  "?????????",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )),
                width: 50,
              ),
              SizedBox(
                child: Center(
                    child: Text(_busController.myCharacter["nick"],
                        style: TextStyle(
                          color: AppColor.mainColor5,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis
                        ))),
                width: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serverSelect() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15),
      child: Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(
                child: Center(
                    child: Text(
                  "??????",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )),
                width: 50,
              ),
              GestureDetector(
                onTap: () => Get.dialog(serverSelectDialog()),
                child: Container(
                  //color: Colors.blue,
                  child: Obx(() => Center(
                      child: Text(_busController.server.length != LostArkList.serverList.length ? _busController.server.toString().replaceAll("[", "").replaceAll("]", "") : "?????? ??????",
                          style: TextStyle(
                            color: AppColor.mainColor5,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis
                          )))),
                  height: 60,
                  width: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget guardianSelect() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15),
      child: Container(
        height: 60,
        width: 250,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(
                child: Center(
                    child: Text(
                  "?????? ??????",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )),
                width: 65,
              ),
              GestureDetector(
                onTap: () async{
                  // await Get.dialog(TypeSelDialog()).then((e){
                  //   if(e != null){
                  //     _busController.boss.value = e;
                  //   }
                  // });
                  await Get.dialog(BaseSelectDialog(LostArkList.type)).then((e){
                      if(e != null){
                        _busController.boss.value = e;
                        bossCheck = true;
                      }
                  });
                },
                child: Container(
                  child: Center(
                      child: Obx(() => Text(_busController.boss.value != "" ? _busController.boss.value : "??????",
                          style: TextStyle(
                            color: AppColor.mainColor5,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15,
                          )))),
                  height: 60,
                  width: 160,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget busNumSelect() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 150,
            decoration: BoxDecoration(
              color: AppColor.mainColor4,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  SizedBox(
                    child: Center(
                        child: Text(
                      "??????",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )),
                    width: 50,
                  ),
                  GestureDetector(
                      onTap: () async{
                        await Get.dialog(BaseSelectDialog(["1???", "2???", "3???", "4???"])).then((e){
                          if(e != null){
                            _busController.numdriver.value = int.parse(e[0]);
                          }
                        });
                      },
                      child: SizedBox(
                        child: Center(
                            child:
                                Text("${_busController.numdriver.toString()}???",
                                    style: TextStyle(
                                      color: AppColor.mainColor5,
                                      fontSize: 15,
                                    ))),
                        width: 80,
                        height: 60,
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: GestureDetector(
              onTap: () => Get.dialog(selectDriverDialog()),
              child: Container(
                height: 60,
                width: Get.width - 250,
                decoration: BoxDecoration(
                  color: AppColor.mainColor4,
                  border: Border.all(
                    color: (_busController.driverList.length ==
                            _busController.numdriver.value)
                        ? Colors.transparent
                        : Colors.redAccent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: (Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: (Get.width - 280) / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_busController.driverList[0]["nick"]}",
                            style: TextStyle(
                                color: AppColor.blue4,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            "${_busController.driverList.length > 1 ? _busController.driverList[1]["nick"] : ""}",
                            style: TextStyle(
                                color: AppColor.blue4,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: (Get.width - 280) / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_busController.driverList.length > 2 ? _busController.driverList[2]["nick"] : ""}",
                            style: TextStyle(
                                color: AppColor.blue4,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            "${_busController.driverList.length > 3 ? _busController.driverList[3]["nick"] : ""}",
                            style: TextStyle(
                                color: AppColor.blue4,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget priceSelect() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15),
      child: Container(
        height: 60 * (_busController.price1.length == 0 ? 1 : _busController.price1.length).toDouble(),
        width: (LostArkList.specificType.contains(_busController.boss.value) || (_busController.price1.length != 0 && _busController.server.length != 1)) ? 250 : 150,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(
                child: Center(
                    child: Text(
                  "??????",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )),
                width: 50,
              ),
              (_busController.price1.length == 1 || _busController.price1.length == 0 || _busController.server.length == 1) ?
              Obx(() => GestureDetector(
                onTap: () => (_busController.numdriver.value == 1 || _busController.price1.length == 0 || _busController.server.length == 1) ? null : Get.dialog(priceSetDialog(0)) ,
                child: Row(
                  children: [
                    SizedBox(
                      width: 75,
                      child: Form(
                          key: priceKey,
                          child: TextFormField(
                            enabled: _busController.numdriver.value == 1 || _busController.server.length == LostArkList.serverList.length || _busController.server.length == 1,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.white70
                            ),
                            onChanged: (text){
                              if(text == ""){
                                text = "0";
                              }
                              _busController.price1.assignAll([{(_busController.server.length != LostArkList.serverList.length ? _busController.myCharacter['server'] : "?????? ??????") : int.parse(text)}]);
                            },
                            textAlign: TextAlign.center,
                            cursorColor: AppColor.mainColor5,
                            controller: priceController,
                            decoration: InputDecoration(
                              hintText: "0",
                              counterText: "",
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
                    ),
                    Text(LostArkList.specificType.contains(_busController.boss.value) ? "/" : "",
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(
                      width: LostArkList.specificType.contains(_busController.boss.value) ? 75 : 0,
                      child: Form(
                          key: price2Key,
                          child: TextFormField(
                            enabled: _busController.numdriver.value == 1 || _busController.server.length == LostArkList.serverList.length,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: Colors.white70
                            ),
                            onChanged: (text){
                              if(text == "" || text == "??????"){
                                text = "0";
                              }
                              _busController.price2.value = int.parse(text);
                            },
                            textAlign: TextAlign.center,
                            cursorColor: AppColor.mainColor5,
                            controller: price2Controller,
                            decoration: InputDecoration(
                              hintText: "??????",
                              counterText: "",
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
                    ),
                  ],

                ),
              )) : Obx(() => price2()),
            ],
          ),
        ),
      ),
    );
  }

  Widget price2(){
    var column = <Padding>[];
    print(_busController.price1);
    for(int i = 0; i < _busController.price1.length; i++){
      _busController.price1[i].forEach((key,value){
        column.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text("$key : ${value}g", style: TextStyle(color: Colors.white70),),
        ));
      });
    }
    if(_busController.price2 != 0 && LostArkList.specificType.contains(_busController.boss.value)){
      column.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text("?????? : ${_busController.price2.value.toString()}g", style: TextStyle(color: AppColor.dark_pink),),
      ));
    } else if(_busController.price2 == 0 && LostArkList.specificType.contains(_busController.boss.value)){
      column.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text("??????", style: TextStyle(color: AppColor.dark_pink),),
      ));
    }
    return Container(
      height: 60 * (_busController.price1.length + ((_busController.price2.value != 0) ? 1 : 0)).toDouble(),
      width: 160,
      decoration: BoxDecoration(
        color: AppColor.mainColor4,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: column,
          ),
        ),
      ),
    );
  }

  Widget timeSelect() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15),
      child: Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          color: AppColor.mainColor4,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(
            color: ((hourError == false && minuteError == false)) ? Colors.transparent : Colors.redAccent,
            width: 1,
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              SizedBox(
                child: Center(
                    child: Text(
                      "??????",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )),
                width: 50,
              ),
              SizedBox(
                child: Form(
                    key: hourKey,
                    child: TextFormField(
                      style: TextStyle(
                          color: Colors.white70
                      ),
                      onChanged: (text){
                        //_busController.time += int.parse((text != "") ? text : "0") * 100;
                        if(int.parse((text != "") ? text : "0") > 24){
                          CustomedFlushBar(context, "24???????????? ??????????????????");
                          setState(() {
                            hourError = true;
                          });
                        } else {
                          setState(() {
                            hourError = false;
                          });
                        }
                      },
                      // validator: (value){
                      //   if(int.parse(value) > 24){
                      //     return "24????????? ??????????????????";
                      //   } else{
                      //     return null;
                      //   }
                      // },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      cursorColor: AppColor.mainColor5,
                      controller: hourController,
                      decoration: InputDecoration(
                        hintText: "00",
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
                width: 55,
              ),
              Text(":", style: TextStyle(color: Colors.white70
              ),),
              SizedBox(
                child: Form(
                    key: minuteKey,
                    child: TextFormField(
                      style: TextStyle(
                          color: Colors.white70
                      ),
                      onChanged: (text){
                        //_busController.time += int.parse((text != "") ? text : "0");
                        if(int.parse((text != "") ? text : "0") >= 60){
                          CustomedFlushBar(context, "59????????? ??????????????????");
                          setState(() {
                            minuteError = true;
                          });
                        } else {
                          setState(() {
                            minuteError = false;
                          });
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      cursorColor: AppColor.mainColor5,
                      controller: minuteController,
                      decoration: InputDecoration(
                        hintText: "00",
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
                width: 55,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget registerButton() {
    return GestureDetector(
      onTap: checkValidate() ? () async {
        Get.dialog(CustomedCircular());
        _busController.time.value = int.parse(hourController.text) * 100 + int.parse(minuteController.text);
        if(_busController.numdriver == 1 || _busController.server.length == LostArkList.serverList.length){ // 1????????? ???????????? or ??????????????????
          if(LostArkList.specificType.contains(_busController.boss.value)){
            (_busController.price2 != 0) ? _busController.numPassenger.assignAll([((LostArkList.fourMemType.contains(_busController.boss.value) ? 3 : 7) - _busController.numdriver.value) , 1]) : _busController.numPassenger.assignAll([((LostArkList.fourMemType.contains(_busController.boss.value) ? 4 : 8) - _busController.numdriver.value)]);
          } else if(LostArkList.fourMemType.contains(_busController.boss.value)) {
            _busController.numPassenger.assignAll([4 - _busController.numdriver.value]);
          } else {
            _busController.numPassenger.assignAll([8 - _busController.numdriver.value]);
          }
        }
        if(priceController.text == ""){
          _busController.server.assignAll(LostArkList.serverList);
        }
        _busController.updateBusForm();
        _busController.busForm.uploader = _user.uid;
        await DatabaseService.instance.registerBus(_busController.busForm);
        _busController.dispose();
        Get.back();
        Get.back();
      } : () => CustomedFlushBar(context, "?????? ????????? ?????????"),
      child: Container(
        decoration: BoxDecoration(color: checkValidate() ? AppColor.lightBlue : Colors.blueGrey),
        height: 60,
        width: Get.width,
        child: Center(
            child: Text("??????",
                style: TextStyle(
                    color: checkValidate() ? Colors.white : AppColor.mainColor5,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget busNumDialog() {
    return AlertDialog(
      title: Text("?????? ???"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () {
                _busController.numdriver.value = 1;
                Get.back();
              },
              child: Container(
                height: 40,
                width: 150,
                child: Text("1???"),
              )),
          GestureDetector(
              onTap: () {
                _busController.numdriver.value = 2;
                Get.back();
              },
              child: Container(
                height: 40,
                width: 150,
                child: Text("2???"),
              )),
          GestureDetector(
              onTap: () {
                _busController.numdriver.value = 3;
                Get.back();
              },
              child: Container(
                height: 40,
                width: 150,
                child: Text("3???"),
              )),
          GestureDetector(
              onTap: () {
                _busController.numdriver.value = 4;
                Get.back();
              },
              child: Container(
                height: 40,
                width: 150,
                child: Text("4???"),
              )),
        ],
      ),
    );
  }

  Widget selectDriverDialog(){
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.mainColor4,
                width: 2
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            height: 150,
            width: 200,
            child: _mainController.favoriteList.length == 0 ? Center(child: Text("????????? ????????? ????????????"),)
            : Obx(() => ListView.builder(
                itemCount: _mainController.favoriteList.length,
                itemBuilder: (BuildContext context, int index){
                  print(index);
                  return GestureDetector(
                    onTap: (){
                      if(!_busController.driverList.contains(_mainController.favoriteList[index]))
                        if(_busController.driverList.length >= _busController.numdriver.value){
                          _busController.errorMessage.value = "????????? ????????? ????????? ??? ????????????";
                        } else {
                          _busController.driverList.add(_mainController.favoriteList[index]);
                        }
                      else
                        _busController.driverList.remove(_mainController.favoriteList[index]);
                      if(_busController.server.length != LostArkList.serverList.length){
                        List driverServer = [];
                        _busController.driverList.forEach((e) {
                          if(!driverServer.contains(e['server']))
                            driverServer.add(e['server']);
                        });
                        _busController.server.assignAll(driverServer);
                      }
                      // if(_busController.numdriver == _busController.driverList.length){
                      //   numCheck = true;
                      // } else {
                      //   numCheck = false;
                      // }
                    },
                    child: Obx(() => Container(
                      decoration: BoxDecoration(
                        borderRadius : BorderRadius.all(Radius.circular(6.0)),

                        color: (_busController.driverList.contains(_mainController.favoriteList[index])) ? AppColor.blue2 : Colors.transparent,
                      ),
                        height: 40,
                        child: Center(child: Text("${_mainController.favoriteList[index]['server']} / ${_mainController.favoriteList[index]['nick']}",
                          style: TextStyle(color: Colors.white70),
                        )))),
                  );
                })),
          ),
          // Obx(() => Text(
          //   _busController.errorMessage.value,
          //   style: TextStyle(color: Colors.red),
          // ),),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Text(
                   "${_busController.driverList.length.toString()} / ${_busController.numdriver.toString()}",
                  style: TextStyle(color: Colors.white70),
                )),
              ],
            ),
          ),
          // GestureDetector(
          //   onTap: () => Get.dialog(AddCharacterDialog(1)),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         color: AppColor.blue3,
          //       borderRadius: BorderRadius.all(Radius.circular(8.0))
          //     ),
          //     height: 40,
          //     width: 200,
          //     child: Center(child: Text("?????? ??????",
          //       style: TextStyle(color: Colors.white70),
          //     )),
          //   ),
          // ),
          SizedBox(
            height: 6,
          ),
          Obx(() => InkWell(
            onTap: (_busController.driverList.length < _busController.numdriver.value) ? () async{
              if(hourController.text != "" && minuteController.text != "" && _busController.boss != "" && !hourError && !minuteError){
                _busController.busForm.type = 1;
                _busController.time.value = int.parse(hourController.text) * 100 + int.parse(minuteController.text);
                _busController.updateBusForm();
                Get.dialog(CustomedCircular());
                await DatabaseService.instance.registerBus(_busController.busForm);
                Get.offAll(Navigation());
              } else {
                CustomedFlushBar(context, "??????/?????? ????????? ??????????????????");
              }
            } : () => CustomedFlushBar(context, "????????? ??????????????????"),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor.blue3,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              height: 50,
              width: 200,
              child: Center(child: Text("?????? ??????",
                style: TextStyle(color: Colors.white70),
              )),
            ),
          ),)
        ],
      ),
    );
  }

  Widget serverSelectDialog(){
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              _busController.server.assignAll(LostArkList.serverList);
              _busController.price1.assignAll([]);
              Get.back(result: "????????????");
            },
            child: Container(
              color: AppColor.blue1,
              height: 40,
              width: 150,
              child: Center(child: Text("?????? ??????",
                style: TextStyle(
                  color: Colors.white70
                ),
              )),
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              _busController.server.assignAll([]);
              _busController.driverList.forEach((e) {
                if(!_busController.server.contains(e['server']))
                  _busController.server.add(e['server']);
              });
              Get.back();
            },
            child: Container(
              color: AppColor.blue1,
              height: 40,
              width: 150,
              child: Center(child: Text("?????? ??????",
                  style: TextStyle(
                      color: Colors.white70
                  ),
              )),
            ),
          ),
          // Container(
          //   height: 40,
          //   width: 150,
          //   child: Center(child: Text("??? ??????")),
          // ),
        ],
      ),
    );
  }

  Widget priceOptionDialog(){
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: (){
              Get.back();
              Get.dialog(priceSetDialog(0));
            },
            child: Container(
              color: AppColor.blue1,
              height: 45,
              width: 150,
              child: Center(child: Text("??????",
                style: TextStyle(color: Colors.white70),
              )),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: (){
              Get.back();
              Get.dialog(priceSetDialog(1));
            },
            child: Container(
              color: AppColor.blue1,
              height: 45,
              width: 150,
              child: Center(child: Text("?????????",
                style: TextStyle(color: Colors.white70),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget priceSetDialog(int type){
    var textcontroller = <TextEditingController>[];
    var numcontroller = <TextEditingController>[];
    var inputForm = <Padding>[];
    // if(type == 0){
    //   inputForm.add(Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 5.0),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         color: AppColor.mainColor4,
    //         borderRadius: BorderRadius.all(Radius.circular(8.0)),
    //       ),
    //       child: Row(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           SizedBox(
    //               width: 80,
    //               child: Center(child: Text("??????",
    //                 style: TextStyle(color: Colors.white),
    //               ))),
    //           Container(
    //             width: 80,
    //             child: TextField(
    //               decoration : InputDecoration(
    //                 disabledBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(8.0),
    //                     borderSide: BorderSide(color: Colors.transparent)
    //                 ),
    //                 focusColor: AppColor.mainColor,
    //                 enabledBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(8.0),
    //                     borderSide: BorderSide(color: Colors.transparent)
    //                 ),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(8.0),
    //                     borderSide: BorderSide(color: Colors.transparent)
    //                 ),
    //               ),
    //               keyboardType: TextInputType.number,
    //               cursorColor: Colors.white70,
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                   color: Colors.white70
    //               ),
    //               controller: textcontroller[i],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ));
    // } else {
    //  
    // }
    for(int i = 0; i < _busController.server.length; i++){
      textcontroller.add(new TextEditingController());
      numcontroller.add(new TextEditingController());
      inputForm.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.mainColor4,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: 80,
                  child: Center(child: Text(_busController.server[i],
                    style: TextStyle(color: Colors.white),
                  ))),
              Container(
                width: 70,
                child: TextField(
                  decoration : InputDecoration(
                    hintText: "??????",
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
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white70,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70
                  ),
                  controller: textcontroller[i],
                ),
              ),
              Text("/", style: TextStyle(color: Colors.white70),),
              Container(
                width: 70,
                child: TextField(
                  decoration : InputDecoration(
                    hintText: "??????",
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
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white70,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white70
                  ),
                  controller: numcontroller[i],
                ),
              ),
            ],
          ),
        ),
      ));
    }
    if(LostArkList.specificType.contains(_busController.boss.value)){
      textcontroller.add(new TextEditingController());
      inputForm.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          width: 230,
          decoration: BoxDecoration(
            color: AppColor.mainColor4,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: 80,
                  child: Center(child: Text("??????",
                    style: TextStyle(color: Colors.white),
                  ))),
              Container(
                width: 150,
                child: TextField(
                  decoration : InputDecoration(
                    hintText: "??????",
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
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white70,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white70
                  ),
                  controller: textcontroller[textcontroller.length-1],
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return AlertDialog(
      backgroundColor: AppColor.mainColor2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: inputForm,
          ),
          TextButton(child: Text("??????"), onPressed: (){
            List price1 = [];
            List numPassenger = [];
            for(int i=0; i < numcontroller.length; i++){
              numPassenger.add(int.parse(numcontroller[i].text));
            }
            for(int i=0; i < textcontroller.length; i++){
              if(LostArkList.specificType.contains(_busController.boss.value) && i == textcontroller.length-1){
                if(textcontroller[i].text == ""){
                  _busController.price2.value = 0;
                } else {
                  _busController.price2.value = int.parse(textcontroller[i].text);
                }
                numPassenger.add(1);
              } else {
                price1.add({_busController.server[i] : textcontroller[i].text});
              }
            }
            _busController.price1.assignAll(price1);
            _busController.numPassenger.assignAll(numPassenger);
            Get.back();
          },)
        ],
      ),
    );
  }




  bool checkValidate(){
    bool numCheck = _busController.numdriver.value == _busController.driverList.length;
    bool timeCheck = (hourController.text != "" && minuteController.text != ""
      && int.parse(hourController.text) < 25 && int.parse(minuteController.text) < 60
    ) ? true : false;
    bool bossCheck = (_busController.boss.value != "") ? true : false;
    print("num $numCheck");
    print("time $timeCheck");
    print("boss $bossCheck");
    return (numCheck && timeCheck && bossCheck);
  }


  
}
