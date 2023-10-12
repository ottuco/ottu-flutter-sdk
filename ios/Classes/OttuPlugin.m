#import "OttuPlugin.h"
#if __has_include(<ottu/ottu-Swift.h>)
#import <ottu/ottu-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ottu-Swift.h"
#endif

@implementation OttuPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOttuPlugin registerWithRegistrar:registrar];
}
@end
