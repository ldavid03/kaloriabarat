part of 'my_widgets.dart';

class GuestAlerDialog extends StatelessWidget {
  const GuestAlerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const MyText(
                'By logging in as guest, you are limited to:',"l","b"),
              const SpaceHeight('m'),
              const MyText('• Default calorie intake.',"m","n"),
              const MyText('• The data you log will be lost!',"m","n"),
              const MyText('• No custom foods.',"m","n"),
              const MyText('• No chatbot',"m","n"),
              const MyText('• No statistics',"m","n"),
              const MyText('• No profile page',"m","n"),
              const SpaceHeight('m'),
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