import 'package:backoffice52switch/modules/shared/models/attendance.dart';
import 'package:backoffice52switch/modules/shared/models/dayoff.dart';
import 'package:backoffice52switch/modules/shared/models/group.dart';
import 'package:backoffice52switch/modules/shared/models/employee.dart';
import 'package:backoffice52switch/modules/shared/models/location.dart';
import 'package:backoffice52switch/modules/shared/services/logger_config.dart';
import 'package:backoffice52switch/modules/shared/services/graphql_service.dart'; // graphqlendpoint
import 'package:graphql_flutter/graphql_flutter.dart';

class GlobalService {
  // Fetch group
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
      final List<Group> members = (result.data!['getMyAllGroups'] as List)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList();
      return members;
    } catch (e) {
      LoggerConfig().logger.e('Error in fetch: $e'); // If error occurs
      return [];
    }
  }

  // Fetch location
  Future<List<Location>> fetchAllLocations() async {
    const query = '''
    query GetAllLocations {
      getAllLocations{
        _id
        workplace
        workhourOn
        workhourOff
        workhourHalf
      } 
    }
    ''';

    final variables = {
      
    };

    try {
      final result = await GraphQLService.query(
        query,
        //variables: variables,
        fetchPolicy: FetchPolicy.networkOnly, // Force network fetch
      );
      if (result.hasException) {
        LoggerConfig().logger.e('Query Exception: ${result.exception}');
        throw Exception("Failed to fetch: ${result.exception}");
      }

      final List<Location> locations = (result.data!['getAllLocations'] as List)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList();
      return locations;
    } catch (e) {
      LoggerConfig().logger.e('Error in fetch: $e'); // If error occurs
      return [];
    }
  }
  // Fetch employees
  Future<List<Employee>> fetchAllEmployees() async {
    const query = '''
    query GetAllEmployees {
      getAllEmployees{
        _id
        employeeId
        name
        email
        position
        phone
        joindate
        groupId 
        locationId
        dayoffPerYear
      } 
    }
    ''';

    final variables = {
      
    };

    try {
      final result = await GraphQLService.query(
        query,
        //variables: variables,
        fetchPolicy: FetchPolicy.networkOnly, // Force network fetch
      );
      if (result.hasException) {
        LoggerConfig().logger.e('Query Exception: ${result.exception}');
        throw Exception("Failed to fetch: ${result.exception}");
      }

      // Correctly map the result to a List<Employee>
      final List<Employee> employees = (result.data!['getAllEmployees'] as List)
          .map((e) => Employee.fromJson(e as Map<String, dynamic>))
          .toList();
      return employees;
    } catch (e) {
      LoggerConfig().logger.e('Error in fetch: $e'); // If error occurs
      return [];
    }
  }
  // Fetch dayoff
  Future<List<Dayoff>> fetchAllDayoffs() async {
    const query = '''
    query GetAllDayoffs {
      getAllDayoffs{
        _id
        employeeOid
        dayoffType
        requestComment
        dayoffDate
        requestStatus
        requestDate
        supervisorOid
        requestKey
      } 
    }
    ''';

    final variables = {
      
    };

    try {
      final result = await GraphQLService.query(
        query,
        //variables: variables,
        fetchPolicy: FetchPolicy.networkOnly, // Force network fetch
      );
      if (result.hasException) {
        LoggerConfig().logger.e('Query Exception: ${result.exception}');
        throw Exception("Failed to fetch: ${result.exception}");
      }

      // Correctly map the result to a List<Employee>
      final List<Dayoff> dayoffs = (result.data!['getAllDayoffs'] as List)
          .map((e) => Dayoff.fromJson(e as Map<String, dynamic>))
          .toList();
      return dayoffs;
    } catch (e) {
      LoggerConfig().logger.e('Error in fetch: $e'); // If error occurs
      return [];
    }
  }
  // Fetch dayoff
  Future<List<Attendance>> fetchAllAttendances() async {
    const query = '''
    query GetAllAttendances {
      getAllAttendances{
        _id
        date
        checkInTime
        checkOutTime
        locationId
        status
        employeeOid
      } 
    }
    ''';

    final variables = {
      
    };

    try {
      final result = await GraphQLService.query(
        query,
        //variables: variables,
        fetchPolicy: FetchPolicy.networkOnly, // Force network fetch
      );
      if (result.hasException) {
        LoggerConfig().logger.e('Query Exception: ${result.exception}');
        throw Exception("Failed to fetch: ${result.exception}");
      }

      // Correctly map the result to a List<Employee>
      final List<Attendance> attendances = (result.data!['getAllAttendances'] as List)
          .map((e) => Attendance.fromJson(e as Map<String, dynamic>))
          .toList();
      return attendances;
    } catch (e) {
      LoggerConfig().logger.e('Error in fetch: $e'); // If error occurs
      return [];
    }
  }
  // Fetch group
  Future<List<Group>> fetchAllGroups() async {
    const query = '''
    query GetAllGroups {
      getAllGroups{
        _id
        groupName
        groupSupervisorOid
        parentGroupId
      } 
    }
    ''';

    final variables = {
      
    };

    try {
      final result = await GraphQLService.query(
        query,
        //variables: variables,
        fetchPolicy: FetchPolicy.networkOnly, // Force network fetch//
      );
      if (result.hasException) {
        LoggerConfig().logger.e('Query Exception: ${result.exception}');
        throw Exception("Failed to fetch: ${result.exception}");
      }

      final List<Group> dayoffs = (result.data!['getAllGroups'] as List)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList();
      return dayoffs;
    } catch (e) {
      LoggerConfig().logger.e('Error in fetch: $e'); // If error occurs
      return [];
    }
  }
}
