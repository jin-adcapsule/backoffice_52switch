import 'package:flutter/material.dart';


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
  final List<Map<String, String>> employees = [
    {'name': 'John Doe', 'position': 'Developer'},
    {'name': 'Jane Smith', 'position': 'Designer'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employees')),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(employees[index]['name']!),
            subtitle: Text(employees[index]['position']!),
          );
        },
      ),
    );
  }
}