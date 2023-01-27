import 'package:flutter/material.dart';

import 'radio_button.dart';
import 'radio_button_builder.dart';
import 'radio_button_text_position.dart';

class RadioGroup extends StatelessWidget {
  /// Creates a [RadioButton] group
  ///
  /// The [groupValue] is the selected value.
  /// The [items] are elements to contruct the group
  /// [onChanged] will called every time a radio is selected. The clouser return the selected item.
  /// [direction] most be horizontal or vertial.
  /// [spacebetween] works only when [direction] is [Axis.vertical] and ignored when [Axis.horizontal].
  /// and represent the space between elements
  /// [horizontalAlignment] works only when [direction] is [Axis.horizontal] and ignored when [Axis.vertical].

  final List<int> items;
  final RadioButtonBuilder Function(int value) itemBuilder;
  final void Function(int?)? onChanged;
  final Axis direction;
  final double spacebetween;
  final String tag;
  final MainAxisAlignment horizontalAlignment;
  final Color? activeColor;

  const RadioGroup.builder({
    required this.onChanged,
    required this.tag,
    required this.items,
    required this.itemBuilder,
    this.direction = Axis.vertical,
    this.spacebetween = 30,
    this.horizontalAlignment = MainAxisAlignment.spaceBetween,
    this.activeColor,
  });

  List<Widget> get _group => this.items.map(
        (item) {
          final radioButtonBuilder = this.itemBuilder(item);

          return Container(
            height: this.direction == Axis.vertical ? this.spacebetween : 40.0,
            child: RadioButton(
              tag: tag,
              description: radioButtonBuilder.description,
              descriptionStyle: radioButtonBuilder.descriptionStyle,
              value: item,
              onChanged: this.onChanged,
              textPosition: radioButtonBuilder.textPosition ??
                  RadioButtonTextPosition.right,
              activeColor: activeColor,
            ),
          );
        },
      ).toList();

  @override
  Widget build(BuildContext context) => this.direction == Axis.vertical
      ? Column(
          children: _group,
        )
      : Row(
          mainAxisAlignment: this.horizontalAlignment,
          children: _group,
        );
}
