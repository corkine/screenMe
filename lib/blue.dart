import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:screen_me/api/core.dart';

class BlueWidget extends ConsumerStatefulWidget {
  const BlueWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlueWidgetState();
}

class _BlueWidgetState extends ConsumerState<BlueWidget>
    with TickerProviderStateMixin {
  bool isOn = false;
  bool unsupport = true;
  bool isProcessing = false;
  bool isPreviewMode = false; // 预览模式标志
  bool showBorder = false; // 控制外圈显示
  Timer? borderTimer; // 外圈消失定时器
  StreamSubscription? sub;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // 初始化动画控制器
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      if (!Platform.isMacOS) {
        FlutterVolumeController.updateShowSystemUI(true);
      }
      FlutterBluePlus.isSupported.then((value) {
        if (!mounted) return;
        setState(() {
          unsupport = !value;
        });
        debugPrint("bluetooth support, start listen state change");
        sub =
            FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
          if (!mounted) return;
          debugPrint(state.toString());
          final now = state == BluetoothAdapterState.on ? true : false;
          if (now != isOn) {
            setState(() {
              isOn = now;
              isProcessing = false; // 状态改变时停止处理状态
              if (isOn) {
                _showBorderTemporarily(); // 开启时显示外圈
              } else {
                _hideBorder(); // 关闭时立即隐藏外圈
              }
            });
          }
        });
      });
    } else if (Platform.isWindows && kDebugMode) {
      // 仅在 Windows Debug 模式下启用预览
      isPreviewMode = true;
      unsupport = false; // 允许显示组件
      isOn = false; // 默认关闭状态，点击后可以切换
      debugPrint("预览模式：在 Windows Debug 模式下显示蓝牙组件 UI");
    } else {
      // 其他平台或Release模式：不支持
      unsupport = true;
      debugPrint("蓝牙组件在当前平台 ${Platform.operatingSystem} 上不支持");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    borderTimer?.cancel();
    sub?.cancel();
    super.dispose();
  }

  // 显示外圈，3秒后自动消失
  void _showBorderTemporarily() {
    setState(() {
      showBorder = true;
    });
    borderTimer?.cancel();
    borderTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showBorder = false;
        });
      }
    });
  }

  // 立即隐藏外圈
  void _hideBorder() {
    borderTimer?.cancel();
    setState(() {
      showBorder = false;
    });
  }

  // 触觉反馈
  void _provideFeedback() {
    HapticFeedback.mediumImpact();
  }

  // 点击动画
  void _animatePress() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configsProvider).value ?? Config();
    
    if (unsupport) {
      return const SizedBox();
    }

    // 统一布局：都使用相同的容器尺寸，确保图标位置一致
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // 只有开启状态且需要显示边框时才显示外圈
              color: isOn && showBorder
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.transparent,
              border: isOn && showBorder
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                splashColor: isOn 
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
                highlightColor: isOn 
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                onTap: isProcessing ? null : () async {
                  _provideFeedback();
                  _animatePress();
                  await _handleBluetoothToggle(config);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 主图标 - 位置固定
                    Icon(
                      isOn ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                      color: isOn ? Colors.blue : Colors.white,
                      size: 24,
                    ),
                    // 处理中的加载指示器
                    if (isProcessing)
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: isOn ? Colors.blue : Colors.white,
                        ),
                      ),
                    // 预览模式标识
                    if (isPreviewMode)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 处理蓝牙切换逻辑
  Future<void> _handleBluetoothToggle(Config config) async {
    if (isPreviewMode) {
      // 预览模式：模拟蓝牙切换
      if (!mounted) return;
      setState(() {
        isProcessing = true;
      });
      
      // 模拟操作延迟
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;
      setState(() {
        isOn = !isOn;
        isProcessing = false;
        if (isOn) {
          _showBorderTemporarily(); // 开启时显示外圈
        } else {
          _hideBorder(); // 关闭时隐藏外圈
        }
      });
      
      debugPrint("预览模式：蓝牙状态切换为 ${isOn ? '开启' : '关闭'}");
    } else if (!unsupport && Platform.isAndroid) {
      if (!mounted) return;
      setState(() {
        isProcessing = true;
      });
      
      try {
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
      } catch (e) {
        debugPrint('蓝牙操作失败: $e');
        if (!mounted) return;
        setState(() {
          isProcessing = false;
        });
      }
    }
  }
}
