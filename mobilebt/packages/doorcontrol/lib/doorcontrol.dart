
import 'doorcontrol_platform_interface.dart';

class Doorcontrol {
  Future<String?> getPlatformVersion() {
    return DoorcontrolPlatform.instance.getPlatformVersion();
  }

  bool doorControl(bool isOpening) {
    if (isOpening)
      {
        DoorcontrolPlatform.instance.turnOn(5);
        return false;
      }
    else
      {
        DoorcontrolPlatform.instance.turnOn(0);
        return true;
      }

  }


  Future<String?> turnOn(int address) {
    return DoorcontrolPlatform.instance.turnOn(address);
  }

  Future<String?> turnOff(int address) {
    return DoorcontrolPlatform.instance.turnOff(address);
  }
}
