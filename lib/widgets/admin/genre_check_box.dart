import 'package:flutter/material.dart';

class GenreCheckBox extends StatefulWidget {
  final String genre;
  final Function(int index) toggleCheckStatus;
  final int genreIndex;

  GenreCheckBox(this.genre, this.toggleCheckStatus, this.genreIndex);

  @override
  _GenreCheckBoxState createState() => _GenreCheckBoxState();
}

class _GenreCheckBoxState extends State<GenreCheckBox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
        widget.toggleCheckStatus(widget.genreIndex);
      },
      child: Container(
        height: 80,
        width: 100,
        child: Column(
          children: [
            Text(
              widget.genre,
              style: TextStyle(
                color: Colors.pink.shade200,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: Icon(
                _isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                color: _isChecked ? Colors.pink.shade200 : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isChecked = !_isChecked;
                });
                widget.toggleCheckStatus(widget.genreIndex);
              },
            )
          ],
        ),
      ),
    );
  }
}
