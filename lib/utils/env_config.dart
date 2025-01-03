//-ignored credential or environment dependant data


class EnvConfig {
  // Get the host address for the platform
  static String get hostAddress => const String.fromEnvironment('HOST_ADDRESS', defaultValue: 'localhost');

  // Get the port number for the platform
  static int get serverPort => const int.fromEnvironment('SERVER_PORT', defaultValue: 8080);

  // Check if we should use the emulator
  static bool get useEmulator => const bool.fromEnvironment('USE_EMULATOR', defaultValue: false);

  // Get the emulator port if needed
  static int get emulatorPort => const int.fromEnvironment('EMULATOR_PORT', defaultValue: 9099);
  
  // Get the API URL (constructed dynamically)
  static String get apiUrl => 'http://$hostAddress:$serverPort/graphql';



}
