class Employee {
   String employeeOid;
   int employeeId; 
   String name; 
   String email; 
   String position; 
   String phone;
   String joindate;
   String groupId;
   String locationId;
   String dayoffPerYear;

  Employee({
    required this.employeeOid,
    required this.employeeId,
    required this.name,
    required this.email,
    required this.position,
    required this.phone,
    required this.joindate,
    required this.groupId,
    required this.locationId,
    required this.dayoffPerYear,
   
  });
// Convert Employee to Map
  Map<String, dynamic> toJson() => {
        'employeeOid': employeeOid,
        'employeeId': employeeId,
        'name': name,
        'email': email,
        'position': position,
        'phone': phone,
        'joindate': joindate,
        'groupId': groupId,
        'locationId': locationId,
        'dayoffPerYear': dayoffPerYear,

      };
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeOid: json['_id'] ?? '', // Default empty string if null
      employeeId: json['employeeId'] ?? 0, // Default 0 if null
      name: json['name'] ?? '', // Default empty string if null
      email: json['email'] ?? '', // Default empty string if null
      position: json['position'] ?? '', // Default empty string if null
      phone: json['phone'] ?? '', // Default empty string if null
      joindate: json['joindate'] ?? '', // Default empty string if null
      groupId: json['groupId'] ?? '', // Default empty string if null
      locationId: json['locationId'] ?? '', // Default empty string if null
      dayoffPerYear: json['dayoffPerYear']?.toString() ?? '0', // Default '0' if null

    );
  }
}
