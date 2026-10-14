import 'package:flutter_test/flutter_test.dart';

import 'package:clothing_store/core/utils/validators.dart';

void main() {
  group('Validators.validateEmail', () {
    test('requires a value', () {
      expect(Validators.validateEmail(''), 'Email is required');
      expect(Validators.validateEmail('   '), 'Email is required');
    });

    test('rejects badly formatted emails', () {
      for (final email in ['abc', 'abc@', 'abc@shop', '@shop.com', 'a b@shop.com', 'abc@shop.c']) {
        expect(Validators.validateEmail(email), 'Enter a valid email address', reason: email);
      }
    });

    test('accepts valid emails', () {
      expect(Validators.validateEmail('demo@shop.com'), isNull);
      expect(Validators.validateEmail('first.last+tag@mail.co.in'), isNull);
      expect(Validators.validateEmail('  demo@shop.com  '), isNull);
    });
  });

  group('Validators.validatePassword', () {
    test('requires a value', () {
      expect(Validators.validatePassword(''), 'Password is required');
    });

    test('enforces minimum length', () {
      expect(Validators.validatePassword('12345'), 'Password must be at least 6 characters');
    });

    test('accepts a valid password', () {
      expect(Validators.validatePassword('Password@123'), isNull);
    });
  });
}
