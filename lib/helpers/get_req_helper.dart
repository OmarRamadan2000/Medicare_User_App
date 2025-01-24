import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class GetService{
  static Future getReq(url)async {
    var dio = Dio();
    try {
      final response= await dio.get("$url");
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("==================URL==============");
          print(url);
          print("==================Response==============");
          print(response);
        }
        final jsonData=await json.decode(response.toString());
        if(jsonData['response']==200) {
          if(jsonData['data']!=null){
            return jsonData['data'];
          }else {
            return null;
          }
        }
        else {
          return null;
        }

      } else {
        return null; //if any error occurs then it return a blank list
      }
    }
    catch (e) {
      return null;
    }

  }
  static Future getReqWithBodY(url,body)async {
    var dio = Dio();
    try {

      final response= await dio.get("$url",
      data: body
      );
      if (kDebugMode) {
        print("$url");
        print("$body");
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("==================URL==============");
          print(url);
          print("==================Response==============");
          print(response);
        }
        final jsonData=await json.decode(response.toString());
        if(jsonData['response']==200) {
          if(jsonData['data']!=null){
            return jsonData['data'];
          }else {
            return null;
          }
        }
        else {
          return null;
        }

      } else {
        return null; //if any error occurs then it return a blank list
      }
    }
    catch (e) {
      return null;
    }

  }

}