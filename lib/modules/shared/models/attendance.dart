import 'package:intl/intl.dart';
class Attendance {

   String attendanceId;
   String employeeOid;
   DateTime? checkInTime; //nullable
   DateTime? checkOutTime; //nullable
   String locationId; 
   bool status; 


  Attendance({
    required this.attendanceId,
    required this.employeeOid,
    required this.checkInTime,
    required this.checkOutTime,
    required this.locationId,
    required this.status,
   
  });
// Convert Employee to Map
  Map<String, dynamic> toJson() => {
        'attendanceId': attendanceId,
        'employeeOid': employeeOid,
        'checkInTime': checkInTime,
        'checkOutTime': checkOutTime,
        'locationId': locationId,
        'status': status
      };
  factory Attendance.fromJson(Map<String, dynamic> json) {
    // Define a custom date format
    final dateFormat = DateFormat("EEE MMM dd HH:mm:ss 'KST' yyyy");
    return Attendance(
      attendanceId: json['_id'],
      employeeOid: json['employeeOid'],
      checkInTime: json['checkInTime'] != null ? dateFormat.parse(json['checkInTime']) : null,
      checkOutTime: json['checkOutTime'] != null ? dateFormat.parse(json['checkOutTime']) : null,
      locationId: json['locationId'],
      status: json['status'],
    );
  }
}
