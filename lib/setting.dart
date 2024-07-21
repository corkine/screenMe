// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_me/api/common.dart';

import 'api/dash.dart';

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
  var warningType = WarnType.eye;
  var faceType = FaceType.bing;
  var normalVoice = 0.0;
  var speakerVoice = 0.0;
  bool demoMode = false;
  bool showAnimation = false;
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
      showWarningOnBing = c.fatWarningOverwriteBingWallpaper;
      demoMode = c.demoMode;
      normalVoice = c.volumeNormal;
      speakerVoice = c.volumeOpenBluetooth;
      showWarning = c.showFatWarningAfter17IfLazy;
      delay.text = c.maxVolDelaySeconds.toInt().toString();
      warningType = c.warningType;
      faceType = c.face;
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
          warningOverwriteBingWallpaper: showWarningOnBing,
          warningType: warningType,
          face: faceType,
          delay: delaySeconds);
      await showSimpleMessage(context, content: "设置已更新", useSnackBar: true);
      Navigator.of(context).pop();
    } else {
      await showSimpleMessage(context, content: "请输入用户名和密码");
    }
  }
}
