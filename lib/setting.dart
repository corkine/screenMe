// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_me/api/common.dart';

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
  var normalVoice = 0.0;
  var speakerVoice = 0.0;
  bool showWallpaper = false;
  bool showAnimation = false;
  bool demoMode = false;
  bool showWarning = false;
  bool showWarningOnBing = false;
  @override
  void dispose() {
    username.dispose();
    password.dispose();
    fetchDuration.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(configsProvider.future).then((c) {
      username.text = c.user;
      fetchDuration.text = c.fetchSeconds.toString();
      password.text = c.password;
      showWallpaper = c.showBingWallpaper;
      showWarningOnBing = c.fatWarningOverwriteBingWallpaper;
      demoMode = c.demoMode;
      normalVoice = c.volumeNormal;
      speakerVoice = c.volumeOpenBluetooth;
      showAnimation = c.showLoadingAnimationIfNoTodo;
      showWarning = c.showFatWarningAfter17IfLazy;
      delay.text = c.maxVolDelaySeconds.toInt().toString();
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
                    const Text("显示 Bing 壁纸"),
                    const Spacer(),
                    Switch(
                        value: showWallpaper,
                        onChanged: (v) => setState(() => showWallpaper = v))
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text("健康视图无待办显示加载动画"),
                    const Spacer(),
                    Switch(
                        value: showAnimation,
                        onChanged: (v) => setState(() => showAnimation = v))
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text("健康视图晚 18:00 后运动圆环未完成显示警告"),
                    const Spacer(),
                    Switch(
                        value: showWarning,
                        onChanged: (v) => setState(() => showWarning = v))
                  ]),
                  Row(children: [
                    const Text("Bing 壁纸下也显示警告"),
                    const Spacer(),
                    Switch(
                        value: showWarningOnBing,
                        onChanged: (v) => setState(() => showWarningOnBing = v))
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
                ]))));
  }

  void handleLogin() async {
    final d = int.tryParse(fetchDuration.text);
    final delaySeconds = double.tryParse(delay.text) ?? 0.0;
    if (delaySeconds < 0 || delaySeconds > 20) {
      await showSimpleMessage(context, content: "延迟时间必须在 0-20 之间");
      return;
    }
    if (username.text.isNotEmpty &&
        password.text.isNotEmpty &&
        fetchDuration.text.isNotEmpty &&
        d != null) {
      await ref.read(configsProvider.notifier).set(
          username.text, password.text, d, showWallpaper,
          demoMode: demoMode,
          minVol: normalVoice,
          maxVol: speakerVoice,
          useAnimalInHealthViewWhenNoTodo: showAnimation,
          showWortoutWarning: showWarning,
          warningOverwriteBingWallpaper: showWarningOnBing,
          delay: delaySeconds);
      await showSimpleMessage(context, content: "设置已更新", useSnackBar: true);
      Navigator.of(context).pop();
    } else {
      await showSimpleMessage(context, content: "请输入用户名和密码");
    }
  }
}
