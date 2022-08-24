import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/myPage/myPage.dart';
import 'package:lostarkbus/ui/map/map.dart';
import 'package:lostarkbus/ui/bus/bus.dart';
import 'package:lostarkbus/ui/myPage/myPageMenu.dart';
import 'package:lostarkbus/ui/trade/trade.dart';
import 'package:lostarkbus/util/colors.dart';

class NavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;

  MainController _mainController = Get.find();
  @override
  void onInit() async {
    DatabaseService.instance.setUser(_mainController.user.value.uid);
    super.onInit();
  }
}

class Navigation extends StatelessWidget {
  final NavigationController _navigationController =
      Get.put(NavigationController());

  int get _selectedIndex => _navigationController.selectedIndex.value;

  final Color activeColor = Colors.blue;
  final Color inactiveColor = Colors.grey;

  final List iconImages = [
    Icons.calendar_today_outlined,
    Icons.attach_money,
    Icons.map_outlined,
    Icons.account_box,
  ];

  final List inactiveIcons = [Icons.favorite, Icons.group, Icons.notifications];

  final List<Widget> _page = <Widget>[Bus(), Trade(), MapPage(), Mypage()];

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop(BuildContext context) {
    if (_selectedIndex != 0) {
      _navigationController.selectedIndex.value = 0;
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: SafeArea(
        top: false,
        child: Scaffold(
          key: _key,
          //backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          //appBar: buildAppBar(context),
          body: Obx(() => _page.elementAt(_selectedIndex)),
          bottomNavigationBar: SizedBox(
              height: 60,
              child: Obx(
                () => Row(
                  children: <Widget>[
                    buildTabbar('버스', 0),
                    buildTabbar('거래', 1),
                    buildTabbar('지도', 2),
                    buildTabbar('내 정보', 3),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      title: const Text(
        'Test',
        style: TextStyle(color: Colors.black, fontFamily: "AppleSDGothicNeoM"),
      ),
      actions: [],
    );
  }

  Widget buildTabbar(String tabName, int index) {
    var tabbarWidth = Get.width / 4;
    return Container(
      color: AppColor.mainColor,
      width: tabbarWidth,
      child: InkWell(
        onTap: () => _navigationController.selectedIndex.value = index,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                //top: BorderSide(color: Colors.grey[300]),
                ),
          ),
          width: tabbarWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconImages[index],
                color: _selectedIndex == index ? activeColor : inactiveColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(tabName,
                    style: _barTextStyle(_selectedIndex == index)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _barTextStyle(active) {
    if (active)
      return TextStyle(color: activeColor, fontSize: 12);
    else
      return TextStyle(color: inactiveColor, fontSize: 12);
  }
}
