
import 'package:byte_bank2/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return th value when create a transaction', () {
    final transaction = Transaction(null, 200, null);
    expect(transaction.value, 200);
  });
  test('Should return an error when the transaction value equal or less than 0', () {
    // se fizer fora da função não funciona
    expect(() => Transaction(null, -2,null), throwsAssertionError);
  });
}
