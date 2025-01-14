import 'package:backoffice52switch/modules/groups/group_service.dart';
import 'package:backoffice52switch/modules/shared/models/group.dart';
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
  String selectedCollection = 'Employee';
  List<Map<String, dynamic>> records = [];
  late Future<List<Map<String,dynamic>>> _futureData;

  ///get a response for search from service
  Future<List<Map<String, dynamic>>> _fetchCollectionData(String collection) async {
    
    try {

      
      // final response = await _superAdminService// Fetch data using GraphQL query
      //     .fetchMyAllGroups(Constants.employeeOid);
      await Future.delayed(Duration(seconds: 1));
        // Replace this with your API call or GraphQL query
      if (collection == 'Employee') {
        return [
          {'id': 1, 'name': 'John Doe', 'email': 'john@example.com'},
          {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com'},
        ];
      } else if (collection == 'Attendance') {
        return [
          {'id': 1, 'employeeId': 101, 'date': '2025-01-10', 'status': 'Present'},
          {'id': 2, 'employeeId': 102, 'date': '2025-01-10', 'status': 'Absent'},
        ];
      }else{return [];}
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
          title: Text(
              Constants.getAppbarTitle(Constants.selectedKeyNotifier.value),
              style: TextStyle(color: Constants.getColor(ColorType.text)))),
      body: Column(
        children: [
          // Dropdown to select a collection
          DropdownButton<String>(
            value: selectedCollection,
            onChanged: (value) {
              setState(() {
                selectedCollection = value!;
                _futureData = _fetchCollectionData(selectedCollection);
              });
            },
            items: ['Employee', 'Attendance', 'DayOff', 'Group']
                .map((collection) =>
                    DropdownMenuItem(value: collection, child: Text(collection)))
                .toList(),
          ),

          // Display data using FutureBuilder
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
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
                return DataTable(
                  columns: records.first.keys
                      .map((key) => DataColumn(label: Text(key.toUpperCase())))
                      .toList()
                    ..add(
                      const DataColumn(label: Text('ACTIONS')),
                    ),
                  rows: records.map((record) {
                    return DataRow(
                      cells: record.entries
                          .map((entry) => DataCell(Text(entry.value.toString())))
                          .toList()
                        ..add(
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
                        ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openEditDialog(null),
        child: Icon(Icons.add),
      ),

    );
  }
}

class RectangleAvatar extends StatelessWidget {
  final Group group;

  const RectangleAvatar(this.group, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.blue,
      child: Text(
        group.groupName,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
