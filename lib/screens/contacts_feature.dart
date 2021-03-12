import 'package:byte_bank2/components/loading.dart';
import 'package:byte_bank2/database/app_database.dart';
import 'package:byte_bank2/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'contact_form.dart';

class ContactsFeature extends StatefulWidget {
  @override
  _ContactsFeatureState createState() => _ContactsFeatureState();
}

class _ContactsFeatureState extends State<ContactsFeature> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transfer to')),
      body: FutureBuilder<List<Contact>>(
        // initial data define como valor inicial uma lista vazia
        initialData: List(),
        // primeiro ele busca o future
        future: findAll(),
        // o builder executa após o future retornar
        // snapshot é o retorno do future
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Loading();
              break;
            case ConnectionState.active:
            // stream
              break;
            case ConnectionState.done:
              final List<Contact> contacts = snapshot.data;

              if (snapshot.data.length == null)
                return ListView();
              else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Contact contact = contacts[index];
                    return _ContactItem(
                      contact: contact,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TransactionForm(contact),
                        ));
                      },
                    );
                  },
                  itemCount: contacts.length,
                );
              }
              break;
          }
          return Text(
              'Então... Alguma coisa deu errado :/\nNem eu sei que que rolou...');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => ContactForm(),
            ),
          )
              .then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onTap;

  const _ContactItem({Key key, @required this.contact, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: ListTile(
        onTap: () {
          this.onTap();
        },
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
