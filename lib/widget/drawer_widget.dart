import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/services/user_service.dart';
import 'package:userapp/services/user_subscription.dart';
import '../controller/user_controller.dart';
import '../helpers/version_control.dart';
import '../pages/auth/login_page.dart';
import 'package:get/get.dart';
import '../utilities/api_content.dart';
import '../utilities/image_constants.dart';
import '../widget/toast_message.dart';
import '../controller/notification_dot_controller.dart';
import '../helpers/date_time_helper.dart';
import '../helpers/route_helper.dart';
import '../utilities/colors_constant.dart';
import '../utilities/sharedpreference_constants.dart';
import 'image_box_widget.dart';

class IDrawerWidget{

   buildDrawerWidget( UserController userController,NotificationDotController notificationDotController){
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const SizedBox(height: 40),
         _buildProfileSection(userController),
          const SizedBox(height: 10),
          _buildCardBox("Profile",Icons.person,()async{
            Get.back();
            SharedPreferences preferences = await SharedPreferences.getInstance();
            final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
            final userId= preferences.getString(SharedPreferencesConstants.uid);
            if(loggedIn&&userId!=""&&userId!=null){
              Get.toNamed(RouteHelper.getEditUserProfilePageRoute());
            }else{
              Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getEditUserProfilePageRoute());}));
            }

          }),
          _buildCardBox("Family Members",Icons.people,()async{
            Get.back();
            SharedPreferences preferences = await SharedPreferences.getInstance();

            final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
            final userId= preferences.getString(SharedPreferencesConstants.uid);
            if(loggedIn&&userId!=""&&userId!=null){
              Get.toNamed(RouteHelper.getFamilyMemberListPageRoute());
            }else{
              Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getFamilyMemberListPageRoute());}));
            }

          }),

          _buildCardBox("My Appointment",Icons.history,()async{
            Get.back();
            SharedPreferences preferences = await SharedPreferences.getInstance();

            final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
            final userId= preferences.getString(SharedPreferencesConstants.uid);
            if(loggedIn&&userId!=""&&userId!=null){
              Get.toNamed(RouteHelper.getMyBookingPageRoute());
            }else{
              Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getMyBookingPageRoute());}));
            }
          }),
          _buildCardBox("Vitals",Icons.bloodtype_outlined,()async{
            Get.back();
            SharedPreferences preferences = await SharedPreferences.getInstance();

            final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
            final userId= preferences.getString(SharedPreferencesConstants.uid);
            if(loggedIn&&userId!=""&&userId!=null){
              Get.toNamed(RouteHelper.getVitalsPageRoute());
            }else{
              Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getVitalsPageRoute());}));
            }

          }),
          _buildCardBox("Prescription",Icons.file_copy,()async{
            Get.back();
            SharedPreferences preferences = await SharedPreferences.getInstance();

            final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
            final userId= preferences.getString(SharedPreferencesConstants.uid);
            if(loggedIn&&userId!=""&&userId!=null){
              Get.toNamed(RouteHelper.getPrescriptionListPageRoute());
            }else{
              Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getPrescriptionListPageRoute());}));
            }

          }),
          _buildCardBox("Files",Icons.file_copy,()async{
            Get.back();
            SharedPreferences preferences = await SharedPreferences.getInstance();

            final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
            final userId= preferences.getString(SharedPreferencesConstants.uid);
            if(loggedIn&&userId!=""&&userId!=null){
              Get.toNamed(RouteHelper.getPatientFilePageRoute());
            }else{
              Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getPatientFilePageRoute());}));
            }

          }),

          _buildNotificationCardBox(notificationDotController,"Notification",Icons.notifications,()async{
            Get.back();
            SharedPreferences preferences = await SharedPreferences.getInstance();
            final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
            final userId= preferences.getString(SharedPreferencesConstants.uid);
            if(loggedIn&&userId!=""&&userId!=null){
              Get.toNamed(RouteHelper.getNotificationPageRoute());
            }else{
              Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getNotificationPageRoute());}));
            }


          }),

          _buildCardBox("Wallet",Icons.wallet,()async{
            Get.back();
            SharedPreferences preferences = await SharedPreferences.getInstance();
            final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
            final userId= preferences.getString(SharedPreferencesConstants.uid);
            if(loggedIn&&userId!=""&&userId!=null){
              Get.toNamed(RouteHelper.getWalletPageRoute());
            }else{
              Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getWalletPageRoute());}));

            }


          }),
          _buildCardBox("Contact Us",Icons.support_agent,(){
            Get.back();
               Get.toNamed(RouteHelper.getContactUsPageRoute());
          
          }),
          _buildCardBox("Share",Icons.share,(){
            Get.back();
              Get.toNamed(RouteHelper.getShareAppPageRoute());
          }),
          const Divider(),
          _buildCardBox("Testimonials",Icons.book,(){
            Get.back();
             Get.toNamed(RouteHelper.getTestimonialPageRoute());
          }),
          const Divider(),
          _buildCardBox("About Us",Icons.info,(){
            Get.back();
               Get.toNamed(RouteHelper.getAboutUsPageRoute());
          }),
          _buildCardBox("Privacy Policy",Icons.link,()async{
            Get.back();
           Get.toNamed(RouteHelper.getPrivacyPagePageRoute());
          }),
          _buildCardBox("Terms & Condition",Icons.link,()async {
            Get.back();
           Get.toNamed(RouteHelper.getTermCondPageRoute());
          }),
          const Divider(),
          _buildCardBox("Logout",Icons.power_settings_new,()async{
           final res= await UserService.logOutUser();
           if(res!=null){
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


          }),
           Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder(
                future: VersionControl.getVersionName(),
              builder: (context, snapshot) {
                return Text("Version - ${snapshot.data}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),);
              }
            ),
          )
        ],
      ),
    );
  }

  static _buildProfileSection(UserController userController) {
    return Obx(() {
      if (!userController.isError.value) { // if no any error
        if (userController.isLoading.value) {
          return const Text("--");
        } else {
          return  SizedBox(
            height: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: ClipOval(
                        child:
                        userController.usersData.value.imageUrl==null||userController.usersData.value.imageUrl==""?
                        const Icon(Icons.person,
                        size: 50,):
                        ImageBoxFillWidget(imageUrl:"${ApiContents.imageUrl}/${userController.usersData.value.imageUrl}") ),
                    ),
                    Row(
                        children:[
                          Image.asset(ImageConstants.crownImage,
                              width: 40,
                              height: 20),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: ColorResources.containerBgColor,
                            child:  const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text("Member",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                                ),),
                            ),
                          )
                        ]

                    )
                  ],
                ),
                const SizedBox(height: 20),
                 Text("Hello, ${userController.usersData.value.fName??"--"}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),),
                 Text("Membership since ${DateTimeHelper.getDataFormat(userController.usersData.value.createdAt)}",
                  style:const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                  ),),

              ],
            ),
          );
        }
      }else {
        return Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,0),
            child:  ListTile(
              onTap:()async {
                Get.back();
                SharedPreferences preferences = await SharedPreferences.getInstance();
                final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
                final userId= preferences.getString(SharedPreferencesConstants.uid);
                if(loggedIn&&userId!=""&&userId!=null){
                  Get.toNamed(RouteHelper.getEditUserProfilePageRoute());
                }else{
                  Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getEditUserProfilePageRoute());}));
                }
              },
              leading: const Icon(Icons.person),
              title:   const  Text("Login/Signup",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),),
            )

        );
      } //Error svg
    }
    );
  }

  static _buildCardBox(String title,IconData icon,onPressed,[selected]) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration:  BoxDecoration(
          color:selected??false?ColorResources.primaryColor:null,
          borderRadius: const BorderRadius.all(
              Radius.circular(5.0) //                 <--- border radius here
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 8, 20),
          child: Row(
            children: [
                Icon(icon,size: 20,
                color: selected??false?Colors.white:Colors.grey,),
              const SizedBox(width:20),
              Text(title,
              style:  TextStyle(
                color: selected??false?Colors.white:Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 14
              ),),
            ],
          ),
        ),
      ),
    );
  }

   static _buildNotificationCardBox(NotificationDotController notificationDotController,String title,IconData icon,onPressed,[selected]) {
     return GestureDetector(
       onTap: onPressed,
       child: Container(
         decoration:  BoxDecoration(
           color:selected??false?ColorResources.primaryColor:null,
           borderRadius: const BorderRadius.all(
               Radius.circular(5.0) //                 <--- border radius here
           ),
         ),

         child: Padding(
           padding: const EdgeInsets.fromLTRB(20, 20, 8, 20),
           child: Row(
             children: [
               Stack(
                 children: [
                   Icon(icon,size: 20,
                     color: selected??false?Colors.white:Colors.grey,),
                Obx((){
                  return  notificationDotController.isShow.value?  const Icon(
                    Icons.circle,
                    size: 10,
                    color: Colors.red,
                  ):Container();
                })
                 ],
               ),
               const SizedBox(width:20),
               Text(title,
                 style:  TextStyle(
                     color: selected??false?Colors.white:Colors.black,
                     fontWeight: FontWeight.w400,
                     fontSize: 14
                 ),),
             ],
           ),
         ),
       ),
     );
   }



}