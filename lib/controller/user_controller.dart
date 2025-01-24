import 'package:get/get.dart';
import '../model/user_model.dart';
import '../services/user_service.dart';

class UserController extends GetxController{
  var isLoading=false.obs; //Loading for data fetching
  var usersData= UserModel().obs; //Object of blog post model
  var isError=false.obs;

  void getData()async{
  isLoading(true);
  try{
  final getDataList=await UserService.getDataById(); //Get all blog post list details from the blog post service page
  if (getDataList!=null) {
    isError(false);
  usersData.value=getDataList;
  } else {
  isError(true);
  } // If its error
  }
  catch(e){
  isError(true);  // If its error
  }
  finally{
  isLoading(false); // Run try block with error ot without error
  }

  }
}
