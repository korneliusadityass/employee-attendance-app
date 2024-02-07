import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  //center
  Widget center() => Center(
        child: this,
      );
}

extension SizedboxExt on num {
  //height
  Widget get height => SizedBox(
        height: toDouble(),
      );

  //width
  Widget get width => SizedBox(
        width: toDouble(),
      );
}
