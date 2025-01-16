import 'package:backoffice52switch/modules/shared/dtos/indexDTO.dart';
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
  final Map<String,dynamic> collectionInfoMap;
  final List<IndexDTO> indexData;
  // final List<Location> allLocations;
  // final List<Group> allMyGroups;

  const ShowRecordWidget(
    { 
      required this.record,
      required this.collectionKey,
      required this.collectionInfoMap,
      required this.indexData,
      // required this.allLocations,
      // required this.allMyGroups,
      super.key});

  @override
  State<ShowRecordWidget> createState() => _ShowRecordWidgetState();
}

class _ShowRecordWidgetState extends State<ShowRecordWidget> {
  // Map to hold TextEditingController for each field dynamically
  late Map<String, dynamic> _controllers;//controllertype will be determined on initstate
  late Map<String, dynamic> _keyTypes;
  final SuperAdminService _superAdminService = SuperAdminService();
  late Map<String,dynamic> collectionInfoMap;
  late List<IndexDTO> indexData;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with member's data dynamically from the record
    _controllers = {};
    collectionInfoMap = widget.collectionInfoMap;
    indexData=widget.indexData;
    _keyTypes={};
    // Iterate through the record map to create TextEditingControllers dynamically
    widget.record!.forEach((key, value) {///////////////////////////////////preprocessing for input 
      final keyType = collectionInfoMap['keyTypeMap'][key];
      if (keyType != null){// Handle based on the keyType
        _keyTypes[key] = keyType;
        if (keyType == 'strDate') {
          // Handle as a string (e.g., date as string)
          _controllers[key] = TextEditingController(text: value?.toString() ?? '');
        } else if (keyType == 'strTime') {
          // Handle as a reference ID (e.g., dropdown)
          _controllers[key] = TextEditingController(text: value?.toString() ?? '');
        }
        else if (keyType == 'longDateTime') {
          // Handle as a reference ID (e.g., dropdown)
          _controllers[key] = TextEditingController(text: value?.toString() ?? '');
        }
        else if (keyType == 'bool') {
           _controllers[key] = value != null 
          ? value.toString()  // Convert bool to string for the dropdown
          : 'false';  // Default to false if null
        }
        else if (keyType == 'refId') {
          // Handle as a reference ID (e.g., dropdown)
          _controllers[key] = value?.toString();  
        }
        else {
          _controllers[key] = TextEditingController();  // Default case
        }
      } else{//not specified so standard int or string
         if (value is int) {
         _keyTypes[key] = 'int';
        _controllers[key] = TextEditingController(text: value.toString());
        } else if (value is String) {
          _keyTypes[key] = 'string';
        _controllers[key] = TextEditingController(text: value);
      }else {
          _keyTypes[key] = null;
          _controllers[key] = TextEditingController();  // Default case
        }
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
    
    _controllers.forEach((key, controller) { ///////////////////////////////////postprocessing for backendquery_keyTypes[fieldName]=='refId'

      
      // For int values, ensure that we parse the value correctly
      if (_keyTypes[key]=='int') {
        
        updatedData[key]  = int.tryParse(controller.text) ?? 0;
      
      }else if (_keyTypes[key]=='refId'||_keyTypes[key]=='bool') {
        updatedData[key]  = controller;
      
      }else {//String
        updatedData[key]  = controller.text;
      }

    
    });

    // Identify changed fields
    final changedFields = updatedData.entries.where((entry) {
      return widget.record?[entry.key] != entry.value;
    }).toList();
    // Create a map for the changed data (only the changed fields)
    final Map<String, dynamic> changedData = {
      for (var entry in changedFields)
        entry.key: entry.value,
    };

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
                  updateRecord(changedData);
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

  Future<void> updateRecord(Map<String, dynamic> changedData) async {
    late bool success= false;
    // Call the update service here
    if(widget.collectionKey=="Employee"){
      success = await _superAdminService.updateEmployee(widget.record?[collectionInfoMap['idxKey']],changedData);
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
    //Navigator.pop(context);
  }
  // Helper function to filter IndexDTO to get Show Value options from Index Key
  List<IndexDTO> getFilteredIndexShowValueList(List<IndexDTO> indexData, String fieldName) {
    // Check if the indexKey is in refIdKeyConverter and update if necessary
    if (Constants.refIdKeyConverter.containsKey(fieldName)) {
      fieldName = Constants.refIdKeyConverter[fieldName].toString();
    }
    return indexData.where((indexDTO) {
      // Check if the indexDTO's indexKey matches the fieldName
      return indexDTO.indexKey == fieldName;
    }).toList();
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
      child: SingleChildScrollView(  // Wrap the Column with SingleChildScrollView to avoid overflow
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${collectionInfoMap['label']} 정보 수정",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          // Dynamically generate TextField widgets based on the record's keys
          ...widget.record!.entries.map((entry) {
            String fieldName = entry.key;
            var controller = _controllers[fieldName];
            // Check if the controller is a TextEditingController
            if (controller is TextEditingController) {///////////////////////////////////main processing input
              return TextField(
                controller: controller,
                decoration: InputDecoration(labelText: fieldName),
                enabled: !collectionInfoMap['disabledKeys'].contains(fieldName),  // Disable fields that are in the label list
              );
            } else if (controller is String && _keyTypes[fieldName] == 'bool') {
              // If it's a boolean, use a DropdownButtonFormField
              return DropdownButtonFormField<String>(
                value: controller.isEmpty ? null : controller, // Make sure the value is set correctly
                items: const [
                  DropdownMenuItem<String>(
                    value: 'true',
                    child: Text('True'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'false',
                    child: Text('False'),
                  ),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _controllers[fieldName] = newValue!;
                  });
                },
                decoration:  InputDecoration(labelText: fieldName), // Label for the dropdown
              );
            } else if (controller is String && _keyTypes[fieldName] == 'refId') {
              // If it's a refId, use a DropdownButtonFormField
              return DropdownButtonFormField<String>(
                value: controller.isEmpty ? null : controller, // Ensure the selected value is properly set
                items: getFilteredIndexShowValueList(indexData, fieldName).map((indexDTO) {
                  return DropdownMenuItem<String>(
                    value: indexDTO.indexValue, // Use the indexValue as the value
                    child: Text(indexDTO.indexShowValue), // Display the indexShowValue
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _controllers[fieldName] = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: fieldName), // Dynamic label for the dropdown
              );
            

    
            } else {
              // Default case (can be extended for other types)
              return Container();  // Return an empty container or other default widget
            }
          
        
          }),
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
      )
    );
  }
}
