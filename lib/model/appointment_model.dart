class AppointmentModel{
  int? id;
  int? patientId;
  String? pFName;
  String? pLName;
  int? userId;
  String? departmentTitle;
  String? status;
  String? date;
  String? timeSlot;
  int? doctorId;
  int? departmentId;
  String? type;
  String? meetingId;
  String? meetingLink;
  String? doctFName;
  String? doctLName;
  String? doctImage;
  String? doctSpecialization;
  String? currentCancelReqStatus;
  double? averageRating;
  int? numberOfReview;
  int? totalAppointmentDone;
  AppointmentModel({
    this.id,
    this.meetingId,
    this.date,
    this.departmentId,
    this.departmentTitle,
    this.doctorId,
    this.meetingLink,
    this.patientId,
    this.pFName,
    this.pLName,
    this.status,
    this.timeSlot,
    this.type,
    this.userId,
    this.doctFName,
    this.doctLName,
    this.doctImage,
    this.doctSpecialization,
    this.currentCancelReqStatus,
    this.averageRating,
    this.numberOfReview,
    this.totalAppointmentDone
  });

  factory AppointmentModel.fromJson(Map<String,dynamic> json){
    return AppointmentModel(
      id: json['id'],
      meetingId: json['meeting_id'],
      date: json['date'],
      departmentId: json['dept_id'],
      departmentTitle: json['dept_title'],
      doctorId: json['doct_id'],
      meetingLink: json['meeting_link'],
      patientId: json['patient_id'],
      pFName: json['patient_f_name'],
      pLName: json['patient_l_name'],
      status: json['status'],
      timeSlot: json['time_slots'],
      type: json['type'],
      userId: json['user_id'],
      doctFName: json['doct_f_name'],
      doctLName: json['doct_l_name'],
      doctImage: json['doct_image'],
        doctSpecialization:json['doct_specialization'],
      currentCancelReqStatus: json['current_cancel_req_status'],
      averageRating:  json['average_rating']!=null?double.parse(json['average_rating'].toString()):null,
      numberOfReview:json['number_of_reviews'],
      totalAppointmentDone:json['total_appointment_done'],

    );
  }

}