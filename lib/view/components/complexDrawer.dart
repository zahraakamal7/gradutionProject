import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/constants/custom_icon_icons.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:get/get.dart';
import '../../constants/extensions.dart';
import 'overlayMenu.dart';

class ComplexDrawer extends StatefulWidget {
  const ComplexDrawer({Key? key}) : super(key: key);

  @override
  _ComplexDrawerState createState() => _ComplexDrawerState();
}

class _ComplexDrawerState extends State<ComplexDrawer> {
  int selectedIndex = -1; //dont set it to 0
  final auth = AuthController.controller;
  bool isExpanded = true;
  double responsiveWidth(BuildContext context) {
    if (isDesktop(context)) return MediaQuery.of(context).size.width / 5;
    if (isTablet(context))
      return MediaQuery.of(context).size.width / 3;
    else
      return MediaQuery.of(context).size.width / 1.5;
  }

  @override
  Widget build(BuildContext context) {
    double width = responsiveWidth(context);
    return Portal(
      child: Container(
        width: width,
        child: row(context),
      ),
    );
  }

  Widget row(BuildContext context) {
    return Row(children: [
      isExpanded
          ? Flexible(child: blackIconTiles(context))
          : Flexible(child: blackIconMenu(context)),
    ]);
  }

  Widget blackIconTiles(BuildContext context) {
    return Container(
      color: context.theme.backgroundColor,
      child: Column(
        children: [
          Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: controlTile(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cdms.length,
              itemBuilder: (BuildContext context, int index) {
                //  if(index==0) return controlTile();

                CDM cdm = cdms[index];
                bool selected = selectedIndex == index;
                if (cdm.submenus.length == 0)
                  return ListTile(
                    tileColor: context.theme.backgroundColor,
                    leading: Icon(
                      cdm.icon,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: cdm.tap,
                    title: Text(
                      cdm.title,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      // color: Colors.white,
                    ),
                    trailing: cdm.submenus.isEmpty
                        ? null
                        : Icon(
                            selected
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                  );
                return ExpansionTile(
                    backgroundColor: context.theme.backgroundColor,
                    onExpansionChanged: (z) {
                      setState(() {
                        selectedIndex = z ? index : -1;
                      });
                    },
                    leading: Icon(cdm.icon),
                    title: Text(
                      cdm.title,
                      style: TextStyle(
                          color: context.theme.textTheme.bodyText2!.color),
                      // color: Colors.white,
                    ),
                    trailing: cdm.submenus.isEmpty
                        ? null
                        : Icon(
                            selected
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                    children: cdm.submenus.map((subMenu) {
                      return sMenuButton(subMenu, false);
                    }).toList());
              },
            ),
          ),
          // Obx(() {
          //   if (auth.isAuth.value)
          //     return accountTile();
          //   else
          //     return SizedBox();
          // }),
        ],
      ),
    );
  }

  Widget controlTile() {
    return Padding(
      padding: EdgeInsets.only(top: 25, bottom: 30),
      child: ListTile(
        leading: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).backgroundColor,
            ),
            child: Image.asset(
              'assets/icon_no_background.png',
              fit: BoxFit.fill,
            )),
        title: Text(
          "منصة فرجال",
          style: TextStyle(color: context.theme.backgroundColor),
        ),
        onTap: expandOrShrinkDrawer,
      ),
    );
  }

  Widget blackIconMenu(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      width: 100,
      color: context.theme.colorScheme.background,
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: controlButton(),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: cdms.length,
                    itemBuilder: (contex, index) {
                      // if(index==0) return controlButton();
                      return Container(
                        child: OverlayChildParent(
                            InkWell(
                              onTap: cdms[index].tap,
                              child: Container(
                                height: 60,
                                alignment: Alignment.center,
                                child: Icon(
                                  cdms[index].icon,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            subMenuWidget([cdms[index].title]
                              ..addAll(cdms[index].submenus)),
                            cdms[index].submenus.length),
                      );
                    }),
              ),
              // Obx(() {
              //   if (auth.isAuth.value)
              //     return accountButton();
              //   else
              //     return SizedBox();
              // }),
            ],
          );
        },
      ),
    );
  }

  Widget controlButton() {
    return Padding(
      padding: EdgeInsets.only(top: 30, bottom: 30),
      child: InkWell(
        onTap: expandOrShrinkDrawer,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).backgroundColor,
              ),
              child: Image.asset(
                'assets/icon_no_background.png',
                fit: BoxFit.fill,
              )),
        ),
      ),
    );
  }

  Widget subMenuWidget(List<String> submenus) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: context.theme.backgroundColor,
          borderRadius: BorderRadius.circular(5)),
      child: SingleChildScrollView(
        primary: true,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: submenus
                .map((subMenu) =>
                    sMenuButton(subMenu, submenus.indexOf(subMenu) == 0))
                .toList()),
      ),
    );
  }

  Widget sMenuButton(String subMenu, bool isTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            //handle the function
            //if index==0? donothing: doyourlogic here
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              subMenu,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isTitle
                      ? context.theme.textTheme.headline1!.color
                      : context.theme.textTheme.bodyText2!.color,
                  fontSize: isTitle ? 17 : 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget accountButton({bool usePadding = true}) {
    return Padding(
      padding: EdgeInsets.all(usePadding ? 8 : 0),
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.white70,
          image: DecorationImage(
            image: NetworkImage(
                "https://image.flaticon.com/icons/png/512/147/147144.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget accountTile() {
    return Container(
      // color: Colorz.complexDrawerBlueGrey,
      child: ListTile(
        leading: accountButton(usePadding: false),
        title: Text(
          "Prem Shanhi",
          style: TextStyle(color: Colors.white),
          // color: Colors.white,
        ),
        subtitle: Text(
          "Web Designer",
          style: TextStyle(color: Colors.white70),
          // color: Colors.white70,
        ),
      ),
    );
  }

  List<CDM> cdms = [
    // CDM(Icons.grid_view, "Control", []),

    // CDM(Icons.grid_view, "Dashboard", []),
    // CDM(Icons.subscriptions, "Category",
    //     ["HTML & CSS", "Javascript", "PHP & MySQL"]),
    // CDM(Icons.markunread_mailbox, "Posts", ["Add", "Edit", "Delete"]),
    // CDM(Icons.pie_chart, "Analytics", []),
    // CDM(Icons.trending_up, "Chart", []),

    // CDM(Icons.power, "Plugins",
    //     ["Ad Blocker", "Everything Https", "Dark Mode"]),
    // CDM(Icons.explore, "Explore", []),
    // CDM(Icons.settings, "Setting", []),
  ];

  void expandOrShrinkDrawer() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    cdms.add(CDM(Icons.home, "الصفحة الرئيسية", [], tap: () async {
      Get.back();
      if (!(Get.currentRoute == MainRoute)) {
        await Get.offAllNamed(MainRoute);
      }
    }));
    cdms.add(CDM(Icons.notifications, "التنبيهات", [], tap: () async {
      Get.back();
      if (!(Get.currentRoute == NotificationRoute)) {
        await Get.toNamed(NotificationRoute);
      }
    }));
    if (!auth.isAuth.value) {
      cdms.add(CDM(Icons.login, "تسجيل دخول", [], tap: () async {
        Get.back();
        await Get.toNamed(RegisterationRoute);
      }));
    }
    cdms.add(
        CDM(Icons.calendar_view_month, "جدول المحاضرات", [], tap: () async {
      Get.back();
      if (!(Get.currentRoute == DailyTableRoute)) {
        await Get.toNamed(DailyTableRoute);
      }
    }));
    cdms.add(CDM(CustomIcon.asset_3, "جدول الإمتحانات", [], tap: () async {
      Get.back();
      if (!(Get.currentRoute == ExamTableRoute)) {
        await Get.toNamed(ExamTableRoute);
      }
    }));
    if (UserType.Student == auth.userType.value)
      cdms.add(CDM(Icons.school, "الشهادة", [], tap: () async {
        Get.back();
        if (!(Get.currentRoute == CertificateTableRoute)) {
          await Get.toNamed(CertificateTableRoute);
        }
      }));

    if (auth.isAuth.value) {
      cdms.add(CDM(Icons.logout, "تسجيل خروج", [], tap: () async {
        if (auth.isLoading.value) return;
        Get.back();
        await auth.logout();
      }));
    }
  }
}

class CDM {
  //complex drawer menu
  final IconData icon;
  final String title;
  final List<String> submenus;
  VoidCallback? tap;
  CDM(this.icon, this.title, this.submenus, {this.tap});
}
