import 'package:flutter/material.dart';

class GenreItem extends StatelessWidget {
  final String title;
  final Color color;
  final void Function(String genre) toggleGenres;

  GenreItem(this.title, this.color, this.toggleGenres);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => toggleGenres(title),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 20,
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.5),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
