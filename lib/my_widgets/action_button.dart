part of 'my_widgets.dart';

class ActionButton extends StatefulWidget {
  final Function() onPressed;
  final BuildContext ctx;
  final String str;

  ActionButton({required this.onPressed, required this.ctx, required this.str});

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: widget.str == 'Save'|| widget.str == 'Sign In' || widget.str == 'Sign Up' ? getColorScheme(context).secondary : getColorScheme(context).onSecondary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: widget.onPressed,
        child:  widget.str == 'Save' || widget.str == 'Sign In' || widget.str == 'Sign Up'
        ? 
        MyText(
          widget.str,
          "l",
          "b",
          color: "",
        )
        
        :MyText(
          widget.str,
          "l",
          "b",
          color: "onPrimary",
        ),
      ),
    );
  }
}
