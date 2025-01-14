import 'package:backoffice52switch/modules/shared/services/logger_config.dart';
import 'package:backoffice52switch/modules/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
class SuperAdminService {
  // Fetch attendance status bool
  Future<List<Map<String, dynamic>>> fetchCollectionData(String collection) async {
    const query = '''
    query GetCollectionData(\$collection: String!) {
      getCollectionData(collection: \$collection){
        
      } 
    }
    ''';

    final variables = {
      'collection': collection,
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
      final data =result.data?['getCollectionData'];

      return data;
    } catch (e) {
      LoggerConfig().logger.e('Error in fetch: $e'); // If error occurs
      return [];
    }
  }
}
