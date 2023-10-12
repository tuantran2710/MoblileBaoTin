import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'doorcontrol_method_channel.dart';

abstract class DoorcontrolPlatform extends PlatformInterface {
  /// Constructs a DoorcontrolPlatform.
  DoorcontrolPlatform() : super(token: _token);

  static final Object _token = Object();

  static DoorcontrolPlatform _instance = MethodChannelDoorcontrol();

  /// The default instance of [DoorcontrolPlatform] to use.
  ///
  /// Defaults to [MethodChannelDoorcontrol].
  static DoorcontrolPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DoorcontrolPlatform] when
  /// they register themselves.
  static set instance(DoorcontrolPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> turnOn(int address) {
    throw UnimplementedError('turnOn() has not been implemented.');
  }

  Future<String?> turnOff(int address) {
    throw UnimplementedError('turnOff() has not been implemented.');
  }

}
