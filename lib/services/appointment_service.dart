import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/get_req_helper.dart';
import '../helpers/post_req_helper.dart';
import '../model/appointment_model.dart';
import '../utilities/api_content.dart';
import '../utilities/sharedpreference_constants.dart';

class AppointmentService{

   static const  getAppByUIDUrl=   ApiContents.getAppByUIDUrl;
   static const  getAppByIDUrl=   ApiContents.getAppByIDUrl;
  static const  addAppUrl=   ApiContents.addAppUrl;

  static List<AppointmentModel> dataFromJson (jsonDecodedData){
    return List<AppointmentModel>.from(jsonDecodedData.map((item)=>AppointmentModel.fromJson(item)));
  }
  static Future addAppointment(
      {
        required String patientId,
        required String status,
        required String date,
        required String timeSlots,
        required String doctId,
        required String deptId,
        required String type,
        required String meetingId,
        required String meetingLink,
        required String paymentStatus,
        required String fee,
        required String serviceCharge,
        required String totalAmount,
        required String invoiceDescription,
        required String paymentMethod,
        required String paymentTransactionId,
        required String isWalletTxn,
        required String familyMemberId,
        required String couponId,
        required String couponValue,
        required String couponTitle,
        required String couponOffAmount,
        required String tax,
        required String unitTaxAmount,
        required String unitTotalAmount,
}
      )async{
    SharedPreferences preferences=await  SharedPreferences.getInstance();
    final uid= preferences.getString(SharedPreferencesConstants.uid)??"-1";
    Map body={
       "family_member_id":familyMemberId,
      'patient_id': patientId,
      'status': status,
      'date': date,
      'time_slots': timeSlots,
      'doct_id': doctId,
      'dept_id': deptId,
      'type': type,
      'meeting_id': meetingId,
      'meeting_link': meetingLink,
      'payment_status': paymentStatus,
      'fee': fee,
      'service_charge': serviceCharge,
      'total_amount': totalAmount,
      'invoice_description': invoiceDescription,
      'payment_method': paymentMethod,
      'user_id': uid,
      'payment_transaction_id': paymentTransactionId,
      "is_wallet_txn":isWalletTxn,
      "coupon_id":couponId,
      "coupon_title":couponTitle,
      "coupon_value":couponValue,
      "coupon_off_amount":couponOffAmount,
      "unit_tax_amount":unitTaxAmount,
      "tax":tax,
      "unit_total_amount":unitTotalAmount,
      "source":Platform.isAndroid?"Android App":Platform.isIOS?"Ios App":""
    };
    final res=await PostService.postReq(addAppUrl, body);
    return res;
  }
  static Future <List<AppointmentModel>?> getData()async {
    SharedPreferences preferences=await  SharedPreferences.getInstance();
    final uid= preferences.getString(SharedPreferencesConstants.uid)??"-1";
    final res=await GetService.getReq("$getAppByUIDUrl/$uid");
    if(res==null) {
      return null;
    } else {
      List<AppointmentModel> dataModelList = dataFromJson(res);
      return dataModelList;
    }
  }
   static Future <AppointmentModel?> getDataById({required String? appId})async {
     final res=await GetService.getReq("$getAppByIDUrl/${appId??""}");
     if(res==null) {
       return null;
     } else {
       AppointmentModel dataModel = AppointmentModel.fromJson(res);
       return dataModel;
     }
   }

}