//Employee model can handle the response from the GraphQL API.
class EmployeeDTO {
   String employeeOid;
   int employeeId;
   String name;
   String position;
   String department;
   String email; 
   String phone; 
   String joindate; 
   String supervisorName;
   String supervisorOid; 
   bool isSupervisor; 
   String locationId; 
   String workplace; 
   String workhour; 
   String workhourOn; 
   String workhourOff; 
   String workhourHalf; 

   int? dayoffPerYear;

  EmployeeDTO({
    required this.employeeOid,
    required this.employeeId,
    required this.name,
    required this.position,
    required this.department,
    required this.email, 
    required this.phone, 
    required this.joindate, 
    required this.supervisorName,
    required this.supervisorOid, 
    required this.isSupervisor, 
    required this.locationId, 
    required this.workplace, 
    required this.workhour, 
    required this.workhourOn,
    required this.workhourOff,
    required this.workhourHalf, 
    required this.dayoffPerYear,
  });

  factory EmployeeDTO.fromJson(Map<String, dynamic> json) {
    return EmployeeDTO(
      employeeOid: json['employeeOid'],
      employeeId: json['employeeId'] as int,
      name: json['name'],
      email: json['email'], // Ensure this is parsed
      position: json['position'],
      phone: json['phone'], // Ensure this is parsed
      joindate: json['joindate'], // Ensure this is parsed

      department: json['department'],
      supervisorName: json['supervisorName'], // Ensure this is parsed
      supervisorOid: json['supervisorOid'], // Ensure this is parsed
      isSupervisor: json['isSupervisor'] as bool, // Ensure this is parsed

      locationId: json['locationId'],
      workplace: json['workplace'], // Ensure this is parsed
      workhour: json['workhour'], // Ensure this is parsed
      workhourOn: json['workhourOn'],
      workhourOff: json['workhourOff'],
      workhourHalf: json['workhourHalf'],
      dayoffPerYear: json['dayoffPerYear'] as int?,

    );
  }
}
