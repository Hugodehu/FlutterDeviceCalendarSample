import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerWidget extends StatefulWidget {
  DateTimePickerWidget(
      {super.key,
      required this.date,
      required this.callback,
      this.validator,
      this.hasDate = false,
      double? width,
      double? textWidth,
      double? fontSize,
      this.shadowColor})
      : fontSize = 14,
        textWidth = 95,
        width = 130;
  final DateTime date;
  final bool hasDate;
  final Function(DateTime) callback;
  final double width;
  final double fontSize;
  final double textWidth;
  final Color? shadowColor;
  final String? Function(String? value)? validator;
  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    if (widget.hasDate) {
      dateInput.text = DateFormat("dd/MM/yyyy")
          .format(widget.date); //set the initial value of text field
    }
    if (widget.hasDate) {
      dateInput.text = DateFormat("dd/MM/yyyy")
          .format(widget.date); //set the initial value of text field
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: widget.date,
            firstDate: DateTime(1950),
            lastDate: DateTime(2100));

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          setState(() {
            dateInput.text =
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
              width: widget.textWidth,
              height: 24,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 10,
                ),
                child: TextFormField(
                  validator: widget.validator,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: TextStyle(fontSize: widget.fontSize),
                  controller: dateInput,
                  //editing controller of this TextField
                  decoration: InputDecoration(
                    hintText: "dd/mm/yyyy",
                    hintStyle: TextStyle(fontSize: widget.fontSize),
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
