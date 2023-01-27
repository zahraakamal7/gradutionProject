import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_booking_sys/api/apiEndpoints.dart';
import 'package:flight_booking_sys/model/commentModel.dart';
import 'package:flight_booking_sys/model/errorModel.dart';
import 'package:flight_booking_sys/model/imageModel.dart';
import 'package:flight_booking_sys/model/responseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:get/get.dart';
import 'package:image_compression/image_compression.dart';
import 'package:images_picker/images_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime_type/mime_type.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'authController.dart';
import 'reportController.dart';

class CommentController extends GetxController {
  Rx<String?> currentReportId = "".obs;
  static CommentController controller({String? reportId}) {
    reportId = reportId ?? Get.parameters['report_id'];
    final _controller = Get.isRegistered<CommentController>(tag: reportId)
        ? Get.find<CommentController>(tag: reportId)
        : Get.put(CommentController(), permanent: false, tag: reportId);
    _controller.currentReportId.value = reportId;
    _controller.connectToChannel();
    return _controller;
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(onScroll);
    if (latestLoading == null) latestLoading = DateTime.now();
    preFetchData();
  }

  final indexReplied = RxInt(-1);
  final indexAnimation = RxInt(-1);
  TextEditingController bodyComment = TextEditingController();
  final auth = AuthController.controller;
  final commentsQueryType = 0.obs;
  final selectedMaterial = "الكل".obs;
  final selectedClass = "الكل".obs;

  /* flight offers */
  AutoScrollController scrollController = AutoScrollController();
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  CancelToken cancelToken = CancelToken();
  final isFetching = false.obs;
  final isFinished = false.obs;
  DateTime? latestLoading;
  final isError = false.obs;
  RxList<CommentModel> comments = RxList.empty();
  int skip = 0;
  int iteration = 1;
  /* end offers */

  Future fetchComments({bool isReplyPressed = false}) async {
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    Map<String, dynamic> parms = {};
    parms["report_id"] = currentReportId.value;
    res = await getCommentToReportApi(skip: skip, limit: 7, data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      r!.comments!.forEach((comment) {
        comments.insert(0, comment);
      });
      if (!isReplyPressed)
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          scrollController.scrollToIndex(comments.length - 1,
              preferPosition: AutoScrollPosition.end);
        });
      skip += 7;
      iteration += 1;
      if (r.count! < iteration) {
        isFinished.value = true;
      }
    });

    isFetching.value = false;
  }

  bool get _isTop {
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      print("scroll top");
      return true;
    }
    return false;
    // if (!scrollController.hasClients) return false;
    // final maxScroll = scrollController.position.maxScrollExtent;
    // final currentScroll = scrollController.offset;
    // return currentScroll >= (maxScroll * 0.5); //threshold
  }

  void onScroll() {
    if (isFinished.value) {
      return;
    }
    if (_isTop && !isFetching.value) {
      print("fetch data");
      isFetching.value = true;
      final now = DateTime.now();

      final debounce = latestLoading!.isAfter(now)
          ? 0
          : now.difference(latestLoading!).inSeconds;

      Future.delayed(Duration(seconds: debounce < 3 ? 3 - debounce : 0),
          () async {
        await fetchComments(isReplyPressed: true);
        latestLoading = DateTime.now();
      });
    }
  }

  @override
  void dispose() {
    commentSocket?.unbind("App\\Events\\CommentSocket");

    super.dispose();
  }

  void reset() {
    isFetching.value = false;
    isFinished.value = false;
    isError.value = false;
    latestLoading = DateTime.now();
    comments.clear();
    skip = 0;
    iteration = 1;
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
  }

  Future<void> preFetchData() async {
    isFinished.value = false;
    isError.value = false;
    comments.clear();
    images.clear();
    skip = 0;
    iteration = 1;
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
    scrollController = new AutoScrollController();
    scrollController.addListener(onScroll);
    if (!isFetching.value) {
      print("fetch data");
      isFetching.value = true;
      final now = DateTime.now();
      final debounce = latestLoading!.isAfter(now)
          ? 0
          : now.difference(latestLoading!).inSeconds;
      Future.delayed(Duration(seconds: debounce < 3 ? 3 - debounce : 0),
          () async {
        await fetchComments();
        latestLoading = DateTime.now();
      });
    }
  }

  Future scrollToReply(CommentModel rcomment) async {
    int scrollIndex =
        comments.indexWhere((element) => element.id == rcomment.id);
    if (scrollIndex == -1) {
      while (!isFinished.value && scrollIndex == -1) {
        await fetchComments(isReplyPressed: true);
        scrollIndex =
            comments.indexWhere((element) => element.id == rcomment.id);
        print(scrollIndex.toString());
      }
    }

    if (scrollIndex == -1) return; //todo: not found
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      scrollController.scrollToIndex(scrollIndex,
          preferPosition: AutoScrollPosition.end);
      indexAnimation.value = scrollIndex;
      Future.delayed(Duration(milliseconds: 500), () {
        indexAnimation.value = -1;
      });
    });
  }

  void addComment() async {
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    Map<String, dynamic> parms = {};
    parms["report_id"] = currentReportId.value;
    parms["body"] = bodyComment.text;
    if (images.length > 0) {
      parms["images"] = getImagesBase64();
    }
    if (indexReplied.value > -1) {
      final rcomment = comments.elementAt(indexReplied.value);
      parms["parent_id"] = rcomment.id;
    }
    res = await addCommentApi(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      images.clear();
      r!.comments!.forEach((comment) {
        comments.add(comment);
      });
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        scrollController.scrollToIndex(comments.length - 1,
            preferPosition: AutoScrollPosition.end);
      });
    });

    isFetching.value = false;

    bodyComment.text = "";
    indexReplied.value = -1;
    indexAnimation.value = -1;
  }

  void deleteComment(String commentId) async {
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    Map<String, dynamic> parms = {};
    parms["comment_id"] = commentId;
    res = await deleteCommentApi(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      comments.removeWhere((element) => element.id == commentId);
      comments
          .where((element) => element.parentId == commentId)
          .forEach((comment) {
        comment.parent = null;
        comment.parentId = null;
      });
    });

    isFetching.value = false;
    indexReplied.value = -1;
    indexAnimation.value = -1;
  }

  Channel? commentSocket;
  Future connectToChannel() async {
    commentSocket = ReportController.controller.pusher.value!
        .subscribe("private-comment_socket.${currentReportId.value}");

    await commentSocket!.bind('App\\Events\\CommentSocket', bindCommentSocket);
  }

  bindCommentSocket(event) {
    if (event is String) event = jsonDecode(event);
    final comment = CommentModel.fromJson(event["comment"]);
    if (comment.userId == auth.user.value!.id) return;
    final commentController =
        CommentController.controller(reportId: comment.reportId!);
    if (event["type"] == "add") {
      commentController.comments.add(comment);
      scrollController.scrollToIndex(comments.length - 1,
          preferPosition: AutoScrollPosition.end);
    } else if (event["type"] == "delete") {
      comments.removeWhere((element) => element.id == comment.id);
      comments
          .where((element) => element.parentId == comment.id)
          .forEach((comment) {
        comment.parent = null;
        comment.parentId = null;
      });
    } else if (event["type"] == "edit") {
      final index = comments.indexWhere((element) => element.id == comment.id);
      comments[index] = comment;
      comments
          .where((element) => element.parentId == comment.id)
          .forEach((comment) {
        comment.parent = comments[index];
        comment.parentId = comments[index].id;
      });
      comments.refresh();
    }
  }

  RxList<Media> images = RxList();

  List<String> getImagesBase64() {
    List<String> _images = List.empty(growable: true);
    if (images.length > 0) {
      images.forEach((element) {
        final file = File(element.path);
        final input = ImageFile(
          rawBytes: file.readAsBytesSync(),
          filePath: file.path,
        );
        final output = compress(ImageFileConfiguration(
            input: input, config: Configuration(jpgQuality: 70)));
        String? mimeType = mime(element.path);
        _images.add("data:$mimeType;base64," + base64Encode(output.rawBytes));
      });
      return _images;
    }
    return [];
  }

  void addImage() async {
    images.clear();
    int count = 4;

    List<Media>? res = await ImagesPicker.pick(
        count: count, pickType: PickType.image, gif: false);
    if (res != null) {
      res.forEach((element) {
        images.add(element);
      });
    }
  }
}
