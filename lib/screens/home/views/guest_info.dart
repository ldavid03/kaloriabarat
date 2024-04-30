import 'package:flutter/material.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/screens/home/views/home_screen.dart';

class GuestInfo extends StatefulWidget {
  const GuestInfo({Key? key}) : super(key: key);

  @override
  GuestInfoState createState() => GuestInfoState();
}

class GuestInfoState extends State<GuestInfo> {

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'By logging in as guest, you are limited to:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text('• Default calorie intake based on your gender.'),
          const Text('• The data you log is not saved anywhere!'),
          const Text('• No custom foods.'),
          const Text('• No chatbot'),
          const Text('• No statistics'),
          const Text('• No profile page'),
          
          Center(child: ActionButton(onPressed: (){return;}, ctx: context, str: "Continue"))
          
        ],
      ),
    );
  }
}