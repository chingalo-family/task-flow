import 'package:flutter/material.dart';
import 'package:task_manager/core/components/input_fields/true_only_input_field_container.dart';
import 'package:task_manager/core/components/material_card.dart';
import 'package:task_manager/models/input_field.dart';
import 'package:task_manager/models/sub_task.dart';

class SubTaskCard extends StatefulWidget {
  const SubTaskCard({
    Key? key,
    required this.textColor,
    required this.subTask,
    this.onDelete,
    this.onEdit,
    this.onUpdateTodoTaskStatus,
  }) : super(key: key);

  final Color textColor;
  final SubTask subTask;

  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final Function? onUpdateTodoTaskStatus;

  @override
  _SubTaskCardState createState() => _SubTaskCardState();
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
                    color: widget.textColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(),
                child: InkWell(
                  child: _buildIcon(
                    Icons.edit,
                    widget.textColor,
                  ),
                  onTap: widget.onEdit,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(),
                child: InkWell(
                  child: _buildIcon(
                    Icons.delete,
                    widget.textColor,
                  ),
                  onTap: widget.onDelete,
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
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Icon(
        icon,
        color: color.withOpacity(0.6),
        size: 20,
      ),
    );
  }
}
