import 'package:backoffice52switch/modules/shared/dtos/indexDTO.dart';
import 'package:backoffice52switch/modules/shared/services/logger_config.dart';
import 'package:backoffice52switch/modules/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SuperAdminService {
  // update employees
  Future<List<IndexDTO>> fetchAllIndexData() async {
    const query = '''
    query GetAllIndexes {
      getAllIndexes{
        collection
        indexKey
        indexValue
        indexShowKey
        indexShowValue
      } 
    }
    ''';

    try {
      // Perform the GraphQL query with the specified fetch policy
      final result = await GraphQLService.query(
        query,
        fetchPolicy: FetchPolicy.networkOnly, // Force network fetch
      );

      // Check if the result contains exceptions
      if (result.hasException) {
        LoggerConfig().logger.e('Query  Exception: ${result.exception}');
        throw Exception("Failed to fetcb indexes: ${result.exception}");
      }

      // Correctly map the result to a List<IndexDTO>
      final List<IndexDTO> indexDTO = (result.data!['getAllIndexes'] as List)
          .map((e) => IndexDTO.fromJson(e as Map<String, dynamic>))
          .toList();
      return indexDTO;
    } catch (e) {
      // Log any error that occurs during the fetch
      LoggerConfig().logger.e('Error in fetching: $e'); // If error occurs
      throw Exception("Error fetching indexes: $e");
    }
  }
  // delete instance by id
  Future<bool> deleteCollectionById(String collection,String id)async{
    // Dynamically construct the GraphQL mutation
    String mutation = '''
      mutation Delete${collection}ById(\$id: String) {
        delete${collection}ById(id: \$id)
      }
    ''';
    // Prepare variables with the proper structure for GraphQL
    Map<String, dynamic> variablesToSend = {
      'id':id,
    };
    try {
      // Perform the GraphQL mutation
      final result = await GraphQLService.mutate(
        mutation,
        variables: variablesToSend,
        fetchPolicy: FetchPolicy.networkOnly, // Always fetch from the network
      );

      // Check if there are any exceptions in the result
      if (result.hasException) {
        LoggerConfig().logger.e('Mutation Exception: ${result.exception}');
        throw Exception("Failed to update entity: ${result.exception}");
      }

      // Assuming the mutation returns a 'success' string or similar response
      bool response = result.data?["delete${collection}ById"] ?? false;
      //bool response = responseString.toLowerCase() == 'success';

      // print('$responseString');  // Prints 'success' or 'failure'
      return response;
    } catch (e) {
      LoggerConfig().logger.e('Error in update: $e');
      throw Exception("Error updating entity: $e");
    }
  }
  // General update function returning String 'success' on sucessful update and String with error details when failed 
  Future<String> updateEntity(String mutationName, String inputTypeName,
      Map<String, dynamic> variables) async {
    // Ensure the mutationName is capitalized
    String capitalizedMutationName =
        mutationName[0].toUpperCase() + mutationName.substring(1);
    // Dynamically construct the GraphQL mutation
    String mutation = '''
      mutation $capitalizedMutationName(\$id: String, \$input: $inputTypeName!) {
        $mutationName(id: \$id, input: \$input)
      }
    ''';
    // Prepare variables with the proper structure for GraphQL
    Map<String, dynamic> variablesToSend = {
      'id': variables['id'],
      'input': variables['input']
    };
    try {
      // Perform the GraphQL mutation
      final result = await GraphQLService.mutate(
        mutation,
        variables: variablesToSend,
        fetchPolicy: FetchPolicy.networkOnly, // Always fetch from the network
      );

      // Check if there are any exceptions in the result
      if (result.hasException) {
        LoggerConfig().logger.e('Mutation Exception: ${result.exception}');
        throw Exception("Failed to update entity: ${result.exception}");
      }

      // Assuming the mutation returns a 'success' string or similar response
      String responseString = result.data?[mutationName] ?? 'Update Failed: Server Error';
      //bool response = responseString.toLowerCase() == 'success';

      // print('$responseString');  // Prints 'success' or 'failure'
      return responseString;
    } catch (e) {
      LoggerConfig().logger.e('Error in update: $e');
      throw Exception("Error updating entity: $e");
    }
  }

  // Update employee function
  Future<String> updateEmployee(
      String? employeeOid, Map<String, dynamic> employeeInput) async {
    final variables = {
      'id': employeeOid,
      'input': employeeInput,
    };

    return await updateEntity("updateOrNewEmployee", "EmployeeInput", variables);
  }
  // Update attendance function
  Future<String> updateAttendance(
      String? attendanceId, Map<String, dynamic> attendanceInput) async {
    final variables = {
      'id': attendanceId,
      'input': attendanceInput,
    };
    return await updateEntity("updateOrNewAttendance", "AttendanceInput", variables);
  }
  // Update dayoff function
  Future<String> updateDayoff(
      String? dayoffId, Map<String, dynamic> dayoffInput) async {
    final variables = {
      'id': dayoffId,
      'input': dayoffInput,
    };
    return await updateEntity("updateOrNewDayoff", "DayoffInput", variables);
  }
  // Update group function
  Future<String> updateGroup(
      String? groupId, Map<String, dynamic> groupInput) async {
    final variables = {
      'id': groupId,
      'input': groupInput,
    };
    return await updateEntity("updateOrNewGroup", "GroupInput", variables);
  }
  // Update location function
  Future<String> updateLocation(
      String? locationId, Map<String, dynamic> locationInput) async {
    final variables = {
      'id': locationId,
      'input': locationInput,
    };
    return await updateEntity("updateOrNewLocation", "LocationInput", variables);
  }
}
