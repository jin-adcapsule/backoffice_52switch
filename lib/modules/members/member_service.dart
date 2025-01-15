
import 'package:backoffice52switch/modules/shared/dtos/groupMembers.dart';

import 'package:backoffice52switch/modules/shared/services/logger_config.dart';
import 'package:backoffice52switch/modules/shared/services/graphql_service.dart'; // graphqlendpoint

import 'package:graphql_flutter/graphql_flutter.dart';

class MemberService {
// Fetch attendance status bool
  Future<List<GroupMembers>> fetchMyAllGroupsMembers(String employeeOid) async {
    const query = '''
    query GetMyAllGroupsMembers(\$employeeOid: String!) {
      getMyAllGroupsMembers(employeeOid: \$employeeOid){
        groupId
        groupName
        parentGroupId
        groupSupervisorOid
        members {
          employeeOid
          employeeId
          name
          email
          position
          phone
          joindate

          department
          supervisorName
          supervisorOid
          isSupervisor

          locationId
          workplace
          workhour
          workhourOn
          workhourOff
          workhourHalf
          
          dayoffPerYear
        }
      } 
    }
    ''';

    final variables = {
      'employeeOid': employeeOid,
    };

    ///employee response to date with exception handling
    try {
      final result = await GraphQLService.query(
        query,
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly, // Force network fetch
      );
      if (result.hasException) {
        LoggerConfig().logger.e('Query Exception: ${result.exception}');
        throw Exception("Failed to fetch: ${result.exception}");
      }

      // Correctly map the result to a List<Employee>
      final List<GroupMembers> members =
          (result.data!['getMyAllGroupsMembers'] as List)
              .map((e) => GroupMembers.fromJson(e as Map<String, dynamic>))
              .toList();
      return members;
    } catch (e) {
      LoggerConfig().logger.e('Error in fetch: $e'); // If error occurs
      return [];
    }
  }
}
