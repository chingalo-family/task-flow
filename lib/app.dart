import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        home: Container(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Task Manager'),
            ),
            body: Container(
              child: Text('Task list'),
            ),
          ),
        ),
      ),
    );
  }
}
