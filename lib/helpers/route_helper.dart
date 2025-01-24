import 'package:get/get.dart';
import 'package:userapp/pages/patient_file_page.dart';
import '../pages/appointment_details_page.dart';
import '../pages/contact_us_page.dart';
import '../pages/doctors_details_page.dart';
import '../pages/doctors_list_page.dart';
import '../pages/edit_profile_page.dart';
import '../pages/family_member_list_page.dart';
import '../pages/home_page.dart';
import '../pages/my_booking_page.dart';
import '../pages/notification_details_page.dart';
import '../pages/notification_page.dart';
import '../pages/prescription_list_page.dart';
import '../pages/share_page.dart';
import '../pages/testimonial_page.dart';
import '../pages/vital_details_page.dart';
import '../pages/vitals_page.dart';
import '../pages/wallet_page.dart';
import '../pages/web_pages/about_us_page.dart';
import '../pages/web_pages/privacy_page.dart';
import '../pages/web_pages/term_cond_page.dart';

class RouteHelper {
  //Auth pages

  //Home page
  static const String homePage = '/HomePage';

  //Others pages
  static const String loginPage = '/LoginPage';
  static const String doctorsListPage = '/DoctorsListPage';
  static const String doctorsDetailsPage = '/DoctorsDetailsPage';
  // static const String patientListPage = '/PatientListPage';
  static const String myBookingPage = '/MyBookingPage';
  static const String appointmentDetailsPagePage = '/AppointmentDetailsPage';
  static const String walletPage = '/WalletPage';
  static const String familyMemberListPage = '/FamilyMemberListPage';
  static const String editUserProfilePage = '/EditUserProfilePage';
  static const String aboutUsPagePage = '/AboutUsPage';
  static const String privacyPage = '/PrivacyPage';
  static const String termCondPage = '/TermCondPage';
  static const String testimonialPage = '/TestimonialPage';
  static const String shareAppPage = '/ShareAppPage';
  static const String contactUsPage = '/ContactUsPage';
  static const String notificationPage = '/NotificationPage';
  static const String notificationDetailsPage = '/NotificationDetailsPage';
  static const String vitalsPage = '/VitalsPage';
  static const String vitalsDetailsPage = '/VitalsDetailsPage';
  static const String prescriptionListPage = '/PrescriptionListPage';
  static const String patientFilePage = '/PatientFilePage';



  //---------------------------------------------------------------//

  static String getHomePageRoute() => homePage;
  static String getLoginPageRoute() => loginPage;
  static String getDoctorsListPageRoute({
    required String selectedDeptTitle,
    required String selectedDeptId
  }) => "$doctorsListPage?selectedDeptTitle=$selectedDeptTitle&selectedDeptId=$selectedDeptId";
  static String getDoctorsDetailsPageRoute({required String doctId}) => "$doctorsDetailsPage?doctId=$doctId";
  static String getEditUserProfilePageRoute() => editUserProfilePage;
  static String getContactUsPageRoute() => contactUsPage;
  static String getPatientFilePageRoute() => patientFilePage;
  // static String getPatientListPageRoute() => patientListPage;

  static String getMyBookingPageRoute() => myBookingPage;
  static String getAppointmentDetailsPageRoute({required String appId}) => "$appointmentDetailsPagePage?appId=$appId";

  static String getVitalsPageRoute() => vitalsPage;

  static String getShareAppPageRoute() => shareAppPage;
  static String getWalletPageRoute() => walletPage;
  static String getAboutUsPageRoute() => aboutUsPagePage;
  static String getPrivacyPagePageRoute() => privacyPage;
  static String getTermCondPageRoute() => termCondPage;

  static String getFamilyMemberListPageRoute() => familyMemberListPage;
  static String getTestimonialPageRoute() => testimonialPage;
  static String getNotificationPageRoute() => notificationPage;
  static String getNotificationDetailsPageRoute({
    required String? notificationId,
  }) => "$notificationDetailsPage?notificationId=$notificationId";
  static String getVitalsDetailsPageRoute({
    required String? notificationId,
  }) => "$vitalsDetailsPage?vitalName=$notificationId";
  static String getPrescriptionListPageRoute() => prescriptionListPage;


  //---------------------------------------------------------------//

  static List<GetPage> routes = [
    //Home Page

    GetPage(name: homePage, page: () => const HomePage()),

    GetPage(name: editUserProfilePage, page: () => const EditProfilePage()),
    GetPage(name: doctorsListPage, page: () =>  DoctorsListPage(
      selectedDeptId:  Get.parameters['selectedDeptId'],
      selectedDeptTitle:  Get.parameters['selectedDeptTitle']
    )),
    GetPage(name: doctorsDetailsPage, page: () =>  DoctorsDetailsPage(
      doctId: Get.parameters['doctId'],
    )),

    // GetPage(name: patientListPage, page: () => const PatientListPage()),

    GetPage(name: myBookingPage, page: () => const MyBookingPage()),
    GetPage(name: appointmentDetailsPagePage, page: () =>  AppointmentDetailsPage(
      appId: Get.parameters['appId'],
    )),

    GetPage(name: walletPage, page: () => const WalletPage()),

    GetPage(name: contactUsPage, page: () => const ContactUsPage()),

    GetPage(name: familyMemberListPage, page: () => const FamilyMemberListPage()),
    GetPage(name: aboutUsPagePage, page: () => const AboutUsPage()),
    GetPage(name: privacyPage, page: () => const PrivacyPage()),
    GetPage(name: termCondPage, page: () => const TermCondPage()),
    GetPage(name: testimonialPage, page: () => const TestimonialPage()),
    GetPage(name: shareAppPage, page: () => const ShareAppPage()),
    GetPage(name: notificationPage, page: () => const NotificationPage()),
    GetPage(name: notificationDetailsPage, page: () =>  NotificationDetailsPage(notificationId: Get.parameters['notificationId'] )),
    GetPage(name: vitalsPage, page: () =>  const VitalsPage()),
    GetPage(name: vitalsDetailsPage, page: () =>  VitalsDetailsPage(
      vitalName: Get.parameters['vitalName'],
    )),
    GetPage(name: prescriptionListPage, page: () =>  const PrescriptionListPage()),
    GetPage(name: patientFilePage, page: () =>  const PatientFilePage()),

  ];




}