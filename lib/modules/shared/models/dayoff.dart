
class Dayoff {

   String dayoffId;
   String employeeOid; 
   String dayoffType; 
   String requestComment; 
   String dayoffDate; 
   String requestStatus;
   String requestDate; 
   String supervisorOid; 
   String requestKey; 


  Dayoff({
    required this.dayoffId,
    required this.employeeOid,
    required this.dayoffType,
    required this.requestComment,
    required this.dayoffDate,
    required this.requestStatus,
    required this.requestDate,
    required this.supervisorOid,
    required this.requestKey,
   
  });
// Convert Employee to Map
  Map<String, dynamic> toJson() => {
        'dayoffId': dayoffId,
        'employeeOid': employeeOid,
        'dayoffType': dayoffType,
        'requestComment': requestComment,
        'dayoffDate': dayoffDate,
        'requestStatus': requestStatus,
        'requestDate': requestDate,
        'supervisorOid': supervisorOid,
        'requestKey': requestKey,

      };
  factory Dayoff.fromJson(Map<String, dynamic> json) {
    return Dayoff(
      dayoffId: json['_id'],
      employeeOid: json['employeeOid'] ,
      dayoffType: json['dayoffType'],
      requestComment: json['requestComment'],
      dayoffDate: json['dayoffDate'],
      requestStatus: json['requestStatus'] ,
      requestDate: json['requestDate'],
      supervisorOid: json['supervisorOid'],
      requestKey: json['requestKey'],

    );
  }
}
