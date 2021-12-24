import 'package:flutter/material.dart';

class LobbyTextInput extends StatelessWidget {
  final String inputHint;
  final Function(String valueToBeSet, String valueHint) setValue;

  LobbyTextInput(this.inputHint, this.setValue);

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
            Colors.purple.shade200,
          ],
        ),
      ),
      child: TextFormField(
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
        keyboardType: (inputHint == 'Lobby Capacity')
            ? TextInputType.number
            : TextInputType.name,
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
            return inputHint + ' cannot be empty!';
          }
          if (inputHint == 'Lobby Capacity') {
            try {
              int lobbyCapacity = int.parse(value);
              if (lobbyCapacity < 3) return 'Capacity should be greater than 3';
            } catch (error) {
              return 'Capacity must be a number!';
            }
          }
          if (inputHint == 'Lobby Code') {
            if (value.length < 7)
              return 'Code must have more than 7 characters';
            else if (!value.contains(RegExp(r'[A-z]')) ||
                !value.contains(RegExp(r'[0-9]'))) {
              return 'Code must be a mix of numbers and letters';
            }
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
