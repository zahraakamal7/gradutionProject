import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/controller/notificationApiController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationView extends StatelessWidget {
  final auth = AuthController.controller;
  final notificationController = NotificationApiController.controller;
  NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
        constraints: constraints.copyWith(
          minHeight: constraints.maxHeight,
          maxHeight: double.infinity,
        ),
        child: RefreshIndicator(
          onRefresh: () => notificationController.preFetchData(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    controller: notificationController.scrollController,
                    physics: AlwaysScrollableScrollPhysics(
                        parent: ClampingScrollPhysics()),
                    child: Obx(() {
                      return Column(
                        children: [
                          if (notificationController.notifications.length > 0)
                            Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                ...notificationController.notifications
                                    .map((notification) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).dividerColor,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 10,
                                              offset: Offset(0, 5),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withAlpha(25))
                                        ]),
                                    child: InkResponse(
                                      onTap: () {
                                        if (notification!.comment != null)
                                          Get.toNamed(CommentRoute.replaceAll(
                                              ":report_id",
                                              notification.comment!.reportId!));
                                      },
                                      child: IntrinsicHeight(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Wrap(
                                                          children: [
                                                            RichText(
                                                                text: TextSpan(
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyText2,
                                                                    children: [
                                                                  TextSpan(
                                                                      text:
                                                                          "${notification!.title}"),
                                                                  TextSpan(
                                                                      text:
                                                                          " من قبل "),
                                                                  TextSpan(
                                                                      text:
                                                                          "${notification.issuer!.fullName}",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).errorColor))
                                                                ])),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Wrap(
                                                          children: [
                                                            RichText(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                text: TextSpan(
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyText2,
                                                                    children: [
                                                                      TextSpan(
                                                                          text:
                                                                              "محتوى التعليق : "),
                                                                      TextSpan(
                                                                          style:
                                                                              TextStyle(color: Theme.of(context).primaryColor),
                                                                          text: "${notification.body}"),
                                                                    ])),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      notificationController
                                                          .markSeen(
                                                              notification);
                                                    },
                                                    child: Icon(notification
                                                                .seen ==
                                                            0
                                                        ? Icons
                                                            .visibility_outlined
                                                        : Icons
                                                            .visibility_off_outlined),
                                                  )
                                                ])
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                              ],
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: Get.height / 3.5),
                                        child: Text("لا يوجد بيانات متاحة."),
                                      ),
                                    ],
                                  )
                                ]),
                              ],
                            ),
                          if (notificationController.isFetching.value)
                            Container(
                              padding: EdgeInsets.only(top: Get.height / 3),
                              child: Center(child: CircularProgressIndicator()),
                            )
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
}
