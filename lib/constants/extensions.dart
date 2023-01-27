import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../view/components/hideGlowingComponent.dart';
import '../view/components/viewContainerComponent.dart';

bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 1100;
//constraints.maxWidth
bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width < 1100 &&
    MediaQuery.of(context).size.width >= 650;

extension PageBuilder on Widget {
  Widget scaffold() => ScrollConfiguration(
        behavior: HideGlowScrollingComponent(),
        child: KeyboardDismisser(
            gestures: [GestureType.onVerticalDragDown],
            child: ViewContainerComponent(this)),
      );
}

extension ParseNumber on String {
  String numberParser() {
    if (Get.locale?.languageCode == "en") return this;
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ','];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩', '،'];
    String output = this;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], arabic[i]);
    }
    return output;
  }
}

extension Neumorphism on Widget {
  addNeumorphism(
    BuildContext context, {
    double borderRadius = 10.0,
    Offset offset = const Offset(5, 5),
    double blurRadius = 10,
    Color topShadowColor = Colors.white60,
    Color bottomShadowColor = const Color(0x26234395),
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            offset: offset,
            blurRadius: blurRadius,
            color: bottomShadowColor,
          ),
          BoxShadow(
            offset: Offset(-offset.dx, -offset.dx),
            blurRadius: blurRadius,
            color: topShadowColor,
          ),
        ],
      ),
      child: this,
    );
  }
}
