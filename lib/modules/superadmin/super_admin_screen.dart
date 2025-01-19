import 'dart:ui';

import 'package:backoffice52switch/modules/shared/dtos/indexDTO.dart';
import 'package:backoffice52switch/modules/shared/models/attendance.dart';
import 'package:backoffice52switch/modules/shared/models/dayoff.dart';
import 'package:backoffice52switch/modules/shared/models/employee.dart';
import 'package:backoffice52switch/modules/shared/models/group.dart';
import 'package:backoffice52switch/modules/shared/models/location.dart';
import 'package:backoffice52switch/modules/shared/services/global_service.dart';
import 'package:backoffice52switch/modules/superadmin/show_record_widget.dart';
import 'package:backoffice52switch/modules/superadmin/super_admin_service.dart';
import 'package:flutter/material.dart';
import 'package:backoffice52switch/utils/constants.dart';

// Public create function
Widget createSuperAdminScreen() {
  return const _SuperAdminScreen();
}

class _SuperAdminScreen extends StatefulWidget {
  //final bool isAttendanceMarked;//Make AttendanceScreen receive the isAttendanceMarked value and update its background color
  const _SuperAdminScreen();
  @override
  _SuperAdminScreenState createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends State<_SuperAdminScreen> {
  final SuperAdminService _superAdminService = SuperAdminService();
  final GlobalService _globalService = GlobalService();
  List<Map<String, dynamic>> filteredData = [];
  List<Map<String, dynamic>> originalData =
      []; // This will hold the data for futureData
  String selectedCollection = 'Employee';
  List<String> collections = [
    'Employee',
    'Attendance',
    'Dayoff',
    'Group',
    'Location'
  ];
  List<String> filteredCollections = [];
  List<Map<String, dynamic>> records = [];
  late Future<List<Map<String, dynamic>>> _futureData;
  late Future<List<IndexDTO>> _indexData;
  List<IndexDTO> indexData = []; // Store index data after it's fetched
  final TextEditingController _searchController = TextEditingController();
  late Map<String, dynamic> collectionInfoMap; //selected Collection Info
  List<Map<String, dynamic>> collectionInfoMapList = Constants.collectionConfig;

  ///get a response for search from service
  Future<List<Map<String, dynamic>>> _fetchCollectionData(
      String collection) async {
    setState(() {
      filteredData = []; // Reset filtered data when collection changes
    });
    try {
      List<Map<String, dynamic>> response = [];
      if (collection == 'Employee') {
        final List<Employee> employees =
            await _globalService.fetchAllEmployees();
        response = employees.map((employee) => employee.toJson()).toList();
      } else if (collection == 'Attendance') {
        final List<Attendance> attendances =
            await _globalService.fetchAllAttendances();
        response =
            attendances.map((attendance) => attendance.toJson()).toList();
      } else if (collection == 'Dayoff') {
        final List<Dayoff> dayoffs = await _globalService.fetchAllDayoffs();
        response = dayoffs.map((dayoff) => dayoff.toJson()).toList();
      } else if (collection == 'Group') {
        final List<Group> groups = await _globalService.fetchAllGroups();
        response = groups.map((group) => group.toJson()).toList();
      } else if (collection == 'Location') {
        final List<Location> locations =
            await _globalService.fetchAllLocations();
        response = locations.map((location) => location.toJson()).toList();
      }

      setState(() {
        originalData = response; // Set the original data
        filteredData =
            response; // Set filtered data to the same as original initially
      });

      _filterData(); // Apply filter immediately after data is fetched
      return response;
    } catch (e) {
      throw Exception('Failed to fetch collections: $e');
    }
  }

  List<Map<String, dynamic>> preprocessDataForSearch(
      List<Map<String, dynamic>> data) {
    return data.map((record) {
      final updatedRecord = Map<String, dynamic>.from(record);
      for (var key in record.keys) {
        if (collectionInfoMap['keyTypeMap'].containsKey(key) &&
            collectionInfoMap['keyTypeMap'][key] == 'refId') {
          // Add a `_showValue` for reference IDs
          updatedRecord['${key}_showValue'] =
              getIndexShowValue(key, record[key]);
        }
      }
      return updatedRecord;
    }).toList();
  }

  List<Map<String, dynamic>> postProcessFilteredData(
      List<Map<String, dynamic>> data) {
    return data.map((record) {
      final updatedRecord = Map<String, dynamic>.from(record);

      // Remove all keys that end with '_showValue'
      updatedRecord.removeWhere((key, value) => key.endsWith('_showValue'));

      return updatedRecord;
    }).toList();
  }

  ///get a response for search from service
  Future<List<IndexDTO>> _fetchAllIndexData() async {
    try {
      final List<IndexDTO> indexes =
          await _superAdminService.fetchAllIndexData();
      //response = employees.map((employee) => employee.toJson()).toList();
      return indexes;
    } catch (e) {
      throw Exception('Failed to fetch index: $e');
    }
  }

  void openEditDialog(
      BuildContext context,
      Map<String, dynamic>? record,
      String collectionKey,
      Map<String, dynamic> collectionInfoMap,
      List<IndexDTO> indexData) {
    if (Constants.isWebOrDesktop) {
      // Show as a popup dialog on web or desktop platforms
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: ShowRecordWidget(
              record: record,
              collectionInfoMap: collectionInfoMap,
              indexData: indexData,
            ),
          );
        },
      ).then((_) {
        // After closing the dialog, re-fetch the collection data
        _fetchCollectionData(selectedCollection);
      });
    } else {
      // Show as a bottom sheet on mobile platforms
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ShowRecordWidget(
              record: record,
              collectionInfoMap: collectionInfoMap,
              indexData: indexData);
        },
      ).then((_) {
        // After closing the dialog, re-fetch the collection data
        _fetchCollectionData(selectedCollection);
      });
    }
  }

  void getCollectionInfoMap(String selectedCollection) {
    collectionInfoMap = collectionInfoMapList
        .firstWhere((map) => map['collection'] == selectedCollection);
  }

  // Function to get the indexShowValue for a given indexKey and indexValue
  String getIndexShowValue(String indexKey, String indexValue) {
    // Check if the indexKey is in refIdKeyConverter and update if necessary
    if (Constants.refIdKeyConverter.containsKey(indexKey)) {
      indexKey = Constants.refIdKeyConverter[indexKey].toString();
    }
    final result = indexData.firstWhere(
        (indexDTO) =>
            indexDTO.indexKey == indexKey && indexDTO.indexValue == indexValue,
        orElse: () => IndexDTO(
            collection: '',
            indexKey: '',
            indexValue: '',
            indexShowKey: '',
            indexShowValue: 'Unknown'));
    return result.indexShowValue;
  }

  @override
  void initState() {
    super.initState();
    getCollectionInfoMap(selectedCollection);
    _futureData = _fetchCollectionData(selectedCollection);
    _indexData = _fetchAllIndexData();
    _indexData.then((data) {
      setState(() {
        indexData = data; // Save the data to the state after fetching
      });
    });

    _searchController
        .addListener(_filterData); // Filter data on search input change
  }

// Filter the data based on the search query
  void _filterData() {
    final query = _searchController.text.toLowerCase();
    // Check if the query is not empty and filter accordingly
    if (query.isEmpty) {
      setState(() {
        filteredData = originalData; // Show all data when search is empty
      });
    } else {
      setState(() {
        // Preprocess data for search - adding '_showValue' fields to originalData
        final searchableData = preprocessDataForSearch(originalData);

        // Filter based on the `_showValue` fields or original values
        final filteredResults = searchableData.where((record) {
          // Check for a match in either '_showValue' fields or the original values
          return record.entries.any((entry) {
            final value = record['${entry.key}_showValue'] ?? entry.value;
            return value != null &&
                value.toString().toLowerCase().contains(query);
          });
        }).toList();

        // If no results found, show an empty list (for no data found)
        if (filteredResults.isEmpty) {
          filteredData =
              []; // Or an empty list, or you can show a special message
        } else {
          // Postprocess to exclude '_showValue' columns from filtered data
          filteredData = postProcessFilteredData(filteredResults);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior: MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
          },
        ),
        home: Scaffold(
            appBar: AppBar(
                title: Text(
                    Constants.getAppbarTitle(
                        Constants.selectedKeyNotifier.value),
                    style:
                        TextStyle(color: Constants.getColor(ColorType.text)))),
            body: Column(
                crossAxisAlignment: Constants.isWebOrDesktop
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center, // Adjust alignment
                children: [
                  Padding(
                    // Search input field
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Constants.isWebOrDesktop
                          ? 200
                          : double
                              .infinity, // Adjust width based on platform (web vs mobile)
                      child: TextField(
                        controller: _searchController,
                        textAlign: Constants.isWebOrDesktop
                            ? TextAlign.start
                            : TextAlign.center, // Align text to start for web
                        decoration: const InputDecoration(
                          labelText: '키워드 검색',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  // Dropdown to select a collection
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: selectedCollection,
                        onChanged: (value) {
                          setState(() {
                            selectedCollection = value!;
                            _futureData =
                                _fetchCollectionData(selectedCollection);
                            getCollectionInfoMap(selectedCollection);
                          });
                        },
                        items: collectionInfoMapList.map((collection) {
                          return DropdownMenuItem<String>(
                            value: collection[
                                'collection'], // The actual collection value
                            child: Text(collection[
                                'label']), // Display label in the dropdown
                          );
                        }).toList(),
                      )),

                  // Data table in an Expanded widget to take remaining space
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: _futureData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No data available.'));
                            }

                            // Build DataTable with fetched data
                            final records = snapshot.data!;
                            //originalData = records;
                            // Use filteredData instead of originalData in the DataTable
                            final dataToDisplay = filteredData;
//                            filteredData.isEmpty ? records : filteredData;

                            // Extract keys from the first record for column headers
                            final columns = records.first.keys.toList();
                            List<String> columnsToDisplay = columns
                                .where((column) =>
                                    column != collectionInfoMap["idxKey"])
                                .toList();
                            return filteredData.isEmpty
                                ? const Center(child: Text('검색 결과 없음'))
                                : DataTable(
                                    columns: columnsToDisplay
                                        .map((key) => DataColumn(
                                            label: Text(key.toUpperCase())))
                                        .toList()
                                      ..add(
                                        const DataColumn(
                                            label: Text('ACTIONS')),
                                      ),
                                    rows: dataToDisplay.map((record) {
                                      // Ensure the row has the same number of cells as columns
                                      final rowCells =
                                          columnsToDisplay.map((key) {
                                        if (collectionInfoMap['keyTypeMap']
                                                .containsKey(key) &&
                                            collectionInfoMap['keyTypeMap']
                                                    [key] ==
                                                'refId') {
                                          // Replace groupId or locationId.... with the corresponding show value
                                          return DataCell(Text(
                                              getIndexShowValue(
                                                  key, record[key])));
                                        } else {
                                          return DataCell(Text(
                                              record[key]?.toString() ?? ''));
                                        }
                                      }).toList();

                                      // Add the Actions cell to each row
                                      rowCells.add(
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () => openEditDialog(
                                                    context,
                                                    record,
                                                    selectedCollection,
                                                    collectionInfoMap,
                                                    indexData),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  // Handle delete logic
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );

                                      return DataRow(cells: rowCells);
                                    }).toList(),
                                  );
                          },
                        ),
                      ),
                    ),
                  )
                ])));
  }
}
