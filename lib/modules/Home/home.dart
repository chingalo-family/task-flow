import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Task Manager',
          ),
        ),
        body: Container(
          child: Text(
            'Task list',
          ),
        ),
      ),
    );
  }
}
