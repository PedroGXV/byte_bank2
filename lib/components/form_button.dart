import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {

  final Function onPressed;
  final String title;

  FormButton({@required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        this.onPressed();
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(
            Size(double.maxFinite, 45)),
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 20,
          letterSpacing: 3,
        ),
      ),
    );
  }
}
