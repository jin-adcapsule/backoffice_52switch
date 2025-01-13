//Employee model can handle the response from the GraphQL API.
import 'package:backoffice52switch/modules/shared/models/employee.dart';

class GroupMembers {
   String groupId;
   String groupName; 
   String parentGroupId; 
   String groupSupervisorOid;
   List<Employee> members; 

  GroupMembers({
    required this.groupId,
    required this.groupName,
    required this.parentGroupId,
    required this.groupSupervisorOid,
    required this.members,
   
  });

  factory GroupMembers.fromJson(Map<String, dynamic> json) {
    return GroupMembers(
      groupId: json['groupId'],
      groupName: json['groupName'] ,
      parentGroupId: json['parentGroupId'],
      groupSupervisorOid: json['groupSupervisorOid'],
      members: (json['members'] as List) // Ensure this is parsed
        .map((memberJson) => Employee.fromJson(memberJson)) // Parse each member
            .toList(),

    );
  }
}
