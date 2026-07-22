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

  static const String _tvLocalIpKey = 'tv_local_ip';
  static const String _defaultTvLocalIp = '192.168.1.4';
  static const String _tvTailscaleIpKey = 'tv_tailscale_ip';
  static const String _defaultTvTailscaleIp = '100.117.222.75';
  static const String _tvUserKey = 'tv_user';
  static const String _defaultTvUser = 'yanli';
  static const String _tvPassKey = 'tv_pass';
  static const String _defaultTvPass = '123';

  static const String _piIpKey = 'pi_ip';
  static const String _defaultPiIp = '192.168.1.2';
  static const String _piUserKey = 'pi_user';
  static const String _defaultPiUser = 'pi';
  static const String _piPassKey = 'pi_pass';
  static const String _defaultPiPass = '123';

  static const String _zeroIpKey = 'zero_ip';
  static const String _defaultZeroIp = '192.168.1.3';
  static const String _zeroUserKey = 'zero_user';
  static const String _defaultZeroUser = 'zero';
  static const String _zeroPassKey = 'zero_pass';
  static const String _defaultZeroPass = '123';

  static const String _useExternalSshAppKey = 'use_external_ssh_app';
  static const bool _defaultUseExternalSshApp = false;

  String _ipAddress = _defaultIp;
  String _macAddress = _defaultMac;
  String _tailscaleIp = _defaultTailscaleIp;
  String _haLocalUrl = _defaultHaLocalUrl;
  String _haTailscaleUrl = _defaultHaTailscaleUrl;
  String _haToken = _defaultHaToken;
  String _haSensorEntity = _defaultHaSensorEntity;
  String _haSwitchEntity = _defaultHaSwitchEntity;

  String _tvLocalIp = _defaultTvLocalIp;
  String _tvTailscaleIp = _defaultTvTailscaleIp;
  String _tvUser = _defaultTvUser;
  String _tvPass = _defaultTvPass;
  String _piIp = _defaultPiIp;
  String _piUser = _defaultPiUser;
  String _piPass = _defaultPiPass;
  String _zeroIp = _defaultZeroIp;
  String _zeroUser = _defaultZeroUser;
  String _zeroPass = _defaultZeroPass;
  bool _useExternalSshApp = _defaultUseExternalSshApp;

  SharedPreferences? _prefs;

  String get ipAddress => _ipAddress;
  String get macAddress => _macAddress;
  String get tailscaleIp => _tailscaleIp;
  String get haLocalUrl => _haLocalUrl;
  String get haTailscaleUrl => _haTailscaleUrl;
  String get haToken => _haToken;
  String get haSensorEntity => _haSensorEntity;
  String get haSwitchEntity => _haSwitchEntity;

  String get tvLocalIp => _tvLocalIp;
  String get tvTailscaleIp => _tvTailscaleIp;
  String get tvUser => _tvUser;
  String get tvPass => _tvPass;
  String get piIp => _piIp;
  String get piUser => _piUser;
  String get piPass => _piPass;
  String get zeroIp => _zeroIp;
  String get zeroUser => _zeroUser;
  String get zeroPass => _zeroPass;
  bool get useExternalSshApp => _useExternalSshApp;

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

    _tvLocalIp = _prefs?.getString(_tvLocalIpKey) ?? _defaultTvLocalIp;
    _tvTailscaleIp = _prefs?.getString(_tvTailscaleIpKey) ?? _defaultTvTailscaleIp;
    _tvUser = _prefs?.getString(_tvUserKey) ?? _defaultTvUser;
    _tvPass = _prefs?.getString(_tvPassKey) ?? _defaultTvPass;
    _piIp = _prefs?.getString(_piIpKey) ?? _defaultPiIp;
    _piUser = _prefs?.getString(_piUserKey) ?? _defaultPiUser;
    _piPass = _prefs?.getString(_piPassKey) ?? _defaultPiPass;
    _zeroIp = _prefs?.getString(_zeroIpKey) ?? _defaultZeroIp;
    _zeroUser = _prefs?.getString(_zeroUserKey) ?? _defaultZeroUser;
    _zeroPass = _prefs?.getString(_zeroPassKey) ?? _defaultZeroPass;
    _useExternalSshApp = _prefs?.getBool(_useExternalSshAppKey) ?? _defaultUseExternalSshApp;

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

  Future<void> setTvLocalIp(String ip) async {
    _tvLocalIp = ip;
    notifyListeners();
    await _prefs?.setString(_tvLocalIpKey, ip);
  }

  Future<void> setTvTailscaleIp(String ip) async {
    _tvTailscaleIp = ip;
    notifyListeners();
    await _prefs?.setString(_tvTailscaleIpKey, ip);
  }

  Future<void> setTvUser(String user) async {
    _tvUser = user;
    notifyListeners();
    await _prefs?.setString(_tvUserKey, user);
  }

  Future<void> setTvPass(String pass) async {
    _tvPass = pass;
    notifyListeners();
    await _prefs?.setString(_tvPassKey, pass);
  }

  Future<void> setPiIp(String ip) async {
    _piIp = ip;
    notifyListeners();
    await _prefs?.setString(_piIpKey, ip);
  }

  Future<void> setPiUser(String user) async {
    _piUser = user;
    notifyListeners();
    await _prefs?.setString(_piUserKey, user);
  }

  Future<void> setPiPass(String pass) async {
    _piPass = pass;
    notifyListeners();
    await _prefs?.setString(_piPassKey, pass);
  }

  Future<void> setZeroIp(String ip) async {
    _zeroIp = ip;
    notifyListeners();
    await _prefs?.setString(_zeroIpKey, ip);
  }

  Future<void> setZeroUser(String user) async {
    _zeroUser = user;
    notifyListeners();
    await _prefs?.setString(_zeroUserKey, user);
  }

  Future<void> setZeroPass(String pass) async {
    _zeroPass = pass;
    notifyListeners();
    await _prefs?.setString(_zeroPassKey, pass);
  }

  Future<void> setUseExternalSshApp(bool value) async {
    _useExternalSshApp = value;
    notifyListeners();
    await _prefs?.setBool(_useExternalSshAppKey, value);
  }
}
