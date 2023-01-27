import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../view/components/customTextField.dart';
import 'package:get/get.dart';

//router
const String RegisterationRoute = "/auth";
const String MainRoute = "/main";
const String CommentRoute = "/comments/:report_id";
const String DailyTableRoute = "/daily_table";
const String ExamTableRoute = "/exam_table";
const String CertificateTableRoute = "/certificate_table";
const String SpalshRoute = "/splash";
const String NotificationRoute = "/notification";
const String ReportFormRoute = "/reportForm";
//end router
Widget buildBeautifulTextField(BuildContext context, String label,
    {bool obscureText = false,
    String obscuringCharacter = "*",
    Widget? suffix,
    bool isReadOnly = false,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatter,
    int? maxLength,
    String? hintText,
    TextInputType? keyboardType,
    dynamic floatingLabelBehavior,
    int maxLines = 1,
    TextEditingController? controller}) {
  return beautyTextField(context,
      labelString: label.tr,
      suffix: suffix,
      keyboardType: keyboardType,
      readOnly: isReadOnly,
      autovalidateMode: AutovalidateMode.always,
      maxLength: maxLength,
      obscureText: obscureText,
      inputFormatters: inputFormatter,
      isDense: true,
      maxLines: maxLines,
      hintText: hintText,
      validator: validator,
      obscuringCharacter: obscuringCharacter,
      containerColor: context.theme.dividerColor,
      fillColor: Colors.transparent,
      labelStyle: TextStyle(color: context.theme.textTheme.caption!.color),
      controller: controller,
      filled: false,
      shadows: [],
      borderRadius: BorderRadius.circular(10),
      floatingLabelBehavior:
          floatingLabelBehavior ?? FloatingLabelBehavior.auto);
}

enum UserType { Unknown, Unknown2, Teacher, Student }

void showUniformSnack(String message) {
  Get.rawSnackbar(message: message);
}
