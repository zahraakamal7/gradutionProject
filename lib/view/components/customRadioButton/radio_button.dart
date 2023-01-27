import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../view/components/customRadioButton/radio_button_controller.dart';

import 'radio_button_text_position.dart';

class RadioButton extends StatelessWidget {
  final String description;
  final String tag;
  final int value;
  final void Function(int?)? onChanged;
  final RadioButtonTextPosition textPosition;
  final Color? activeColor;
  final TextEditingController? currnetValue;
  final TextStyle? descriptionStyle;
  RadioButton({
    required this.tag,
    required this.description,
    required this.value,
    required this.onChanged,
    this.descriptionStyle,
    this.currnetValue,
    this.textPosition = RadioButtonTextPosition.right,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered()
        ? Get.find()
        : Get.put(RadioButtonController(), permanent: false);
    return InkWell(
      onTap: () {
        if (this.onChanged != null) {
          this.onChanged!(value);
        }
        Get.find<RadioButtonController>()
            .groupValueChanged(this.tag + value.toString(), tag, value);
      },
      child: Row(
        mainAxisAlignment: this.textPosition == RadioButtonTextPosition.right
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: <Widget>[
          this.textPosition == RadioButtonTextPosition.left
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    this.description,
                    style: descriptionStyle,
                    textAlign: TextAlign.left,
                  ),
                )
              : Container(),
          GetBuilder<RadioButtonController>(
            id: this.tag + value.toString(),
            init: controller,
            builder: (radioButtonController) {
              print("ameer I am here");
              return Radio<int>(
                groupValue: radioButtonController.groupValue[tag],
                value: this.value,
                activeColor: activeColor,
                onChanged: (value) {
                  if (this.onChanged != null) {
                    this.onChanged!(value);
                  }
                  Get.find<RadioButtonController>().groupValueChanged(
                      this.tag + value.toString(), tag, value!);
                },
              );
            },
          ),
          this.textPosition == RadioButtonTextPosition.right
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    this.description,
                    style: descriptionStyle,
                    textAlign: TextAlign.right,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
