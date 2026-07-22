import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _ipAddressKey = 'ip_address';
  static const String _defaultIp = '192.168.1.100';
  static const String _macAddressKey = 'mac_address';
  static const String _defaultMac = '00:00:00:00:00:00';
  static const String _tailscaleIpKey = 'tailscale_ip';
  static const String _defaultTailscaleIp = '100.117.222.75';

  static const String _haLocalUrlKey = 'ha_local_url';
  static const String _defaultHaLocalUrl = 'http://192.168.1.4:8123';
  static const String _haTailscaleUrlKey = 'ha_tailscale_url';
  static const String _defaultHaTailscaleUrl = 'http://100.117.222.75:8123';
  static const String _haTokenKey = 'ha_token';
  static const String _defaultHaToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI1ZjkwNWE5ZWY5MWE0NWIwYjc2ZjdmZmJiMDM1NDg3OSIsImlhdCI6MTc4NDY5OTM4MCwiZXhwIjoyMTAwMDU5MzgwfQ.lanOu2nVdWGaAMopyp7hMQR-7Ln8csvcZJNbU-8hguw';
  static const String _haSensorEntityKey = 'ha_sensor_entity';
  static const String _defaultHaSensorEntity = 'binary_sensor.192_168_1_100';
  static const String _haSwitchEntityKey = 'ha_switch_entity';
  static const String _defaultHaSwitchEntity = 'switch.desktop_pc';

  String _ipAddress = _defaultIp;
  String _macAddress = _defaultMac;
  String _tailscaleIp = _defaultTailscaleIp;
  String _haLocalUrl = _defaultHaLocalUrl;
  String _haTailscaleUrl = _defaultHaTailscaleUrl;
  String _haToken = _defaultHaToken;
  String _haSensorEntity = _defaultHaSensorEntity;
  String _haSwitchEntity = _defaultHaSwitchEntity;
  SharedPreferences? _prefs;

  String get ipAddress => _ipAddress;
  String get macAddress => _macAddress;
  String get tailscaleIp => _tailscaleIp;
  String get haLocalUrl => _haLocalUrl;
  String get haTailscaleUrl => _haTailscaleUrl;
  String get haToken => _haToken;
  String get haSensorEntity => _haSensorEntity;
  String get haSwitchEntity => _haSwitchEntity;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ipAddress = _prefs?.getString(_ipAddressKey) ?? _defaultIp;
    _macAddress = _prefs?.getString(_macAddressKey) ?? _defaultMac;
    _tailscaleIp = _prefs?.getString(_tailscaleIpKey) ?? _defaultTailscaleIp;
    _haLocalUrl = _prefs?.getString(_haLocalUrlKey) ?? _defaultHaLocalUrl;
    _haTailscaleUrl = _prefs?.getString(_haTailscaleUrlKey) ?? _defaultHaTailscaleUrl;
    _haToken = _prefs?.getString(_haTokenKey) ?? _defaultHaToken;
    _haSensorEntity = _prefs?.getString(_haSensorEntityKey) ?? _defaultHaSensorEntity;
    _haSwitchEntity = _prefs?.getString(_haSwitchEntityKey) ?? _defaultHaSwitchEntity;
    notifyListeners();
  }

  Future<void> setIpAddress(String ip) async {
    _ipAddress = ip;
    notifyListeners();
    await _prefs?.setString(_ipAddressKey, ip);
  }

  Future<void> setMacAddress(String mac) async {
    _macAddress = mac;
    notifyListeners();
    await _prefs?.setString(_macAddressKey, mac);
  }

  Future<void> setTailscaleIp(String ip) async {
    _tailscaleIp = ip;
    notifyListeners();
    await _prefs?.setString(_tailscaleIpKey, ip);
  }

  Future<void> setHaLocalUrl(String url) async {
    _haLocalUrl = url;
    notifyListeners();
    await _prefs?.setString(_haLocalUrlKey, url);
  }

  Future<void> setHaTailscaleUrl(String url) async {
    _haTailscaleUrl = url;
    notifyListeners();
    await _prefs?.setString(_haTailscaleUrlKey, url);
  }

  Future<void> setHaToken(String token) async {
    _haToken = token;
    notifyListeners();
    await _prefs?.setString(_haTokenKey, token);
  }

  Future<void> setHaSensorEntity(String entity) async {
    _haSensorEntity = entity;
    notifyListeners();
    await _prefs?.setString(_haSensorEntityKey, entity);
  }

  Future<void> setHaSwitchEntity(String entity) async {
    _haSwitchEntity = entity;
    notifyListeners();
    await _prefs?.setString(_haSwitchEntityKey, entity);
  }
}
