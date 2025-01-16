import 'package:backoffice52switch/modules/shared/dtos/indexDTO.dart';
import 'package:backoffice52switch/modules/shared/services/logger_config.dart';
import 'package:backoffice52switch/modules/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
class SuperAdminService {
  // update employees
  Future<bool> updateEmployee(String employeeOid,employeeInput) async {
    const mutation  = '''
    mutation UpdateEmployee(\$employeeOid: String!, \$employeeInput: EmployeeInput!) {
    updateEmployee(employeeOid: \$employeeOid, employeeInput: \$employeeInput) 
    }
    ''';

    // // Dynamically build the employeeInput by only including fields that have been updated
    // final Map<String, dynamic> employeeInput = {};

    // if (updatedData['employeeId'] != null) employeeInput['employeeId'] = updatedData['employeeId'];
    // if (updatedData['name'] != null) employeeInput['name'] = updatedData['name'];
    // if (updatedData['email'] != null) employeeInput['email'] = updatedData['email'];
    // if (updatedData['position'] != null) employeeInput['position'] = updatedData['position'];
    // if (updatedData['phone'] != null) employeeInput['phone'] = updatedData['phone'];
    // if (updatedData['joindate'] != null) employeeInput['joindate'] = updatedData['joindate'];
    // if (updatedData['groupId'] != null) employeeInput['groupId'] = updatedData['groupId'];
    // if (updatedData['locationId'] != null) employeeInput['locationId'] = updatedData['locationId'];
    // if (updatedData['dayoffPerYear'] != null) employeeInput['dayoffPerYear'] = updatedData['dayoffPerYear'];

    // Prepare the variables needed for the mutation
    final variables = {
    'employeeOid': employeeOid,  // The unique identifier for the employee
    'employeeInput': employeeInput,       // The input with only updated fields
  };
    try {
      // Perform the GraphQL query with the specified fetch policy
      final result = await GraphQLService.mutate(
        mutation,
        variables: variables, // Add variables if required
        fetchPolicy: FetchPolicy.networkOnly, // Force network fetch
      );

      // Check if the result contains exceptions
      if (result.hasException) {
        LoggerConfig().logger.e('Mutation  Exception: ${result.exception}');
        throw Exception("Failed to update employee: ${result.exception}");
      }
      // Assuming that the GraphQL mutation returns a boolean value directly
      String responseString = result.data?['updateEmployee'] ?? 'false';  // Defaulting to 'false' if null


      // Convert the String response to a boolean
      bool response = responseString.toLowerCase() == 'success';  // 'true' as string maps to true in Dart

      print('$responseString');  // Prints true or false based on the mutation result
      return response;
    } catch (e) {
      // Log any error that occurs during the fetch
      LoggerConfig().logger.e('Error in update: $e'); // If error occurs
      throw Exception("Error updating employee: $e");
    }
  }
  // update employees
  Future<List<IndexDTO>> fetchAllIndexData() async {
    const query  = '''
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

      print(result.data!['getAllIndexes']);
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
}
