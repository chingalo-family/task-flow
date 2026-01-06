import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:task_flow/app_state/app_info_state/app_info_state.dart';
import '../helpers/test_helper.mocks.dart';

void main() {
  late AppInfoState appInfoState;
  late MockSystemInfoService mockSystemInfoService;

  setUp(() {
    mockSystemInfoService = MockSystemInfoService();
    appInfoState = AppInfoState(service: mockSystemInfoService);
  });

  group('AppInfoState Tests', () {
    test('initial state is correct', () {
      expect(appInfoState.loading, true);
      expect(appInfoState.appName, '');
      expect(appInfoState.packageName, '');
      expect(appInfoState.version, '');
      expect(appInfoState.buildNumber, '');
    });

    test('initialize loads app info', () async {
      when(mockSystemInfoService.getPackageInfo()).thenAnswer(
        (_) async => PackageInfo(
          appName: 'Task Flow',
          packageName: 'com.example.task_flow',
          version: '1.0.0',
          buildNumber: '1',
        ),
      );

      appInfoState.initiatizeAppInfo();

      // Since initiatizeAppInfo is void and not Future, we might need a small delay
      // or verify calls.
      // Wait for microtasks
      await Future.delayed(Duration.zero);

      verify(mockSystemInfoService.getPackageInfo()).called(1);
      expect(appInfoState.appName, 'Task Flow');
      expect(appInfoState.packageName, 'com.example.task_flow');
      expect(appInfoState.version, '1.0.0');
      expect(appInfoState.buildNumber, '1');
      expect(appInfoState.loading, false);
    });

    test('initialize handles error', () async {
      when(mockSystemInfoService.getPackageInfo()).thenThrow('Error');

      appInfoState.initiatizeAppInfo();
      await Future.delayed(Duration.zero);

      expect(appInfoState.loading, false);
      // Fields remain empty defaults
      expect(appInfoState.appName, '');
    });
  });
}
