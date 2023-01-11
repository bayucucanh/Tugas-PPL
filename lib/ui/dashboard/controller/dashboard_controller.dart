import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/auth.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/ui/home/controller/home_controller.dart';
import 'package:mobile_pssi/ui/home/controller/menu.controller.dart';

class DashboardController extends BaseController {
  static DashboardController get to => Get.put(DashboardController());
  final _authRequest = AuthRequest();
  final pageController = PageController();
  final pageIndex = 0.obs;
  final pages = <Widget>[].obs;
  final menuItems = <BottomNavigationBarItem>[].obs;

  @override
  void onInit() {
    getUserData();
    _refreshToken();
    // WsClient.instance.init();
    _getPages();
    _getMenus();
    // debugPrint(WsClient.instance.getSocketId());
    super.onInit();
  }

  _refreshToken() async {
    try {
      String? token = await messaging.getToken(vapidKey: F.vapidKey);
      _authRequest.updateFcmToken(token: token!);
    } catch (_) {}
  }

  _getPages() {
    if (userData.value.isPlayer) {
      pages.addAll(MenuController.getPlayerBottomNavbar()
          .map((e) => e.widget!)
          .toList());
    } else if (userData.value.isClub) {
      pages.addAll(
          MenuController.getClubBottomNavbar().map((e) => e.widget!).toList());
    } else {
      pages.addAll(
          MenuController.getCoachBottomNavbar().map((e) => e.widget!).toList());
    }
  }

  _getMenus() {
    if (userData.value.isPlayer) {
      menuItems.addAll(MenuController.getPlayerBottomNavbar()
          .map(
            (navbar) => BottomNavigationBarItem(
                icon: Icon(navbar.icon), label: navbar.label),
          )
          .toList());
    } else if (userData.value.isCoach) {
      menuItems.addAll(MenuController.getCoachBottomNavbar()
          .map(
            (navbar) => BottomNavigationBarItem(
                icon: Icon(navbar.icon), label: navbar.label),
          )
          .toList());
    } else if (userData.value.isClub) {
      menuItems.addAll(MenuController.getClubBottomNavbar()
          .map(
            (navbar) => BottomNavigationBarItem(
                icon: Icon(navbar.icon), label: navbar.label),
          )
          .toList());
    }
  }

  changePage(int index) {
    if (index == 0) {
      if (HomeController.to.scrollController.hasClients) {
        HomeController.to.scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      }
    }
    pageIndex(index);
    pageController.animateToPage((index),
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 500));
  }

  Widget? get getBottomNavbar {
    if (!userData.value.isClub && !userData.value.isPlayer) {
      if (userData.value.hasOneRole && !userData.value.isCoach) {
        return null;
      } else if (userData.value.hasOneRole && userData.value.isCoach) {
        return BottomNavigationBar(
          currentIndex: pageIndex.value,
          onTap: changePage,
          items: menuItems,
        );
      } else if (userData.value.hasMultiRole && !userData.value.isCoach) {
        return null;
      } else if (userData.value.hasMultiRole && userData.value.isCoach) {
        return BottomNavigationBar(
          currentIndex: pageIndex.value,
          onTap: changePage,
          items: menuItems,
        );
      } else {
        return null;
      }
    } else {
      return BottomNavigationBar(
        currentIndex: pageIndex.value,
        onTap: changePage,
        items: menuItems,
      );
    }
  }
}
