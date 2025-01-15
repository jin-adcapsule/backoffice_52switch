

import 'package:intl/intl.dart';
class Attendance {

   String attendanceId;
   String employeeOid;
   int? checkInTime; // Nullable int
   int? checkOutTime; // Nullable int
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

    return Attendance(
      attendanceId: json['_id'],
      employeeOid: json['employeeOid'],
      checkInTime: json['checkInTime'] != null ? json['checkInTime'] as int : null,
      checkOutTime: json['checkOutTime'] != null ? json['checkOutTime'] as int : null,
      locationId: json['locationId'],
      status: json['status'],
    );
  }
}
