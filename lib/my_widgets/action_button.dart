part of 'my_widgets.dart';

class ActionButton extends StatefulWidget {
  final Function() onPressed;
  final BuildContext ctx;
  final String str;

  const ActionButton({super.key, required this.onPressed, required this.ctx, required this.str});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: widget.str == 'Save'|| widget.str == 'Sign In' || widget.str == 'Sign Up' ? getColorScheme(context).secondary : getColorScheme(context).tertiary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: widget.onPressed,
        child:  MyText(
          widget.str,
          "l",
          "b",
          color: "",
        ),
      ),
    );
  }
}
