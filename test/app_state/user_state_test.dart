import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/models/user.dart';
import '../helpers/test_helper.mocks.dart';

void main() {
  late UserState userState;
  late MockUserService mockUserService;

  setUp(() {
    mockUserService = MockUserService();
    userState = UserState(service: mockUserService);
  });

  final testUser = User(
    id: '123',
    username: 'test_user',
    fullName: 'Test User',
    email: 'test@example.com',
  );

  group('UserState Tests', () {
    test('initial state is correct', () {
      expect(userState.currentUser, null);
      expect(userState.isAuthenticated, false);
    });

    test('initialize loads current user', () async {
      when(mockUserService.getCurrentUser()).thenAnswer((_) async => testUser);

      await userState.initialize();

      verify(mockUserService.getCurrentUser()).called(1);
      expect(userState.currentUser, testUser);
      expect(userState.isAuthenticated, true);
    });

    test('initialize handles null user', () async {
      when(mockUserService.getCurrentUser()).thenAnswer((_) async => null);

      await userState.initialize();

      verify(mockUserService.getCurrentUser()).called(1);
      expect(userState.currentUser, null);
    });

    test('signIn success sets user and returns true', () async {
      when(
        mockUserService.login('user', 'pass'),
      ).thenAnswer((_) async => testUser);

      final result = await userState.signIn('user', 'pass');

      verify(mockUserService.login('user', 'pass')).called(1);
      expect(result, true);
      expect(userState.currentUser, testUser);
    });

    test('signIn failure returns false', () async {
      when(
        mockUserService.login('user', 'wrong_pass'),
      ).thenAnswer((_) async => null);

      final result = await userState.signIn('user', 'wrong_pass');

      verify(mockUserService.login('user', 'wrong_pass')).called(1);
      expect(result, false);
      expect(userState.currentUser, null);
    });

    test('logout clears user', () async {
      // Setup initial logged in state
      when(mockUserService.login(any, any)).thenAnswer((_) async => testUser);
      await userState.signIn('u', 'p');
      expect(userState.currentUser, isNotNull);

      when(mockUserService.logout()).thenAnswer((_) async {});

      await userState.logout();

      verify(mockUserService.logout()).called(1);
      expect(userState.currentUser, null);
    });
  });
}
