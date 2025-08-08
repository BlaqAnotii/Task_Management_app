import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:taskmanagementapp/config/config.dart';
import 'package:taskmanagementapp/controllers/note_provider.dart';
import 'package:taskmanagementapp/resources/theme.dart';
import 'package:taskmanagementapp/services/app_cache.dart';
import 'package:taskmanagementapp/views/home/home.dart';

import 'services/locator.dart';
import 'services/navigation_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  run();
}

Future run() async {
  Config.appFlavor = Flavor.DEVELOPMENT;
  setupLocator();
  getIt<AppData>().init();

  runApp(const MyApp());
  //setup dependency injector
}

var keyako = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    getIt<NavigationService>().materialC = context;
    return OKToast(
        child: ScreenUtilInit(
      //setup to fit into bigger screens
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: MaterialApp(
            navigatorKey:
                getIt<NavigationService>().navigatorKey,
            scaffoldMessengerKey:
                getIt<NavigationService>().snackBarKey,
            debugShowCheckedModeBanner: false,
            title: "Task Management App",
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: ThemeMode.light,
            // BottomNav(selectedIndex: 0),
            home: const HomeScreen(),
          ),
        );
      },
    ));
  }
}
