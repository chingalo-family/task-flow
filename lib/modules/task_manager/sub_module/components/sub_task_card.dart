import 'package:flutter/material.dart';
import 'package:task_manager/core/components/entry_input_fields/models/input_field.dart';
import 'package:task_manager/core/components/entry_input_fields/true_only_input_field_container.dart';
import 'package:task_manager/core/components/material_card.dart';
import 'package:task_manager/models/sub_task.dart';

class SubTaskCard extends StatefulWidget {
  const SubTaskCard({
    super.key,
    required this.subTask,
    this.onDelete,
    this.onEdit,
    this.onUpdateTodoTaskStatus,
  });

  final SubTask subTask;

  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final Function? onUpdateTodoTaskStatus;

  @override
  State<SubTaskCard> createState() => _SubTaskCardState();
}

class _SubTaskCardState extends State<SubTaskCard> {
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    onUpdateTodoTaskStatus(widget.subTask.isCompleted!);
  }

  @override
  void didUpdateWidget(covariant SubTaskCard oldWidget) {
    super.didUpdateWidget(widget);
    if (oldWidget.subTask.isCompleted != widget.subTask.isCompleted) {
      onUpdateTodoTaskStatus(widget.subTask.isCompleted!);
    }
  }

  onUpdateTodoTaskStatus(bool isCompleted) {
    _isCompleted = isCompleted;
    widget.onUpdateTodoTaskStatus!(isCompleted);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: MaterialCard(
        body: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10.0,
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(),
                child: TrueOnlyInputFieldContainer(
                  inputField: InputField(
                    id: widget.subTask.id!,
                    name: widget.subTask.title!,
                    valueType: 'TRUE_ONLY',
                  ),
                  inputValue: _isCompleted,
                  onInputValueChange: (dynamic value) =>
                      onUpdateTodoTaskStatus(value != ''),
                ),
              ),
              Expanded(
                child: Text(
                  widget.subTask.title!,
                  style: const TextStyle().copyWith(
                    decoration: widget.subTask.isCompleted!
                        ? TextDecoration.lineThrough
                        : null,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(),
                child: InkWell(
                  onTap: widget.onEdit,
                  child: _buildIcon(
                    Icons.edit,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(),
                child: InkWell(
                  onTap: widget.onDelete,
                  child: _buildIcon(Icons.delete),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Icon(
        icon,
        size: 20,
      ),
    );
  }
}
