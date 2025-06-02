import 'package:flutter/cupertino.dart';

extension WidgetMargin on Widget {
  Container bottomMargin(double height) {
    return Container(
      margin: EdgeInsets.only(bottom: height),
      child: this,
    );
  }

  Container rightMargin(double width) {
    return Container(
      margin: EdgeInsets.only(right: width),
      child: this,
    );
  }

  Container leftMargin(double width) {
    return Container(
      margin: EdgeInsets.only(left: width),
      child: this,
    );
  }
}
