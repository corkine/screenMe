import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:screen_me/api/common.dart';

class BlueWidget extends ConsumerStatefulWidget {
  const BlueWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlueWidgetState();
}

class _BlueWidgetState extends ConsumerState<BlueWidget> {
  bool isOn = false;
  bool unsupport = true;
  StreamSubscription? sub;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      if (!Platform.isMacOS) {
        FlutterVolumeController.updateShowSystemUI(true);
      }
      FlutterBluePlus.isSupported.then((value) {
        setState(() {
          unsupport = !value;
        });
        debugPrint("bluetooth support, start listen state change");
        sub =
            FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
          debugPrint(state.toString());
          final now = state == BluetoothAdapterState.on ? true : false;
          if (now != isOn) {
            setState(() {
              isOn = now;
            });
          }
        });
      });
    } else {
      unsupport = true;
    }
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configsProvider).value ?? Config();
    return unsupport
        ? const SizedBox()
        : IconButton(
            onPressed: () async {
              if (!unsupport && Platform.isAndroid) {
                if (isOn) {
                  // ignore: deprecated_member_use
                  await FlutterVolumeController.setVolume(config.volumeNormal);
                  await FlutterBluePlus.turnOff();
                } else {
                  try {
                    await FlutterBluePlus.turnOn();
                  } catch (_) {}
                  if (config.maxVolDelaySeconds > 0) {
                    await Future.delayed(Duration(
                        milliseconds:
                            (config.maxVolDelaySeconds * 1000).toInt()));
                    await FlutterVolumeController.setVolume(
                        config.volumeOpenBluetooth);
                  }
                }
              }
            },
            icon: Icon(
                !isOn ? Icons.bluetooth_disabled : Icons.bluetooth_connected,
                color: Colors.white));
  }
}
