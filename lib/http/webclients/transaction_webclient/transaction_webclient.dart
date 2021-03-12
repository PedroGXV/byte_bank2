// para prevenir que o usuário demore para receber
// uma mensagem de erro ou sucesso  e continue
//  fazendo outras transições usamos o uuid

import 'dart:convert';

import 'package:byte_bank2/models/contact.dart';
import 'package:byte_bank2/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import '../../interceptors/logging_interceptor.dart';

class TransactionWebClient {
  // timeout é pra encerrar o async
  // parar não carregar pra sempre
  final Client client = HttpClientWithInterceptor.build(
    interceptors: [LoggingInterceptor()],
    requestTimeout: Duration(seconds: 5),
  );
  final String url = 'http://192.168.0.15:8080/transactions';

  Future<List<Transaction>> findAll() async {
    Future.delayed(Duration(seconds: 5));

    final Response response = await client.get(url);

    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = List();

    _toTransactions(decodedJson, transactions);

    if (response.statusCode == 200) {
      return transactions;
    }

    throw HttpException(_getMessage(response.statusCode));
  }

  Future<Transaction> save(Transaction transaction, String pwd) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'password': pwd,
      },
      // precisa mandar um json
      body: transactionJson,
    );

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) {
    if (_statusCodeResponse.containsKey(statusCode)) {
      return _statusCodeResponse[statusCode];
    }
    return 'Unknown error.';
  }

  void _toTransactions(List decodedJson, List<Transaction> transactions) {
    decodedJson.forEach((key) {
      transactions.add(Transaction.fromJson(key));
    });
  }

  static final Map<int, String> _statusCodeResponse = {
    400: 'There was an error while submitting transaction.',
    401: 'Authentication failed.',
    409: 'Transaction already exists.'
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  String toString() {
    String result = "TimeoutException";
    if (message.isNotEmpty || message != null) result = "$message";
    return result;
  }
}
