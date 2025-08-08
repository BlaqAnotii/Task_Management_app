import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const ext = 0;

extension WidgetExtensions on double {
  Widget get sbH => SizedBox(height: this.h);
  Widget get sbW => SizedBox(width: this.w);
  EdgeInsetsGeometry get padA => EdgeInsets.all(this);
  EdgeInsetsGeometry get padV => EdgeInsets.symmetric(vertical: h);
  EdgeInsetsGeometry get padH => EdgeInsets.symmetric(horizontal: w);
}

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double CalcWidth(BuildContext context, double width, {double maxWidth = 0}) {
  //width : 375
  //height : 677

  if (maxWidth != 0) {
    return (MediaQuery.of(context).size.width / 375) * width > maxWidth
        ? maxWidth
        : (MediaQuery.of(context).size.width / 375) * width;
  }
  return (MediaQuery.of(context).size.width / 375) * width;
}

double CalcHeight(BuildContext context, double height, {double maxHeight = 0}) {
  //width : 375
  //height : 677

  if (maxHeight != 0) {
    return (MediaQuery.of(context).size.height / 677) * height > maxHeight
        ? maxHeight
        : (MediaQuery.of(context).size.height / 677) * height;
  }
  return (MediaQuery.of(context).size.height / 677) * height;
}
