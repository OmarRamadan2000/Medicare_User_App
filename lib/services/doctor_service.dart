import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/model/doctors_review_model.dart';
import '../helpers/get_req_helper.dart';
import '../helpers/post_req_helper.dart';
import '../model/doctors_model.dart';
import '../utilities/api_content.dart';
import '../utilities/sharedpreference_constants.dart';

class DoctorsService{

  static const  getUrl=   ApiContents.getDoctorsUrl;
  static const  getDoctorsActiveUrl=   ApiContents.getDoctorsActiveUrl;
  static const  addDoctorsReviewUrl=   ApiContents.addDoctorsReviewUrl;
  static const  getDoctorReviewUrl=   ApiContents.getDoctorReviewUrl;
  static List<DoctorsModel> dataFromJson (jsonDecodedData){

    return List<DoctorsModel>.from(jsonDecodedData.map((item)=>DoctorsModel.fromJson(item)));
  }
  static List<DoctorsReviewModel> dataFromJsonDR (jsonDecodedData){

    return List<DoctorsReviewModel>.from(jsonDecodedData.map((item)=>DoctorsReviewModel.fromJson(item)));
  }
  static Future addDoctorReView(
      {
        required String appointmentId,
        required String points,
        required String description,
        required String doctorId,
      }
      )async{
    SharedPreferences preferences=await  SharedPreferences.getInstance();
    final uid= preferences.getString(SharedPreferencesConstants.uid)??"";
    Map body={
      'doctor_id': doctorId,
      'points': points,
      'description': description,
      'appointment_id':appointmentId,
      "user_id":uid
    };
    final res=await PostService.postReq(addDoctorsReviewUrl, body);
    return res;
  }


  static Future <List<DoctorsModel>?> getData({String? searchQuery})async {
      // fetch data
    final res=await GetService.getReq("$getDoctorsActiveUrl?search_query=$searchQuery");

    if(res==null) {
      return null; //check if any null value
    } else {
      List<DoctorsModel> dataModelList = dataFromJson(res); // convert all list to model
      return dataModelList;  // return converted data list model
    }
  }

  static Future <DoctorsModel?> getDataById({required String? doctId})async {
    final res=await GetService.getReq("$getUrl/${doctId??""}");
    if(res==null) {
      return null;
    } else {
      DoctorsModel dataModel = DoctorsModel.fromJson(res);
      return dataModel;
    }
  }
  static Future <List<DoctorsReviewModel>?> getDataDoctorsReview({String? doctId})async {
    // fetch data
    final res=await GetService.getReq("$getDoctorReviewUrl/$doctId");

    if(res==null) {
      return null; //check if any null value
    } else {
      List<DoctorsReviewModel> doctorsReviewModelList = dataFromJsonDR(res); // convert all list to model
      return doctorsReviewModelList;  // return converted data list model
    }
  }

}