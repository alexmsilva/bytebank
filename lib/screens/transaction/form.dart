import 'dart:async';

import 'package:bytebank/components/progress.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_authentication_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _amountController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String _transactionId = Uuid().v4();
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova transferência'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: _sending,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Progress(message: 'Enviando...'),
                ),
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
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
                  controller: _amountController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 48.0,
                  child: RaisedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final value = double.tryParse(_amountController.text);
                      final trasaction = Transaction(
                        _transactionId,
                        value,
                        widget.contact,
                      );
                      showDialog(
                        context: context,
                        builder: (_) {
                          return TransactionAuthDialog(
                            onConfirm: (String password) {
                              _save(trasaction, password, context);
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

  void _save(Transaction trasaction, String password, BuildContext context) {
    setState(() => _sending = true);
    _webClient
        .save(trasaction, password)
        .then((createdTransaction) {
          if (createdTransaction != null) {
            showDialog(
                context: context,
                builder: (_) {
                  return SuccessDialog('Transferência realizada');
                }).then((value) => Navigator.pop(context));
          }
        })
        .catchError(
          (error) => _showFailureMessage(
            context,
            message: 'A transferência demorou muito e não foi salva',
          ),
          test: (error) => error is TimeoutException,
        )
        .catchError(
          (error) => _showFailureMessage(context, message: error.message),
          test: (error) => error is HttpException,
        )
        .catchError(
          (error) => _showFailureMessage(context),
          test: (error) => error is Exception,
        )
        .whenComplete(() {
          setState(() => _sending = false);
        });
  }

  void _showFailureMessage(
    BuildContext context, {
    String message = 'Erro desconhecido',
  }) {
    showDialog(
      context: context,
      builder: (_) => FailureDialog(message),
    );
  }
}
