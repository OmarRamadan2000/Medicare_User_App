import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/model/patient_file_model.dart';
import 'package:userapp/utilities/sharedpreference_constants.dart';

import '../helpers/get_req_helper.dart';

import '../utilities/api_content.dart';

class PatientFilesService{

  static const  getUrl=   ApiContents.getPatientFileQrl;
  static const  getPatientFileByIdrl=   ApiContents.getPatientFileByIdrl;
  static const  getPatientFileByPatientIUrl=   ApiContents.getPatientFileByPatientIUrl;


  static List<PatientFileModel> dataFromJson (jsonDecodedData){

    return List<PatientFileModel>.from(jsonDecodedData.map((item)=>PatientFileModel.fromJson(item)));
  }

  static Future <List<PatientFileModel>?> getData(String searchQ)async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final uid=preferences.getString(SharedPreferencesConstants.uid);

    // fetch data
    final res=await GetService.getReq("$getUrl?user_id=$uid&search_query=$searchQ");

    if(res==null) {
      return null; //check if any null value
    } else {
      List<PatientFileModel> dataModelList = dataFromJson(res); // convert all list to model
      return dataModelList;  // return converted data list model
    }
  }
  static Future <PatientFileModel?> getDataById({required String? id})async {
    final res=await GetService.getReq("$getPatientFileByIdrl/${id??""}");
    if(res==null) {
      return null;
    } else {
      PatientFileModel dataModel = PatientFileModel.fromJson(res);
      return dataModel;
    }
  }
  static Future <List<PatientFileModel>?> getDataByPatientId(String id)async {

    // fetch data
    final res = await GetService.getReq("$getPatientFileByPatientIUrl/$id");

    if (res == null) {
      return null; //check if any null value
    } else {
      List<PatientFileModel> dataModelList = dataFromJson(
          res); // convert all list to model
      return dataModelList; // return converted data list model
    }
  }




}