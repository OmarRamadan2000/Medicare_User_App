import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controller/theme_controller.dart';
import './utilities/app_constans.dart';
import 'helpers/route_helper.dart';
import 'helpers/get_di.dart' as di;
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return
      GetBuilder<ThemeController>(builder: (themeController){
        return GetMaterialApp(
          title: AppConstants.appName,
          initialRoute:  RouteHelper.getHomePageRoute(),//RouteHelper.getOnBoardingPageRoute(),//LoginPage(),
          debugShowCheckedModeBanner: false,
          theme: themeController.darkTheme ? dark : light,
          getPages: RouteHelper.routes,
        );
      });
  }
}
