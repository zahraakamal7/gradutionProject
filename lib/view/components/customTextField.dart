import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

//example beautyTextField
/*
    beautyTextField(
                  context,
                  containerColor: context.theme.backgroundColor,
                  fillColor: context.theme.backgroundColor,
                  filled: true,
                  shadows: [
                    BoxShadow(
                      color: context.theme.colorScheme.primary.withAlpha(25),
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    )
                  ],

                  borderRadius: BorderRadius.circular(5),
                  // autovalidateMode: AutovalidateMode.always,
                  validator: (val) {
                    String? error;
                    if (val!.length == 0) return null;
                    if (val.length < 10) error = "يجب آن يكون آكثر من ١٠ حروف";
                    if (val.length > 15) error = "يجب آن يكون آقل من ١٥ حروف";
                    return error;
                  },
                  alignLabelWithHint: true,
                  labelString: "تجربة",
                  // outlineborderContainer:
                  //     Border.all(color: context.theme.dividerColor),
                  // border: InputBorder.none,
                ),
             
 */
Widget beautyTextField(
  BuildContext context, {
  EdgeInsetsGeometry paddingContainer = const EdgeInsets.all(10),
  EdgeInsetsGeometry contentPadding = const EdgeInsets.all(0),
  BorderRadiusGeometry? borderRadius,
  String? labelString,
  TextStyle? labelStyle,
  bool isCollapsed = false,
  bool isDense = false,
  String? counterText,
  Color? containerColor,
  bool alignLabelWithHint = false,
  Widget? counter,
  TextStyle? counterStyle,
  List<TextInputFormatter>? inputFormatters,
  List<BoxShadow>? shadows,
  InputBorder? border = InputBorder.none,
  InputBorder? enabledBorder,
  InputBorder? errorBorder,
  InputBorder? disabledBorder,
  InputBorder? focusedBorder,
  Color? focusedColor,
  InputBorder? focusedErrorBorder,
  bool enabled = true,
  int? errorMaxLines,
  TextStyle? errorStyle,
  String? errorText,
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  String? helperText,
  TextStyle? helperStyle,
  int? helperMaxLines,
  String? hintText,
  int? hintMaxLines,
  TextStyle? hintStyle,
  Color? fillColor,
  bool? filled,
  Widget? icon,
  Widget? prefix,
  Widget? prefixIcon,
  BoxConstraints? prefixIconConstraints,
  TextStyle? prefixStyle,
  String? prefixText,
  Widget? suffix,
  Widget? suffixIcon,
  BoxConstraints? suffixIconConstraints,
  TextStyle? suffixStyle,
  String? suffixText,
  TextAlign textAlign = TextAlign.start,
  Widget? Function(BuildContext,
          {required int currentLength,
          required bool isFocused,
          required int? maxLength})?
      buildCounter,
  AutovalidateMode? autovalidateMode,
  TextEditingController? controller,
  FocusNode? focusNode,
  String? initialValue,
  Brightness? keyboardAppearance,
  TextInputType? keyboardType,
  int? maxLength,
  int? minLines,
  int? maxLines,
  bool obscureText = false,
  String obscuringCharacter = "*",
  bool readOnly = false,
  TextStyle? style,
  BoxBorder? outlineborderContainer,
  String? Function(String?)? validator,
  bool expands = false,
  Color? blinkingPointerColor,
  Radius? blinkingPointerRadius,
  double blinkingPointerWidth = 2.0,
}) {
  Color shadowColor = context.theme.colorScheme.primary;
  if (shadows == null) {
    borderRadius = borderRadius ?? BorderRadius.circular(5);
    shadows = [
      BoxShadow(
        color: shadowColor,
        blurRadius: 10,
        offset: Offset(0, 5),
      )
    ];
  }
  if (containerColor == null)
    containerColor = context.theme.colorScheme.primary;
  if (fillColor == null) {
    filled = true;
    fillColor = containerColor;
  }

  if (blinkingPointerColor == null) {
    /* COLOR CURSOR */
    // blinkingPointerColor = shadowColor;
    /* END COLOR CURSOR */
  }
  return Container(
    padding: paddingContainer,
    decoration: BoxDecoration(
        border: outlineborderContainer,
        color: containerColor,
        borderRadius: borderRadius,
        boxShadow: shadows),
    child: TextFormField(
      cursorColor: blinkingPointerColor,
      cursorRadius: blinkingPointerRadius,
      cursorWidth: blinkingPointerWidth,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      buildCounter: buildCounter,
      autovalidateMode: autovalidateMode,
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      keyboardAppearance: keyboardAppearance,
      keyboardType: keyboardType,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      readOnly: readOnly,
      style: style,
      validator: validator,
      expands: expands,
      enabled: enabled,
      decoration: InputDecoration(
          icon: icon,
          prefix: prefix,
          prefixIcon: prefixIcon,
          focusedBorder: focusedBorder,
          focusColor: focusedColor,
          focusedErrorBorder: focusedErrorBorder,
          prefixIconConstraints: prefixIconConstraints,
          prefixStyle: prefixStyle,
          prefixText: prefixText,
          suffix: suffix,
          suffixIcon: suffixIcon,
          suffixIconConstraints: suffixIconConstraints,
          suffixStyle: suffixStyle,
          suffixText: suffixText,
          errorMaxLines: errorMaxLines,
          errorStyle: errorStyle,
          errorText: errorText,
          floatingLabelBehavior: floatingLabelBehavior,
          helperText: helperText,
          helperStyle: helperStyle,
          helperMaxLines: helperMaxLines,
          hintText: hintText,
          hintMaxLines: hintMaxLines,
          hintStyle: hintStyle,
          fillColor: fillColor,
          filled: filled,
          alignLabelWithHint: alignLabelWithHint,
          counter: counter,
          counterStyle: counterStyle,
          counterText: counterText,
          isCollapsed: isCollapsed,
          isDense: isDense,
          border: border,
          enabledBorder: enabledBorder,
          errorBorder: errorBorder,
          disabledBorder: disabledBorder,
          labelText: labelString,
          contentPadding: contentPadding,
          enabled: enabled,
          labelStyle: labelStyle),
    ),
  );
}
