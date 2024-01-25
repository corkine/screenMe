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
  final password = TextEditingController();
  final fetchDuration = TextEditingController();
  var normalVoice = 0.0;
  var speakerVoice = 0.0;
  bool showWallpaper = false;
  bool demoMode = false;
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
      demoMode = c.demoMode;
      normalVoice = c.volumeNormal;
      speakerVoice = c.volumeOpenBluetooth;
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
                  ])
                ]))));
  }

  void handleLogin() async {
    final d = int.tryParse(fetchDuration.text);
    if (username.text.isNotEmpty &&
        password.text.isNotEmpty &&
        fetchDuration.text.isNotEmpty &&
        d != null) {
      await ref.read(configsProvider.notifier).set(
          username.text, password.text, d, showWallpaper,
          demoMode: demoMode, minVol: normalVoice, maxVol: speakerVoice);
      await showSimpleMessage(context, content: "设置已更新");
      Navigator.of(context).pop();
    } else {
      await showSimpleMessage(context, content: "请输入用户名和密码");
    }
  }
}
