import 'package:dropdown_search/dropdown_search.dart';
import 'package:flight_booking_sys/controller/certificateController.dart';
import 'package:flight_booking_sys/services/preDataService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateView extends StatelessWidget {
  CertificateView({Key? key}) : super(key: key);
  final certificateController = CertificateController.controller;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
        constraints: constraints.copyWith(
          minHeight: constraints.maxHeight,
          maxHeight: double.infinity,
        ),
        child: Column(
          children: [
            semsterBuilder(context),
            Obx(() {
              if (certificateController.isFetching.value) {
                return Container(
                  padding: EdgeInsets.only(top: Get.height / 3),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (certificateController.certificate.length == 0) {
                return Container(
                  padding: EdgeInsets.only(top: Get.height / 3),
                  child: Center(
                      child: Center(
                    child: Text("لا يوجد بيانات متاحة."),
                  )),
                );
              }
              return Expanded(
                  child: Column(
                children: [
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
                                child: Text("المادة",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "الدرجة",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70),
                                ),
                              )
                            ]),
                        ...certificateController.certificate
                            .map((e) => TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "${e!.material!.name}",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "${e.degree}",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ]))
                            .toList()
                      ],
                    ),
                  ),
                  Expanded(
                      child: Row(
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
                  ))
                ],
              ));
            })
          ],
        ),
      );
    });
  }

  Container semsterBuilder(BuildContext context) {
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      selectedItem!,
                      style: Theme.of(context).textTheme.subtitle2!,
                    ),
                  );
                },
                dropdownSearchDecoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "الفصل",
                ),
                onChanged: (item) {
                  certificateController.selectedSemester.value = item!;
                  certificateController.preFetchData();
                },
                searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(border: InputBorder.none)),
                mode: Mode.MENU,
                showSelectedItems: false,
                items: [
                  ...PreDataService.servicesController.semesters
                      .map((element) => element.name!)
                      .toList()
                ],
                selectedItem:
                    CertificateController.controller.selectedSemester.value,
              ),
            )
          ])
        ],
      ),
    );
  }
}
