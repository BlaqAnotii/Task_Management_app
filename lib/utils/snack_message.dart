import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:oktoast/oktoast.dart';
import 'package:taskmanagementapp/resources/colors.dart';
import 'package:taskmanagementapp/utils/widget_extensions.dart';

Widget toast(String message, {ToastType? toastType}) {
  List<Color> listColor = [];
  IconData iconData = Icons.warning;
  if (toastType! == ToastType.error) {
    iconData = Icons.error;
    listColor = [
      const Color.fromARGB(255, 229, 94, 27),
      const Color.fromARGB(255, 183, 28, 28)
    ];
  } else if (toastType == ToastType.success) {
    iconData = Icons.check_circle;
    listColor = [Colors.green, const Color(0XFF33691E)];
  } else if (toastType == ToastType.info) {
    iconData = Icons.info;
    listColor = [
      const Color.fromARGB(255, 43, 126, 251),
      const Color.fromARGB(255, 4, 7, 101)
    ];
  } else {
    listColor = [
      const Color.fromARGB(255, 249, 195, 59),
      const Color.fromARGB(255, 207, 104, 8)
    ];
  }
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 50.h),
        padding: EdgeInsets.all(12.0.h),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGrey, width: 2.5),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            gradient: LinearGradient(
              colors: listColor,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )),
        child: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 25,
            ),
            10.0.sbW,
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

showCustomToast(String message,
    {ToastType toastType = ToastType.error, int time = 3}) {
  // dialogLocation(message: message, success: success, time: time);
  showToastWidget(
    toast(message, toastType: toastType),
    duration: Duration(seconds: time),
    onDismiss: () {},
  );
}

enum ToastType { info, error, warning, success }
