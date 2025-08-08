import 'package:flutter/material.dart';
import 'package:taskmanagementapp/resources/colors.dart';

class CustomInputText extends StatelessWidget {
  const CustomInputText(
      {super.key,
      required this.inputType,
      this.textColor,
      this.color,
      this.prefix,
      this.onChangeVal,
      this.suffix,
      this.obscure,
      this.onChange,
      this.maxLine,
      required this.hintText,
      this.controller,
      this.validator,
      this.style,
      this.enabled,
      this.autovalidateMode,
      this.onChanged,
      this.moreRounded = true});

  final Widget? prefix;
  final AutovalidateMode? autovalidateMode;
  final Widget? suffix;
  final Color? color;
  final Color? textColor;
  final String hintText;
  final bool? obscure;
  final bool? enabled;
  final Function(String)? onChanged;
  final String? onChangeVal;
  final TextInputType inputType;
  final TextEditingController? controller;
  final Function? onChange;
  final int? maxLine;
  final TextStyle? style;
  final String? Function(String?)? validator;
  final bool? moreRounded;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscure ?? false,
      validator: validator,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.darkBlue,
            width: 0.5,
          ),
        ),
        contentPadding: const EdgeInsets.only(
          top: 12,
        ),
        prefixIcon: prefix,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 13,
          color: AppColors.darkBlue,
        ),
        suffix: suffix,
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => length > 0
      ? replaceAll(RegExp(' +'), ' ')
          .split(' ')
          .map((str) => str.toCapitalized())
          .join(' ')
      : this;
  String sanitizePhoneNumber() => replaceAll(" ", "").replaceAll("-", "");
  String lastChars(int n) => substring(length - n);
}
