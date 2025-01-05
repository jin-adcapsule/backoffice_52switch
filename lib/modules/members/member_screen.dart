import 'package:flutter/material.dart';
import 'package:backoffice52switch/modules/members/member_service.dart';
import 'package:backoffice52switch/modules/shared/models/employee.dart';
import 'package:backoffice52switch/utils/constants.dart'; // For app configuration

// Public create function
Widget createMemberScreen() {
  return _MemberScreen();
}

class _MemberScreen extends StatefulWidget {
  //final bool isAttendanceMarked;//Make AttendanceScreen receive the isAttendanceMarked value and update its background color
  const _MemberScreen();
  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<_MemberScreen> {
  final MemberService _memberService = MemberService();
  late Future<List<Employee>> _futureData;

  ///get a response for search from service
  Future<List<Employee>> _fetchMyAllGroupsMembers() async {
    try {
      final response = await _memberService
          .fetchMyAllGroupsMembers(Constants.objectId //employeeOid
              );
      if (response != null) {
        return response;
      } else {
        throw Exception('response is null');
      }
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
      body: FutureBuilder<List<Employee>>(
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
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(member.name),
                  subtitle: Text(member.position),
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
