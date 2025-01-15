import 'package:backoffice52switch/modules/shared/models/employee.dart';
import 'package:backoffice52switch/modules/shared/models/group.dart';
import 'package:backoffice52switch/modules/shared/models/location.dart';
import 'package:backoffice52switch/modules/superadmin/super_admin_service.dart';
import 'package:flutter/material.dart';
import 'package:backoffice52switch/modules/members/member_service.dart';
import 'package:backoffice52switch/modules/shared/dtos/employeeDTO.dart';
import 'package:backoffice52switch/utils/constants.dart'; // For app configuration


class ShowRecordWidget extends StatefulWidget {
  final Map<String, dynamic>? record;
  final String collectionKey;
  // final List<Location> allLocations;
  // final List<Group> allMyGroups;

  const ShowRecordWidget(
    { 
      required this.record,
      required this.collectionKey,
      // required this.allLocations,
      // required this.allMyGroups,
      super.key});

  @override
  State<ShowRecordWidget> createState() => _ShowRecordWidgetState();
}

class _ShowRecordWidgetState extends State<ShowRecordWidget> {
  // Map to hold TextEditingController for each field dynamically
  late Map<String, TextEditingController> _controllers;
  final SuperAdminService _superAdminService = SuperAdminService();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with member's data dynamically from the record
    _controllers = {};

    // Iterate through the record map to create TextEditingControllers dynamically
    widget.record?.forEach((key, value) {
      // If the value is an integer, convert it to a string
      if (value is int) {
        _controllers[key] = TextEditingController(text: value.toString());
      } else if (value is String) {
        _controllers[key] = TextEditingController(text: value);
      } else {
        _controllers[key] = TextEditingController();  // Default case
      }
    });
  }


  @override
  void dispose() {
    // Dispose all controllers dynamically
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }
  void _confirmChanges() {
    // Create a map to store updated data from the controllers
    final Map<String, dynamic> updatedData = {};

    _controllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        // For int values, ensure that we parse the value correctly
        if (widget.record?[key] is int) {
          updatedData[key] = int.tryParse(controller.text) ?? 0;
        } else {
          updatedData[key] = controller.text;
        }
      }
    });
    // Identify changed fields
    final changedFields = updatedData.entries.where((entry) {
      return widget.record?[entry.key] != entry.value;
    }).toList();

    // Show a confirmation dialog if changes exist
    if (changedFields.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('다음과 같이 변경됩니다:'),
                const SizedBox(height: 8.0),
                ...changedFields.map((entry) {
                  final fieldName = entry.key;
                  final originalValue = widget.record?[fieldName] ?? '';
                  final updatedValue = entry.value;
                  return Text(
                    '$fieldName: "$originalValue" → "$updatedValue"',
                    style: const TextStyle(fontSize: 14.0),
                  );
                }),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Cancel
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () {
                  updateRecord(updatedData);
                  Navigator.pop(context); // Close confirmation dialog
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    } else {
      // No changes made
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('업데이트 취소: 변경 내용 없음')),
      );
    }
  }

  Future<void> updateRecord(Map<String, dynamic> updatedData) async {
    late bool success= false;
    // Call the update service here
    if(widget.collectionKey=="Employee"){
      success = await _superAdminService.updateEmployee(updatedData);
    }
    if (success) {
      // Handle successful update, e.g., show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('업데이트 성공')),
      );
    } else {
      // Handle failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('업데이트 실패')),
      );
    }
    Navigator.pop(context); // Close confirmation dialog
    
    // Close the modal
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '팀원 정보 수정',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          // Dynamically generate TextField widgets based on the record's keys
          ...widget.record!.entries.map((entry) {
            String fieldName = entry.key;
            return TextField(
              controller: _controllers[fieldName],
              decoration: InputDecoration(labelText: fieldName),
              enabled: fieldName != '이름' && fieldName != '직위' && fieldName != '입사일' && fieldName != '승인자', // Example: disable specific fields
            );
          }).toList(),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context), // Cancel button
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: _confirmChanges, // Save changes
                child: const Text('업데이트'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
