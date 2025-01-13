//Employee model can handle the response from the GraphQL API.
import 'package:backoffice52switch/modules/shared/models/employee.dart';

class Group {
   String groupId;
   String groupName; 
   String parentGroupId; 
   String groupSupervisorOid; 

  Group({
    required this.groupId,
    required this.groupName,
    required this.parentGroupId,
    required this.groupSupervisorOid,
   
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['_id'],
      groupName: json['groupName'] ,
      parentGroupId: json['parentGroupId'],
      groupSupervisorOid: json['groupSupervisorOid'],

    );
  }
}
