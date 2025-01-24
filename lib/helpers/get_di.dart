import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/notification_dot_controller.dart';
import '../controller/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import '../controller/user_controller.dart';
import '../services/handle_firebase_notification.dart';
import '../services/handle_local_notification.dart';

init() async {
  // Core
  await Firebase.initializeApp();
  await HandleFirebaseNotification.handleNotifications();
  await HandleLocalNotification.initializeFlutterNotification();
  final sharedPreferences = await SharedPreferences.getInstance();
  final UserController userController=Get.put(UserController(),tag: "user",permanent: true);
   Get.put(NotificationDotController(),tag: "notification_dot",permanent: true);
  userController.getData();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));

}