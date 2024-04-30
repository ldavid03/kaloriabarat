part of 'my_widgets.dart';

class DatePickerField extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateChanged;

  DatePickerField({required this.initialDate, required this.onDateChanged});

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  TextEditingController dateController = TextEditingController();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    dateController.text = DateFormat('yyyy. MM. dd.').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: TextFormField(
        controller: dateController,
        readOnly: true,
        textAlignVertical: TextAlignVertical.center,
        onTap: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now().subtract(Duration(days: 365)),
              lastDate: DateTime.now().add(Duration(days: 365)));
          if (newDate != null) {
            setState(() {
              dateController.text = DateFormat('yyyy. MM. dd.').format(newDate);
              selectedDate = newDate;
            });
            widget.onDateChanged(newDate);
          }
        },
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: getColorScheme(context).tertiary
                                                    .withOpacity(0.5),
          prefixIcon: const Icon(FontAwesomeIcons.calendar, size: 16, color: Colors.grey),
          hintText: "Date",
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}