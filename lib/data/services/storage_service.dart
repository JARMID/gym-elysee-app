import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/storage_keys.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;
  
  StorageService(this._secureStorage, this._prefs);
  
  // Token management
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: StorageKeys.accessToken, value: token);
  }
  
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: StorageKeys.accessToken);
  }
  
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: StorageKeys.refreshToken, value: token);
  }
  
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: StorageKeys.refreshToken);
  }
  
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: StorageKeys.accessToken);
    await _secureStorage.delete(key: StorageKeys.refreshToken);
  }
  
  // User data
  Future<void> saveUserData(String userData) async {
    await _prefs.setString(StorageKeys.userData, userData);
  }
  
  Future<String?> getUserData() async {
    return _prefs.getString(StorageKeys.userData);
  }
  
  Future<void> clearUserData() async {
    await _prefs.remove(StorageKeys.userData);
  }
  
  // Settings
  Future<bool> isFirstLaunch() async {
    return _prefs.getBool(StorageKeys.isFirstLaunch) ?? true;
  }
  
  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool(StorageKeys.isFirstLaunch, value);
  }
  
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(StorageKeys.isOnboardingCompleted) ?? false;
  }
  
  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(StorageKeys.isOnboardingCompleted, value);
  }
  
  Future<String?> getSelectedLanguage() async {
    return _prefs.getString(StorageKeys.selectedLanguage);
  }
  
  Future<void> setSelectedLanguage(String language) async {
    await _prefs.setString(StorageKeys.selectedLanguage, language);
  }
  
  Future<bool> isRamadanModeEnabled() async {
    return _prefs.getBool(StorageKeys.ramadanModeEnabled) ?? false;
  }
  
  Future<void> setRamadanModeEnabled(bool enabled) async {
    await _prefs.setBool(StorageKeys.ramadanModeEnabled, enabled);
  }
  
  Future<bool> isDarkModeEnabled() async {
    return _prefs.getBool(StorageKeys.darkModeEnabled) ?? true;
  }
  
  Future<void> setDarkModeEnabled(bool enabled) async {
    await _prefs.setBool(StorageKeys.darkModeEnabled, enabled);
  }
  
  // Cache
  Future<void> saveCache(String key, String value) async {
    await _prefs.setString(key, value);
  }
  
  Future<String?> getCache(String key) async {
    return _prefs.getString(key);
  }
  
  Future<void> clearCache() async {
    await _prefs.remove(StorageKeys.cachedBranches);
    await _prefs.remove(StorageKeys.cachedPrograms);
    await _prefs.remove(StorageKeys.lastSyncTimestamp);
  }
  
  // Clear all data (logout)
  Future<void> clearAll() async {
    await clearTokens();
    await clearUserData();
    await clearCache();
  }
}

