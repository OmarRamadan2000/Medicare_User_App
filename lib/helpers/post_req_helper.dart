import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/helpers/route_helper.dart';
import '../controller/notification_dot_controller.dart';
import '../controller/user_controller.dart';
import '../services/user_subscription.dart';
import '../utilities/sharedpreference_constants.dart';
import '../widget/toast_message.dart';
import 'package:get/get.dart';

class PostService{
  static Future postReq(url,body)async {
    if (kDebugMode) {
      print("======Url==========");
      print(url);
      print("======Send Data==========");
      print(body);
    }
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final token=  preferences.getString(SharedPreferencesConstants.token)??"";
    try {
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
       dio.options.headers["contentType"] = "application/x-www-form-urlencoded";
      dio.options.validateStatus = (status) {
        // Allow 200 and 401 status codes, so they don't throw exceptions
        return status! < 500;
      };
      final response = await dio.post(url, data: body);
      // print("==========URL Response==========");
      // print(response);
      if (kDebugMode) {
        print("==========URL Response==========");
        print(response);
      }
      if (response.statusCode == 401) {
        IToastMsg.showMessage("Session expired. Please log in again.");
        logOut();
        return null;
      }
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.toString());
        if (kDebugMode) {
          print("==========Response==========");
          print(jsonData);
        }
        if (jsonData['response'] == 201) {
          if (jsonData['message'] == "error") {
            IToastMsg.showMessage("Something went wrong");
          } else {
            IToastMsg.showMessage(jsonData['message']);
          }
          return null;
        }
        else if (jsonData['response'] == 200){
          return jsonData;
       }
      }else {
        IToastMsg.showMessage("Something went wrong");
        return null;
      }
    }catch(e){
       if (kDebugMode) {
         print(e);
       }
         IToastMsg.showMessage("Something went wrong $e");


       return null;
    }

  }
  static logOut()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.clear();
    IToastMsg.showMessage("Logout");
    final NotificationDotController notificationDotController=Get.find(tag: "notification_dot");
    final   UserController userController0=Get.find(tag: "user");
    userController0.getData();
    notificationDotController.setDotStatus(false);
    Get.offAllNamed(RouteHelper.getHomePageRoute());
    UserSubscribe.deleteToTopi(topicName: "PATIENT_APP");
  }

}