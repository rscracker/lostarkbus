import 'package:lostarkbus/model/busModel.dart';
import 'package:get/get.dart';

class BusController extends GetxController{
  var busForm = BusModel().obs();
  RxMap<dynamic, dynamic> myCharacter = {}.obs;
  RxList driverList = [].obs;
  RxInt numdriver = 0.obs;
  RxList server = [].obs;
  RxString boss = "미정".obs;
  RxList price1 = [].obs;
  RxInt price2 = 0.obs;
  RxString errorMessage = "".obs;
  RxInt time = 0.obs;
  RxList numPassenger = [].obs;
  //RxMap<String, dynamic> bus = {}.obs;

  @override
  void onInit() {
    this.busForm = BusModel.initBusForm();
    numdriver.value = 1;
    price2.value = 0;
    //this.bus = BusModel.initBusForm().toJson();
    super.onInit();
  }

  void registerBus(String uid) async{

  }

  updateBusForm() async{
    this.busForm.server.assignAll(server);
    this.busForm.driverList.assignAll(driverList);
    this.busForm.numDriver = numdriver.value;
    this.busForm.time = time.value;
    this.busForm.price1.assignAll(price1);
    this.busForm.busName = boss.value;
    this.busForm.numPassenger.assignAll(numPassenger);
    if(price2.value != 0){
      this.busForm.price2.assign(price2.value);
    }
  }

  // registerCharacter(Map<String, dynamic> character) async{
  //   this.myCharacter = character;
  // }

}