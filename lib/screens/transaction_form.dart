import 'dart:async';

import 'package:byte_bank2/components/response_dialog.dart';
import 'package:byte_bank2/components/transaction_auth_dialog.dart';
import 'package:uuid/uuid.dart';
import '../http/webclients/transaction_webclient/transaction_webclient.dart';
import 'package:byte_bank2/models/contact.dart';
import 'package:byte_bank2/models/transaction.dart';
import 'package:flutter/material.dart';
import '../components/form_button.dart';
import '../components/progress.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final String transactionId = Uuid().v4();
  final TextEditingController _valueController = TextEditingController();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    print('ID TRANSACTION: $transactionId');
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                child: Progress(
                  message: 'Sending...',
                ),
                visible: _sending,
              ),
              Text(
                'To: ${widget.contact.name}',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Account Nº',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 15,
                    backgroundColor: Colors.grey,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: FormButton(
                    title: 'Transfer',
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);

                      final transactionCreated =
                          Transaction(transactionId, value, widget.contact);

                      showDialog(
                        context: context,
                        builder: (contextDialog) {
                          return TransactionAuthDialog(
                            onConfirm: (pwd) {
                              _save(transactionCreated, pwd, context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(
      Transaction transactionCreated, String pwd, BuildContext context) async {
    Transaction transaction = await _send(transactionCreated, pwd, context);

    _showSuccessfulMessage(transaction, context);
  }

  Future _showSuccessfulMessage(
      Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
        context: context,
        builder: (contextDialog) {
          return SuccessDialog('Successful transaction!');
        },
      );
      Navigator.of(context).pop(context);
    }
  }

  Future<Transaction> _send(
      Transaction transactionCreated, String pwd, BuildContext context) async {
    setState(() {
      _sending = true;
    });

    final Transaction transaction =
        await TransactionWebClient().save(transactionCreated, pwd).catchError(
      (err) {
        _showFailureMessage(context, message: '${err.message}');
      },
      test: (err) => err is HttpException,
    ).catchError(
      (err) {
        _showFailureMessage(context, message: 'Timeout Error.');
      },
      test: (err) => err is TimeoutException,
    ).catchError((err) {
      // deixe o mais generico por último
      _showFailureMessage(context);
    }).whenComplete(
      () => {
        setState(() {
          _sending = false;
        })
      },
    );

    return transaction;
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'Unknown Error.'}) {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return FailureDialog(message);
      },
    );
  }
}
