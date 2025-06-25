import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:screen_me/api/core.dart';

class ConfigSyncService {
  // 获取设备唯一标识用于加密
  static Future<String> getDeviceIdentifier() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return "${androidInfo.model}-${androidInfo.id}";
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return "${iosInfo.model}-${iosInfo.identifierForVendor}";
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        return "${windowsInfo.computerName}-${windowsInfo.deviceId}";
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        return "${macInfo.computerName}-${macInfo.systemGUID}";
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        return "${linuxInfo.name}-${linuxInfo.machineId}";
      }
    } catch (e) {
      debugPrint("获取设备信息失败: $e");
    }
    return "default-device";
  }

  // 简单的字符串加密（使用设备标识作为密钥）
  static String encryptData(String data, String key) {
    final keyBytes = utf8.encode(key);
    final dataBytes = utf8.encode(data);
    final encrypted = <int>[];
    
    for (int i = 0; i < dataBytes.length; i++) {
      encrypted.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return base64Encode(encrypted);
  }

  // 字符串解密
  static String decryptData(String encryptedData, String key) {
    try {
      final keyBytes = utf8.encode(key);
      final encrypted = base64Decode(encryptedData);
      final decrypted = <int>[];
      
      for (int i = 0; i < encrypted.length; i++) {
        decrypted.add(encrypted[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      return utf8.decode(decrypted);
    } catch (e) {
      return "";
    }
  }

  // 导出配置到云端
  static Future<ConfigSyncResult> exportConfig(Config config) async {
    try {
      // 获取设备标识并加密配置
      final deviceId = await getDeviceIdentifier();
      final configJson = config.toJson();
      final encryptedConfig = encryptData(jsonEncode(configJson), deviceId);
      
      // 发送到云端
      final response = await http.post(
        Uri.parse('https://screenme.mazhangjing.com/upload'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'config': encryptedConfig,
          'deviceId': encodeSha1Base64(deviceId), // 只发送设备ID的哈希值用于识别
        }),
      );
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true) {
          return ConfigSyncResult.success(
            password: result['password'],
            expiresIn: result['expiresIn'],
            message: result['message'] ?? '导出成功',
          );
        } else {
          return ConfigSyncResult.error("导出失败: ${result['message']}");
        }
      } else {
        return ConfigSyncResult.error("网络请求失败: ${response.statusCode}");
      }
    } catch (e) {
      return ConfigSyncResult.error("导出失败: $e");
    }
  }

  // 从云端导入配置
  static Future<ConfigSyncResult> importConfig(String secret) async {
    if (secret.isEmpty) {
      return ConfigSyncResult.error("请输入配置密码");
    }
    
    try {
      // 从云端获取配置
      final response = await http.get(
        Uri.parse('https://screenme.mazhangjing.com/config/$secret'),
      );
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true) {
          final encryptedConfig = result['data']['config'];
          final remainingTime = result['remainingTime'];
          
          // 获取设备标识并解密配置
          final deviceId = await getDeviceIdentifier();
          final decryptedConfig = decryptData(encryptedConfig, deviceId);
          
          if (decryptedConfig.isEmpty) {
            return ConfigSyncResult.error("配置解密失败，可能不是从相同类型设备导出的配置");
          }
          
          try {
            final configJson = jsonDecode(decryptedConfig) as Map<String, dynamic>;
            final config = Config.fromJson(configJson);
            
            return ConfigSyncResult.success(
              config: config,
              remainingTime: remainingTime,
              message: "配置导入成功！剩余时间：${remainingTime}秒",
            );
          } catch (e) {
            return ConfigSyncResult.error("配置格式错误: $e");
          }
        } else {
          return ConfigSyncResult.error("获取配置失败: ${result['message'] ?? '未知错误'}");
        }
      } else {
        return ConfigSyncResult.error("网络请求失败: ${response.statusCode}");
      }
    } catch (e) {
      return ConfigSyncResult.error("导入失败: $e");
    }
  }
}

// 配置同步结果类
class ConfigSyncResult {
  final bool success;
  final String message;
  final String? password;
  final int? expiresIn;
  final int? remainingTime;
  final Config? config;

  ConfigSyncResult._({
    required this.success,
    required this.message,
    this.password,
    this.expiresIn,
    this.remainingTime,
    this.config,
  });

  factory ConfigSyncResult.success({
    String? password,
    int? expiresIn,
    int? remainingTime,
    Config? config,
    String message = "操作成功",
  }) {
    return ConfigSyncResult._(
      success: true,
      message: message,
      password: password,
      expiresIn: expiresIn,
      remainingTime: remainingTime,
      config: config,
    );
  }

  factory ConfigSyncResult.error(String message) {
    return ConfigSyncResult._(
      success: false,
      message: message,
    );
  }
} 