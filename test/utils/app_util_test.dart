import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/utils/app_util.dart';

void main() {
  group('AppUtil', () {
    group('isPasswordValid', () {
      test('should return true for valid password', () {
        expect(AppUtil.isPasswordValid('Test123!@'), true);
        expect(AppUtil.isPasswordValid('ValidPass1!'), true);
        expect(AppUtil.isPasswordValid('Str0ng#Pass'), true);
      });

      test('should return false for password without uppercase', () {
        expect(AppUtil.isPasswordValid('test123!@'), false);
      });

      test('should return false for password without lowercase', () {
        expect(AppUtil.isPasswordValid('TEST123!@'), false);
      });

      test('should return false for password without number', () {
        expect(AppUtil.isPasswordValid('TestPass!@'), false);
      });

      test('should return false for password without special character', () {
        expect(AppUtil.isPasswordValid('TestPass123'), false);
      });

      test('should return false for password shorter than 8 characters', () {
        expect(AppUtil.isPasswordValid('Test1!'), false);
        expect(AppUtil.isPasswordValid('Ab1!'), false);
      });

      test('should return true for password with various special characters', () {
        expect(AppUtil.isPasswordValid('Test123!'), true);
        expect(AppUtil.isPasswordValid('Test123@'), true);
        expect(AppUtil.isPasswordValid('Test123#'), true);
        expect(AppUtil.isPasswordValid('Test123\$'), true);
        expect(AppUtil.isPasswordValid('Test123%'), true);
        expect(AppUtil.isPasswordValid('Test123^'), true);
        expect(AppUtil.isPasswordValid('Test123&'), true);
        expect(AppUtil.isPasswordValid('Test123*'), true);
      });

      test('should return false for empty password', () {
        expect(AppUtil.isPasswordValid(''), false);
      });
    });

    group('isEmailValid', () {
      test('should return true for valid email', () {
        expect(AppUtil.isEmailValid('test@example.com'), true);
        expect(AppUtil.isEmailValid('user.name@example.com'), true);
        expect(AppUtil.isEmailValid('user+tag@example.co.uk'), true);
      });

      test('should return false for invalid email', () {
        expect(AppUtil.isEmailValid('invalid'), false);
        expect(AppUtil.isEmailValid('invalid@'), false);
        expect(AppUtil.isEmailValid('@example.com'), false);
        expect(AppUtil.isEmailValid('user@'), false);
      });

      test('should return true for empty email', () {
        // Empty email is considered valid per implementation
        expect(AppUtil.isEmailValid(''), true);
      });

      test('should return false for email without domain', () {
        expect(AppUtil.isEmailValid('test@.com'), false);
      });

      test('should return false for email with spaces', () {
        expect(AppUtil.isEmailValid('test @example.com'), false);
        expect(AppUtil.isEmailValid('test@ example.com'), false);
      });
    });

    group('isPhoneNumberValid', () {
      test('should return true for valid phone number', () {
        expect(AppUtil.isPhoneNumberValid('1234567890'), true);
        expect(AppUtil.isPhoneNumberValid('12345678901'), true);
        expect(AppUtil.isPhoneNumberValid('123456789012'), true);
      });

      test('should return true for phone number with country code', () {
        expect(AppUtil.isPhoneNumberValid('+11234567890'), true);
        expect(AppUtil.isPhoneNumberValid('01234567890'), true);
      });

      test('should return false for too short phone number', () {
        expect(AppUtil.isPhoneNumberValid('123456789'), false);
        expect(AppUtil.isPhoneNumberValid('12345'), false);
      });

      test('should return false for too long phone number', () {
        expect(AppUtil.isPhoneNumberValid('1234567890123'), false);
      });

      test('should return true for empty phone number', () {
        // Empty phone is considered valid per implementation
        expect(AppUtil.isPhoneNumberValid(''), true);
      });

      test('should return false for phone with letters', () {
        expect(AppUtil.isPhoneNumberValid('123abc7890'), false);
      });

      test('should return false for phone with special characters', () {
        expect(AppUtil.isPhoneNumberValid('123-456-7890'), false);
        expect(AppUtil.isPhoneNumberValid('(123) 456-7890'), false);
      });
    });

    group('getUid', () {
      test('should generate UID', () {
        final uid = AppUtil.getUid();
        
        expect(uid, isNotNull);
        expect(uid, isA<String>());
      });

      test('should generate UID with correct length', () {
        final uid = AppUtil.getUid();
        
        expect(uid.length, 11);
      });

      test('should generate UID starting with letter', () {
        final uid = AppUtil.getUid();
        final firstChar = uid[0];
        
        expect(RegExp(r'[a-zA-Z]').hasMatch(firstChar), true);
      });

      test('should generate unique UIDs', () {
        final uid1 = AppUtil.getUid();
        final uid2 = AppUtil.getUid();
        final uid3 = AppUtil.getUid();
        
        expect(uid1, isNot(equals(uid2)));
        expect(uid2, isNot(equals(uid3)));
        expect(uid1, isNot(equals(uid3)));
      });

      test('should generate UID with alphanumeric characters', () {
        final uid = AppUtil.getUid();
        
        expect(RegExp(r'^[a-zA-Z0-9]+$').hasMatch(uid), true);
      });

      test('should generate multiple UIDs consistently', () {
        for (int i = 0; i < 10; i++) {
          final uid = AppUtil.getUid();
          expect(uid.length, 11);
          expect(RegExp(r'^[a-zA-Z][a-zA-Z0-9]+$').hasMatch(uid), true);
        }
      });
    });
  });
}
