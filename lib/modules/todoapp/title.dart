import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Titless extends StatelessWidget {
    String? text;
  late final title;

  Titless(
    String? text,
    String? title,
  ) {
    this.text = text!;
    this.title = title!;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        title: Text(
          '$title',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: (text!.isNotEmpty)
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            '$text',
            style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          fontSize: 30,
            ),
          ),
        ),
      )
          : Center(
            child: Text(
        'description is empty',
        style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w900,
              fontSize: 30,
              fontStyle: FontStyle.italic),
      ),
          ),
    );
  }
}
