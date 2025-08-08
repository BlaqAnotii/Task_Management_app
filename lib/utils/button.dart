// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskmanagementapp/resources/colors.dart';

enum ButtonType { fill, outline, text, gradient }

class AppButton extends StatelessWidget {
  final double borderRadius;
  final double? fontSize;
  final String title;
  final bool busy;
  final Border? border;
  final Function onPressed;
  final Color buttonBgColor;
  final double? radius;
  final Color? loadingColor;
  final Color? buttonTextColor;
  final Color? leadingIconColor;
  final Color? trailingIconColor;
  final bool? disabled;
  // final FontWeight fontWeight;
  final ButtonType? buttonType;
  final Icon? leadingIcon;
  final String? trailingIcon;
  final double trailingIconSpace;
  final EdgeInsets? padding;
  final bool? loading;
  const AppButton({
    super.key,
    this.borderRadius = 8.0,
    this.border,
    this.fontSize = 20,
    this.trailingIconSpace = 4.0,
    required this.onPressed,
    this.buttonBgColor = AppColors.darkBlue,
    this.buttonTextColor = AppColors.white,
    required this.title,
    this.leadingIcon,
    this.trailingIcon,
    this.leadingIconColor = AppColors.white,
    this.trailingIconColor = AppColors.white,
    this.busy = false,
    this.loadingColor,
    this.disabled,
    this.padding,
    this.loading,
    this.buttonType = ButtonType.fill,
    this.radius,
  });

  Color getBackgroundColor() {
    if (buttonType == ButtonType.outline) {
      return Colors.transparent;
    } else if (buttonType == ButtonType.fill) {
      return buttonBgColor;
    } else {
      return Colors.transparent;
    }
  }

  Color getColor() {
    if (buttonType == ButtonType.fill) {
      return buttonTextColor != null ? buttonTextColor! : AppColors.white;
    } else if (buttonType == ButtonType.outline) {
      return buttonTextColor!;
    } else {
      return buttonTextColor != null ? buttonTextColor! : buttonBgColor;
    }
  }

  Border constructBorder() {
    if (border != null) {
      return border!;
    }
    if (buttonType == ButtonType.outline) {
      return Border.all(
        color: getColor(),
        width: 2.w,
      );
    } else {
      return Border.all(
        color: Colors.transparent,
        width: 0.w,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _color = getColor();
    final _bgColor = getBackgroundColor();
    return InkWell(
      splashColor: AppColors.darkBlue,
      // onTap: onPressed,
      onTap: ((disabled != null && disabled!) || loading != null && loading!)
          ? null
          : () => onPressed(),
      child: Container(
        height: 60.h,
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: 13.0.h,
            ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 10.h),
          color:
              (disabled != null && disabled!) || (loading != null && loading!)
                  ? _bgColor.withOpacity(0.6)
                  : _bgColor,
          border: constructBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leadingIcon != null)
              Container(
                margin: EdgeInsets.only(
                  right: 3.w,
                  bottom: 4.w,
                ),
                height: 20.h,
                width: 20.w,
                child: leadingIcon!,
              ),
            Text(
              title,
              // ignore: deprecated_member_use
              textScaleFactor: 1.0,
              style: TextStyle(
                fontSize: 15,
                color: _color,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (trailingIcon != null) SizedBox(width: trailingIconSpace),
            if (trailingIcon != null)
              Image.asset(
                trailingIcon!,
                height: 20.h,
                width: 20.w,
              ),
            if (loading != null && loading!)
              SizedBox(
                width: 16.w,
                height: 16.h,
                child: CircularProgressIndicator(
                  color: loadingColor ?? _color,
                  strokeWidth: 3,
                ),
              )
          ],
        ),
      ),
    );
  }
}

// class AppButton2 extends StatelessWidget {
//   final double borderRadius;
//   final double fontSize;
//   final String title;
//   final bool busy;
//   final Border? border;
//   final Function onPressed;
//   final Color buttonBgColor;
//   final double? radius;
//   final Color? loadingColor;
//   final Color? buttonTextColor;
//   final Color? leadingIconColor;
//   final Color? trailingIconColor;
//   final bool? disabled;
//   // final FontWeight fontWeight;
//   final ButtonType? buttonType;
//   final String? leadingIcon;
//   final String? trailingIcon;
//   final double trailingIconSpace;
//   final EdgeInsets? padding;
//   final bool? loading;
//   const AppButton2({
//     super.key,
//     this.borderRadius = 8.0,
//     this.border,
//     this.fontSize = 14.0,
//     this.trailingIconSpace = 4.0,
//     required this.onPressed,
//     this.buttonBgColor = AppColor.btnbackground,
//     this.buttonTextColor = AppColor.white,
//     required this.title,
//     this.leadingIcon,
//     this.trailingIcon,
//     this.leadingIconColor = AppColor.white,
//     this.trailingIconColor = AppColor.white,
//     this.busy = false,
//     this.loadingColor,
//     this.disabled,
//     this.padding,
//     this.loading,
//     this.buttonType = ButtonType.gradient,
//     this.radius,
//   });

//   Color getBackgroundColor() {
//     if (buttonType == ButtonType.outline) {
//       return Colors.transparent;
//     } else if (buttonType == ButtonType.fill) {
//       return buttonBgColor;
//     } else {
//       return Colors.transparent;
//     }
//   }

//   Color getColor() {
//     if (buttonType == ButtonType.fill) {
//       return buttonTextColor != null ? buttonTextColor! : AppColor.white;
//     } else if (buttonType == ButtonType.outline) {
//       return buttonTextColor!;
//     } else {
//       return buttonTextColor != null ? buttonTextColor! : buttonBgColor;
//     }
//   }

//   Border constructBorder() {
//     if (border != null) {
//       return border!;
//     }
//     if (buttonType == ButtonType.outline) {
//       return Border.all(
//         color: getColor(),
//         width: 1.w,
//       );
//     } else {
//       return Border.all(
//         color: Colors.transparent,
//         width: 0.w,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _color = getColor();
//     final _bgColor = getBackgroundColor();
//     return InkWell(
//       splashColor: AppColor.btnbackground,
//       // onTap: onPressed,
//       onTap: ((disabled != null && disabled!) || loading != null && loading!)
//           ? null
//           : () => onPressed(),
//       child: Container(
//         height: 60.h,
//         padding: padding ??
//             EdgeInsets.symmetric(
//               vertical: 13.0.h,
//             ),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(radius ?? 10.h),
//           gradient: const LinearGradient(
//             colors: [
//               AppColor.borderblue,
//               AppColor.btnbackground,
//               AppColor.btnbackground,
//               AppColor.btnbackground,
//             ],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           color:
//               (disabled != null && disabled!) || (loading != null && loading!)
//                   ? _bgColor.withOpacity(0.6)
//                   : _bgColor,
//           border: constructBorder(),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (leadingIcon != null)
//               Container(
//                 margin: EdgeInsets.only(right: 20.w),
//                 child: Image.asset(
//                   leadingIcon!,
//                   height: 20.h,
//                   width: 20.w,
//                 ),
//               ),
//             loading != null && loading!
//                 ? const Text('')
//                 : Text(
//                     title,
//                     // ignore: deprecated_member_use
//                     textScaleFactor: 1.0,
//                     style: TextStyle(
//                       fontSize: fontSize,
//                       fontFamily: 'Montserrat',
//                       color: _color,
//                       decoration: TextDecoration.none,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//             if (trailingIcon != null) SizedBox(width: trailingIconSpace),
//             if (trailingIcon != null)
//               Image.asset(
//                 trailingIcon!,
//                 height: 20.h,
//                 width: 20.w,
//               ),
//             if (loading != null && loading!)
//               SizedBox(
//                 width: 16.w,
//                 height: 16.h,
//                 child: CircularProgressIndicator(
//                   color: loadingColor ?? _color,
//                   strokeWidth: 3,
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AppGradientButton2 extends StatelessWidget {
//   final double fontSize;
//   final Function onPressed;
//   final String title;
//   final IconData? buttonIcon;
//   final ButtonType? buttonType;
//   final Color? textColor;
//   final Color? buttonBgColor1;
//   final Color? buttonBgColor2;
//   final bool? loading;
//   const AppGradientButton2({
//     super.key,
//     this.fontSize = 14.0,
//     required this.onPressed,
//     required this.title,
//     this.buttonIcon = Icons.arrow_forward,
//     this.textColor = AppColor.white,
//     this.buttonType = ButtonType.gradient,
//     this.buttonBgColor1 = AppColor.borderblue,
//     this.buttonBgColor2 = AppColor.btnbackground,
//     this.loading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       splashColor: Colors.transparent,
//       // onTap: onPressed,
//       onTap: (loading != null && loading!) ? null : () => onPressed(),
//       child: Center(
//         child: Container(
//           height: 60.h,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.h),
//             color: buttonType == ButtonType.gradient
//                 ? null
//                 : buttonType == ButtonType.outline
//                     ? buttonBgColor2 ?? Colors.transparent
//                     : (loading != null && loading!)
//                         ? buttonBgColor1!.withOpacity(0.6)
//                         : buttonBgColor1!,
//             border: constructBorder2(),
//             gradient: buttonType == ButtonType.gradient
//                 ? LinearGradient(
//                     colors: (loading != null && loading!)
//                         ? [
//                             buttonBgColor1!.withOpacity(0.5),
//                             buttonBgColor2!.withOpacity(0.5),
//                             buttonBgColor2!.withOpacity(0.5),
//                             buttonBgColor2!.withOpacity(0.5)
//                           ]
//                         : [buttonBgColor1!, buttonBgColor2!],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   )
//                 : null,
//           ),
//           child: Stack(
//             children: [
//               if (loading != null && loading!)
//                 Positioned(
//                   left: 25.h,
//                   top: 17.h,
//                   child: SizedBox(
//                     width: 16.h,
//                     height: 16.h,
//                     child: CircularProgressIndicator(
//                       color: textColor!,
//                       strokeWidth: 3,
//                     ),
//                   ),
//                 ),
//               Center(
//                 child: AutoSizeText(
//                   title,
//                   textScaleFactor: 1.0,
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     fontFamily: 'Montserrat',
//                     color: textColor,
//                     decoration: TextDecoration.none,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               // Positioned(
//               //     right: 0.h,
//               //     top: 0.h,
//               //     child: Container(
//               //         decoration: BoxDecoration(
//               //             borderRadius: BorderRadius.circular(30.h),
//               //             color: buttonType == ButtonType.gradient
//               //                 ? AppColor.white
//               //                 : Colors.transparent,
//               //             border: constructBorder()),
//               //         width: 60.0.h,
//               //         height: 60.0.h,
//               //         child:
//               //             Icon(buttonIcon, color: Colors.black, size: 20.h))),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Border constructBorder2() {
//     if (buttonType == ButtonType.outline) {
//       return Border.all(
//         color: loading! ? AppColor.grey : buttonBgColor1!,
//         width: 1.w,
//       );
//     } else {
//       return Border.all(
//         color: Colors.grey.withOpacity(0.5),
//         width: 0.w,
//       );
//     }
//   }
// }

// class AppButton3 extends StatelessWidget {
//   final double borderRadius;
//   final double fontSize;
//   final String title;
//   final bool busy;
//   final Border? border;
//   final Function onPressed;
//   final Color buttonBgColor;
//   final double? radius;
//   final Color? loadingColor;
//   final Color? buttonTextColor;
//   final Color? leadingIconColor;
//   final Color? trailingIconColor;
//   final bool? disabled;
//   // final FontWeight fontWeight;
//   final ButtonType? buttonType;
//   final String? leadingIcon;
//   final String? trailingIcon;
//   final double trailingIconSpace;
//   final EdgeInsets? padding;
//   final bool? loading;
//   const AppButton3({
//     super.key,
//     this.borderRadius = 8.0,
//     this.border,
//     this.fontSize = 14.0,
//     this.trailingIconSpace = 4.0,
//     required this.onPressed,
//     this.buttonBgColor = AppColor.btnbackground,
//     this.buttonTextColor = AppColor.white,
//     required this.title,
//     this.leadingIcon,
//     this.trailingIcon,
//     this.leadingIconColor = AppColor.white,
//     this.trailingIconColor = AppColor.white,
//     this.busy = false,
//     this.loadingColor,
//     this.disabled,
//     this.padding,
//     this.loading,
//     this.buttonType = ButtonType.fill,
//     this.radius,
//   });

//   Color getBackgroundColor() {
//     if (buttonType == ButtonType.outline) {
//       return Colors.transparent;
//     } else if (buttonType == ButtonType.fill) {
//       return buttonBgColor;
//     } else {
//       return Colors.transparent;
//     }
//   }

//   Color getColor() {
//     if (buttonType == ButtonType.fill) {
//       return buttonTextColor != null ? buttonTextColor! : AppColor.white;
//     } else if (buttonType == ButtonType.outline) {
//       return buttonTextColor!;
//     } else {
//       return buttonTextColor != null ? buttonTextColor! : buttonBgColor;
//     }
//   }

//   Border constructBorder() {
//     if (border != null) {
//       return border!;
//     }
//     if (buttonType == ButtonType.outline) {
//       return Border.all(
//         color: AppColor.borderblue,
//         width: 1.w,
//       );
//     } else {
//       return Border.all(
//         color: Colors.transparent,
//         width: 0.w,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _color = getColor();
//     final _bgColor = getBackgroundColor();
//     return InkWell(
//       splashColor: AppColor.btnbackground,
//       // onTap: onPressed,
//       onTap: ((disabled != null && disabled!) || loading != null && loading!)
//           ? null
//           : () => onPressed(),
//       child: Container(
//         height: 60.h,
//         padding: padding ??
//             EdgeInsets.symmetric(
//               vertical: 13.0.h,
//             ),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(radius ?? 50.h),
//           color:
//               (disabled != null && disabled!) || (loading != null && loading!)
//                   ? _bgColor.withOpacity(0.6)
//                   : _bgColor,
//           border: constructBorder(),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (leadingIcon != null)
//               Container(
//                 margin: EdgeInsets.only(right: 20.w),
//                 child: Image.asset(
//                   leadingIcon!,
//                   height: 20.h,
//                   width: 20.w,
//                 ),
//               ),
//             loading != null && loading!
//                 ? const Text('')
//                 : Text(
//                     title,
//                     // ignore: deprecated_member_use
//                     textScaleFactor: 1.0,
//                     style: TextStyle(
//                       fontSize: fontSize,
//                       fontFamily: 'Montserrat',
//                       color: _color,
//                       decoration: TextDecoration.none,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//             if (trailingIcon != null) SizedBox(width: trailingIconSpace),
//             if (trailingIcon != null)
//               Image.asset(
//                 trailingIcon!,
//                 height: 20.h,
//                 width: 20.w,
//               ),
//             if (loading != null && loading!)
//               SizedBox(
//                 width: 16.w,
//                 height: 16.h,
//                 child: CircularProgressIndicator(
//                   color: loadingColor ?? _color,
//                   strokeWidth: 3,
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AppButton4 extends StatelessWidget {
//   final double borderRadius;
//   final double fontSize;
//   final String? title;
//   final bool busy;
//   final Border? border;
//   final Function onPressed;
//   final Color buttonBgColor;
//   final double? radius;
//   final Color? loadingColor;
//   final Color? buttonTextColor;
//   final Color? leadingIconColor;
//   final Color? trailingIconColor;
//   final bool? disabled;
//   // final FontWeight fontWeight;
//   final ButtonType? buttonType;
//   final IconData leadingIcon;
//   final String? trailingIcon;
//   final double trailingIconSpace;
//   final EdgeInsets? padding;
//   final bool? loading;
//   const AppButton4({
//     super.key,
//     this.borderRadius = 8.0,
//     this.border,
//     this.fontSize = 14.0,
//     this.trailingIconSpace = 4.0,
//     required this.onPressed,
//     this.buttonBgColor = AppColor.btnbackground,
//     this.buttonTextColor = AppColor.white,
//     this.title,
//     required this.leadingIcon,
//     this.trailingIcon,
//     this.leadingIconColor = AppColor.white,
//     this.trailingIconColor = AppColor.white,
//     this.busy = false,
//     this.loadingColor,
//     this.disabled,
//     this.padding,
//     this.loading,
//     this.buttonType = ButtonType.fill,
//     this.radius,
//   });

//   Color getBackgroundColor() {
//     if (buttonType == ButtonType.outline) {
//       return Colors.transparent;
//     } else if (buttonType == ButtonType.fill) {
//       return buttonBgColor;
//     } else {
//       return Colors.transparent;
//     }
//   }

//   Color getColor() {
//     if (buttonType == ButtonType.fill) {
//       return buttonTextColor != null ? buttonTextColor! : AppColor.white;
//     } else if (buttonType == ButtonType.outline) {
//       return buttonTextColor!;
//     } else {
//       return buttonTextColor != null ? buttonTextColor! : buttonBgColor;
//     }
//   }

//   Border constructBorder() {
//     if (border != null) {
//       return border!;
//     }
//     if (buttonType == ButtonType.outline) {
//       return Border.all(
//         color: AppColor.blue,
//         width: 1.w,
//       );
//     } else {
//       return Border.all(
//         color: Colors.transparent,
//         width: 0.w,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //final _color = getColor();
//     final _bgColor = getBackgroundColor();
//     return InkWell(
//       splashColor: AppColor.btnbackground,
//       // onTap: onPressed,
//       onTap: ((disabled != null && disabled!) || loading != null && loading!)
//           ? null
//           : () => onPressed(),
//       child: Container(
//         height: 60.h,
//         padding: padding ??
//             EdgeInsets.symmetric(
//               vertical: 13.0.h,
//             ),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(radius ?? 50.h),
//           color:
//               (disabled != null && disabled!) || (loading != null && loading!)
//                   ? _bgColor.withOpacity(0.6)
//                   : _bgColor,
//           border: constructBorder(),
//         ),
//         child: loading != null && loading! ? Container() : Icon(leadingIcon),
//       ),
//     );
//   }
// }

// class AppButton5 extends StatelessWidget {
//   final double borderRadius;
//   final double fontSize;
//   final String? title;
//   final bool busy;
//   final Border? border;
//   final Function onPressed;
//   final Color buttonBgColor;
//   final double? radius;
//   final Color? loadingColor;
//   final Color? buttonTextColor;
//   final Color? leadingIconColor;
//   final Color? trailingIconColor;
//   final bool? disabled;
//   // final FontWeight fontWeight;
//   final ButtonType? buttonType;
//   final IconData leadingIcon;
//   final String? trailingIcon;
//   final double trailingIconSpace;
//   final EdgeInsets? padding;
//   final bool? loading;
//   const AppButton5({
//     super.key,
//     this.borderRadius = 8.0,
//     this.border,
//     this.fontSize = 14.0,
//     this.trailingIconSpace = 4.0,
//     required this.onPressed,
//     this.buttonBgColor = AppColor.btnbackground,
//     this.buttonTextColor = AppColor.white,
//     this.title,
//     required this.leadingIcon,
//     this.trailingIcon,
//     this.leadingIconColor = AppColor.textred,
//     this.trailingIconColor = AppColor.white,
//     this.busy = false,
//     this.loadingColor,
//     this.disabled,
//     this.padding,
//     this.loading,
//     this.buttonType = ButtonType.fill,
//     this.radius,
//   });

//   Color getBackgroundColor() {
//     if (buttonType == ButtonType.outline) {
//       return Colors.transparent;
//     } else if (buttonType == ButtonType.fill) {
//       return buttonBgColor;
//     } else {
//       return Colors.transparent;
//     }
//   }

//   Color getColor() {
//     if (buttonType == ButtonType.fill) {
//       return buttonTextColor != null ? buttonTextColor! : AppColor.white;
//     } else if (buttonType == ButtonType.outline) {
//       return buttonTextColor!;
//     } else {
//       return buttonTextColor != null ? buttonTextColor! : buttonBgColor;
//     }
//   }

//   Border constructBorder() {
//     if (border != null) {
//       return border!;
//     }
//     if (buttonType == ButtonType.outline) {
//       return Border.all(
//         color: AppColor.textred,
//         width: 1.w,
//       );
//     } else {
//       return Border.all(
//         color: Colors.transparent,
//         width: 0.w,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //final _color = getColor();
//     final _bgColor = getBackgroundColor();
//     return InkWell(
//       splashColor: AppColor.btnbackground,
//       // onTap: onPressed,
//       onTap: ((disabled != null && disabled!) || loading != null && loading!)
//           ? null
//           : () => onPressed(),
//       child: Container(
//         height: 60.h,
//         padding: padding ??
//             EdgeInsets.symmetric(
//               vertical: 13.0.h,
//             ),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(radius ?? 50.h),
//           color:
//               (disabled != null && disabled!) || (loading != null && loading!)
//                   ? _bgColor.withOpacity(0.6)
//                   : _bgColor,
//           border: constructBorder(),
//         ),
//         child: loading != null && loading! ? Container() : Icon(leadingIcon),
//       ),
//     );
//   }
// }
