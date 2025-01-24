import '../model/invoice_model.dart';
import '../helpers/get_req_helper.dart';
import '../utilities/api_content.dart';

class InvoiceService{
  static const  getUrl=   ApiContents.getInvoiceByAppIdUrl;

  static List<InvoiceModel> dataFromJson (jsonDecodedData){

    return List<InvoiceModel>.from(jsonDecodedData.map((item)=>InvoiceModel.fromJson(item)));
  }

  static Future <InvoiceModel?> getDataByAppId({required String? appId})async {
    final res=await GetService.getReq("$getUrl/${appId??""}");
    if(res==null) {
      return null;
    } else {
      InvoiceModel dataModel = InvoiceModel.fromJson(res);
      return dataModel;
    }
  }
}