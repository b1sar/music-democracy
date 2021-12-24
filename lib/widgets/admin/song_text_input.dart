import 'package:flutter/material.dart';

class SongTextInput extends StatelessWidget {
  final String inputHint;
  final Function(String valueToBeSet, String valueHint) setValue;

  SongTextInput(this.inputHint, this.setValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade200,
            Colors.pink.shade200,
          ],
        ),
      ),
      child: TextFormField(
        autocorrect: false,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none,
          //     helperText: 'Song info',
          hintText: inputHint,
          errorStyle: TextStyle(
            fontFamily: 'PTSans',
            fontWeight: FontWeight.bold,
          ),
          //        labelText: inputHint,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          focusColor: Colors.white,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return inputHint.toString() + ' cannot be empty!';
          }
          return null;
        },
        onSaved: (value) {
          setValue(value, inputHint);
        },
      ),
    );
  }
}
