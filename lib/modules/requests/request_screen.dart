import 'package:backoffice52switch/modules/shared/dtos/groupMembers.dart';
import 'package:flutter/material.dart';
import 'package:backoffice52switch/modules/members/member_service.dart';
import 'package:backoffice52switch/modules/shared/dtos/employeeDTO.dart';
import 'package:backoffice52switch/utils/constants.dart'; // For app configuration

// Public create function
Widget createRequestScreen() {
  return const _RequestScreen();
}

class _RequestScreen extends StatefulWidget {
  //final bool isAttendanceMarked;//Make AttendanceScreen receive the isAttendanceMarked value and update its background color
  const _RequestScreen();
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<_RequestScreen> {
  final MemberService _memberService = MemberService();
  late Future<List<GroupMembers>> _futureData;

  ///get a response for search from service
  Future<List<GroupMembers>> _fetchMyAllGroupsMembers() async {
    try {
      final response = await _memberService
          .fetchMyAllGroupsMembers(Constants.employeeOid //employeeOid
              );
      return response;
        } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureData = _fetchMyAllGroupsMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Members')),
      body: FutureBuilder<List<GroupMembers>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final members = snapshot.data!;
            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, idx) {
                final member = members[idx];

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
