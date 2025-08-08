import 'package:flutter/material.dart';

class AppColors {
  static const darkBlue = Color(0xFF006400);
  static const lightBlue = Color(0xFF94cafc);
  static const blue = Color(0xFF0000FF);
  static const cyan = Color(0xFF00FFFF);
  static const yellow = Color(0xFFFFFF00);
  static const orange = Color(0xFFFFA500);
  static const red = Color(0xFFFF0000);
  static const maroon = Color(0xFF800000);
  static const green = Color(0xFF00FF00);
  static const darkGreen = Color(0xFF006400);
  static const lemon = Color(0xFFfff700);
  static const amber = Color(0xFFFFBF00);
  static const pink = Color(0xFFFFC0CB);
  static const brightPink = Color(0xFFFC0FC0);
  static const ruby = Color(0xFFE0115F);
  static const magenta = Color(0xFFFF0090);
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFF808080);
  static const lightGrey = Color(0xFFD3D3D3);
  static const darkGrey = Color.fromARGB(255, 49, 48, 48);
  static const brown = Color(0xFF964B00);
  static const purple = Color(0xFF800080);
  static const gold = Color(0xFFFFD700);
  static const silver = Color(0xFFC0C0C0);
}

promptUser(BuildContext context, String title, String comment,
    void Function() callback) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(comment),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No")),
            TextButton(
                onPressed: () {
                  callback();
                  Navigator.pop(context);
                },
                child: const Text("Yes")),
          ],
        );
      });
}

class AppPhotoBottomSheet {
  static void bottomSheetBuilder(Widget bottomSheetView, BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        context: context,
        builder: (context) => bottomSheetView);
  }
}
