import 'package:dropdown_search/dropdown_search.dart';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/controller/dailyMaterialController.dart';
import 'package:flight_booking_sys/services/preDataService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyTableView extends StatelessWidget {
  final dailyMaterialController = DailyMaterialController.controller;
  final auth = AuthController.controller;
  DailyTableView({Key? key}) : super(key: key);
  final dros = [
    "المحاضرة الاولى ",
    "المحاضرة الثانية",
    "المحاضرة الثالثة",
    "المحاضرة الرابعة",
  ];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
        constraints: constraints.copyWith(
          minHeight: constraints.maxHeight,
          maxHeight: double.infinity,
        ),
        child: RefreshIndicator(
          onRefresh: () => dailyMaterialController.preFetchData(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(
                        parent: ClampingScrollPhysics()),
                    child: Obx(() {
                      if (dailyMaterialController.isFetching.value) {
                        return Container(
                          padding: EdgeInsets.only(top: Get.height / 3),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return Column(
                        children: [
                          if (UserType.Teacher ==
                              AuthController.controller.userType.value)
                            classBuilder(context),
                          if (dailyMaterialController.dailyMaterials.length > 0)
                            daysBuilder(context),
                          if (dailyMaterialController.dailyMaterials.length > 0)
                            Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(20.0)
                                        .copyWith(top: 0),
                                    child: Table(
                                      border: TableBorder.all(),
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      children: [
                                        TableRow(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "المحاضرة",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "المادة",
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ]),
                                        ...dros.map((e) {
                                          final daily = dailyMaterialController
                                              .dailyMaterials
                                              .firstWhere((d) =>
                                                  d!.day ==
                                                  dailyMaterialController
                                                      .selectedDay.value)!
                                              .materials!
                                              .map((e) => PreDataService
                                                  .servicesController.materials
                                                  .where((e1) => e1.id == e)
                                                  .first
                                                  .name);
                                          final index = dros.indexOf(e);
                                          if (index >= daily.length) {
                                            return TableRow(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "$e",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "لا يوجد",
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ]);
                                          }
                                          return TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "$e",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "${daily.elementAt(index)}",
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ]);
                                        }).toList()
                                      ],
                                    )),
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
                            )
                          else
                            Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: Get.height / 3.5),
                                    child: Text("لا يوجد بيانات متاحة."),
                                  ),
                                ],
                              )
                            ]),
                        ],
                      );
                    })),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget daysBuilder(BuildContext context) {
    return Obx(() {
      final days = dailyMaterialController.dailyMaterials
          .map((element) => element!.day!)
          .toList();
      if (days.length == 0) return Container();
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
                  onChanged: (item) =>
                      dailyMaterialController.selectedDay.value = item!,
                  dropdownSearchDecoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "اليوم",
                  ),
                  searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(border: InputBorder.none)),
                  mode: Mode.MENU,
                  showSelectedItems: false,
                  popupItemDisabled: (item) => item
                      .startsWith(dailyMaterialController.selectedDay.value),
                  items: days,
                  selectedItem: days.first,
                ),
              )
            ])
          ],
        ),
      );
    });
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
                    dailyMaterialController.selectedClass.value = item!;
                    dailyMaterialController.preFetchData();
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
                  selectedItem: dailyMaterialController.selectedClass.value,
                ),
              )
            ])
          ],
        ),
      );
    });
  }
}
