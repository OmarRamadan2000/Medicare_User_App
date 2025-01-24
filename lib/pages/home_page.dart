import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/depratment_controller.dart';
import '../controller/doctors_controller.dart';
import '../controller/notification_dot_controller.dart';
import '../helpers/route_helper.dart';
import '../model/department_model.dart';
import '../model/doctors_model.dart';
import '../pages/auth/login_page.dart';
import '../pages/doctors_list_page.dart';
import '../pages/my_booking_page.dart';
import '../pages/wallet_page.dart';
import '../services/configuration_service.dart';
import '../services/notification_seen_service.dart';
import '../utilities/sharedpreference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_rating/star_rating.dart';
import '../controller/user_controller.dart';
import '../utilities/api_content.dart';
import '../utilities/colors_constant.dart';
import '../utilities/image_constants.dart';
import '../widget/drawer_widget.dart';
import '../widget/image_box_widget.dart';
import '../widget/loading_Indicator_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final DepartmentController _departmentController=Get.put(DepartmentController(),tag: "department");
  final DoctorsController _doctorsController=Get.put(DoctorsController(),tag: "doctor");
  final ScrollController _scrollController=ScrollController();
  final NotificationDotController _notificationDotController=Get.find(tag: "notification_dot");
  int _selectedIndex = 3; // Index of the initially selected item
  bool _isLoading=false;
  UserController userController=Get.find(tag: "user");
  String appStoreUrl="";
  String playStoreUrl="";
  String doctorImage="";
  String? clinicLat;
  String? clinicLng;
  String? email;
  String? phone;
  String? whatsapp;
  String? ambulancePhone;
  List boxCardItems=[
    {
      "title":"Appointment",
      "assets":ImageConstants.appointmentImageBox,
      "onClick":()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();

        final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
        final userId= preferences.getString(SharedPreferencesConstants.uid);
        if(loggedIn&&userId!=""&&userId!=null){
          Get.toNamed(RouteHelper.getMyBookingPageRoute());
        }else{
          Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getMyBookingPageRoute());}));
          // Get.toNamed(RouteHelper.getLoginPageRoute());
        }
      }
    },
    {
      "title":"Vitals",
      "assets":ImageConstants.vialImageBox,
      "onClick":()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();

        final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
        final userId= preferences.getString(SharedPreferencesConstants.uid);
        if(loggedIn&&userId!=""&&userId!=null){
          Get.toNamed(RouteHelper.getVitalsPageRoute());
        }else{
          Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getVitalsPageRoute());}));
          // Get.toNamed(RouteHelper.getLoginPageRoute());
        }
      }
    },
    {
      "title":"Prescription",
      "assets":ImageConstants.prescriptionImageBox,
      "onClick":()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();

        final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
        final userId= preferences.getString(SharedPreferencesConstants.uid);
        if(loggedIn&&userId!=""&&userId!=null){
          Get.toNamed(RouteHelper.getPrescriptionListPageRoute());
        }else{
          Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getPrescriptionListPageRoute());}));
          // Get.toNamed(RouteHelper.getLoginPageRoute());
        }
      }
    },
    {
      "title":"Profile",
      "assets":ImageConstants.profileImageBox,
      "onClick":()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();

        final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
        final userId= preferences.getString(SharedPreferencesConstants.uid);
        if(loggedIn&&userId!=""&&userId!=null){
          Get.toNamed(RouteHelper.getEditUserProfilePageRoute());
        }else{
          Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getEditUserProfilePageRoute());}));
          // Get.toNamed(RouteHelper.getLoginPageRoute());
        }
      }
    },
    {
      "title":"Family Member",
      "assets":ImageConstants.familyMemberImageBox,
      "onClick":()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();

        final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
        final userId= preferences.getString(SharedPreferencesConstants.uid);
        if(loggedIn&&userId!=""&&userId!=null){
          Get.toNamed(RouteHelper.getFamilyMemberListPageRoute());
        }else{
          Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getFamilyMemberListPageRoute());}));
          // Get.toNamed(RouteHelper.getLoginPageRoute());
        }
      }
    },
    {
      "title":"Wallet",
      "assets":ImageConstants.walletImageBox,
      "onClick":()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();

        final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
        final userId= preferences.getString(SharedPreferencesConstants.uid);
        if(loggedIn&&userId!=""&&userId!=null){
          Get.toNamed(RouteHelper.getWalletPageRoute());
        }else{
          Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getWalletPageRoute());}));
          // Get.toNamed(RouteHelper.getLoginPageRoute());
        }
      }
    },
    {
      "title":"Notification",
      "assets":ImageConstants.notificationImageBox,
      "onClick":()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();

        final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
        final userId= preferences.getString(SharedPreferencesConstants.uid);
        if(loggedIn&&userId!=""&&userId!=null){
          Get.toNamed(RouteHelper.getNotificationPageRoute());
        }else{
          Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getNotificationPageRoute());}));
          // Get.toNamed(RouteHelper.getLoginPageRoute());
        }
      }
    },
    {
      "title":"Contact Us",
      "assets":ImageConstants.contactUsImageBox,
      "onClick":()async{

       Get.toNamed(RouteHelper.getContactUsPageRoute());
      }
    },
    {
      "title":"Files",
      "assets":ImageConstants.filesImageBox,
      "onClick":()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();

        final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
        final userId= preferences.getString(SharedPreferencesConstants.uid);
        if(loggedIn&&userId!=""&&userId!=null){
          Get.toNamed(RouteHelper.getPatientFilePageRoute());
        }else{
          Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getPatientFilePageRoute());}));
          // Get.toNamed(RouteHelper.getLoginPageRoute());
        }
      }
    }
  ];
  @override
  void initState() {
    // TODO: implement initState

    userController.getData();
    _departmentController.getData();
    _doctorsController.getData("");
    getAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex==3?true:false,
      onPopInvokedWithResult: (didPop, dynamic)  {
        if (_selectedIndex == 3) {}
        else {
          setState(() {
            _selectedIndex = 3;
          });
        //  return false;
        }
      },
      child: Scaffold(
          key: _key,
          drawer:IDrawerWidget().buildDrawerWidget(userController,_notificationDotController),
        backgroundColor: ColorResources.bgColor,
          bottomNavigationBar:_isLoading?null: BottomAppBar(
            height: 80,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      final loggedIn = preferences.getBool(
                          SharedPreferencesConstants.login) ?? false;
                      final userId = preferences.getString(
                          SharedPreferencesConstants.uid);
                      if (loggedIn && userId != "" && userId != null) {
                        _onItemTapped(4);
                      } else {
                     Get.to(LoginPage(onSuccessLogin: (){  _onItemTapped(4);},));
                      }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month,
                          color: _selectedIndex == 4 ? ColorResources
                              .primaryColor : Colors.black),
                      const SizedBox(height: 3),
                      Text("Appointments",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _selectedIndex == 4 ? ColorResources
                                .primaryColor : Colors.grey
                        ),)
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _onItemTapped(2);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search,
                          color: _selectedIndex == 2 ? ColorResources
                              .primaryColor : Colors.black),
                      const SizedBox(height: 3),
                      Text("Search",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _selectedIndex == 2 ? ColorResources
                                .primaryColor : Colors.grey
                        ),)
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                // Empty space for the circular button
                GestureDetector(
                  onTap: () async {
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    final loggedIn = preferences.getBool(
                        SharedPreferencesConstants.login) ?? false;
                    final userId = preferences.getString(
                        SharedPreferencesConstants.uid);
                    if (loggedIn && userId != "" && userId != null) {
                      _onItemTapped(1);
                    } else {
                      Get.to(LoginPage(onSuccessLogin: (){  _onItemTapped(1);},));
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_balance_wallet,
                          color: _selectedIndex == 1 ? ColorResources
                              .primaryColor : Colors.black),
                      const SizedBox(height: 3),
                      Text("Wallet",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _selectedIndex == 1 ? ColorResources
                                .primaryColor : Colors.grey
                        ),)
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    _key.currentState!.openDrawer();
                    // print("open drawer");
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu,
                        color: Colors.black,
                      ),
                      SizedBox(height: 3),
                      Text("Menu",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),)
                    ],
                  ),
                )

              ],
            ),
          ),
          floatingActionButtonLocation:_isLoading?null: FloatingActionButtonLocation
              .centerDocked,
          floatingActionButton: MediaQuery
              .of(context)
              .viewInsets
              .bottom != 0 ? null : FloatingActionButton(
            backgroundColor: ColorResources.secondaryColor,
            onPressed:()=> _onItemTapped(3),
            tooltip: 'Home',
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Icon(Icons.home,
            color: Colors.white),
          ),
        body:_isLoading?const ILoadingIndicatorWidget(): _selectedIndex == 1 ? const WalletPage() : _selectedIndex == 2
            ? const DoctorsListPage(selectedDeptTitle: "",selectedDeptId: "",)
            : _selectedIndex == 4 ? const MyBookingPage() :_buildBody()
      ),
    );
  }



  _buildBody() {
    return ListView(
      controller: _scrollController,
      padding:const  EdgeInsets.all(0),
      children: [
        _buildHeaderSection(),
        checkIsShowBox()?_buildContactCard():Container(),
        _buildDepartment(),
        _buildDoctor(),
        _buildCardBox(),
        const SizedBox(height: 100)
      ],
    );
  }

  _buildCardBox(){
    return    GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 3 ),
      itemBuilder: (BuildContext context, int index) {
        return  Card(
          elevation: .1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child:  GestureDetector(
            onTap: boxCardItems[index]['onClick'],
            child: GridTile(
              footer:  Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(boxCardItems[index]['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Image.asset(boxCardItems[index]['assets']),
              ), //just for testing, will fill with image later
            ),
          ),
        );
      },
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }
  _buildDepartmentBox(List dataList) {
    return Card(
      elevation: .1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(5),
        title:   Padding(
            padding:const EdgeInsets.only(bottom: 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  const    Text("Department",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14
                    ),),
                  dataList.length<4?Container(): const Text('Swipe More >>',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14
                    ),),
                ]
            )

        ),
        subtitle:  SizedBox(
          height: 100,
          child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: dataList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                final DepartmentModel departmentModel=dataList[index];
                return  Padding(
                  padding: const EdgeInsets.fromLTRB(8,8,18,8),
                  child: GestureDetector(
                    onTap: (){
                         Get.toNamed(RouteHelper.getDoctorsListPageRoute(
                           selectedDeptId: departmentModel.id?.toString()??"",
                           selectedDeptTitle: departmentModel.title??""
                         ));
                      //   Get.toNamed(RouteHelper.getSearchProductsPageRoute(initSelectedProductCatId: productCatModel.id.toString()));
                    },
                    child: Column(
                      children: [
                        departmentModel.image == null ||
                            departmentModel.image == "" ?
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 25,
                          child: Icon(Icons.image),
                        )
                            :
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25,
                            child:
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      '${ApiContents.imageUrl}/${departmentModel.image}'
                                  ),
                                ),
                              ),
                            )
                        ),
                        const SizedBox(height: 5),
                        Text(departmentModel.title??"--",
                          maxLines: 1, // Limit to 1 line
                          overflow: TextOverflow.ellipsis,
                          style:const  TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    ),
                  ),
                );}),
        ),
      ),
    );
  }
  _buildDoctorBox(List dataList) {
    return Card(
      elevation: .1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(5),
        title:   Padding(
            padding:const EdgeInsets.only(bottom: 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  const   Text("Doctors",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14
                    ),),
                  dataList.length<3?
                  Container():
                  const  Text('Swipe More >>',
                    style:TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14
                    ),),
                ]
            )
        ),
        subtitle:   Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: SizedBox(
              height: 250,
              child:
              GridView.builder(
                  padding: const EdgeInsets.all(0),
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: dataList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: .5,
                      crossAxisCount: 2 ),
                  itemBuilder: (context,index){
                    return   _buildDoctorCard(dataList[index]);
                  })
          ),
        ),

      ),
    );
  }
  _buildDoctorCard(DoctorsModel doctorsModel) {
    return  GestureDetector(
      onTap: ()async {
        SharedPreferences preferences = await SharedPreferences.getInstance();

        final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
        final userId= preferences.getString(SharedPreferencesConstants.uid);
        if(loggedIn&&userId!=""&&userId!=null){
          Get.toNamed(RouteHelper.getDoctorsDetailsPageRoute(doctId: doctorsModel.id.toString()));
        }else{
          Get.to(()=>LoginPage(onSuccessLogin:  (){   Get.toNamed(RouteHelper.getDoctorsDetailsPageRoute(doctId: doctorsModel.id.toString()));}));
          // Get.toNamed(RouteHelper.getLoginPageRoute());
        }
     //   Get.toNamed(RouteHelper.getDoctorsListPageRoute());

      },
      child:
      SizedBox(
        width: 240,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    flex:2,
                    child: Stack(
                      children: [
                        doctorsModel.image==null|| doctorsModel.image==""?
                        const SizedBox(
                          height: 70,
                          width: 70,
                          child: Icon(Icons.person,
                              size: 40),
                        )
                            :   SizedBox(
                            height: 70,
                            width: 70,
                            child: CircleAvatar(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Adjust the radius according to your preference
                                child: ImageBoxFillWidget(
                                  imageUrl: "${ApiContents.imageUrl}/${doctorsModel.image}",
                                  boxFit: BoxFit.fill,
                                ),
                              ),
                            )
                        ),

                        const Positioned(
                          top: 5,
                          right: 0,
                          child:  CircleAvatar(backgroundColor: Colors.white,radius: 8,
                            child:CircleAvatar(backgroundColor: Colors.green,radius: 6),),
                        )
                      ],
                    )),
                const SizedBox(width: 10),
                Flexible(
                    flex:6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text("${doctorsModel.fName??"--"} ${doctorsModel.lName??"--"}",
                                maxLines: 1, // Limit to 1 line
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12
                                ),),
                            ),
                          ],
                        ),
                        const SizedBox(height:2),
                        Text(doctorsModel.specialization??"",
                          maxLines: 1, // Limit to 1 line
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: ColorResources.secondaryFontColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12
                          ),),
                         const SizedBox(height: 2),
                        Row(
                          children: [
                            StarRating(
                              mainAxisAlignment: MainAxisAlignment.center,
                              length: 5,
                              color:  doctorsModel.averageRating==0?Colors.grey:Colors.amber,
                              rating: doctorsModel.averageRating??0,
                              between: 5,
                              starSize: 15,
                              onRaitingTap: (rating) {
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text("${doctorsModel.averageRating} (${doctorsModel.numberOfReview} review)",
                          style:const TextStyle(
                              color: ColorResources.secondaryFontColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12
                          ),)
                      ],))
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildDepartment() {
    return      Obx(() {
      if (!_departmentController.isError.value) { // if no any error
        if (_departmentController.isLoading.value) {
          return const IVerticalListLongLoadingWidget();
        } else if (_departmentController.dataList.isEmpty) {
          return  Container();
        } else {
          return
            _departmentController.dataList.length==1?Container(): _buildDepartmentBox(_departmentController.dataList);
        }
      }else {
        return Container();
      } //Error svg
    }
    );
  }

  _buildDoctor() {
    return   Obx(() {
      if (!_doctorsController.isError.value) { // if no any error
        if (_doctorsController.isLoading.value) {
          return const IVerticalListLongLoadingWidget();
        } else if (_doctorsController.dataList.isEmpty) {
          return  Container();
        } else {
          return
            _doctorsController.dataList.length==1?Container():   _buildDoctorBox(_doctorsController.dataList);
        }
      }else {
        return Container();
      } //Error svg
    }
    );
  }
  _buildHeaderSection() {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.white, // Start color
            ColorResources.primaryColor,  // End color
          ],
        ),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 40),
          Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Welcome!",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24
                        ),),
                      Row(
                        children: [
                          Obx((){
                            return      !userController.isLoading.value&&  userController.usersData.value.fName!=null? Text("${userController.usersData.value.fName}",
                                              style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24
                            ),):const Text("User",
                            style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24
                            ),);
                          }),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: ()async{
                              SharedPreferences preferences = await SharedPreferences.getInstance();
                              final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ??false;
                              final userId= preferences.getString(SharedPreferencesConstants.uid);
                              if(loggedIn&&userId!=""&&userId!=null){
                                Get.toNamed(RouteHelper.getNotificationPageRoute());
                              }else{
                                Get.to(()=>LoginPage(onSuccessLogin:  (){ Get.toNamed(RouteHelper.getNotificationPageRoute());}));
                                // Get.toNamed(RouteHelper.getLoginPageRoute());
                              }
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 18,
                                  child: Icon(Icons.notifications_none,
                                    size: 25,),
                                ),
                                Obx((){
                                  return _notificationDotController.isShow.value? const Positioned(
                                    top:-5,
                                    right: -5,
                                    child: Icon(Icons.circle,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                  ):Container();
                                })


                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text("How it's going today",
                        style: TextStyle(
                          color: ColorResources.secondaryFontColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                        ),),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: (){
                            Get.toNamed(RouteHelper.getDoctorsListPageRoute(selectedDeptTitle: "", selectedDeptId: ""));
                           // HandleLocalNotification.showWithOutImageNotification("hii","hiii");
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: ColorResources.secondaryColor,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Book Appointment",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12
                              ),),
                            ),
                          ),
                        )
                    ],
                  ),
                  doctorImage==""?Container():
                  Flexible(
                    child: SizedBox(
                        height:  300,
                        width: 200,
                        child: ImageBoxFillWidget(imageUrl: "${ApiContents.imageUrl}/$doctorImage")),
                  )
                ],
              ),

          )
        ],
      )
    );
  }
  void _requestNotificationPermission() {
    //HandleLocalNotification.showWithOutImageNotification("ssss","slsls");
    if (Platform.isAndroid) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      // HandleLocalNotification.showWithOutImageNotification("hii", "ddd",);
    } else if (Platform.isIOS) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void getAndSetData() async{
    setState(() {
      _isLoading=true;
    });
    final res=await NotificationSeenService.getDataById();
    if(res!=null){
      if(res.dotStatus==true){
        _notificationDotController.setDotStatus(true);
      }
    }
    final doctorImageSetting=await ConfigurationService.getDataById(idName:"ma_doctor_image" );
    if(doctorImageSetting!=null){
      doctorImage=doctorImageSetting.value??"";
      if (kDebugMode) {
        print("Doctor Image  ${doctorImageSetting.value}");
      }}

    if(Platform.isAndroid){
      final webSetting=await ConfigurationService.getDataById(idName:"play_store_link" );

      if(webSetting!=null){
        playStoreUrl=webSetting.value??"";
        if (kDebugMode) {
          print("Play store Url ${webSetting.value}");
        }}
      final  issueSetting=await ConfigurationService.getDataById(idName: "android_technical_issue_enable");
      if(issueSetting!=null) {
        if (issueSetting.value == "true") {
          _openDialogIssueBox();
        } else {
          final  updateBox=await ConfigurationService.getDataById(idName: "android_update_box_enable");
          if(updateBox!=null){
            if(updateBox.value=="true"){
              final  versionSetting=await ConfigurationService.getDataById(idName: "android_android_app_version");
              if(versionSetting!=null){
                PackageInfo.fromPlatform().then((PackageInfo packageInfo)async {
                  String version = packageInfo.version;
                  if (kDebugMode) {
                    print("Version $version");
                    print("setting version ${versionSetting.value}");
                  }
                  if(version.toString()!=versionSetting.value.toString()){
                    final  forceUpdateSetting=await ConfigurationService.getDataById(idName: "android_force_update_box_enable");
                    if(forceUpdateSetting!=null){
                      if(forceUpdateSetting.value=="true"){
                        _openDialogSettingBox(false);
                      }else{
                        _openDialogSettingBox(true);
                      }
                    }
                  }
                }
                );
              }
            }

          }

        }
      }

    }else if(Platform.isIOS){
      final webSetting=await ConfigurationService.getDataById(idName: "app_store_link");

      if(webSetting!=null){
        appStoreUrl=webSetting.value??"";
        if (kDebugMode) {
          print("app store Url ${webSetting.value}");
        }}
      final  issueSetting=await ConfigurationService.getDataById(idName: "ios_technical_issue_enable");
      if(issueSetting!=null) {
        if (issueSetting.value == "true") {
          _openDialogIssueBox();
        } else {
          final  updateBox=await ConfigurationService.getDataById(idName: "ios_update_box_enable");
          if(updateBox!=null){
            if(updateBox.value=="true"){
              final  versionSetting=await ConfigurationService.getDataById(idName: "ios_app_version");
              if(versionSetting!=null){
                PackageInfo.fromPlatform().then((PackageInfo packageInfo)async {
                  String version = packageInfo.version;
                  if (kDebugMode) {
                    print("Version Ios $version");
                    print("setting version Ios ${versionSetting.value}");
                  }
                  if(version.toString()!=versionSetting.value.toString()){
                    final  forceUpdateSetting=await ConfigurationService.getDataById(idName: "ios_force_update_box_enable");
                    if(forceUpdateSetting!=null){
                      if(forceUpdateSetting.value=="true"){
                        _openDialogSettingBox(false);
                      }else{
                        _openDialogSettingBox(true);
                      }
                    }
                  }
                }
                );

              }
            }

          }
        }
      }

    }
    final configRes=await ConfigurationService.getDataByGroupName("Basic");
    if(configRes!=null) {
      for (var e in configRes) {
        if (e.idName == "clinic_location_latitude") {
          clinicLat = e.value;
        }
        if (e.idName == "clinic_location_longitude") {
          clinicLng = e.value;
        }
        if (e.idName == "whatsapp") {
          whatsapp = e.value;
        }
        if (e.idName == "phone") {
          phone = e.value;
        }
        if (e.idName == "email") {
          email = e.value;
        }
        if (e.idName == "ambulance_phone") {
          ambulancePhone = e.value;
        }
      }
    }
    _requestNotificationPermission();
    setState(() {
      _isLoading=false;
    });}
  _openDialogSettingBox(bool isCancel) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return PopScope(
            canPop: isCancel,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text("Update",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              ),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isCancel
                    ? "New version is available, please update the app"
                    : "Sorry we are currently not supporting the old version of the app please update with new version",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    )),
                const SizedBox(height: 10),

              ],
            ),
            actions: <Widget>[
              isCancel ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.greyBtnColor,
                  ),
                  child: const Text("Cancel",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }) : Container(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.greenFontColor,
                  ),
                  child: const Text("Update",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    ),),
                  onPressed: () async {
                    // Navigator.of(context).pop();
                    if (Platform.isAndroid) {
                      if (playStoreUrl != "") {
                        try {
                          await launchUrl(Uri.parse(playStoreUrl),
                              mode: LaunchMode.externalApplication);
                        }
                        catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      }
                    } else if (Platform.isIOS) {
                      if (appStoreUrl != "") {
                        try {
                          await launchUrl(Uri.parse(appStoreUrl),
                              mode: LaunchMode.externalApplication);
                        }
                        catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      }
                    }
                  }),
              // usually buttons at the bottom of the dialog
            ],
          ),
        );
      },
    );
  }
  _openDialogIssueBox() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text("Sorry!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              ),),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "We are facing some technical issues. our team trying to solve problems. hope we will come back very soon.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    )),
                SizedBox(height: 10),

              ],
            ),
          ),
        );
      },
    );
  }
  _buildContactCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      color: ColorResources.cardBgColor,
      elevation: .1,
      child: ListTile(
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              phone==null||phone==""?Container(): _buildTapBox(ImageConstants.telephoneImageBox, "Call",()async{
                if(phone!=null&&phone!=""){
                  await launchUrl(Uri.parse("tel:$phone"));
                }
              }),
              whatsapp==null||whatsapp==""?Container():   Padding(padding: const EdgeInsets.only(left: 20),
              child:      _buildTapBox(ImageConstants.whatsappImageBox, "Whatsapp",()async{
                if(whatsapp!=null&&whatsapp!=""){
                  final url = "https://wa.me/$whatsapp?text=Hello"; //remember country code
                  await launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication
                  );
                }

              })
              ),

              email==null||email==""?Container():   Padding(padding: const EdgeInsets.only(left: 20),
                child:  _buildTapBox(ImageConstants.emailImageBox, "Email",()async{
                  if(email!=null&&email!=""){
                    await launchUrl(Uri.parse("mailto:$email"));
                  }

                }),
              ),

              clinicLng==null||clinicLng==""||clinicLat==null||clinicLat==""?Container():  Padding(padding: const EdgeInsets.only(left: 20),
                child:     _buildTapBox(ImageConstants.mapPlaceImageBox, "Map",()async{
                  if(clinicLng!=null&&clinicLng!=""&&clinicLat!=null&&clinicLat!=""){
                    final url="http://maps.google.com/maps?daddr=$clinicLat,$clinicLng";
                    try{
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    }catch(e){
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  }

                }),
              ),
              ambulancePhone==null||ambulancePhone==""?Container():   Flexible(
                child: Padding(padding: const EdgeInsets.only(left: 20),
                  child: _buildTapBox(ImageConstants.ambulanceImageBox, "Ambulance",()async{
                    if(ambulancePhone!=null&&ambulancePhone!=""){
                      await launchUrl(Uri.parse("tel:$ambulancePhone"));
                    }
                
                  }), 
                ),
              )


            ],
          ),
        ),
        title: const Text("Contact US",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500
          ),),
      ),
    );
  }
  _buildTapBox(String imageAsset, String title,GestureTapCallback onTap) {
    return GestureDetector(
      onTap:onTap ,
      child: Column(
        children: [
          SizedBox(
              height: 30,
              child: Image.asset(imageAsset)),
          const SizedBox(height: 5),
          Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12
            ),)
        ],
      ),
    );
  }

  bool checkIsShowBox() {
    if(clinicLng==null&&clinicLat==null&&phone==null&&email==null&&whatsapp==null&&ambulancePhone==null){
      return false;
    }else{return true;}
  }
}
