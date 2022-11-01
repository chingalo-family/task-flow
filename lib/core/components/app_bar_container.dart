import 'package:flutter/material.dart';
import 'package:task_manager/core/components/app_pop_up_menu.dart';

class AppBarContainer extends StatelessWidget {
  const AppBarContainer({
    Key? key,
    this.isAboutPage,
    this.isViewChartVisible,
    this.isAddVisible,
    this.elevation = 0.0,
    required this.title,
    this.onAdd,
    this.onOpenChart,
    this.isEditVisible = false,
    this.isDeleteVisible = false,
    this.isUserVisible = false,
    this.onEdit,
    this.onDelete,
    this.onOpenUserActionSheet,
  }) : super(key: key);

  final String title;
  final bool? isAboutPage;
  final bool? isViewChartVisible;
  final bool? isAddVisible;
  final bool? isUserVisible;
  final bool isEditVisible;
  final bool isDeleteVisible;
  final double elevation;

  final VoidCallback? onOpenChart;
  final VoidCallback? onOpenUserActionSheet;
  final VoidCallback? onAdd;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      title: Text(
        title,
        style: const TextStyle().copyWith(
          fontSize: 16.0,
        ),
      ),
      actions: [
        Visibility(
          visible: isViewChartVisible!,
          child: IconButton(
            icon: const Icon(
              Icons.bar_chart,
            ),
            onPressed: onOpenChart,
          ),
        ),
        Visibility(
          visible: isAddVisible!,
          child: IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: onAdd,
          ),
        ),
        Visibility(
          visible: isEditVisible,
          child: IconButton(
            icon: const Icon(
              Icons.edit,
            ),
            onPressed: onEdit,
          ),
        ),
        Visibility(
          visible: isDeleteVisible,
          child: IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: onDelete,
          ),
        ),
        Visibility(
          visible: isUserVisible!,
          child: IconButton(
            icon: const Icon(
              Icons.person,
            ),
            onPressed: onOpenUserActionSheet,
          ),
        ),
        AppPopUpMenu(
          currentPage: isAboutPage == true ? 'about' : '',
        ),
      ],
    );
  }
}
