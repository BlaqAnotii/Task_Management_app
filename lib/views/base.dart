import 'dart:async';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import 'package:taskmanagementapp/services/locator.dart';
import '../../utils/widget_extensions.dart';
import '../controllers/base.vm.dart';
import '../resources/colors.dart';
//import 'package:lottie/src/lottie.dart';

// the base view controls all the states of all the UIs
class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child)? builder;
  final Function(T)? onModelReady;
  final Function(T)? onModelDispose;
  final Color color;
  const BaseView(
      {Key? key,
      this.builder,
      this.onModelReady,
      this.color = AppColors.white,
      this.onModelDispose})
      : super(key: key);

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  T model = getIt<T>();

  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }

    //model.syncToCart();
  }

  // 

  @override
  void dispose() {
    super.dispose();
    if (widget.onModelDispose != null) {
      widget.onModelDispose!(model);
    }
    if (subscription != null) {
      subscription!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (_) => model,
        child: Consumer<T>(
          builder: (_, model, __) => Stack(
            children: [
              widget.builder!.call(_, model, __),
              if (model.isLoading)
                Stack(children: [
                  Container(
                    width: width(context),
                    height: height(context),
                    child: ModalBarrier(
                      color: Colors.black12.withOpacity(.5),
                      dismissible: false,
                    ),
                  ),
                  const Center(
                      child: SpinKitFoldingCube(
                    color: AppColors.orange,
                    size: 60,
                  ))
                ])
              // ShimmerUser()
            ],
          ),
        ));
  }
}
