import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final _controller;
  final Function search;
  SearchBox(this._controller, this.search);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      margin: EdgeInsets.only(top: 15, right: 25, left: 25, bottom: 5),
      //    color: Colors.purple,
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.pink.shade200],
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 4,
            child: TextFormField(
              autocorrect: false,
              controller: _controller,
              onFieldSubmitted: (value) {
                search();
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                fontFamily: 'Lexend',
                //    fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: IconButton(icon: Icon(Icons.search), onPressed: search),
            ),
          )
        ],
      ),
    );
  }
}
