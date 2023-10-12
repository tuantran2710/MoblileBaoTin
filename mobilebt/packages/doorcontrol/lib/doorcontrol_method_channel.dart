import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'doorcontrol_platform_interface.dart';

/// An implementation of [DoorcontrolPlatform] that uses method channels.
class MethodChannelDoorcontrol extends DoorcontrolPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('doorcontrol');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> turnOn(int address) async {
    final version = await methodChannel.invokeMethod<String>('turnOn', <String, dynamic>{
      'address': address
    });
    return version;
  }

  @override
  Future<String?> turnOff(int address) async {
    final version = await methodChannel.invokeMethod<String>('turnOff', <String, dynamic>{
      'address': address
    });
    return version;
  }

}
