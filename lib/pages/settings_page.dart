import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  final SettingsService settingsService;

  const SettingsPage({super.key, required this.settingsService});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _ipController;
  late TextEditingController _macController;
  late TextEditingController _tailscaleIpController;
  late TextEditingController _haLocalUrlController;
  late TextEditingController _haTailscaleUrlController;
  late TextEditingController _haTokenController;
  late TextEditingController _haSensorController;
  late TextEditingController _haSwitchController;
  bool _darkMode = false;
  double _fontSize = 16;
  bool _haExpanded = true;

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController(text: widget.settingsService.ipAddress);
    _macController = TextEditingController(text: widget.settingsService.macAddress);
    _tailscaleIpController = TextEditingController(text: widget.settingsService.tailscaleIp);
    _haLocalUrlController = TextEditingController(text: widget.settingsService.haLocalUrl);
    _haTailscaleUrlController = TextEditingController(text: widget.settingsService.haTailscaleUrl);
    _haTokenController = TextEditingController(text: widget.settingsService.haToken);
    _haSensorController = TextEditingController(text: widget.settingsService.haSensorEntity);
    _haSwitchController = TextEditingController(text: widget.settingsService.haSwitchEntity);
  }

  @override
  void dispose() {
    _ipController.dispose();
    _macController.dispose();
    _tailscaleIpController.dispose();
    _haLocalUrlController.dispose();
    _haTailscaleUrlController.dispose();
    _haTokenController.dispose();
    _haSensorController.dispose();
    _haSwitchController.dispose();
    super.dispose();
  }

  void _saveIp() {
    final ip = _ipController.text.trim();
    if (ip.isNotEmpty) {
      widget.settingsService.setIpAddress(ip);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IP地址已保存')),
      );
    }
  }

  void _saveMac() {
    final mac = _macController.text.trim();
    if (mac.isNotEmpty) {
      widget.settingsService.setMacAddress(mac);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('MAC地址已保存')),
      );
    }
  }

  void _saveTailscaleIp() {
    final ip = _tailscaleIpController.text.trim();
    if (ip.isNotEmpty) {
      widget.settingsService.setTailscaleIp(ip);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tailscale IP已保存')),
      );
    }
  }

  void _saveHaLocalUrl() {
    final url = _haLocalUrlController.text.trim();
    if (url.isNotEmpty) {
      widget.settingsService.setHaLocalUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('局域网HA地址已保存')),
      );
    }
  }

  void _saveHaTailscaleUrl() {
    final url = _haTailscaleUrlController.text.trim();
    if (url.isNotEmpty) {
      widget.settingsService.setHaTailscaleUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tailscale HA地址已保存')),
      );
    }
  }

  void _saveHaToken() {
    final token = _haTokenController.text.trim();
    if (token.isNotEmpty) {
      widget.settingsService.setHaToken(token);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('HA密钥已保存')),
      );
    }
  }

  void _saveHaSensor() {
    final entity = _haSensorController.text.trim();
    if (entity.isNotEmpty) {
      widget.settingsService.setHaSensorEntity(entity);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('传感器实体已保存')),
      );
    }
  }

  void _saveHaSwitch() {
    final entity = _haSwitchController.text.trim();
    if (entity.isNotEmpty) {
      widget.settingsService.setHaSwitchEntity(entity);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('开关实体已保存')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _ipController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '设备IP地址',
                hintText: '例如: 192.168.1.100',
                prefixIcon: const Icon(Icons.computer),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveIp,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _saveIp(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _macController,
              decoration: InputDecoration(
                labelText: '设备MAC地址',
                hintText: '例如: 00:1A:2B:3C:4D:5E',
                prefixIcon: const Icon(Icons.settings_ethernet),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveMac,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _saveMac(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _tailscaleIpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '设备Tailscale IP',
                hintText: '例如: 100.117.222.75',
                prefixIcon: const Icon(Icons.vpn_lock),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveTailscaleIp,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _saveTailscaleIp(),
            ),
          ),
          const Divider(),
          ExpansionTile(
            title: const Text('Home Assistant'),
            subtitle: const Text('通过HA检测和唤醒电脑'),
            leading: const Icon(Icons.home),
            initiallyExpanded: _haExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _haExpanded = expanded;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _haLocalUrlController,
                  decoration: InputDecoration(
                    labelText: '局域网HA地址',
                    hintText: '例如: http://192.168.1.4:8123',
                    prefixIcon: const Icon(Icons.link),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _saveHaLocalUrl,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _saveHaLocalUrl(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _haTailscaleUrlController,
                  decoration: InputDecoration(
                    labelText: 'Tailscale HA地址',
                    hintText: '例如: http://100.117.222.75:8123',
                    prefixIcon: const Icon(Icons.vpn_lock),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _saveHaTailscaleUrl,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _saveHaTailscaleUrl(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _haTokenController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'HA密钥 (Token)',
                    hintText: 'Long-Lived Access Token',
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _saveHaToken,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _saveHaToken(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _haSensorController,
                  decoration: InputDecoration(
                    labelText: '在线检测实体',
                    hintText: '例如: binary_sensor.192_168_1_100',
                    prefixIcon: const Icon(Icons.sensors),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _saveHaSensor,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _saveHaSensor(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TextField(
                  controller: _haSwitchController,
                  decoration: InputDecoration(
                    labelText: '唤醒开关实体',
                    hintText: '例如: switch.desktop_pc',
                    prefixIcon: const Icon(Icons.power),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _saveHaSwitch,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _saveHaSwitch(),
                ),
              ),
            ],
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('深色模式'),
            subtitle: const Text('切换应用主题'),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          ListTile(
            title: const Text('字体大小'),
            subtitle: Slider(
              value: _fontSize,
              min: 12,
              max: 24,
              divisions: 6,
              label: _fontSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
            leading: const Icon(Icons.text_fields),
          ),
          const Divider(),
          ListTile(
            title: const Text('设备管理'),
            subtitle: const Text('管理唤醒设备列表'),
            leading: const Icon(Icons.devices),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('关于'),
            subtitle: const Text('版本 1.0.0'),
            leading: const Icon(Icons.info_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
