import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({
    @required this.text,
    @required this.icon,
    this.onPressed, List<Widget> children,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.blueGrey,
          ), 
          title: Text(
            text,
            style: TextStyle(
              fontFamily: 'Source Sans Pro',
              fontSize: 16.0,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}