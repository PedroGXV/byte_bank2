import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:byte_bank2/models/contact.dart';

// USE DAO instead

Future<Database> createDatabase() async {

  final String path = join(await getDatabasesPath(), 'bytebank.db');

  return openDatabase(
    path,
    onDowngrade: onDatabaseDowngradeDelete,
    onCreate: (db, version) {
      db.execute('CREATE TABLE contacts('
          'id INTEGER PRIMARY KEY AUTOINCREMENT , '
          'nome TEXT, '
          'account_number INTEGER)');
    },
    version: 1,
  );
}

Future<int> save(Contact contact) {
  final db =  createDatabase();

  return createDatabase().then((db) {
    final Map<String, dynamic> contactMap = Map();
    contactMap['nome'] = contact.name;
    contactMap['account_number'] = contact.accountNumber;
    return db.insert('contacts', contactMap);
  });
}

Future<List<Contact>> findAll() {
  return createDatabase().then((db) {
    return db.query('contacts').then((maps) {
      final List<Contact> contacts = List();
      for (Map<String, dynamic> map in maps) {
        final Contact contact = Contact(
          map['id'],
          map['nome'],
          map['account_number'],
        );
        contacts.add(contact);
      }
      return contacts;
    });
  });
}

Future<String> drop() async {
  return createDatabase().then((db) {
    return db.delete('contacts').then((value) {
      return value.toString();
    });
  });
}
