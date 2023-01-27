import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/controller/reportController.dart';
import 'package:flight_booking_sys/controller/reportFormController.dart';
import 'package:flight_booking_sys/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportFormView extends StatelessWidget {
  ReportFormView({Key? key}) : super(key: key);
  final reportController = ReportFormController.controller;

  final auth = AuthController.controller;
  @override
  Widget build(BuildContext context) {
    if (reportController.isEdit.value) {
      reportController.body.text = ReportController
              .controller.reports[reportController.currentReport.value].body ??
          "";
      reportController.url.text = ReportController
              .controller.reports[reportController.currentReport.value].link ??
          "";
    }
    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
          constraints: constraints.copyWith(
            minHeight: constraints.maxHeight,
            maxHeight: double.infinity,
          ),
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics()),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Obx(() {
                    List<String> materials = List.empty(growable: true);

                    auth.stageMaterial[reportController.selectedClass.value]!
                        .forEach((m) {
                      materials.add(m.name!);
                    });

                    return Column(
                      children: [
                        if (!reportController.isEdit.value)
                          buildReportsType(context),
                        if (!reportController.isEdit.value)
                          classBuilder(context),
                        if (!reportController.isEdit.value)
                          materialBuilder(context, materials),
                        if (!reportController.isEdit.value)
                          if (reportController.reportsQueryType.value == "خاص")
                            buildUserSearch(context),
                        SizedBox(
                          height: 10,
                        ),
                        buildBeautifulTextField(context, "محتوى التبليغ",
                            controller: reportController.body,
                            maxLines: 5,
                            maxLength: 300,
                            validator: (val) {}),
                        SizedBox(
                          height: 10,
                        ),
                        buildBeautifulTextField(context, "رابط يوتيوب",
                            controller: reportController.url,
                            maxLines: 1,
                            validator: (val) {}),
                        SizedBox(
                          height: 10,
                        ),
                        if (reportController.isEdit.value)
                          editImageBuilder(context),
                        if (!reportController.isEdit.value)
                          if (reportController.reportsQueryType.value != "خاص")
                            addImageBuilder(context)
                          else
                            buttonSave()
                      ],
                    );
                  }),
                ),
              ),
            )
          ]));
    });
  }

  DropdownSearch<String> materialBuilder(
      BuildContext context, List<String> materials) {
    return DropdownSearch<String>(
        dropdownBuilder: (context, selectedItem) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Text(
              selectedItem!,
            ),
          );
        },
        dropdownSearchDecoration: InputDecoration(
            border: InputBorder.none,
            labelText: "المادة",
            labelStyle: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor)),
        searchFieldProps: TextFieldProps(
            decoration: InputDecoration(border: InputBorder.none)),
        mode: Mode.BOTTOM_SHEET,
        showSelectedItems: false,
        items: materials,
        // popupItemDisabled: (String s) => s.startsWith(
        //     reportController.selectedMaterial.value),
        onChanged: (i) {
          reportController.selectedMaterial.value = i!;
        },
        selectedItem: reportController.selectedMaterial.value);
  }

  Widget addImageBuilder(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: reportController.images
                .map((element) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Stack(
                        children: [
                          Container(
                            height: Get.width / 4,
                            width: Get.width / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: Image.file(File(element.path)).image,
                                    fit: BoxFit.fill)),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                  onPressed: () {
                                    final index = reportController.images
                                        .indexOf(element);
                                    reportController.images.removeAt(index);
                                  },
                                  iconSize: Get.width / 9,
                                  color: Theme.of(context).colorScheme.error,
                                  icon: Icon(Icons.delete)),
                            ),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  reportController.getImage();
                },
                child: Text("إضافة صور للتبليغ")),
            buttonSave()
          ],
        ),
      ],
    );
  }

  Widget buildReportsType(BuildContext context) {
    return DropdownSearch<String>(
      onChanged: (i) {
        //taha طه
        reportController.reportsQueryType.value = i!;
      },
      dropdownSearchDecoration: InputDecoration(
        border: InputBorder.none,
        labelText: "نوع التبليغ",
      ),
      dropdownBuilder: (context, selectedItem) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            selectedItem!,
          ),
        );
      },
      selectedItem: reportController.reportsQueryType.value,
      popupItemDisabled: (item) =>
          item.startsWith(reportController.reportsQueryType.value),
      items: [
        "خاص",
        //2
        "امتحان",
        //3
        "واجب",
        //4
      ],
    );
  }

  Widget buildUserSearch(BuildContext context) {
    return DropdownSearch<UserModel>(
      showSearchBox: true,
      onChanged: (i) {
        reportController.selectedUser.value = i!;
      },
      searchDelay: Duration(seconds: 1),
      dropdownSearchDecoration: InputDecoration(
        border: InputBorder.none,
        labelText: "أسم الطالب",
      ),
      onFind: (String? query) {
        final users = reportController.searchUser(query!);
        return users;
      },
      itemAsString: (UserModel? u) {
        return "${u!.fullName}";
      },
      dropdownBuilder: (context, selectedItem) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            selectedItem == null
                ? "يرجى أختيار طالب اولا"
                : selectedItem.fullName!,
          ),
        );
      },
      selectedItem: reportController.selectedUser.value,
      popupItemDisabled: (item) => reportController.selectedUser.value == null
          ? false
          : item.fullName!
              .startsWith(reportController.selectedUser.value!.fullName!),
    );
  }

  Widget classBuilder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: DropdownSearch<String>(
                dropdownBuilder: (context, selectedItem) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      selectedItem!,
                      style: Theme.of(context).textTheme.subtitle2!,
                    ),
                  );
                },
                onChanged: (item) {
                  reportController.selectedClass.value = item!;
                  reportController.selectedMaterial.value = auth
                      .stageMaterial[reportController.selectedClass.value]!
                      .first
                      .name!;
                  // dailyMaterialController.preFetchData();
                },
                dropdownSearchDecoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "االمرحلة",
                ),
                searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(border: InputBorder.none)),
                mode: Mode.MENU,
                showSelectedItems: false,
                // popupItemDisabled: (item) => item
                //     .startsWith(dailyMaterialController.selectedDay.value),
                items: [...auth.stageMaterial.keys],
                selectedItem: reportController.selectedClass.value,
              ),
            )
          ])
        ],
      ),
    );
  }

  Widget editImageBuilder(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ReportController.controller
                .reports[reportController.currentReport.value].images!
                .map((element) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Stack(
                        children: [
                          Container(
                            height: Get.width / 4,
                            width: Get.width / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        element!.image!),
                                    fit: BoxFit.fill)),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                  onPressed: () {
                                    final index = ReportController
                                        .controller
                                        .reports[reportController
                                            .currentReport.value]
                                        .images!
                                        .indexOf(element);
                                    // reportController.images.removeAt(index);
                                    reportController.deleteImage(index);
                                  },
                                  iconSize: Get.width / 9,
                                  color: Theme.of(context).colorScheme.error,
                                  icon: Icon(Icons.delete)),
                            ),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  reportController.getImage();
                },
                child: Text("إضافة صور للتبليغ")),
            buttonSave(buttonText: "تعديل الإبلاغ")
          ],
        ),
      ],
    );
  }

  Widget buttonSave({String? buttonText}) {
    return ElevatedButton(
        onPressed: () {
          if (reportController.isEdit.value)
            reportController.updateBody();
          else
            reportController.addNewReport();
        },
        child: Text(buttonText ?? "نشر تبليغ"));
  }
}
