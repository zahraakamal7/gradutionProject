import 'package:dropdown_search/dropdown_search.dart';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/controller/examTableController.dart';
import 'package:flight_booking_sys/services/preDataService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamTableView extends StatelessWidget {
  ExamTableView({Key? key}) : super(key: key);
  final examTableController = ExamTableController.controller;
  final auth = AuthController.controller;
  final materials = PreDataService.servicesController.materials;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
        constraints: constraints.copyWith(
          minHeight: constraints.maxHeight,
          maxHeight: double.infinity,
        ),
        child: RefreshIndicator(
          onRefresh: () => examTableController.preFetchData(),
          child: SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            child: Column(
              children: [
                titleBuilder(context),
                if (UserType.Teacher ==
                    AuthController.controller.userType.value)
                  classBuilder(context),
                Obx(() {
                  if (examTableController.isFetching.value) {
                    return Container(
                      padding: EdgeInsets.only(top: Get.height / 3),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final exams = examTableController.examTables;
                  return Column(
                    children: [
                      if (exams.length > 0)
                        Padding(
                          padding: const EdgeInsets.all(20.0).copyWith(top: 0),
                          child: Table(
                            border: TableBorder.all(),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "اليوم",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "المادة",
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ]),
                              ...exams
                                  .map((e) => TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "${e!.day}",
                                                textAlign: TextAlign.center,
                                              ),
                                              if (e.date != null)
                                                Text(
                                                  "${e.date!.year}/${e.date!.month}/${(e.date!.day < 10 ? '0' : '') + e.date!.day.toString()}",
                                                  textAlign: TextAlign.center,
                                                ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "${materials.firstWhere((m) => m.id == e.materialId).name}",
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ]))
                                  .toList()
                            ],
                          ),
                        ),
                      if (exams.length == 0)
                        Container(
                          padding: EdgeInsets.only(
                              top: Get.height / 3.5, bottom: Get.height / 5),
                          child: Text("لا يوجد بيانات متاحة."),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  children: [
                                    Icon(Icons.chevron_left),
                                    Text("رجوع")
                                  ],
                                ),
                              ))
                        ],
                      )
                    ],
                  );
                })
              ],
            ),
          ),
        ),
      );
    });
  }

  Container titleBuilder(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: Column(
        children: [
          Row(children: [
            Expanded(
                child: Text(
              "جدول الإمتحانات",
              textAlign: TextAlign.center,
            ))
          ])
        ],
      ),
    );
  }

  Widget classBuilder(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(20.0),
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        selectedItem!,
                        style: Theme.of(context).textTheme.subtitle2!,
                      ),
                    );
                  },
                  onChanged: (item) {
                    examTableController.selectedClass.value = item!;
                    examTableController.preFetchData();
                  },
                  dropdownSearchDecoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "المرحلة",
                  ),
                  searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(border: InputBorder.none)),
                  mode: Mode.MENU,
                  showSelectedItems: false,
                  // popupItemDisabled: (item) => item
                  //     .startsWith(dailyMaterialController.selectedDay.value),
                  items: [...auth.stageMaterial.keys],
                  selectedItem: examTableController.selectedClass.value,
                ),
              )
            ])
          ],
        ),
      );
    });
  }
}
