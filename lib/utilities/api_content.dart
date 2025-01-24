class ApiContents{

 // static const webApiUr="http://192.168.1.38:8000" for localhost;
  static const webApiUrl="API_BASE_URL";
  //API_BASE_URL
  static const baseApiUrl="$webApiUrl/api/v1";
  static const imageUrl="$webApiUrl/public/storage";
  static const prescriptionUrl="$baseApiUrl/prescription/generatePDF";
  static const invoiceUrl="$baseApiUrl/invoice/generatePDF";
  //Doctors
  static const getDoctorsUrl="$baseApiUrl/get_doctor";
  static const getDoctorsActiveUrl="$baseApiUrl/get_active_doctor";

  //Review
  static const addDoctorsReviewUrl="$baseApiUrl/add_doctor_review";
  static const getDoctorReviewUrl="$baseApiUrl/get_doctor_review/doctor";

  //Time Slots
  static const getTimeSlotsUrl="$baseApiUrl/get_doctor_time_interval";
  static const getVideoTimeSlotsUrl="$baseApiUrl/get_doctor_video_time_interval";
  static const getBookedTimeSlotsUrl="$baseApiUrl/get_booked_time_slots";


  //Patients
  static const getPatientsByUIDUrl="$baseApiUrl/get_patients/user";
  static const addPatientsUrl="$baseApiUrl/add_patient";



  //Appointment
  static const addAppUrl="$baseApiUrl/add_appointment";
  static const getAppByUIDUrl="$baseApiUrl/get_appointment/user";
  static const getAppByIDUrl="$baseApiUrl/get_appointment";


  //Appointment Cancellation
  static const appointmentCancellationUrl="$baseApiUrl/appointment_cancellation";
  static const deleteAppointmentCancellationUrl="$baseApiUrl/delete_appointment_cancellation";
  static const getAppointmentCancellationUrlByAppId="$baseApiUrl/get_appointment_cancel_req/appointment";

  //Invoice
  static const getInvoiceByAppIdUrl="$baseApiUrl/get_invoice/appointment";

  //Department
  static const getDepartmentUrl="$baseApiUrl/get_department_active";


  //Transaction
  static const getWalletByUidUrl="$baseApiUrl/get_wallet_txn/user";
  static const addWalletMoneyUrl="$baseApiUrl/add_wallet_money";


  //Prescription
  static const getPrescriptionByAppointmentUrl="$baseApiUrl/get_prescription/appointment";
  static const getPrescriptionByUserUrl="$baseApiUrl/get_prescription/user";

  //Family Member
  static const getFamilyMembersByUIDUrl="$baseApiUrl/get_family_members/user";
  static const addFamilyMemberUrl="$baseApiUrl/add_family_member";
  static const deleteFamilyMemberUrl="$baseApiUrl/delete_family_member";
  static const updateFamilyMemberUrl="$baseApiUrl/update_family_member";

  //Loginscreen
  static const getLoginImageUrl="$baseApiUrl/get_login_screen_images";

  //User
  static const getUserUrl="$baseApiUrl/get_user";
  static const addUserUrl="$baseApiUrl/add_user";
  static const updateUserUrl="$baseApiUrl/update_user";
  static const useSoftDeleteUrl="$baseApiUrl/user_soft_delete";

  //Login
  static const loginPhoneUrl="$baseApiUrl/login_phone";
  static const loginOutUrl="$baseApiUrl/logout";

  //WebPage
  static const getWebApiUrl="$baseApiUrl/get_web_page/page";

  //Testimonial
  static const getTestimonialApiUrl="$baseApiUrl/get_testimonial";

  //configurations
  static const getConfigByIdNameApiUrl="$baseApiUrl/get_configurations/id_name";
  static const getConfigByGroupNameApiUrl="$baseApiUrl/get_configurations/group_name";

  //SocialMedia
  static const getSocialMediaApiUrl="$baseApiUrl/get_social_media";

  //Notification
  static const getNotifyByDateUrl="$baseApiUrl/get_user_notification/date";
  static const getUserNotificationUrl="$baseApiUrl/get_user_notification";

  //Notification Seen
  static const usersNotificationSeenStatusUrl="$baseApiUrl/users_notification_seen_status";

  //Vitals
  static const getVitalsByFamilyID="$baseApiUrl/get_vitals_family_member_id_type";
  static const addVitalsId="$baseApiUrl/add_vitals";
  static const deleteVitalsUrl="$baseApiUrl/delete_vitals";
  static const updateVitalsUrl="$baseApiUrl/update_vitals";

  //Coupon
  static const getValidateUrl="$baseApiUrl/get_validate";

  //Checkin
  static const getAppointmentCheckInUserUrl="$baseApiUrl/get_appointment_check_in_doct_date";

  //Razorpay
  static const createRzOrderUrl="$baseApiUrl/create_rz_order";

  //Payment Getaway
  static const getPaymentGatewayActiveUrl="$baseApiUrl/get_payment_gateway_active";

  //Stripe
  static const createStripeIntentUrl="$baseApiUrl/create_intent";

  //Files
  static const getPatientFileQrl="$baseApiUrl/get_patient_file_q/user";
  static const getPatientFileByIdrl="$baseApiUrl/get_patient_file";
  static const getPatientFileByPatientIUrl="$baseApiUrl/get_patient_file/patient";


}