import 'dart:ui';

import 'package:backoffice52switch/modules/groups/group_service.dart';
import 'package:backoffice52switch/modules/shared/models/attendance.dart';
import 'package:backoffice52switch/modules/shared/models/dayoff.dart';
import 'package:backoffice52switch/modules/shared/models/employee.dart';
import 'package:backoffice52switch/modules/shared/models/group.dart';
import 'package:backoffice52switch/modules/shared/models/location.dart';
import 'package:backoffice52switch/modules/shared/services/global_service.dart';
import 'package:backoffice52switch/modules/superadmin/super_admin_service.dart';
import 'package:flutter/material.dart';
import 'package:backoffice52switch/utils/constants.dart';
import 'package:graphview/GraphView.dart';

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
  List<Map<String, dynamic>> originalData = [];  // This will hold the data for futureData
  String selectedCollection = 'Employee';
  List<String> collections = ['Employee', 'Attendance', 'Dayoff', 'Group', 'Location'];
  List<String> filteredCollections = [];
  List<Map<String, dynamic>> records = [];
  late Future<List<Map<String,dynamic>>> _futureData;
  TextEditingController _searchController = TextEditingController();

  ///get a response for search from service
  Future<List<Map<String, dynamic>>> _fetchCollectionData(String collection) async {
    
    try {
                       
      if (collection == 'Employee') {
        final List<Employee> employees=await _globalService.fetchAllEmployees();
        return employees.map((employee) => employee.toJson()).toList();
      } else if (collection == 'Attendance') {
        final List<Attendance> attendances=await _globalService.fetchAllAttendances();
        return attendances.map((attendance) => attendance.toJson()).toList();
      } else if (collection == 'Dayoff') {
        final List<Dayoff> dayoffs=await _globalService.fetchAllDayoffs();
        return dayoffs.map((dayoff) => dayoff.toJson()).toList();
      } else if (collection == 'Group') {
        final List<Group> groups=await _globalService.fetchAllGroups();
        return groups.map((group) => group.toJson()).toList();
      } else if (collection == 'Location') {
        final List<Location> locations=await _globalService.fetchAllLocations();
        return locations.map((location) => location.toJson()).toList();
      } else{return [];}
      //return response;
    } catch (e) {
      throw Exception('Failed to fetch collections: $e');
    }
  }
  void openEditDialog(Map<String, dynamic>? record) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(record == null ? 'Add Record' : 'Edit Record'),
            content: const Text('Build your form here.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),  
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle save logic
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    }
  @override
  void initState() {
    super.initState();
    _futureData = _fetchCollectionData(selectedCollection);
     _searchController.addListener(_filterData);  // Filter data on search input change
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
        filteredData = originalData.where((item) {
          // Iterate over the keys of the current map to check if any key-value pair matches the query
          return item.values.any((value) {
            if (value != null) {
              return value.toString().toLowerCase().contains(query);
            }
            return false;
          });
        }).toList();
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
    home:Scaffold(
      appBar: AppBar( 
          title: Text(
              Constants.getAppbarTitle(Constants.selectedKeyNotifier.value),
              style: TextStyle(color: Constants.getColor(ColorType.text)))),
      body: Column(
        children: [
          // Search input field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
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
                  _futureData = _fetchCollectionData(selectedCollection);
                });
              },
              items: ['Employee', 'Attendance', 'Dayoff', 'Group','Location']
                  .map((collection) =>
                      DropdownMenuItem(value: collection, child: Text(collection)))
                  .toList(),
            )
          ),

          // Data table in an Expanded widget to take remaining space
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:FutureBuilder<List<Map<String, dynamic>>>(
                  future: _futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available.'));
                    }

                    // Build DataTable with fetched data
                    final records = snapshot.data!;
                    originalData = records;
                    // Use filteredData instead of originalData in the DataTable
                    final dataToDisplay = filteredData.isEmpty ? originalData : filteredData;
                    // Extract keys from the first record for column headers
                    final columns = records.first.keys.toList();
                    return DataTable(
                      columns: columns
                        .map((key) => DataColumn(label: Text(key.toUpperCase())))
                        .toList()
                      ..add(
                        const DataColumn(label: Text('ACTIONS')),
                      ),
                      rows: dataToDisplay.map((record) {
                        // Ensure the row has the same number of cells as columns
                        final rowCells = columns.map((key) {
                          return DataCell(Text(record[key]?.toString() ?? ''));
                        }).toList();

                        // Add the Actions cell to each row
                        rowCells.add(
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => openEditDialog(record),
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
        ]
      )
    )
    

    );
  }
}

