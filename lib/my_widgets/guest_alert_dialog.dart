part of 'my_widgets.dart';

class GuestAlerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MyText(
                'By logging in as guest, you are limited to:',"l","b"),
              SpaceHeight('m'),
              MyText('• Default calorie intake.',"m","n"),
              MyText('• The data you log will be lost!',"m","n"),
              MyText('• No custom foods.',"m","n"),
              MyText('• No chatbot',"m","n"),
              MyText('• No statistics',"m","n"),
              MyText('• No profile page',"m","n"),
              SpaceHeight('m'),
              ActionButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                ctx:context,str:'Continue'
              ),
            ],
          ),
        ),
      ),
    );
  }
}