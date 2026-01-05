import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/components/components.dart';

class EditStatusContainer extends StatefulWidget {
  final TaskStatus status;

  const EditStatusContainer({super.key, required this.status});

  @override
  State<EditStatusContainer> createState() => _EditStatusContainerState();
}

class _EditStatusContainerState extends State<EditStatusContainer> {
  late TextEditingController _nameController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.status.name);
    _selectedColor = widget.status.color;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstant.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Edit Task Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: AppConstant.textSecondary),
              ),
            ],
          ),
          SizedBox(height: AppConstant.defaultPadding),
          InputField(
            controller: _nameController,
            hintText: 'Enter status name',
            icon: Icons.label,
            labelText: 'Status Name',
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Color',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _colorOption(const Color(0xFF2E90FA)),
              _colorOption(const Color(0xFF10B981)),
              _colorOption(const Color(0xFFF59E0B)),
              _colorOption(const Color(0xFFEF4444)),
              _colorOption(const Color(0xFF8B5CF6)),
              _colorOption(const Color(0xFFEC4899)),
              _colorOption(const Color(0xFF6B7280)),
              _colorOption(const Color(0xFF14B8A6)),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppConstant.textSecondary),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isNotEmpty) {
                      Navigator.pop(context, {
                        'name': _nameController.text.trim(),
                        'color': _selectedColor,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppConstant.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _colorOption(Color color) {
    final isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 24)
            : null,
      ),
    );
  }
}
