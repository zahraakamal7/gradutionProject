import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/constants/full_screen_image.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/controller/reportController.dart';
import 'package:flight_booking_sys/controller/reportFormController.dart';
import 'package:flight_booking_sys/controller/scaffoldController.dart';
import 'package:flight_booking_sys/model/reportModel.dart';
import 'package:flight_booking_sys/view/components/customGroupButton/utils/grouping_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'components/customGroupButton/group_button_body.dart';

class MainView extends StatelessWidget {
  MainView({Key? key}) : super(key: key);
  final reportController = ReportController.controller;
  final auth = AuthController.controller;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ScaffoldController.controller.showAppbar.value = true;
    });
    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
        constraints: constraints.copyWith(
          minHeight: constraints.maxHeight,
          maxHeight: double.infinity,
        ),
        child: RefreshIndicator(
          onRefresh: () => reportController.preFetchData(),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: appBarBottom(context)),
                    if (auth.userType.value == UserType.Teacher)
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle),
                        child: IconButton(
                            onPressed: () {
                              ReportFormController.controller.isEdit.value =
                                  false;
                              Get.toNamed(ReportFormRoute);
                            },
                            icon: Icon(Icons.add,
                                color:
                                    Theme.of(context).colorScheme.background)),
                      )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  scrollDirection: Axis.vertical,
                  controller: reportController.scrollController,
                  child: Column(
                    children: [
                      buildReportsType(context),
                      reportBodyBuilder(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget reportBodyBuilder(BuildContext context) {
    return Obx(() {
      if (!reportController.isFetching.value &&
          reportController.reports.length == 0)
        return Container(
          padding: EdgeInsets.only(top: Get.height / 3),
          child: Center(
            child: Text("لا يوجد تبليغات متاحة."),
          ),
        );
      else {
        return Column(
          children: [
            // generalReportItemBuilder(context),
            // privateReportItemBuilder(context),
            // assignmentItemBuilder(context)
            // examItemBuilder(context)
            ...reportController.reports.map((report) {
              switch (report.type) {
                case 0:
                  return absentReportItemBuilder(context, report);

                case 1:
                  return generalReportItemBuilder(context, report);

                case 2:
                  return privateReportItemBuilder(context, report);

                case 3:
                  return examItemBuilder(context, report);

                case 4:
                  return assignmentItemBuilder(context, report);

                default:
                  return Text("غير معروف");
              }
            }).toList(),
            if (reportController.isFetching.value)
              Container(
                padding: EdgeInsets.only(top: Get.height / 3),
                child: Center(child: CircularProgressIndicator()),
              )
          ],
        );
      }
    });
  }

  Widget appBarBottom(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration:
          BoxDecoration(color: Theme.of(context).appBarTheme.backgroundColor),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "${auth.user.value!.fullName}",
                style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor),
              )
            ],
          ),
          Row(
            children: [
              Text(
                "${auth.userTypeText()}${auth.userTypeText() == 'طالب' ? (" - " + auth.user.value!.studentStage!.name!) : ''}",
                style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor),
              )
            ],
          ),
          if (auth.userType.value == UserType.Teacher) Divider(),
          if (auth.userType.value == UserType.Teacher)
            Obx(() {
              List<String> materials = List.empty(growable: true);
              materials.add("الكل");

              auth.stageMaterial.keys.forEach((String e) {
                if (reportController.selectedClass.value == "الكل" ||
                    reportController.selectedClass.value == e) {
                  auth.stageMaterial[e]!.forEach((m) {
                    if (materials.indexOf(m.name!) == -1)
                      materials.add(m.name!);
                  });
                }
              });
              return Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: Theme.of(context).iconTheme.copyWith(
                      color: Theme.of(context).appBarTheme.foregroundColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownSearch<String>(
                          dropdownBuilder: (context, selectedItem) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor),
                              child: Text(
                                selectedItem!,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .appBarTheme
                                            .foregroundColor),
                              ),
                            );
                          },
                          dropdownSearchDecoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "الصف",
                              labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .foregroundColor)),
                          searchFieldProps: TextFieldProps(
                              decoration:
                                  InputDecoration(border: InputBorder.none)),
                          mode: Mode.BOTTOM_SHEET,
                          showSelectedItems: false,
                          items: ['الكل', ...auth.stageMaterial.keys],
                          popupItemDisabled: (String s) => s
                              .startsWith(reportController.selectedClass.value),
                          onChanged: (i) {
                            reportController.selectedClass.value = i!;
                            reportController.selectedMaterial.value = "الكل";
                            reportController.preFetchData();
                          },
                          selectedItem: reportController.selectedClass.value),
                    ),
                    Expanded(
                      child: DropdownSearch<String>(
                          dropdownBuilder: (context, selectedItem) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor),
                              child: Text(
                                selectedItem!,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .appBarTheme
                                            .foregroundColor),
                              ),
                            );
                          },
                          dropdownSearchDecoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "المادة",
                              labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .foregroundColor)),
                          searchFieldProps: TextFieldProps(
                              decoration:
                                  InputDecoration(border: InputBorder.none)),
                          mode: Mode.BOTTOM_SHEET,
                          showSelectedItems: false,
                          items: materials,
                          popupItemDisabled: (String s) => s.startsWith(
                              reportController.selectedMaterial.value),
                          onChanged: (i) {
                            reportController.selectedMaterial.value = i!;
                            reportController.preFetchData();
                          },
                          selectedItem:
                              reportController.selectedMaterial.value),
                    ),
                  ],
                ),
              );
            })
        ],
      ),
    );
  }

  Widget buildReportsType(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: GroupButtonBody(
        groupingType: GroupingType.row,
        onSelected: (i, selected) {
          reportController.reportsQueryType.value = i;
          reportController.preFetchData();
        },
        selectedButton: reportController.reportsQueryType.value,
        isRadio: true,
        unselectedColor: Theme.of(context).dividerColor,
        unselectedBorderColor: Theme.of(context).dividerColor,
        unselectedTextStyle: Theme.of(context).textTheme.subtitle1,
        disabledButtons: auth.userType.value == UserType.Teacher ? [1] : [],
        buttons: [
          "كل التبليغات",
          "الغياب",
          "عام",
          "خاص",
          "امتحان",
          "واجبات",
        ],
      ),
    );
  }

  Widget generalReportItemBuilder(BuildContext context, ReportModel report) {
    return Container(
      margin: EdgeInsets.only(top: 5, right: 10, left: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12)],
          borderRadius: BorderRadius.circular(2)),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 5,
                  margin: EdgeInsets.symmetric(vertical: 5).copyWith(right: 5),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.info, color: Colors.blue),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "الإدارة من : ${report.issuer?.fullName}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children: [
                          Text("${report.body}"),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text(timeago.format(report.createdAt!, locale: 'ar'))],
          )
        ],
      ),
    );
  }

  Widget privateReportItemBuilder(BuildContext context, ReportModel report) {
    return Container(
      margin: EdgeInsets.only(top: 5, right: 10, left: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12)],
          borderRadius: BorderRadius.circular(2)),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 5,
                  margin: EdgeInsets.symmetric(vertical: 5).copyWith(right: 5),
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent[100],
                      borderRadius: BorderRadius.circular(10)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.person, color: Colors.orangeAccent[100]),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "التدريسي : ${report.issuer?.fullName}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "الطالب : ${report.user?.fullName}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (report.material != null)
                        Text(
                          "المادة : ${report.material?.name}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      Wrap(
                        children: [
                          Text("${report.body}"),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text(timeago.format(report.createdAt!, locale: 'ar'))],
          )
        ],
      ),
    );
  }

  Widget assignmentItemBuilder(BuildContext context, ReportModel report) {
    return Container(
      margin: EdgeInsets.only(top: 5, right: 10, left: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12)],
          borderRadius: BorderRadius.circular(2)),
      child: ObxValue((RxDouble currentIndex) {
        double _currentIndex = currentIndex.value;
        print(_currentIndex);
        return Column(
          children: [
            if (report.images!.length > 0)
              CarouselSlider(
                options: CarouselOptions(
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    onPageChanged: (i, state) {
                      currentIndex.value = i.toDouble();
                    }),
                items: report.images!.map((i) {
                  final imageWidget = CachedNetworkImage(
                    imageUrl: i!.image!,
                    width: Get.width,
                    imageBuilder: (context, image) {
                      return Container(
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(children: <Widget>[
                            Positioned.fill(
                              child: InkResponse(
                                  child: Image(
                                image: image,
                                fit: BoxFit.fitWidth,
                              )),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkResponse(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                                opaque: false,
                                                barrierColor:
                                                    Colors.white.withOpacity(0),
                                                pageBuilder:
                                                    (BuildContext context, _,
                                                        __) {
                                                  return FullScreenPage(
                                                    child: PhotoView(
                                                      minScale: 0.1,
                                                      maxScale: 1.0,
                                                      imageProvider:
                                                          CachedNetworkImageProvider(
                                                        i.image!,
                                                      ),
                                                    ),
                                                  );
                                                }));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                        child: Icon(Icons.fullscreen),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkResponse(
                                      onTap: () => saveImage(i.image),
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context)
                                                .backgroundColor),
                                        child: Icon(Icons.download),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ]),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return Center(
                          child: LoadingBouncingGrid.circle(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withAlpha(100),
                      ));
                    },
                  );
                  return imageWidget;
                }).toList(),
              ),
            if (report.images!.length > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: DotsIndicator(
                          dotsCount: report.images!.length,
                          position: currentIndex.value)),
                ],
              ),
            Padding(
              padding: EdgeInsets.all(10),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      margin:
                          EdgeInsets.symmetric(vertical: 5).copyWith(right: 5),
                      decoration: BoxDecoration(
                          color: Colors.green[200],
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.file_copy, color: Colors.green[200]),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${report.issuer?.fullName}" + " / واجب",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "المادة : ${report.material?.name}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (report.body != null)
                            Wrap(
                              children: [
                                Text("${report.body}"),
                              ],
                            )
                        ],
                      ),
                    ),
                    if (auth.userType.value == UserType.Teacher)
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                ReportFormController.controller.isEdit.value =
                                    true;
                                final index =
                                    reportController.reports.indexOf(report);
                                ReportFormController
                                    .controller.currentReport.value = index;
                                Get.toNamed(ReportFormRoute);
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                reportController.deleteReport(report);
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    if (auth.userType.value == UserType.Student &&
                        report.link != null)
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                            child: IconButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  launch(report.link!);
                                },
                                icon: Icon(Icons.play_arrow)),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCommentButton(context, report),
                  Text(timeago.format(report.createdAt!, locale: 'ar'))
                ],
              ),
            )
          ],
        );
      }, (0.0).obs),
    );
  }

  Widget examItemBuilder(BuildContext context, ReportModel report) {
    return Container(
      margin: EdgeInsets.only(top: 5, right: 10, left: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12)],
          borderRadius: BorderRadius.circular(2)),
      child: ObxValue((RxDouble currentIndex) {
        double _currentIndex = currentIndex.value;
        print(_currentIndex);
        return Column(
          children: [
            if (report.images!.length > 0)
              CarouselSlider(
                options: CarouselOptions(
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    onPageChanged: (i, state) {
                      currentIndex.value = i.toDouble();
                    }),
                items: report.images!.map((i) {
                  final imageWidget = CachedNetworkImage(
                    imageUrl: i!.image!,
                    width: Get.width,
                    imageBuilder: (context, image) {
                      return Container(
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(children: <Widget>[
                            Positioned.fill(
                              child: InkResponse(
                                  child: Image(
                                image: image,
                                fit: BoxFit.fitWidth,
                              )),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkResponse(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                                opaque: false,
                                                barrierColor:
                                                    Colors.white.withOpacity(0),
                                                pageBuilder:
                                                    (BuildContext context, _,
                                                        __) {
                                                  return FullScreenPage(
                                                    child: PhotoView(
                                                      minScale: 0.1,
                                                      maxScale: 1.0,
                                                      imageProvider:
                                                          CachedNetworkImageProvider(
                                                        i.image!,
                                                      ),
                                                    ),
                                                  );
                                                }));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                        child: Icon(Icons.fullscreen),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkResponse(
                                      onTap: () => saveImage(i.image),
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context)
                                                .backgroundColor),
                                        child: Icon(Icons.download),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ]),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return Center(
                          child: LoadingBouncingGrid.circle(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withAlpha(100),
                      ));
                    },
                  );
                  return imageWidget;
                }).toList(),
              ),
            if (report.images!.length > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: DotsIndicator(
                          dotsCount: report.images!.length,
                          position: currentIndex.value)),
                ],
              ),
            Padding(
              padding: EdgeInsets.all(10),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      margin:
                          EdgeInsets.symmetric(vertical: 5).copyWith(right: 5),
                      decoration: BoxDecoration(
                          color: Colors.green[200],
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.file_copy, color: Colors.green[200]),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${report.issuer?.fullName}" + " / إمتحان",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "المادة : ${report.material?.name}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (report.body != null)
                            Wrap(
                              children: [
                                Text("${report.body}"),
                              ],
                            )
                        ],
                      ),
                    ),
                    if (auth.userType.value == UserType.Teacher)
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                ReportFormController.controller.isEdit.value =
                                    true;
                                final index =
                                    reportController.reports.indexOf(report);
                                ReportFormController
                                    .controller.currentReport.value = index;
                                Get.toNamed(ReportFormRoute);
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                reportController.deleteReport(report);
                              },
                              icon: Icon(Icons.delete))
                        ],
                      )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCommentButton(context, report),
                  Text(timeago.format(report.createdAt!, locale: 'ar'))
                ],
              ),
            )
          ],
        );
      }, (0.0).obs),
    );
  }

  Widget buildCommentButton(BuildContext context, ReportModel report) {
    return InkWell(
      onTap: () {
        Get.toNamed(CommentRoute.replaceAll(":report_id", report.id!));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(50)),
        child: Row(
          children: [
            Icon(
              Icons.more,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            SizedBox(width: 10),
            Text(
              "التعليقات",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget absentReportItemBuilder(BuildContext context, ReportModel report) {
    return Container(
      margin: EdgeInsets.only(top: 5, right: 10, left: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12)],
          borderRadius: BorderRadius.circular(2)),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 5,
                  margin: EdgeInsets.symmetric(vertical: 5).copyWith(right: 5),
                  decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(10)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.person, color: Colors.red[400]),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "الإدارة من : ${report.issuer?.fullName}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "الطالب : ${report.user?.fullName}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children: [
                          Text(report.body ??
                              (report.body == ""
                                  ? "إبنك أو إبنتك" +
                                      "${report.user?.fullName}" +
                                      "تغيبت اليوم"
                                  : report.body!)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text(timeago.format(report.createdAt!, locale: 'ar'))],
          )
        ],
      ),
    );
  }

  saveImage(String? image) async {
    if (await Permission.storage.request().isGranted) {
      Get.rawSnackbar(message: "جاري تحميل الصورة");
      final file = await DefaultCacheManager().getSingleFile(image!);
      await ImageGallerySaver.saveImage(await file.readAsBytes(),
          name: "فرجال");
      Get.rawSnackbar(message: "تم التحميل الصورة بنجاح");
    }
  }
}
