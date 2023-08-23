import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskWidget extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onChanged;
  final String? timeInitialValue;
  final void Function(DateTime?) onTimeChange;
  const TaskWidget({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.timeInitialValue,
    required this.onTimeChange,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late final TextEditingController _controller;
  late final TextEditingController _tcontroller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.initialValue ?? '';
    _tcontroller = TextEditingController();
    _tcontroller.text = widget.timeInitialValue ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    _tcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            onChanged: widget.onChanged,
            decoration: const InputDecoration(
              hintText: "Add Task",
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter something';
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 150,
          child: DateTimeField(
            onChanged: widget.onTimeChange,
            controller: _tcontroller,
            decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.calendar_month,
                ),
                hintText: 'Deadline'),
            format: DateFormat('yyyy-MM-dd HH:mm'),
            onShowPicker: (context, currentValue) async {
              return await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100),
              ).then((DateTime? date) async {
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
