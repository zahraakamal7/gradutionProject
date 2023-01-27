import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/constants/full_screen_image.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/controller/commentController.dart';
import 'package:flight_booking_sys/model/commentModel.dart';
import 'package:flight_booking_sys/view/components/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CommentView extends StatelessWidget {
  CommentView({Key? key}) : super(key: key);
  final commentController = CommentController.controller();
  final auth = AuthController.controller;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      commentController.scrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        suggestedRowHeight: 200,
        //choose vertical/horizontal
        axis: Axis.vertical,
      );
      commentController.scrollController
          .addListener(commentController.onScroll);
      return ConstrainedBox(
        constraints: constraints.copyWith(
          minHeight: constraints.maxHeight,
          maxHeight: double.infinity,
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return ListView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    scrollDirection: Axis.vertical,
                    controller: commentController.scrollController,
                    children: [
                      if (commentController.isFetching.value)
                        Container(
                          padding: EdgeInsets.only(
                              top: commentController.comments.length == 0
                                  ? Get.height / 1.9
                                  : 10,
                              bottom: 10),
                          width: Get.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("جاري تحميل التعليقات"),
                              SizedBox(width: 10),
                              LoadingBouncingGrid.circle(
                                  size: 20,
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                            ],
                          ),
                        ),
                      ...commentController.comments.map((element) {
                        final isSender =
                            element.user!.id! == auth.user.value!.id;
                        final commentIndex = commentController.comments
                            .indexWhere((e) => e.id == element.id);
                        CommentModel? rcomment = element.parent;
                        bool isScrolled =
                            commentController.indexAnimation.value ==
                                commentIndex;
                        return AutoScrollTag(
                          key: ValueKey(element.id),
                          index: commentIndex,
                          controller: commentController.scrollController,
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            margin: isScrolled
                                ? EdgeInsets.all(0.0)
                                : EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: isScrolled
                                    ? Theme.of(context)
                                        .colorScheme
                                        .secondaryVariant
                                    : isSender
                                        ? Theme.of(context).dividerColor
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withAlpha(300),
                                borderRadius: isScrolled
                                    ? BorderRadius.circular(0)
                                    : BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                if (rcomment != null)
                                  InkWell(
                                    onTap: () async {
                                      await commentController
                                          .scrollToReply(rcomment);
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Text("رد على "),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                    .withAlpha(100)),
                                            child: Text(
                                              "${rcomment.body}",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "المرسل : ${isSender ? "انـت" : element.user!.fullName}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // if (UserType.Teacher == auth.userType.value)
                                    Column(
                                      children: [
                                        if (isSender ||
                                            UserType.Teacher ==
                                                auth.userType.value)
                                          InkWell(
                                              onTap: () {
                                                commentController
                                                    .deleteComment(element.id!);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .errorColor,
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 15,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                ),
                                              )),
                                        SizedBox(height: 10),
                                        InkWell(
                                            onTap: () {
                                              commentController.indexReplied
                                                  .value = commentIndex;
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  shape: BoxShape.circle),
                                              child: Icon(
                                                Icons.message,
                                                size: 15,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Wrap(
                                        runAlignment: WrapAlignment.start,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        alignment: WrapAlignment.start,
                                        children: [
                                          Text(
                                            element.body!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (auth.userType.value == UserType.Teacher ||
                                    auth.user.value!.id == element.userId)
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...element.images!.map((commentImage) {
                                          final imageWidget =
                                              CachedNetworkImage(
                                            imageUrl: commentImage!.image!,
                                            width: Get.width / 3,
                                            height: Get.width / 3,
                                            imageBuilder: (context, image) {
                                              return Container(
                                                width: Get.width,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.0)),
                                                  child: Stack(
                                                      children: <Widget>[
                                                        Positioned.fill(
                                                          child: InkResponse(
                                                              child: Image(
                                                            image: image,
                                                            fit: BoxFit.cover,
                                                          )),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkResponse(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        PageRouteBuilder(
                                                                            opaque: false,
                                                                            barrierColor: Colors.white.withOpacity(0),
                                                                            pageBuilder: (BuildContext context, _, __) {
                                                                              return FullScreenPage(
                                                                                child: PhotoView(
                                                                                  minScale: 0.1,
                                                                                  maxScale: 1.0,
                                                                                  imageProvider: CachedNetworkImageProvider(
                                                                                    commentImage.image!,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .backgroundColor,
                                                                    ),
                                                                    child: Icon(
                                                                        Icons
                                                                            .fullscreen),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                InkResponse(
                                                                  onTap: () =>
                                                                      saveImage(
                                                                          commentImage
                                                                              .image),
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Theme.of(context)
                                                                            .backgroundColor),
                                                                    child: Icon(
                                                                        Icons
                                                                            .download),
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
                                                  child: LoadingBouncingGrid
                                                      .circle(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onBackground
                                                        .withAlpha(100),
                                              ));
                                            },
                                          );
                                          return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: imageWidget);
                                        })
                                      ],
                                    ),
                                  ),
                                if (element.images!.length > 0 &&
                                    auth.userType.value != UserType.Teacher &&
                                    auth.user.value!.id != element.userId)
                                  Text(
                                      "محتوى مخفي للاساتذة فقط | وصاحب التعليق")
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      if (!commentController.isFetching.value &&
                          commentController.comments.length == 0)
                        Container(
                          padding: EdgeInsets.only(
                              top: commentController.comments.length == 0
                                  ? Get.height / 1.9
                                  : 0),
                          width: Get.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("لا يوجد تعليقات")],
                          ),
                        ),
                    ]);
              }),
            ),
            buildCommentAndReplied(context)
          ],
        ),
      );
    });
  }

  Container buildCommentAndReplied(BuildContext context) {
    return Container(
      color: Theme.of(context).dividerColor,
      child: Obx(() {
        CommentModel? element;
        bool isSender = false;
        if (commentController.indexReplied.value > -1) {
          element = commentController.comments
              .elementAt(commentController.indexReplied.value);
          isSender = element.user!.id! == auth.user.value!.id;
        }

        return Column(
          children: [
            if (commentController.indexReplied.value > -1)
              Stack(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5)
                            .copyWith(right: 12),
                        child: Text("رد على"),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          padding:
                              const EdgeInsets.all(10.0).copyWith(right: 12),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withAlpha(300),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "المرسل : ${isSender ? "انـت" : element!.user!.fullName}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  // if (UserType.Teacher == auth.userType.value)
                                  Column(
                                    children: [
                                      if (isSender ||
                                          UserType.Teacher ==
                                              auth.userType.value)
                                        InkWell(
                                            onTap: () {
                                              commentController
                                                  .indexReplied.value = -1;
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .errorColor,
                                                  shape: BoxShape.circle),
                                              child: Icon(
                                                Icons.close,
                                                size: 15,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                            )),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Wrap(
                                      runAlignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      alignment: WrapAlignment.start,
                                      children: [
                                        Text(
                                          element!.body!,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Positioned(
                  //     child: Container(
                  //   padding: EdgeInsets.all(12).copyWith(left: 20),
                  //   // decoration: BoxDecoration(
                  //   //     borderRadius:
                  //   //         BorderRadius.only(bottomLeft: Radius.circular(10)),
                  //   //     color: Theme.of(context).bottomAppBarColor),
                  //   child: Text("رد على"),
                  // ))
                ],
              ),
            Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              if (commentController.bodyComment.text
                                      .trim()
                                      .length ==
                                  0)
                                return showUniformSnack(
                                    "يرجى إضافة محتوى للتعليق");
                              commentController.addComment();
                            },
                            icon: RotatedBox(
                                quarterTurns: 2, child: Icon(Icons.send))),
                        IconButton(
                            onPressed: () {
                              commentController.addImage();
                            },
                            icon: Badge(
                              badgeColor: Theme.of(context).primaryColor,
                              child: Icon(Icons.image),
                              badgeContent: Text(
                                "${commentController.images.length}",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                            )),
                        Expanded(
                            child: beautyTextField(context,
                                controller: commentController.bodyComment,
                                shadows: [],
                                hintText: "إترك تعليق هنا ...",
                                containerColor: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.circular(0))),
                      ],
                    ),
                  ],
                ),
                if (commentController.isFetching.value)
                  Positioned.fill(
                      child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "يرجى الإنتظار",
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LoadingBouncingLine.circle(
                              size: 20,
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              ],
            ),
          ],
        );
      }),
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
