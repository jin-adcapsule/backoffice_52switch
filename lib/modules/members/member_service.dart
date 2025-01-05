import 'package:backoffice52switch/modules/shared/services/logger_config.dart';
import 'package:backoffice52switch/modules/shared/services/graphql_service.dart'; // graphqlendpoint
import 'package:backoffice52switch/modules/shared/models/employee.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MemberService {
// Fetch attendance status bool
  Future<List<Employee>?> fetchMyAllGroupsMembers(String employeeOid) async {
    final query = '''
    query GetMyAllGroupsMembers(\$employeeOid: String!) {
      getMyAllGroupsMembers(employeeOid: \$employeeOid){
        name
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

      final data = result.data?['getMyAllGroupsMembers'];
      print(data);
      if (data != null) {
        return data; // Return both success and status
      } else {
        LoggerConfig()
            .logger
            .e('Query Failed: No data returned.'); // If no data is returned
        return null;
      }
    } catch (e) {
      LoggerConfig().logger.e('Error in fetch: $e'); // If error occurs
      return null;
    }
  }
}
