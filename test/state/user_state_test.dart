import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/models/user.dart';
import 'package:task_flow/core/services/user_service.dart';

@GenerateMocks([UserService])
import 'user_state_test.mocks.dart';

void main() {
  group('UserState', () {
    late MockUserService mockService;
    late UserState userState;

    setUp(() {
      mockService = MockUserService();
      userState = UserState(service: mockService);
    });

    test('should start with null current user', () {
      expect(userState.currentUser, null);
      expect(userState.isAuthenticated, false);
    });

    test('should initialize with current user', () async {
      final user = User(
        id: 'user1',
        fullName: 'Test User',
        email: 'test@example.com',
        username: 'testuser',
      );

      when(mockService.getCurrentUser()).thenAnswer((_) async => user);

      await userState.initialize();

      expect(userState.currentUser, user);
      expect(userState.isAuthenticated, true);
      verify(mockService.getCurrentUser()).called(1);
    });

    test('should sign in successfully', () async {
      final user = User(
        id: 'user1',
        fullName: 'Test User',
        email: 'test@example.com',
        username: 'testuser',
      );

      when(
        mockService.login('testuser', 'password'),
      ).thenAnswer((_) async => user);

      final result = await userState.signIn(
        username: 'testuser',
        password: 'password',
      );

      expect(result, true);
      expect(userState.currentUser, user);
      expect(userState.isAuthenticated, true);
      verify(mockService.login('testuser', 'password')).called(1);
    });

    test('should fail to sign in with invalid credentials', () async {
      when(mockService.login('invalid', 'wrong')).thenAnswer((_) async => null);

      final result = await userState.signIn(
        username: 'invalid',
        password: 'wrong',
      );

      expect(result, false);
      expect(userState.currentUser, null);
      expect(userState.isAuthenticated, false);
    });

    test('should sign up user', () async {
      final user = User(
        id: 'user1',
        fullName: 'New User',
        email: 'new@example.com',
        username: 'newuser',
      );

      when(
        mockService.signUpUser(
          username: 'newuser',
          password: 'password',
          email: 'new@example.com',
          name: 'New User',
          phoneNumber: '1234567890',
        ),
      ).thenAnswer((_) async => user);

      final result = await userState.signUp(
        name: 'New User',
        email: 'new@example.com',
        username: 'newuser',
        phoneNumber: '1234567890',
        password: 'password',
      );

      expect(result, user);
      verify(
        mockService.signUpUser(
          username: 'newuser',
          password: 'password',
          email: 'new@example.com',
          name: 'New User',
          phoneNumber: '1234567890',
        ),
      ).called(1);
    });

    test('should logout user', () async {
      final user = User(
        id: 'user1',
        fullName: 'Test User',
        email: 'test@example.com',
        username: 'testuser',
      );

      when(
        mockService.login('testuser', 'password'),
      ).thenAnswer((_) async => user);
      when(mockService.logout()).thenAnswer((_) async => {});

      await userState.signIn(username: 'testuser', password: 'password');
      expect(userState.isAuthenticated, true);

      await userState.logout();

      expect(userState.currentUser, null);
      expect(userState.isAuthenticated, false);
      verify(mockService.logout()).called(1);
    });

    test('should set current user', () async {
      final user = User(
        id: 'user1',
        fullName: 'Test User',
        email: 'test@example.com',
        username: 'testuser',
      );

      when(mockService.setCurrentUser(user)).thenAnswer((_) async => {});

      await userState.setCurrent(user);

      expect(userState.currentUser, user);
      expect(userState.isAuthenticated, true);
      verify(mockService.setCurrentUser(user)).called(1);
    });

    test('should request forget password', () async {
      when(
        mockService.requestForgetPassword('test@example.com'),
      ).thenAnswer((_) async => true);

      final result = await userState.requestForgetPassword('test@example.com');

      expect(result, true);
      verify(mockService.requestForgetPassword('test@example.com')).called(1);
    });

    test('should change current user password', () async {
      when(
        mockService.changeCurrentUserPassword('newPassword'),
      ).thenAnswer((_) async => true);

      final result = await userState.changeCurrentUserPassword('newPassword');

      expect(result, true);
      verify(mockService.changeCurrentUserPassword('newPassword')).called(1);
    });

    test('should notify listeners on state changes', () async {
      final user = User(
        id: 'user1',
        fullName: 'Test User',
        email: 'test@example.com',
        username: 'testuser',
      );

      when(
        mockService.login('testuser', 'password'),
      ).thenAnswer((_) async => user);

      int notificationCount = 0;
      userState.addListener(() {
        notificationCount++;
      });

      await userState.signIn(username: 'testuser', password: 'password');

      expect(notificationCount, greaterThan(0));
    });
  });
}
