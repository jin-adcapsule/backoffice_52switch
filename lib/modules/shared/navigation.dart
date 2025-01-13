import 'package:backoffice52switch/modules/groups/group_screen.dart';
import 'package:flutter/foundation.dart'; // For platform detection
import 'package:flutter/material.dart';
import 'package:backoffice52switch/modules/members/member_screen.dart';
import 'package:backoffice52switch/modules/requests/request_screen.dart';
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
    // Check if the platform is web or mobile
    const isWeb = kIsWeb; // Returns true for web apps
    final isLargeScreen =
        MediaQuery.of(context).size.width > 800; // Adjust breakpoint as needed

    return ValueListenableBuilder<String>(
      valueListenable: Constants.selectedKeyNotifier,
      builder: (context, selectedKey, child) {
        final tabs = getTabs();
        // For Web or Large Screens: Use Vertical Menu
        if (isWeb || isLargeScreen) {
          return Scaffold(
            body: Row(
              children: [
                // Left Vertical Menu
                Container(
                  width: 250, // Set the width of the vertical menu
                  color: Constants.getColor(ColorType.background),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Menu',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Constants.getColor(ColorType.selectedItem),
                          ),
                        ),
                      ),
                      Divider(
                          color: Constants.getColor(ColorType.unselectedItem)),
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
                              title: Text(
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
                ),
                // Main Content Area
                Expanded(
                  child: _getSelectedScreen(selectedKey),
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
