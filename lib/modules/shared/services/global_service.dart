import 'package:backoffice52switch/modules/shared/models/group.dart';
import 'package:backoffice52switch/modules/shared/models/location.dart';
import 'package:backoffice52switch/modules/shared/services/logger_config.dart';
import 'package:backoffice52switch/modules/shared/services/graphql_service.dart'; // graphqlendpoint
import 'package:graphql_flutter/graphql_flutter.dart';

class GlobalService {
  // Fetch attendance status bool
  Future<List<Group>> fetchMyAllGroups(String employeeOid) async {
    const query = '''
    query GetMyAllGroups(\$employeeOid: String!) {
      getMyAllGroups(employeeOid: \$employeeOid){
        _id
        groupName
        parentGroupId
        groupSupervisorOid
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
      final List<Group> members = (result.data!['getMyAllGroups'] as List)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList();
      return members;
    } catch (e) {
      LoggerConfig().logger.e('Error in fetch: $e'); // If error occurs
      return [];
    }
  }

  // Fetch attendance status bool
  Future<List<Location>> fetchAllLocations(String employeeOid) async {
    const query = '''
    query GetAllLocations(\$employeeOid: String!) {
      getAllLocations(employeeOid: \$employeeOid){
        _id
        workplace
        workhourOn
        workhourOff
        workhourHalf
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
      print(result.data!['getAllLocations']);
      // Correctly map the result to a List<Employee>
      final List<Location> locations = (result.data!['getAllLocations'] as List)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList();
      return locations;
    } catch (e) {
      LoggerConfig().logger.e('Error in fetch: $e'); // If error occurs
      return [];
    }
  }
}
