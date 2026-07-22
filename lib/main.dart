import 'package:flutter/material.dart';
import 'pages/settings_page.dart';
import 'services/network_service.dart';
import 'services/settings_service.dart';
import 'services/app_launcher_service.dart';
import 'services/home_assistant_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wake On LAN',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SettingsService _settingsService = SettingsService();

  bool _isPcOnline = false;
  bool _isChecking = false;
  bool _isInitialized = false;
  bool _isOnLocal = false;
  bool _isOnTailscale = false;

  HomeAssistantService? _haService;

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  Future<void> _initSettings() async {
    await _settingsService.init();
    _haService = HomeAssistantService(
      baseUrl: _settingsService.haBaseUrl,
      token: _settingsService.haToken,
    );
    setState(() {
      _isInitialized = true;
    });
    _checkPcStatus();
  }

  Future<void> _checkNetworkStatus() async {
    final onLocal = await NetworkService.isOnLocalNetwork();
    final onTailscale = await NetworkService.isOnTailscaleNetwork();
    if (mounted) {
      setState(() {
        _isOnLocal = onLocal;
        _isOnTailscale = onTailscale;
      });
    }
  }

  Future<void> _checkPcStatus() async {
    if (_isChecking) return;

    setState(() {
      _isChecking = true;
    });

    await _checkNetworkStatus();

    bool online = false;

    if (_isOnLocal) {
      final ip = _settingsService.ipAddress;
      online = await NetworkService.isPcOnline(ip);
    } else if (_isOnTailscale) {
      _haService = HomeAssistantService(
        baseUrl: _settingsService.haBaseUrl,
        token: _settingsService.haToken,
      );
      final state = await _haService?.getEntityState(
        _settingsService.haSensorEntity,
      );
      online = state == 'on';
    } else {
      online = false;
    }

    if (mounted) {
      setState(() {
        _isPcOnline = online;
        _isChecking = false;
      });
    }
  }

  bool _canWake() {
    return _isOnLocal || _isOnTailscale;
  }

  Future<void> _onCircleButtonTap() async {
    if (_isPcOnline || _isChecking) return;

    await _checkNetworkStatus();

    if (_canWake()) {
      bool wakeSuccess = false;

      if (_isOnLocal) {
        final mac = _settingsService.macAddress;
        String? broadcastAddr;

        final ip = _settingsService.ipAddress;
        final parts = ip.split('.');
        if (parts.length == 4) {
          broadcastAddr = '${parts[0]}.${parts[1]}.${parts[2]}.255';
        }

        NetworkService.sendMagicPacket(mac, broadcastAddress: broadcastAddr);
        wakeSuccess = true;
      } else if (_isOnTailscale) {
        _haService = HomeAssistantService(
          baseUrl: _settingsService.haBaseUrl,
          token: _settingsService.haToken,
        );
        wakeSuccess =
            await _haService?.turnOnSwitch(_settingsService.haSwitchEntity) ??
            false;
      }

      if (wakeSuccess && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('已发送唤醒指令')));
      } else if (!wakeSuccess && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('唤醒失败，请检查设置')));
      }

      await Future.delayed(const Duration(seconds: 3));
      _checkPcStatus();
    } else {
      AppLauncherService.launchTailscale();
    }
  }

  Color _getButtonColor() {
    if (_isPcOnline) {
      return Colors.blue;
    }
    if (_canWake()) {
      return Colors.orange;
    }
    return Colors.grey;
  }

  String _getStatusText() {
    if (_isChecking) {
      return '检测中...';
    }
    if (_isPcOnline) {
      return 'PC在线';
    }
    if (_isOnLocal) {
      return 'PC离线，点击唤醒（局域网）';
    }
    if (_isOnTailscale) {
      return 'PC离线，点击唤醒（HA）';
    }
    return 'PC离线，点击启动Tailscale';
  }

  Color? _getStatusTextColor() {
    if (_isPcOnline) {
      return Colors.blue;
    }
    if (_canWake()) {
      return Colors.orange;
    }
    return Colors.grey[600];
  }

  void _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(settingsService: _settingsService),
      ),
    );
    _haService = HomeAssistantService(
      baseUrl: _settingsService.haBaseUrl,
      token: _settingsService.haToken,
    );
    _checkPcStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wake On LAN'),
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _checkPcStatus,
          tooltip: '刷新',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
            tooltip: '设置',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _isPcOnline || _isChecking ? null : _onCircleButtonTap,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: _getButtonColor(),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _getButtonColor().withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.power_settings_new,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _getStatusText(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: _getStatusTextColor()),
            ),
            if (_isChecking)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSquareButton(
              icon: Icons.play_arrow,
              label: '唤醒',
              onTap: _isPcOnline || _isChecking ? null : _onCircleButtonTap,
            ),
            _buildSquareButton(
              icon: Icons.network_ping,
              label: _isOnLocal ? '局域网已连' : '局域网未连',
              onTap: null,
            ),
            _buildSquareButton(
              icon: Icons.vpn_lock,
              label: _isOnTailscale ? 'VPN已连' : 'VPN未连',
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: Container(
          width: 90,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
