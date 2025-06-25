// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_me/api/core.dart';

class SettingView extends ConsumerStatefulWidget {
  const SettingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingViewState();
}

class _SettingViewState extends ConsumerState<SettingView> {
  final username = TextEditingController();
  final password = TextEditingController();
  final delay = TextEditingController();
  final fetchDuration = TextEditingController();
  final importCode = TextEditingController();
  Config? _config;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    fetchDuration.dispose();
    delay.dispose();
    importCode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(configsProvider.future).then((c) {
      username.text = c.user;
      fetchDuration.text = c.fetchSeconds.toString();
      password.text = c.password;
      delay.text = c.maxVolDelaySeconds.toInt().toString();
      setState(() {
        _config = c;
      });
    });
  }

  toggleDemoMode() {
    if (_config!.demoMode) {
      username.text = "demo";
      password.text = "demo";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_config == null) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
    return Scaffold(
        appBar: AppBar(
            title: Transform.translate(
                offset: Offset(-20, 0),
                child: const Text("设置", style: TextStyle(fontSize: 20))),
            toolbarHeight: 45,
            actions: [
              Row(children: [
                Checkbox.adaptive(
                    value: _config!.demoMode,
                    onChanged: (v) => setState(() {
                          _config = _config!.copyWith(demoMode: v!);
                          toggleDemoMode();
                        })),
                InkWell(
                    onTap: () => setState(() {
                          _config =
                              _config!.copyWith(demoMode: !_config!.demoMode);
                          toggleDemoMode();
                        }),
                    child: const Text("演示模式")),
                const SizedBox(width: 10)
              ]),
              TextButton.icon(
                  onPressed: handleLogin,
                  icon: const Icon(Icons.save),
                  label: const Text("保存"))
            ]),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SettingsGroup(title: "基础配置", children: [
                        Row(spacing: 10, children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                                controller: username,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: "用户名")),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextField(
                                controller: password,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: "密码")),
                          ),
                          LimitedBox(
                              maxWidth: 80,
                              child: TextField(
                                  controller: fetchDuration,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      suffixText: "秒",
                                      border: UnderlineInputBorder(),
                                      labelText: "刷新间隔")))
                        ]),
                        const SizedBox(height: 10),
                        Row(children: [
                          const Text("表盘样式"),
                          const Spacer(),
                          DropdownButton<FaceType>(
                              isDense: true,
                              alignment: Alignment.centerRight,
                              underline: const SizedBox(),
                              focusColor: Colors.transparent,
                              value: _config!.face,
                              onChanged: (v) => setState(() {
                                    _config = _config!.copyWith(face: v!);
                                  }),
                              items: FaceType.values
                                  .map((e) => DropdownMenuItem<FaceType>(
                                      value: e, child: Text(e.name)))
                                  .toList())
                        ]),
                        const SizedBox(height: 10),
                        Row(children: [
                          const Text("时钟字体"),
                          const Spacer(),
                          DropdownButton<FontType>(
                              isDense: true,
                              alignment: Alignment.centerRight,
                              underline: const SizedBox(),
                              focusColor: Colors.transparent,
                              value: _config!.fontType,
                              onChanged: (v) => setState(() {
                                    _config = _config!.copyWith(fontType: v!);
                                  }),
                              items: FontType.values
                                  .map((e) => DropdownMenuItem<FontType>(
                                      value: e, child: Text(e.name)))
                                  .toList())
                        ]),
                        const SizedBox(height: 10),
                        Row(children: [
                          const Text("下雨提示"),
                          const Spacer(),
                          DropdownButton<RainType>(
                              isDense: true,
                              alignment: Alignment.centerRight,
                              underline: const SizedBox(),
                              focusColor: Colors.transparent,
                              value: _config!.rainType,
                              onChanged: (v) => setState(() {
                                    _config = _config!.copyWith(rainType: v!);
                                  }),
                              items: RainType.values
                                  .map((e) => DropdownMenuItem<RainType>(
                                      value: e, child: Text(e.name)))
                                  .toList())
                        ])
                      ]),
                      _SettingsGroup(title: "蓝牙音量", children: [
                        Row(children: [
                          Text(
                              "关闭蓝牙时音量：${(_config!.volumeNormal * 100).toInt()}"),
                          const Spacer(),
                          Slider(
                              onChanged: (v) {
                                setState(() {
                                  _config = _config!.copyWith(volumeNormal: v);
                                });
                              },
                              label: "${_config!.volumeNormal * 100}",
                              value: _config!.volumeNormal,
                              min: 0,
                              max: 1)
                        ]),
                        Row(mainAxisSize: MainAxisSize.max, children: [
                          Text(
                              "打开蓝牙时音量：${(_config!.volumeOpenBluetooth * 100).toInt()}"),
                          const Spacer(),
                          Slider(
                              onChanged: (v) {
                                setState(() {
                                  _config =
                                      _config!.copyWith(volumeOpenBluetooth: v);
                                });
                              },
                              label: "${_config!.volumeOpenBluetooth * 100}",
                              value: _config!.volumeOpenBluetooth,
                              min: 0,
                              max: 1)
                        ]),
                        TextField(
                            controller: delay,
                            decoration: const InputDecoration(
                                suffixText: "秒",
                                border: UnderlineInputBorder(),
                                labelText: "打开蓝牙时延迟调高音量")),
                      ]),
                      _SettingsGroup(title: "暗色模式", children: [
                        Row(
                          children: [
                            const Text("启用暗色模式"),
                            const Spacer(),
                            Switch.adaptive(
                              value: _config!.darkModeStart != null,
                              onChanged: (value) {
                                setState(() {
                                  if (value) {
                                    _config = _config!.copyWith(
                                      darkModeStart:
                                          const TimeOfDay(hour: 22, minute: 0),
                                      darkModeEndDay2:
                                          const TimeOfDay(hour: 6, minute: 0),
                                    );
                                  } else {
                                    _config = _config!.copyWith(
                                      darkModeStart: null,
                                      darkModeEndDay2: null,
                                    );
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        if (_config!.darkModeStart != null) ...[
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                              child: Text(
                                  "从 ${_config!.darkModeStart!.format(context)} 到次日 ${_config!.darkModeEndDay2!.format(context)}"),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                                onPressed: () async {
                                  final time = await showTimePicker(
                                      context: context,
                                      initialTime: _config!.darkModeStart!);
                                  if (time != null) {
                                    setState(() {
                                      _config = _config!
                                          .copyWith(darkModeStart: time);
                                    });
                                  }
                                },
                                child: const Text("开始时间")),
                            TextButton(
                                onPressed: () async {
                                  final time = await showTimePicker(
                                      context: context,
                                      initialTime: _config!.darkModeEndDay2!);
                                  if (time != null) {
                                    setState(() {
                                      _config = _config!
                                          .copyWith(darkModeEndDay2: time);
                                    });
                                  }
                                },
                                child: const Text("结束时间"))
                          ]),
                          Row(mainAxisSize: MainAxisSize.max, children: [
                            Text("暗度：${(_config!.darkness * 100).toInt()}%"),
                            Expanded(
                              child: Slider(
                                  onChanged: (v) {
                                    setState(() {
                                      _config = _config!.copyWith(darkness: v);
                                    });
                                  },
                                  label: "${(_config!.darkness * 100).toInt()}",
                                  value: _config!.darkness,
                                  min: 0,
                                  max: 1),
                            )
                          ]),
                        ]
                      ]),
                      _SettingsGroup(
                          title: "配置同步",
                          subtitle: "通过云端同步配置，可在跨设备或版本更新时使用",
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: exportConfig,
                                    icon: const Icon(Icons.upload),
                                    label: const Text("导出配置"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => showImportDialog(context),
                                    icon: const Icon(Icons.download),
                                    label: const Text("导入配置"),
                                  ),
                                ),
                              ],
                            )
                          ]),
                      const SizedBox(height: 20)
                    ]))));
  }

  void handleLogin() async {
    final d = int.tryParse(fetchDuration.text);
    final delaySeconds = double.tryParse(delay.text) ?? 0.0;
    if (delaySeconds < 0 || delaySeconds > 30) {
      await showSimpleMessage(context, content: "延迟时间必须在 0-30 之间");
      return;
    }
    if (username.text.isNotEmpty &&
        password.text.isNotEmpty &&
        fetchDuration.text.isNotEmpty &&
        d != null) {
      await ref.read(configsProvider.notifier).set(
            username.text,
            password.text,
            d,
            demoMode: _config!.demoMode,
            minVol: _config!.volumeNormal,
            maxVol: _config!.volumeOpenBluetooth,
            rainType: _config!.rainType,
            face: _config!.face,
            fontType: _config!.fontType,
            delay: delaySeconds,
            darkModeStart: _config!.darkModeStart,
            darkModeAfterDay2: _config!.darkModeEndDay2,
            darkness: _config!.darkness,
          );
      await showSimpleMessage(context, content: "设置已更新", useSnackBar: true);
      Navigator.of(context).pop();
    } else {
      await showSimpleMessage(context, content: "请输入用户名和密码");
    }
  }

  // 导出配置
  Future<void> exportConfig() async {
    try {
      showWaitingBar(context, text: "正在导出配置...");

      // 获取当前配置
      final config = ref.read(configsProvider).value ?? Config();

      // 使用ConfigSyncService导出
      final result = await ConfigSyncService.exportConfig(config);

      ScaffoldMessenger.of(context).clearMaterialBanners();

      if (result.success) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("导出成功"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      Expanded(
                          child: Text(result.password ?? "",
                              style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace'))),
                      IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: result.password ?? ""));
                            showSimpleMessage(context,
                                content: "已复制到剪贴板", useSnackBar: true);
                          },
                          icon: const Icon(Icons.copy))
                    ])),
                const SizedBox(height: 10),
                Text("请在 ${result.expiresIn} 秒内使用此密码导入配置"),
                const SizedBox(height: 5),
                const Text("注意：只有相同设备类型才能导入此配置",
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("确定"),
              ),
            ],
          ),
        );
      } else {
        await showSimpleMessage(context, content: result.message);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearMaterialBanners();
      await showSimpleMessage(context, content: "导出失败: $e");
    }
  }

  // 显示导入对话框
  Future<void> showImportDialog(BuildContext context) async {
    importCode.clear();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
            EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 8, right: 10),
        content: _ImportDialogContent(importCode: importCode),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              importConfig(importCode.text.trim());
            },
            child: const Text("导入"),
          ),
        ],
      ),
    );
  }

  // 导入配置
  Future<void> importConfig(String secret) async {
    try {
      showWaitingBar(context, text: "正在导入配置...");

      // 使用ConfigSyncService导入
      final result = await ConfigSyncService.importConfig(secret);

      ScaffoldMessenger.of(context).clearMaterialBanners();

      if (result.success && result.config != null) {
        final config = result.config!;

        // 应用配置到界面
        username.text = config.user;
        password.text = config.password;
        fetchDuration.text = config.fetchSeconds.toString();
        delay.text = config.maxVolDelaySeconds.toInt().toString();
        setState(() {
          _config = config;
        });

        await showSimpleMessage(context,
            content: result.message + "\n请点击保存按钮应用配置",
            useSnackBar: true,
            snackBarDuration: 3000);
      } else {
        await showSimpleMessage(context, content: result.message);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearMaterialBanners();
      await showSimpleMessage(context, content: "导入失败: $e");
    }
  }
}

class _ImportDialogContent extends StatefulWidget {
  final TextEditingController importCode;
  const _ImportDialogContent({required this.importCode});

  @override
  State<_ImportDialogContent> createState() => _ImportDialogContentState();
}

class _ImportDialogContentState extends State<_ImportDialogContent> {
  void _onKeyTap(String value) {
    if (widget.importCode.text.length >= 10) return;
    setState(() {
      widget.importCode.text += value;
    });
  }

  void _onBackspace() {
    if (widget.importCode.text.isNotEmpty) {
      setState(() {
        widget.importCode.text = widget.importCode.text
            .substring(0, widget.importCode.text.length - 1);
      });
    }
  }

  void _onClear() {
    setState(() {
      widget.importCode.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
        flex: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "导入配置",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const Text("只能导入相同设备类型的配置",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            Spacer(),
            TextField(
              controller: widget.importCode,
              readOnly: true,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: const InputDecoration(labelText: "配置密码"),
            ),
          ],
        ),
      ),
      const SizedBox(width: 20),
      Expanded(flex: 3, child: _buildKeypad())
    ]);
  }

  Widget _buildKeypad() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildKeypadButton("1"),
            _buildKeypadButton("2"),
            _buildKeypadButton("3")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildKeypadButton("4"),
            _buildKeypadButton("5"),
            _buildKeypadButton("6")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildKeypadButton("7"),
            _buildKeypadButton("8"),
            _buildKeypadButton("9")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildKeypadButton("C", onTap: _onClear),
            _buildKeypadButton("0"),
            _buildKeypadButton("<", onTap: _onBackspace),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String text, {VoidCallback? onTap}) {
    return SizedBox(
      width: 45,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        onPressed: onTap ?? () => _onKeyTap(text),
        child: text == "<" ? const Icon(Icons.backspace_outlined) : Text(text),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  const _SettingsGroup(
      {required this.title, this.subtitle, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              child: Text(subtitle!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          const SizedBox(height: 8),
          ...children,
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
