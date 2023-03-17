import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  TimePickerWidget({
    super.key,
    required this.timeInput,
    required this.callback,
    width,
    this.shadowColor,
  }) : width = 142;
  final TimeOfDay timeInput;
  final Function(TimeOfDay) callback;
  final double width;
  final Color? shadowColor;
  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  TextEditingController timeInput = TextEditingController();
  @override
  void initState() {
    timeInput.text =
        "${widget.timeInput.hour.toString().padLeft(2, '0')}:${widget.timeInput.minute.toString().padLeft(2, '0')}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedDate = await showTimePicker(
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(),
            child: child!,
          ),
          context: context,
          initialTime: widget.timeInput,
        );

        if (pickedDate != null) {
          setState(() {
            String formattedDate =
                "${pickedDate.hour.toString().padLeft(2, '0')}:${pickedDate.minute.toString().padLeft(2, '0')}";
            timeInput.text =
                formattedDate; //set output date to TextField value.
            widget.callback(pickedDate);
          });
        } else {}
      },
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        width: widget.width,
        height: 24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 110,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 10,
                ),
                child: TextField(
                  controller: timeInput,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  //editing controller of this TextField
                  decoration: const InputDecoration(
                    hintText: "TimePicker Hint",
                    border: InputBorder.none,
                  ),
                  readOnly: true,
                  //set it true, so that user will not able to edit text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
