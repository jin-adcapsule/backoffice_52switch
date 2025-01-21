
import 'package:backoffice52switch/modules/shared/models/group.dart';
import 'package:backoffice52switch/modules/shared/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:backoffice52switch/utils/constants.dart';
import 'package:graphview/GraphView.dart';

// Public create function
Widget createGroupScreen() {
  return const _GroupScreen();
}

class _GroupScreen extends StatefulWidget {
  //final bool isAttendanceMarked;//Make AttendanceScreen receive the isAttendanceMarked value and update its background color
  const _GroupScreen();
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<_GroupScreen> {
  final GlobalService _globalService = GlobalService();
  late Future<List<Group>> _futureData;

  ///get a response for search from service
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

  @override
  void initState() {
    super.initState();
    _futureData = _fetchMyAllGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              Constants.getAppbarTitle(Constants.selectedKeyNotifier.value),
              style: TextStyle(color: Constants.getColor(ColorType.text)))),
      body: FutureBuilder<List<Group>>(
        future: _futureData, // Fetch data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final groups = snapshot.data!;

            // Create the graph
            final graph = Graph();

            // Create nodes for each group
            final nodesMap = <String, Node>{};
            for (var group in groups) {
              nodesMap[group.groupId] = Node.Id(group.groupId);
            }

            // Add edges based on parent-child relationships
            for (var group in groups) {
              if (group.parentGroupId != null) {
                final parentNode = nodesMap[group.parentGroupId];
                final childNode = nodesMap[group.groupId];
                if (parentNode != null && childNode != null) {
                  graph.addEdge(parentNode, childNode);
                }
              }
            }

            return GraphView(
              graph: graph,
              algorithm: BuchheimWalkerAlgorithm(
                BuchheimWalkerConfiguration(),
                null, // Use null if you don't need a custom edge renderer
              ),
              builder: (Node node) {
                final group =
                    groups.firstWhere((g) => g.groupId == node.key.toString());
                return RectangleAvatar(group);
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
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
