import 'package:byte_bank2/components/centered_message.dart';
import 'package:byte_bank2/components/loading.dart';
import '../http/webclients/transaction_webclient/transaction_webclient.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionsList extends StatefulWidget {
  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  final List<Transaction> transactions = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: FutureBuilder<List<Transaction>>(
          future: TransactionWebClient().findAll(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                // TODO: Handle this case.
                break;
              case ConnectionState.waiting:
                return Loading();
                break;
              case ConnectionState.active:
                // TODO: Handle this case.
                break;
              case ConnectionState.done:

                if (snapshot.hasData) {
                  final List<Transaction> transactions = snapshot.data;

                  if (transactions.isNotEmpty) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final Transaction transaction = transactions[index];

                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.monetization_on),
                            title: Text(
                              transaction.value.toString(),
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              transaction.contact.accountNumber.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: transactions.length,
                    );
                  }
                }

                return CenteredMessage(
                  'No transactions found.',
                  icon: Icons.warning_amber_rounded,
                );

                break;
            }
            return CenteredMessage(
                'Então... Alguma coisa deu errado :/\nNem eu sei que que rolou...');
          }),
    );
  }
}
