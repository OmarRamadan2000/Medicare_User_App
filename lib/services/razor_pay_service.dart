import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/api_content.dart';
import '../helpers/post_req_helper.dart';
import '../utilities/sharedpreference_constants.dart';

class RazorPayService{


  static const  createOrderUrl=   ApiContents.createRzOrderUrl;


  static Future createOrderWallet(
      {required String? amount,
        required String? key,
        required String? secret

      })async{

    SharedPreferences preferences=await  SharedPreferences.getInstance();
    final uid= preferences.getString(SharedPreferencesConstants.uid)??"";
    final payload=jsonEncode({
    "amount":amount,
    "user_id":uid,
    "payment_method":"Online" ,//1=credit 2=debit
    "transaction_type":"Credited",
    "description":"Amount credited to user wallet",
    });
    Map body={
      "amount":amount,
      "key":key??"",
      "secret":secret??"",
      "payload":payload,
      "type":"Wallet"
    };
    final res=await PostService.postReq(createOrderUrl, body);
    return res;
  }
  static Future createOrderAppointment(
      {
        required String status,
        required String date,
        required String timeSlots,
        required String doctId,
        required String deptId,
        required String type,
        required String paymentStatus,
        required String fee,
        required String serviceCharge,
        required String totalAmount,
        required String invoiceDescription,
        required String paymentMethod,
        required String isWalletTxn,
        required String familyMemberId,
        required String couponId,
        required String couponValue,
        required String couponTitle,
        required String couponOffAmount,
        required String tax,
        required String unitTaxAmount,
        required String unitTotalAmount,
        required String secret,
        required String key,
      }
      )async{
    SharedPreferences preferences=await  SharedPreferences.getInstance();
    final uid= preferences.getString(SharedPreferencesConstants.uid)??"-1";
    final payload=jsonEncode({
      "family_member_id":familyMemberId,
      'status': status,
      'date': date,
      'time_slots': timeSlots,
      'doct_id': doctId,
      'dept_id': deptId,
      'type': type,
      'payment_status': paymentStatus,
      'fee': fee,
      'service_charge': serviceCharge,
      'total_amount': totalAmount,
      'invoice_description': invoiceDescription,
      'payment_method': paymentMethod,
      'user_id': uid,
      "is_wallet_txn":isWalletTxn,
      "coupon_id":couponId,
      "coupon_title":couponTitle,
      "coupon_value":couponValue,
      "coupon_off_amount":couponOffAmount,
      "unit_tax_amount":unitTaxAmount,
      "tax":tax,
      "unit_total_amount":unitTotalAmount,
      "source":Platform.isAndroid?"Android App":Platform.isIOS?"Ios App":""
    });
    Map body={
      "amount":totalAmount,
      "key":key,
      "secret":secret,
      "payload":payload,
      "type":"Appointment"
    };
    final res=await PostService.postReq(createOrderUrl, body);
    return res;
  }
}