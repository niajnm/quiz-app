// import 'package:flutter_assessment/app/data/local/preference/pref_manager.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class PrefManagerImpl implements PrefManager {
//   final storage = const FlutterSecureStorage();

//   @override
//   Future<void> setString(String key, value) async {
//     await storage.write(key: key, value: value);
//   }

//   @override
//   Future<String?> getString(String key) async {
//     final result = await storage.read(key: key);
//     return result ?? "";
//   }
// }
