import 'package:byte_bank2/models/contact.dart';
import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../components/form_button.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _accountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Contact')),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                  ),
                  style: TextStyle(fontSize: 18)),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _accountController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              FormButton(
                title: 'Create',
                onPressed: () {
                  final String name = _nameController.text;
                  final int accountNumber =
                      int.tryParse(_accountController.text);

                  final Contact newContact = Contact(0, name, accountNumber);
                  save(newContact).then((id) => Navigator.pop(context));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
