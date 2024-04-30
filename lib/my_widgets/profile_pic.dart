part of 'my_widgets.dart';

class ProfilePic extends StatelessWidget {
  final bool isGuest;

  ProfilePic(this.isGuest);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = getColorScheme(context);
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 50,
        height: 50,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: colorScheme.onSecondary),
      ),
      isGuest
          ? Icon(CupertinoIcons.question, color: colorScheme.tertiary)
          : Icon(CupertinoIcons.person_fill, color: colorScheme.tertiary),
    ]);
  }
}
