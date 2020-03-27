import 'package:flutter/material.dart';

const Key transactionAuthDialogTextFieldPasswordKey = Key('password_field');

class TransactionAuthDialog extends StatefulWidget {
  final Function(String password) onConfirm;

  TransactionAuthDialog({@required this.onConfirm});

  @override
  _TransactionAuthDialogState createState() => _TransactionAuthDialogState();
}

class _TransactionAuthDialogState extends State<TransactionAuthDialog> {
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: transactionAuthDialogTextFieldPasswordKey,
      title: Text('Autenticação'),
      content: TextField(
        controller: _passwordController,
        obscureText: true,
        maxLength: 4,
        style: TextStyle(fontSize: 64.0, letterSpacing: 24.0),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(border: OutlineInputBorder()),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCELAR'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
            child: Text('CONFIRMAR'),
            onPressed: () {
              widget.onConfirm(_passwordController.text);
              Navigator.pop(context);
            }),
      ],
    );
  }
}
