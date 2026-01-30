import 'package:flutter_test/flutter_test.dart';
import 'package:sweetstall/models/sweet.dart';

void main() {
  group('Sweet', () {
    test('equality is based on id and name', () {
      const a = Sweet(id: 'bubble', name: 'Bubble Gum');
      const b = Sweet(id: 'bubble', name: 'Bubble Gum');
      const c = Sweet(id: 'mint', name: 'Mint');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('toString includes id and name', () {
      const sweet = Sweet(id: 'berry', name: 'Berry Burst');
      expect(sweet.toString(), contains('berry'));
      expect(sweet.toString(), contains('Berry Burst'));
    });
  });
}
