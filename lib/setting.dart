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
  final delay = TextEditingController();
  final password = TextEditingController();
  final fetchDuration = TextEditingController();
  final importCode = TextEditingController();
  var warningType = WarnType.eye;
  var rainType = RainType.cloud;
  var faceType = FaceType.bing;
  var normalVoice = 0.0;
  var speakerVoice = 0.0;
  TimeOfDay? darkModeStart;
  TimeOfDay? darkModeAfterDay2;
  bool demoMode = false;
  bool showAnimation = false;
  bool showWarning = false;
  bool warningShowGalleryInBg = false;
  double darkness = 0.8;
  bool showChineseCalendar = false;

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
      demoMode = c.demoMode;
      normalVoice = c.volumeNormal;
      speakerVoice = c.volumeOpenBluetooth;
      showAnimation = c.useAnimationWhenNoTodo;
      showWarning = c.showFatWarningAfter17IfLazy;
      delay.text = c.maxVolDelaySeconds.toInt().toString();
      warningShowGalleryInBg = c.warningShowGalleryInBg;
      rainType = c.rainType;
      warningType = c.warningType;
      faceType = c.face;
      darkModeStart = c.darkModeStart;
      darkModeAfterDay2 = c.darkModeEndDay2;
      darkness = c.darkness;
      showChineseCalendar = c.showChineseCalendar;
      setState(() {});
    });
  }

  toggleDemoMode() {
    if (demoMode) {
      username.text = "demo";
      password.text = "demo";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("设置"), actions: [
          Row(children: [
            Checkbox.adaptive(
                value: demoMode,
                onChanged: (v) => setState(() {
                      demoMode = v!;
                      toggleDemoMode();
                    })),
            InkWell(
                onTap: () => setState(() {
                      demoMode = !demoMode;
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
                child: Column(children: [
                  TextField(
                      controller: username,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(), labelText: "用户名")),
                  TextField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(), labelText: "密码")),
                  TextField(
                      controller: fetchDuration,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "刷新间隔(秒)")),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text("表盘样式"),
                    const Spacer(),
                    DropdownButton<FaceType>(
                        focusColor: Colors.transparent,
                        value: faceType,
                        onChanged: (v) => setState(() {
                              faceType = v!;
                            }),
                        items: FaceType.values
                            .map((e) => DropdownMenuItem<FaceType>(
                                value: e, child: Text(e.name)))
                            .toList())
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text("无待办显示加载动画"),
                    const Spacer(),
                    Switch(
                        value: showAnimation,
                        onChanged: (v) => setState(() => showAnimation = v))
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text("晚 18:00 后运动未完成显示警告视图"),
                    const Spacer(),
                    Switch(
                        value: showWarning,
                        onChanged: (v) => setState(() => showWarning = v))
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text("显示农历节气和时辰"),
                    const Spacer(),
                    Switch(
                        value: showChineseCalendar,
                        onChanged: (v) =>
                            setState(() => showChineseCalendar = v))
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text("警告视图使用画廊打底"),
                    const Spacer(),
                    Switch(
                        value: warningShowGalleryInBg,
                        onChanged: (v) =>
                            setState(() => warningShowGalleryInBg = v))
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text("警告图案样式"),
                    const Spacer(),
                    DropdownButton<WarnType>(
                        focusColor: Colors.transparent,
                        value: warningType,
                        onChanged: (v) => setState(() {
                              warningType = v!;
                            }),
                        items: WarnType.values
                            .map((e) => DropdownMenuItem<WarnType>(
                                value: e, child: Text(e.cnName)))
                            .toList())
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text("下雨提示图案样式"),
                    const Spacer(),
                    DropdownButton<RainType>(
                        focusColor: Colors.transparent,
                        value: rainType,
                        onChanged: (v) => setState(() {
                              rainType = v!;
                            }),
                        items: RainType.values
                            .map((e) => DropdownMenuItem<RainType>(
                                value: e, child: Text(e.name)))
                            .toList())
                  ]),
                  Row(children: [
                    Text("关闭蓝牙时音量：${(normalVoice * 100).toInt()}"),
                    const Spacer(),
                    Slider(
                        onChanged: (v) {
                          setState(() {
                            normalVoice = v;
                          });
                        },
                        label: "${normalVoice * 100}",
                        value: normalVoice,
                        min: 0,
                        max: 1)
                  ]),
                  Row(mainAxisSize: MainAxisSize.max, children: [
                    Text("打开蓝牙时音量：${(speakerVoice * 100).toInt()}"),
                    const Spacer(),
                    Slider(
                        onChanged: (v) {
                          setState(() {
                            speakerVoice = v;
                          });
                        },
                        label: "${speakerVoice * 100}",
                        value: speakerVoice,
                        min: 0,
                        max: 1)
                  ]),
                  TextField(
                      controller: delay,
                      decoration: const InputDecoration(
                          suffixText: "秒",
                          border: UnderlineInputBorder(),
                          labelText: "打开蓝牙时延迟调高音量")),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: Text((darkModeStart == null ||
                              darkModeAfterDay2 == null)
                          ? "不使用暗色模式"
                          : "在 ${darkModeStart!.hour}:${darkModeStart!.minute.toString().padLeft(2, '0')} 后使用暗色模式，直到第二天" +
                              " ${darkModeAfterDay2!.hour}:${darkModeAfterDay2!.minute.toString().padLeft(2, '0')}"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) {
                            setState(() {
                              darkModeStart = time;
                            });
                          }
                        },
                        child: const Text("开始")),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: 4, minute: 0));
                          if (time != null) {
                            setState(() {
                              darkModeAfterDay2 = time;
                            });
                          }
                        },
                        child: const Text("结束(第二天)"))
                  ]),
                  Row(mainAxisSize: MainAxisSize.max, children: [
                    Text("暗色模式暗度：${(darkness * 100).toInt()}"),
                    const Spacer(),
                    Slider(
                        onChanged: (v) {
                          setState(() {
                            darkness = v;
                          });
                        },
                        label: "${darkness * 100}",
                        value: darkness,
                        min: 0,
                        max: 1)
                  ]),
                  const SizedBox(height: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("配置同步",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const Text("通过云端同步配置，可在跨设备或版本更新时使用",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 10),
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
          username.text, password.text, d,
          demoMode: demoMode,
          minVol: normalVoice,
          maxVol: speakerVoice,
          useAnimationWhenNoTodo: showAnimation,
          showWortoutWarning: showWarning,
          warningShowGalleryInBg: warningShowGalleryInBg,
          warningType: warningType,
          rainType: rainType,
          face: faceType,
          delay: delaySeconds,
          darkModeStart: darkModeStart,
          darkModeAfterDay2: darkModeAfterDay2,
          darkness: darkness,
          showChineseCalendar: showChineseCalendar);
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
        title: const Text("导入配置"),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: importCode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "配置密码",
                  hintText: "例如: 19895",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              const Text("注意：只能导入相同设备类型的配置",
                  style: TextStyle(fontSize: 12, color: Colors.grey))
            ]),
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
  Future<void> importConfig(String password) async {
    try {
      showWaitingBar(context, text: "正在导入配置...");

      // 使用ConfigSyncService导入
      final result = await ConfigSyncService.importConfig(password);

      ScaffoldMessenger.of(context).clearMaterialBanners();

      if (result.success && result.config != null) {
        final config = result.config!;

        // 应用配置到界面
        username.text = config.user;
        this.password.text = config.password;
        fetchDuration.text = config.fetchSeconds.toString();
        demoMode = config.demoMode;
        normalVoice = config.volumeNormal;
        speakerVoice = config.volumeOpenBluetooth;
        showAnimation = config.useAnimationWhenNoTodo;
        showWarning = config.showFatWarningAfter17IfLazy;
        delay.text = config.maxVolDelaySeconds.toInt().toString();
        warningShowGalleryInBg = config.warningShowGalleryInBg;
        rainType = config.rainType;
        warningType = config.warningType;
        faceType = config.face;
        darkModeStart = config.darkModeStart;
        darkModeAfterDay2 = config.darkModeEndDay2;
        darkness = config.darkness;
        showChineseCalendar = config.showChineseCalendar;

        setState(() {});

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
