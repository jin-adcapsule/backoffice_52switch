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
// Convert Employee to Map
  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'groupName': groupName,
        'parentGroupId': parentGroupId,
        'groupSupervisorOid': groupSupervisorOid,

      };
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['_id'],
      groupName: json['groupName'] ,
      parentGroupId: json['parentGroupId'],
      groupSupervisorOid: json['groupSupervisorOid'],

    );
  }
}
