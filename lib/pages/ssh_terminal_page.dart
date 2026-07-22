import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/ssh_service.dart';

class SshTerminalPage extends StatefulWidget {
  final String deviceName;
  final String host;
  final int port;
  final String username;
  final String password;
  final bool useJumpHost;
  final String? jumpHost;
  final int? jumpPort;
  final String? jumpUsername;
  final String? jumpPassword;

  const SshTerminalPage({
    super.key,
    required this.deviceName,
    required this.host,
    this.port = 22,
    required this.username,
    required this.password,
    this.useJumpHost = false,
    this.jumpHost,
    this.jumpPort,
    this.jumpUsername,
    this.jumpPassword,
  });

  @override
  State<SshTerminalPage> createState() => _SshTerminalPageState();
}

class _SshTerminalPageState extends State<SshTerminalPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final StringBuffer _outputBuffer = StringBuffer();
  final List<String> _commandHistory = [];
  int _historyIndex = -1;

  SshShell? _shell;
  bool _isConnecting = true;
  bool _isConnected = false;
  String? _error;

  final RegExp _ansiEscape = RegExp(
    r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])',
    multiLine: true,
  );

  String _cleanAnsi(String input) {
    return input.replaceAll(_ansiEscape, '');
  }

  @override
  void initState() {
    super.initState();
    _connect();
  }

  @override
  void dispose() {
    _shell?.close();
    _scrollController.dispose();
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    setState(() {
      _isConnecting = true;
      _isConnected = false;
      _error = null;
      _outputBuffer.clear();
    });

    try {
      SshShell shell;
      if (widget.useJumpHost) {
        shell = await SshService.openShellViaJump(
          jumpHost: widget.jumpHost!,
          jumpPort: widget.jumpPort ?? 22,
          jumpUsername: widget.jumpUsername!,
          jumpPassword: widget.jumpPassword!,
          targetHost: widget.host,
          targetPort: widget.port,
          targetUsername: widget.username,
          targetPassword: widget.password,
        );
      } else {
        shell = await SshService.openShell(
          host: widget.host,
          port: widget.port,
          username: widget.username,
          password: widget.password,
        );
      }

      shell.output.listen(
        (data) {
          final raw = utf8.decode(data, allowMalformed: true);
          final clean = _cleanAnsi(raw);
          setState(() {
            _outputBuffer.write(clean);
          });
          _scrollToBottom();
        },
        onError: (e) {
          setState(() {
            _outputBuffer.write('\n连接错误: $e');
            _isConnected = false;
          });
        },
        onDone: () {
          setState(() {
            _outputBuffer.write('\n连接已断开');
            _isConnected = false;
          });
        },
      );

      setState(() {
        _shell = shell;
        _isConnecting = false;
        _isConnected = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _error = e.toString();
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendCommand() {
    final cmd = _inputController.text;
    if (cmd.isEmpty || _shell == null || !_isConnected) return;

    _shell!.write('$cmd\n');

    if (_commandHistory.isEmpty || _commandHistory.last != cmd) {
      _commandHistory.add(cmd);
    }
    _historyIndex = _commandHistory.length;

    _inputController.clear();
    _focusNode.requestFocus();
  }

  void _historyUp() {
    if (_commandHistory.isEmpty) return;
    if (_historyIndex > 0) {
      _historyIndex--;
      _inputController.text = _commandHistory[_historyIndex];
      _inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: _inputController.text.length),
      );
    }
  }

  void _historyDown() {
    if (_commandHistory.isEmpty) return;
    if (_historyIndex < _commandHistory.length - 1) {
      _historyIndex++;
      _inputController.text = _commandHistory[_historyIndex];
    } else {
      _historyIndex = _commandHistory.length;
      _inputController.clear();
    }
    _inputController.selection = TextSelection.fromPosition(
      TextPosition(offset: _inputController.text.length),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _historyUp();
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _historyDown();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  Widget _buildTerminal() {
    return SizedBox.expand(
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SelectableText(
            _outputBuffer.toString(),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: Colors.greenAccent,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            Icon(
              _isConnected
                  ? Icons.circle
                  : _isConnecting
                      ? Icons.hourglass_empty
                      : Icons.error,
              size: 12,
              color: _isConnected
                  ? Colors.green
                  : _isConnecting
                      ? Colors.orange
                      : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(widget.deviceName),
          ],
        ),
        actions: [
          if (_isConnected)
            IconButton(
              icon: const Icon(Icons.stop_circle_outlined),
              onPressed: () {
                _shell?.session.write(Uint8List.fromList([0x03]));
              },
              tooltip: '发送 Ctrl+C',
            ),
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: () {
              _shell?.close();
              _connect();
            },
            tooltip: '重新连接',
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: _isConnecting
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.greenAccent),
                          SizedBox(height: 16),
                          Text(
                            '正在连接...',
                            style: TextStyle(color: Colors.greenAccent),
                          ),
                        ],
                      ),
                    )
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  '连接失败',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _error!,
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: _connect,
                                  child: const Text('重试'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _buildTerminal(),
            ),
            if (!_isConnecting && _error == null)
              Container(
                color: Colors.grey[900],
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      const Text(
                        '\$ ',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.greenAccent,
                        ),
                      ),
                      Expanded(
                        child: Focus(
                          focusNode: _focusNode,
                          onKeyEvent: _handleKeyEvent,
                          child: TextField(
                            controller: _inputController,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.greenAccent,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                            ),
                            onSubmitted: (_) => _sendCommand(),
                            enabled: _isConnected,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_up, size: 24),
                        color: Colors.greenAccent,
                        onPressed: _isConnected ? _historyUp : null,
                        tooltip: '上一条命令',
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.keyboard_arrow_down, size: 24),
                        color: Colors.greenAccent,
                        onPressed: _isConnected ? _historyDown : null,
                        tooltip: '下一条命令',
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, size: 20),
                        color: Colors.greenAccent,
                        onPressed: _isConnected ? _sendCommand : null,
                        tooltip: '发送',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
