import 'dart:io';
import 'package:backoffice52switch/modules/shared/models/group.dart';
import 'package:backoffice52switch/modules/shared/dtos/groupMembers.dart';
import 'package:backoffice52switch/modules/shared/models/location.dart';
import 'package:backoffice52switch/modules/shared/services/global_service.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:backoffice52switch/modules/members/member_service.dart';
import 'package:backoffice52switch/modules/members/show_member_widget.dart';
import 'package:backoffice52switch/modules/shared/dtos/employeeDTO.dart';
import 'package:backoffice52switch/utils/constants.dart'; // For app configuration

// Public create function
Widget createMemberScreen() {
  return const _MemberScreen();
}

class _MemberScreen extends StatefulWidget {
  //final bool isAttendanceMarked;//Make AttendanceScreen receive the isAttendanceMarked value and update its background color
  const _MemberScreen();
  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<_MemberScreen> {
  final MemberService _memberService = MemberService();
  final GlobalService _globalService = GlobalService();
  late Future<List<GroupMembers>> _futureData;
  late Future<List<Group>> _allMyGroups;
  late Future<List<Location>> _allLocations;

  ///get a response for search from service
  Future<List<GroupMembers>> _fetchMyAllGroupsMembers() async {
    try {
      final response = await _memberService
          .fetchMyAllGroupsMembers(Constants.employeeOid //employeeOid
              );
      return response;
    } catch (e) {
      throw Exception('Failed to fetch group members: $e');
    }
  }

  Future<List<Group>> _fetchMyAllGroups() async {
    try {
      final response = await _globalService
          .fetchMyAllGroups(Constants.employeeOid //employeeOid
              );
      return response;
    } catch (e) {
      throw Exception('Failed to fetch groups: $e');
    }
  }

  Future<List<Location>> _fetchAllLocations() async {
    try {
      final response = await _globalService
          .fetchAllLocations();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch locations: $e');
    }
  }

  void _showMemberinfo(BuildContext context, EmployeeDTO member,
      List<Location> allLocations, List<Group> allMyGroups) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // Show as a popup dialog on web or desktop platforms
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: ShowMemberWidget(
                member: member,
                allLocations: allLocations,
                allMyGroups: allMyGroups), // Pass the member widget
            // actions: [
            //   TextButton(
            //     onPressed: () => Navigator.pop(context), // Close dialog
            //     child: const Text('Close'),
            //   ),
            // ],
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ShowMemberWidget(
              member: member,
              allLocations: allLocations,
              allMyGroups: allMyGroups); // Pass the member to the widget
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _futureData = _fetchMyAllGroupsMembers();
    _allMyGroups = _fetchMyAllGroups();
    _allLocations = _fetchAllLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              Constants.getAppbarTitle(Constants.selectedKeyNotifier.value),
              style: TextStyle(color: Constants.getColor(ColorType.text)))),
      body: FutureBuilder<List<GroupMembers>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final groups = snapshot.data!;
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, idx) {
                final group = groups[idx];

// Use a Column to include the group divider and its members
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Name Divider
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      color: Colors
                          .transparent, // Optional background color for divider
                      child: Text(
                        group.groupName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Horizontal Divider (Full Width)
                    const Divider(
                      thickness: 1, // Thickness of the divider
                      color: Colors.grey, // Color of the divider
                    ),
                    // List of group members
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Prevent nested scrolling issues
                      itemCount: group.members.length,
                      itemBuilder: (context, memberIdx) {
                        final member = group.members[memberIdx];
                        return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(member.name),
                            subtitle: Text(member.position),
                            onTap: () {
                              // Fetch Locations and Groups first
                              Future.wait([_allLocations, _allMyGroups])
                                  .then((results) {
                                final allLocations =
                                    results[0] as List<Location>;
                                final allMyGroups = results[1] as List<Group>;
                                _showMemberinfo(
                                    context, member, allLocations, allMyGroups);
                              });
                            });
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
