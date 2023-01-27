import 'dart:ui';
import 'package:flight_booking_sys/controller/reportController.dart';

import '../../view/components/complexDrawer.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../constants/constantsVariables.dart';
import '../../constants/theme.dart';
import '../../controller/scaffoldController.dart';
import 'package:supercharged/supercharged.dart';
import 'package:simple_animations/simple_animations.dart';

class ViewContainerComponent extends StatelessWidget {
  final sc = ScaffoldController.controller;
  final storage = GetStorage();
  final Widget child;
  ViewContainerComponent(
    this.child, {
    Key? key,
  }) : super(key: key);
  bool isSplash() {
    return sc.currentRoute.value == "" || sc.currentRoute.value == SpalshRoute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: buildDrawer(),
      appBar: PreferredSize(
        child: Obx(() {
          double statusBarHeight =
              MediaQueryData.fromWindow(window).padding.top;
          if (!sc.showNetworkAppbar.value || !sc.showAppbar.value) {
            return SizedBox(height: statusBarHeight);
          }
          return appbarBuilder(Get.context!);
        }),
        preferredSize: Size.fromHeight(56.0),
      ),
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: Obx(() {
        if (!sc.showNetworkBottom.value || !sc.showBottom.value)
          return SizedBox();
        return SizedBox();
        // return buildBottomNavigationBar();
      }),
    );
  }

  Widget appbarBuilder(BuildContext context) {
    return Obx(() {
      String title = "";
      switch (sc.currentRoute.value) {
        case MainRoute:
          title = "الصفحة الرئيسية";
          break;
        case CommentRoute:
          title = "تعليقات التبليغ";
          break;
        default:
      }
      return AppBar(
        elevation: 0,
        actions: [
          // PopupMenuButton(
          //     onSelected: (locale) {
          //       String _locale = locale == 1
          //           ? "ar"
          //           : locale == 2
          //               ? "he"
          //               : "en";
          //       storage.write('locale', _locale);
          //       print(_locale);
          //       Get.updateLocale(Locale(_locale));
          //     },
          //     itemBuilder: (context) {
          //       return [
          //         PopupMenuItem(
          //           child: Text("عربي"),
          //           value: 1,
          //         ),
          //         PopupMenuItem(
          //           child: Text("كوردى"),
          //           value: 2,
          //         ),
          //         PopupMenuItem(child: Text("English"), value: 3),
          //       ];
          //     },
          //     icon: Icon(Icons.public)),

          ThemeSwitcher(
            clipper: ThemeSwitcherCircleClipper(),
            builder: (context) {
              return IconButton(
                onPressed: () {
                  sc.isDark.toggle();
                  storage.write("dark", sc.isDark.value);
                  ThemeSwitcher.of(context).changeTheme(
                    theme: ThemeModelInheritedNotifier.of(context)
                                .theme
                                .brightness ==
                            Brightness.light
                        ? Themes.dark
                        : Themes.light,
                  );
                },
                icon: Icon(
                    sc.isDark.value ? Icons.wb_sunny : Icons.brightness_2,
                    size: 25),
              );
            },
          ),
          Obx(() {
            if (ScaffoldController.controller.currentRoute.value !=
                ScaffoldController.controller.firstRoute.value)
              return TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "رجوع",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ));
            else
              return IconButton(
                  onPressed: () {
                    ReportController.controller.showFeedback(context);
                  },
                  icon: Icon(Icons.help));
          })
        ],
        title: Text(title),
      );
    });
  }

  Widget buildBottomNavigationBar() {
    return Obx(() {
      switch (sc.currentRoute.value) {
        case MainRoute:
          break;
        default:
      }
      return ObxValue(
        (data) {
          return new PlayAnimation<double?>(
              key: UniqueKey(),
              curve: Curves.easeInOut,
              tween: sc.hideBttomBar.value
                  ? 50.0.tweenTo(0)
                  : 0.0.tweenTo(50), // define tween
              duration: 500.milliseconds, // define duration

              builder: (context, child, value) {
                return Container(
                  color: Colors.red,
                  width: 100,
                  height: value,
                );
              });
        },
        sc.hideBttomBar,
      );
    });
  }

  Widget? buildDrawer() {
    final sc = ScaffoldController.controller;

    if (sc.currentRoute.value == RegisterationRoute) return null;
    return ComplexDrawer();
  }
}
