part of 'my_widgets.dart';

ButtonStyle blackButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.black,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
).copyWith(
  textStyle: MaterialStateProperty.all<TextStyle>(
    const TextStyle(
      color: Colors.white,
    ),
  ),
);