package baotin.com.mobilestore.doorcontrol;

import android.os.AsyncTask;
import de.re.easymodbus.modbusclient.*;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


/** DoorcontrolPlugin */
public class DoorcontrolPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  ModbusClient modbusClient;
  int address;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "doorcontrol");
    channel.setMethodCallHandler(this);
    modbusClient = new ModbusClient("171.248.173.241", 502);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }
    else if (call.method.equals("turnOn")) {
      Runnable r = new Runnable()
      {
        @Override
        public void run()
        {
          String ret;
          try {
            address = call.argument("address");
            modbusClient.Connect();
            modbusClient.WriteSingleRegister(address, 1);
            modbusClient.Disconnect();
          }
          catch (Exception e)
          {
            ret = "Modbus:" + e.toString();
            Thread.interrupted();
          }
        }
      };
      Thread t = new Thread(r);
      t.start();

      result.success("On");
    }
    else if (call.method.equals("turnOff")) {
      Runnable r = new Runnable()
      {
        @Override
        public void run()
        {
          String ret;
          try {
            address = call.argument("address");
            modbusClient.Connect();
            modbusClient.WriteSingleRegister(address, 0);
            modbusClient.Disconnect();
          }
          catch (Exception e)
          {
            ret = "Modbus:" + e.toString();
            Thread.interrupted();
          }
        }
      };
      Thread t = new Thread(r);
      t.start();

      result.success("Off");
    }
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
