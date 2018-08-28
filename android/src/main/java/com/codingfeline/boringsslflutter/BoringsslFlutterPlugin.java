package com.codingfeline.boringsslflutter;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** BoringsslFlutterPlugin */
public class BoringsslFlutterPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "boringssl_flutter");
    channel.setMethodCallHandler(new BoringsslFlutterPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE + " " + stringFromJNI());
    } else {
      result.notImplemented();
    }
  }

  public native String stringFromJNI();

  static {
    System.loadLibrary("crypto-main");
  }
}
