import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('User creation with required fields', () {
      final user = User(id: '1', username: 'testuser');

      expect(user.id, '1');
      expect(user.username, 'testuser');
      expect(user.fullName, isNull);
      expect(user.email, isNull);
      expect(user.phoneNumber, isNull);
    });

    test('User creation with all fields', () {
      final user = User(
        id: '1',
        username: 'testuser',
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: '+1234567890',
      );

      expect(user.id, '1');
      expect(user.username, 'testuser');
      expect(user.fullName, 'Test User');
      expect(user.email, 'test@example.com');
      expect(user.phoneNumber, '+1234567890');
    });

    test('User fromJson with all fields', () {
      final json = {
        'id': 123,
        'username': 'jsonuser',
        'name': 'JSON User',
        'email': 'json@example.com',
        'phoneNumber': '+9876543210',
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.username, 'jsonuser');
      expect(user.fullName, 'JSON User');
      expect(user.email, 'json@example.com');
      expect(user.phoneNumber, '+9876543210');
    });

    test('User fromJson with missing optional fields', () {
      final json = {
        'id': '456',
        'username': 'minimaluser',
      };

      final user = User.fromJson(json);

      expect(user.id, '456');
      expect(user.username, 'minimaluser');
      expect(user.fullName, '');
      expect(user.email, '');
      expect(user.phoneNumber, '');
    });

    test('User fromJson with null values', () {
      final json = {
        'id': null,
        'username': null,
        'name': null,
        'email': null,
        'phoneNumber': null,
      };

      final user = User.fromJson(json);

      expect(user.id, '');
      expect(user.username, '');
      expect(user.fullName, '');
      expect(user.email, '');
      expect(user.phoneNumber, '');
    });

    test('User toString returns formatted string', () {
      final user = User(
        id: '1',
        username: 'testuser',
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: '+1234567890',
      );

      final result = user.toString();

      expect(result, contains('id: 1'));
      expect(result, contains('username: testuser'));
      expect(result, contains('fullName: Test User'));
      expect(result, contains('email: test@example.com'));
      expect(result, contains('phoneNumber: +1234567890'));
    });
  });
}
