import 'package:backoffice52switch/modules/groups/group_screen.dart';
import 'package:flutter/foundation.dart'; // For platform detection
import 'package:flutter/material.dart';
import 'package:backoffice52switch/modules/members/member_screen.dart';
import 'package:backoffice52switch/modules/requests/request_screen.dart';
import 'package:backoffice52switch/modules/superadmin/super_admin_screen.dart';
import 'package:backoffice52switch/utils/constants.dart'; // For app configuration

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  final String employeeOid = Constants.employeeOid; // Use from config
  // Cache for storing created screens
  //final Map<String, Widget> _screenCache = {};
  final Map<String, Widget Function()> _screenCache = {};

  void _onItemTapped(String key) {
    setState(() {
      Constants.selectedKeyNotifier.value = key; // Update the notifier
    });
  }

  List<Map<String, dynamic>> getTabs() {
    return Constants.tabConfig.toList();
  }

  Widget _getSelectedScreen(String selectedKey) {
    if (_screenCache.containsKey(selectedKey)) {
      return _screenCache[
          selectedKey]!(); // Call the cached function to create a fresh screen
    }
    // If the screen isn't cached, create a factory function and store it in the Map
    Widget Function() screenFactory;
    switch (selectedKey) {
      case 'members':
        screenFactory = () => createMemberScreen();
        break;
      case 'groups':
        screenFactory = () => createGroupScreen();
        break;
      case 'requests':
        screenFactory = () => createRequestScreen();
        break;
      case 'superadmin':
        screenFactory = () => createSuperAdminScreen();
        break;
      default:
        screenFactory = () => createMemberScreen();
        break;
    }
    // Store the factory in the cache
    _screenCache[selectedKey] = screenFactory;

    return screenFactory();
  }

//buildformat
  @override
  Widget build(BuildContext context) {


    const double menuExpandedSize =Constants.menuExpandedSize;
    const double menuCollapsedSize =Constants.menuCollapsedSize;
    final menuWidth = Constants.menuWidth; // Initial width of the menu


    return ValueListenableBuilder<String>(
      valueListenable: Constants.selectedKeyNotifier,
      builder: (context, selectedKey, child) {
        final tabs = getTabs();
        // For Web or Large Screens: Use Vertical Menu
        if (Constants.isWebOrDesktop) {
          return Scaffold(
            body: Row(
              children: [
                // Left Vertical Menu
                ValueListenableBuilder<double>(
                  valueListenable: menuWidth,
                  builder: (context, width, child) {
                    final isCollapsed = width == menuCollapsedSize; // Check if the menu is collapsed

                    return Container(
                      width: width, // Set width as 20% of the screen width
                      color: Constants.getColor(ColorType.background),
                      child: Column(
                        children: [
                          // Collapse/Expand Menu Item
                          ListTile(
                            leading: Icon(
                              isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                              color: Constants.getColor(ColorType.selectedItem),
                            ),
                            title: isCollapsed
                                ? null // Hide text when collapsed
                                : Text(
                                    'Menu',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.getColor(ColorType.selectedItem),
                                    ),
                                  ),
                            onTap: () {
                              // Toggle the menu width
                              menuWidth.value =
                                  isCollapsed ? menuExpandedSize : menuCollapsedSize;
                            },
                          ),
                          Divider(color: Constants.getColor(ColorType.unselectedItem)),

                          Expanded(
                            child: ListView.builder(
                              itemCount: tabs.length,
                              itemBuilder: (context, index) {
                                final tab = tabs[index];
                                final isSelected = tab['key'] == selectedKey;
                                return ListTile(
                                  leading: Icon(
                                    tab['icon'],
                                    color: isSelected
                                        ? Constants.getColor(ColorType.selectedItem)
                                        : Constants.getColor(
                                            ColorType.unselectedItem),
                                  ),
                                  title: isCollapsed
                                    ? null // Hide text if the menu is collapsed
                                    : Text(
                                      tab['label'],
                                      style: TextStyle(
                                        color: isSelected
                                            ? Constants.getColor(
                                                ColorType.selectedItem)
                                            : Constants.getColor(
                                                ColorType.unselectedItem),
                                      ),
                                    ),
                                  selected: isSelected,
                                  onTap: () => _onItemTapped(tab['key']),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
                // Main Content Area - Modified for scrolling
                Expanded(  // Replace Container with Expanded
                  child:_getSelectedScreen(selectedKey)
                      
                    
                  
                ),
         
                
              ],
            ),
          );
        }

        // For Mobile: Use Bottom Navigation Bar
        return Scaffold(
          body: _getSelectedScreen(selectedKey),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Constants.getColor(ColorType.background),
            elevation: 0,
            items: tabs.map((tab) {
              return BottomNavigationBarItem(
                icon: Icon(tab['icon']),
                label: tab['label'],
              );
            }).toList(),
            currentIndex: tabs.indexWhere((tab) => tab['key'] == selectedKey),
            onTap: (index) => _onItemTapped(tabs[index]['key']),
            selectedItemColor: Constants.getColor(ColorType.selectedItem),
            unselectedItemColor: Constants.getColor(ColorType.unselectedItem),
            showUnselectedLabels: true,
          ),
        );
      },
    );
  }
}
