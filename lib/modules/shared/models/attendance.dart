

import 'package:intl/intl.dart';
class Attendance {

   String attendanceId;
   String employeeOid;
   String date;
   int? checkInTime; // Nullable int// Store as int (Long equivalent in Dart)
   int? checkOutTime; // Nullable int// Store as int (Long equivalent in Dart)
   String locationId; 
   bool status; 


  Attendance({
    required this.attendanceId,
    required this.date,
    required this.employeeOid,
    required this.checkInTime,
    required this.checkOutTime,
    required this.locationId,
    required this.status,
   
  });
// Convert Employee to Map
  Map<String, dynamic> toJson() => {
        'attendanceId': attendanceId,
        'date': date,
        'employeeOid': employeeOid,
        'checkInTime': checkInTime,
        'checkOutTime': checkOutTime,
        'locationId': locationId,
        'status': status
      };
  factory Attendance.fromJson(Map<String, dynamic> json) {

    return Attendance(
      attendanceId: json['_id']as String,
      date: json['date']as String,
      employeeOid: json['employeeOid']as String,
      checkInTime: json['checkInTime'] != null 
          ? int.parse(json['checkInTime'].toString()) // Convert String to int
          : null,  // Handle null
      checkOutTime: json['checkOutTime'] != null 
          ? int.parse(json['checkOutTime'].toString()) // Convert String to int
          : null,  // Handle null
      locationId: json['locationId']as String,
      status: json['status'] as bool,
    );
  }
}
