#import "BoringsslFlutterPlugin.h"
#import <boringssl_flutter/boringssl_flutter-Swift.h>

@implementation BoringsslFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBoringsslFlutterPlugin registerWithRegistrar:registrar];
}
@end
