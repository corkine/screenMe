// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_me/api/common.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final username = TextEditingController();
  final password = TextEditingController();
  final fetchDuration = TextEditingController();
  @override
  void dispose() {
    username.dispose();
    password.dispose();
    fetchDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(configsProvider).value;
    if (c != null) {
      if (username.text.isEmpty) {
        username.text = c.user;
      }
      if (fetchDuration.text.isEmpty) {
        fetchDuration.text = c.fetchSeconds.toString();
      }
      if (password.text.isEmpty) {
        password.text = c.password;
      }
    }
    return Scaffold(
        appBar: AppBar(title: const Text("登录"), actions: [
          TextButton.icon(
              onPressed: handleLogin,
              icon: const Icon(Icons.login),
              label: const Text("登录"))
        ]),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(children: [
                  TextField(
                      autofocus: true,
                      controller: username,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(), labelText: "用户名")),
                  TextField(
                      controller: password,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(), labelText: "密码")),
                  TextField(
                      controller: fetchDuration,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(), labelText: "刷新间隔(秒)"))
                ]))));
  }

  void handleLogin() async {
    final d = int.tryParse(fetchDuration.text);
    if (username.text.isNotEmpty &&
        password.text.isNotEmpty &&
        fetchDuration.text.isNotEmpty &&
        d != null) {
      await ref
          .read(configsProvider.notifier)
          .set(username.text, password.text, d);
      await showSimpleMessage(context, content: "设置已更新");
      Navigator.of(context).pop();
    } else {
      await showSimpleMessage(context, content: "请输入用户名和密码");
    }
  }
}
