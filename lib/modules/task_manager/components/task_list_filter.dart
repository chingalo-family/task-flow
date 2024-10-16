import 'package:flutter/material.dart';

class TaskListFilter extends StatelessWidget {
  const TaskListFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Container(
          alignment: Alignment.topLeft,
          child: Text(
            'Todo list filters',
            style: const TextStyle().copyWith(
              fontWeight: FontWeight.normal,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
