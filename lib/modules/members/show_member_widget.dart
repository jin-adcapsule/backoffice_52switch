import 'package:backoffice52switch/modules/shared/models/group.dart';
import 'package:backoffice52switch/modules/shared/models/location.dart';
import 'package:flutter/material.dart';
import 'package:backoffice52switch/modules/members/member_service.dart';
import 'package:backoffice52switch/modules/shared/dtos/employeeDTO.dart';
import 'package:backoffice52switch/utils/constants.dart'; // For app configuration


class ShowMemberWidget extends StatefulWidget {
  final EmployeeDTO member;
  final List<Location> allLocations;
  final List<Group> allMyGroups;

  const ShowMemberWidget(
    { 
      required this.member,
      required this.allLocations,
      required this.allMyGroups,
      super.key});

  @override
  State<ShowMemberWidget> createState() => _ShowMemberWidgetState();
}

class _ShowMemberWidgetState extends State<ShowMemberWidget> {
  // Define controllers for all editable fields
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _departmentController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _joindateController;
  late TextEditingController _supervisorNameController;
  late TextEditingController _workplaceController;
  late TextEditingController _workhourController;
  late TextEditingController _dayoffPerYearController;

  // To track original and updated data
  late Map<String, String> _originalData;
  late Map<String, String> _updatedData;

  // New controllers for dropdown selections
  String? _selectedWorkplace;
  String? _selectedGroup;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with member's data
    _nameController = TextEditingController(text: widget.member.name);
    _positionController = TextEditingController(text: widget.member.position);
    _departmentController = TextEditingController(text: widget.member.department);
    _emailController = TextEditingController(text: widget.member.email);
    _phoneController = TextEditingController(text: widget.member.phone);
    _joindateController = TextEditingController(text: widget.member.joindate);
    _supervisorNameController = TextEditingController(text: widget.member.supervisorName);
    
    _workhourController = TextEditingController(text: widget.member.workhour);
    _dayoffPerYearController = TextEditingController(
      text: widget.member.dayoffPerYear?.toString() ?? '',
    );

    _workplaceController = TextEditingController();


    // Save original data for comparison
    _originalData = {
      '이름': widget.member.name,
      '직위': widget.member.position,
      '부서': widget.member.department,
      '이메일': widget.member.email,
      '전화번호': widget.member.phone,
      '입사일': widget.member.joindate,
      '승인자': widget.member.supervisorName,
      '근무지명': widget.member.workplace,
      '근무시간': widget.member.workhour,
      '연차일수': widget.member.dayoffPerYear?.toString() ?? '',
    };
    _updatedData = Map.from(_originalData); // Start with identical data
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _joindateController.dispose();
    _supervisorNameController.dispose();
    _workplaceController.dispose();
    _workhourController.dispose();
    _dayoffPerYearController.dispose();
    super.dispose();
  }
void _confirmChanges() {
    // Compare changes and update _updatedData
    _updatedData = {
      '이름': _nameController.text,
      '직위': _positionController.text,
      '부서': _departmentController.text ?? widget.member.department,
      '이메일': _emailController.text,
      '전화번호': _phoneController.text,
      '입사일': _joindateController.text,
      '승인자': _supervisorNameController.text,
      '근무지명': _selectedWorkplace ?? widget.member.workplace,  // Use selected workplace
      '근무시간': _workhourController.text,
      '연차일수': _dayoffPerYearController.text,

    };

    // Identify changed fields
    final changedFields = _updatedData.entries.where((entry) {
      return _originalData[entry.key] != entry.value;
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
                  final originalValue = _originalData[fieldName] ?? '';
                  final updatedValue = entry.value;
                  return Text(
                    '$fieldName: "$originalValue" → "$updatedValue"',
                    style: const TextStyle(fontSize: 14.0),
                  );
                }).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Cancel
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () {
                  _updateMemberInfo();
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
        const SnackBar(content: Text('업데이트 취소')),
      );
    }
  }

  void _updateMemberInfo() {
    // Handle saving updated member info
    setState(() {
      widget.member.name = _nameController.text;
      widget.member.position = _positionController.text;
      widget.member.department = _departmentController.text??widget.member.department;
      widget.member.email = _emailController.text;
      widget.member.phone = _phoneController.text;
      widget.member.joindate = _joindateController.text;
      widget.member.supervisorName = _supervisorNameController.text;
      widget.member.workplace = _selectedWorkplace ?? widget.member.workplace;
      widget.member.workhour = _workhourController.text;
      widget.member.dayoffPerYear = int.tryParse(_dayoffPerYearController.text);
    });

    // Optionally, send updated data to the backend
    //MemberService.updateMember(widget.member);

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
          // Use a Row with Expanded widgets for two columns
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: '이름'),
                      enabled: false, // Makes the field read-only
                    ),
                    TextField(
                      controller: _positionController,
                      decoration: const InputDecoration(labelText: '직위'),
                      enabled: false, // Makes the field read-only
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: '이메일'),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: '전화번호'),
                    ),
                    TextField(
                        controller: _joindateController,
                        decoration: const InputDecoration(labelText: '입사일'),
                        enabled: false, // Makes the field read-only
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0), // Add some spacing between columns
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Group Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGroup?? widget.member.department,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGroup = newValue;
                          });
                        },
                        decoration: const InputDecoration(labelText: '그룹'),
                        items: widget.allMyGroups.map<DropdownMenuItem<String>>((Group group) {
                          return DropdownMenuItem<String>(
                            value: group.groupName, // Assuming `Group` has a `groupName` property
                            child: Text(group.groupName), // Display the group name
                          );
                        }).toList(),
                      ),
                      TextField(
                        controller: _supervisorNameController,
                        decoration: const InputDecoration(labelText: '승인자'),
                        enabled: false, // Makes the field read-only
                      ),
                      // Location Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedWorkplace?? widget.member.workplace ,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedWorkplace = newValue;
                          });
                        },
                        decoration: const InputDecoration(labelText: '근무지'),
                        items: widget.allLocations.map<DropdownMenuItem<String>>((Location location) {
                          return DropdownMenuItem<String>(
                            value: location.workplace, // Assuming `Location` has a `name` property
                            child: Text(location.workplace), // Display the workplace name
                          );
                        }).toList(),
                      ),
                      
                      
                      TextField(
                        controller: _workhourController,
                        decoration: const InputDecoration(labelText: '근무시간'),
                        enabled: false, // Makes the field read-only
                      ),
                      TextField(
                        controller: _dayoffPerYearController,
                        decoration: const InputDecoration(labelText: '연차일수'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
