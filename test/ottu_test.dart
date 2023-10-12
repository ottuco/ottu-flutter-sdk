// import 'package:flutter_test/flutter_test.dart';
// import 'package:ottu/ottu.dart';
// import 'package:ottu/ottu_platform_interface.dart';
// import 'package:ottu/ottu_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockOttuPlatform
//     with MockPlatformInterfaceMixin
//     implements OttuPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final OttuPlatform initialPlatform = OttuPlatform.instance;

//   test('$MethodChannelOttu is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelOttu>());
//   });

//   test('getPlatformVersion', () async {
//     Ottu ottuPlugin = Ottu();
//     MockOttuPlatform fakePlatform = MockOttuPlatform();
//     OttuPlatform.instance = fakePlatform;

//     expect(await ottuPlugin.getPlatformVersion(), '42');
//   });
// }
