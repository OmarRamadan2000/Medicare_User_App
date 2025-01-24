import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/get_req_helper.dart';
import '../model/prescription_model.dart';
import '../utilities/api_content.dart';
import '../utilities/sharedpreference_constants.dart';

class PrescriptionService{

  static const  getByAppointmentUrl=   ApiContents.getPrescriptionByAppointmentUrl;
  static const  getByUidUrl=   ApiContents.getPrescriptionByUserUrl;

  static List<PrescriptionModel> dataFromJson (jsonDecodedData){

    return List<PrescriptionModel>.from(jsonDecodedData.map((item)=>PrescriptionModel.fromJson(item)));
  }

  static Future <List<PrescriptionModel>?> getData({required String appointmentId})async {

    final res=await GetService.getReq("$getByAppointmentUrl/$appointmentId");
    if(res==null) {
      return null;
    } else {

      List<PrescriptionModel> dataModelList = dataFromJson(res);

      return dataModelList;
    }
  }
  static Future <List<PrescriptionModel>?> getDataByUid()async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final uid=preferences.getString(SharedPreferencesConstants.uid);

    final res=await GetService.getReq("$getByUidUrl/$uid");
    if(res==null) {
      return null;
    } else {
      List<PrescriptionModel> dataModelList = dataFromJson(res);
      return dataModelList;
    }
  }
}