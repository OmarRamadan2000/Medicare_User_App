import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/appointment_controller.dart';
import '../model/appointment_model.dart';
import '../widget/loading_Indicator_widget.dart';
import '../helpers/route_helper.dart';
import '../utilities/colors_constant.dart';
import '../widget/error_widget.dart';
import '../widget/no_data_widgets.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {

  String  serviceName ="Offline";
  AppointmentController appointmentController =Get.put(AppointmentController());

  @override
  void initState() {
    // TODO: implement initState
    appointmentController.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:ColorResources.bgColor,
        //Color(0xFFF7F8FA),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 0,
          backgroundColor:ColorResources.appBarColor ,
          title: const Text("My Booking",
            style:  TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400
            ),),
          bottom: const TabBar(
            indicatorWeight: 3,
            indicatorColor: ColorResources.primaryColor,
            labelPadding: EdgeInsets.all(8),
            tabs: [
              Text(
                "Upcoming",
                style:  TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                ),
              ),
              Text(
                "Closed",
                style:  TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                ),
              ),
            ],
          ),
        ),
        body:
        Obx(() {
          if (!appointmentController.isError.value) { // if no any error
            if (appointmentController.isLoading.value) {
              return const IVerticalListLongLoadingWidget();
            } else if (appointmentController.dataList.isEmpty) {
              return const NoDataWidget();
            }
            else {
              return
              TabBarView(
                children: [
                  _upcomingAppointmentList(appointmentController.dataList),
                  _pastAppointmentList(appointmentController.dataList)
                ],
              );

            }
          }else {
            return  const IErrorWidget();
          } //Error svg
        }
        )
      ),
    );
  }

  _upcomingAppointmentList(List dataList) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return dataList[index].status=="Pending"||dataList[index].status=="Confirmed"||dataList[index].status=="Rescheduled"?
          _card( dataList[index]):Container();
        });
  }

  _pastAppointmentList(List dataList) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return dataList[index].status=="Completed"||dataList[index].status=="Visited"||dataList[index].status=="Rejected"||dataList[index].status=="Cancelled"? _card( dataList[index]):Container();//_card( true);
        });
  }
  Widget _card(AppointmentModel appointmentModel) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: GestureDetector(
        onTap: () async{
         Get.toNamed(RouteHelper.getAppointmentDetailsPageRoute(appId:appointmentModel.id.toString() ));
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Card(
            color:ColorResources.cardBgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: .1,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _appointmentDate(appointmentModel.date),
                    Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children:  [
                             const Text("Name: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  )),
                              Text(
                                  "${appointmentModel.pFName??""} ${appointmentModel.pLName??""} #${appointmentModel.id}" ,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                          Row(
                            children:  [
                              const  Text("Time: ",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans-Regular',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  )),
                              Text(appointmentModel.timeSlot??"",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      height: 1, color: Colors.grey[300])),
                              Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: appointmentModel.status ==
                                      "Pending"
                                      ? _statusIndicator(Colors.yellowAccent)
                                      : appointmentModel.status ==
                                      "Rescheduled"
                                      ? _statusIndicator(Colors.orangeAccent)
                                      : appointmentModel.status ==
                                      "Rejected"
                                      ? _statusIndicator(Colors.red)
                                      : appointmentModel.status ==
                                      "Confirmed"
                                      ? _statusIndicator(Colors.green)
                                      : appointmentModel.status ==
                                      "Completed"
                                      ? _statusIndicator(Colors.green)
                                      :appointmentModel.status ==
                                      "Cancelled"
                                      ? _statusIndicator(Colors.red)
                                      :appointmentModel.status ==
                                      "Visited"
                                      ? _statusIndicator(Colors.green)
                                      :null),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                                child: Text(
                                  appointmentModel.status??"--",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  [
                                     Text(
                                        appointmentModel.type??"--",
                                        style: const TextStyle(
                                          color: ColorResources.secondaryFontColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        )),
                                     Text("Doctor ${appointmentModel.doctFName??"--"} ${appointmentModel.doctLName??"--"}",
                                        style: const TextStyle(
                                          color: ColorResources.secondaryFontColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        )),
                                    Text(
                                        appointmentModel.departmentTitle??"--",
                                        style: const TextStyle(
                                          color: ColorResources.secondaryFontColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        )),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorResources.btnColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5.0)),
                                  ),
                                  child:const  Center(
                                      child: Text("Rebook",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ))),
                                  onPressed: () {
                                    if(appointmentModel.doctorId!=null){
                                      Get.toNamed(RouteHelper.getDoctorsDetailsPageRoute(doctId: appointmentModel.doctorId!.toString()));
                                    }
                               //   Get.toNamed(RouteHelper.getBookingDetailsPageRoute());

                                  })
                              //:Container(),
                            ],
                          ),
                          //  const Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     Text("Token A - 12",
                          //       style: TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           color: ColorResources.primaryColor),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _appointmentDate(date) {
  //  print(date);
    var appointmentDate = date.split("-");
    String appointmentMonth="";
    switch (int.parse(appointmentDate[1])) {
      case 1:
        appointmentMonth = "JAN";
        break;
      case 2:
        appointmentMonth = "FEB";
        break;
      case 3:
        appointmentMonth = "MARCH";
        break;
      case 4:
        appointmentMonth = "APRIL";
        break;
      case 5:
        appointmentMonth = "MAY";
        break;
      case 6:
        appointmentMonth = "JUN";
        break;
      case 7:
        appointmentMonth = "JULY";
        break;
      case 8:
        appointmentMonth = "AUG";
        break;
      case 9:
        appointmentMonth = "SEP";
        break;
      case 10:
        appointmentMonth = "OCT";
        break;
      case 11:
        appointmentMonth = "NOV";
        break;
      case 12:
        appointmentMonth = "DEC";
        break;
    }

    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(appointmentMonth,
            style: const TextStyle(
           fontWeight: FontWeight.w600,
              fontSize: 15,
            )),
        Text(appointmentDate[2],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: ColorResources.primaryColor,
              fontSize: 35,
            )),
        Text(appointmentDate[0],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            )),
      ],
    );
  }

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 4, backgroundColor: color);
  }
}
