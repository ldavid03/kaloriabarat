import 'dart:async';
import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:flutter/material.dart';
import 'package:kaloriabarat/pages/chatbot/controller/chatbot_service.dart';
import 'package:user_repository/user_repository.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';

class ChatScreen extends StatefulWidget {
  final MyUser myUser;
  final List<Meal> meals;
  const ChatScreen(this.meals, this.myUser, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [
    {
      'text':
          "Hi. How can I help you live a healthier life today?",
      'isUser': false
    }
  ];
  final TextEditingController _controller = TextEditingController();

  Future<void> sendMessage(String message) async {
    int consumedKcal =
        widget.meals.fold(0, (total, meal) => total + meal.calories);
    int dailyGoal = widget.myUser.goalCalories;
    String typingIndicator = '';
    int typingMessageIndex = messages.length + 1;
    bool isFirstMessage = true;
    setState(() {
      messages.add({'text': message, 'isUser': true});
    });

    Timer timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (isFirstMessage) {
          messages.add(
              {'text': 'CalorieHelper$typingIndicator', 'isUser': false});
          isFirstMessage = false;
        }
        typingIndicator += '.';
        if (typingIndicator.length > 3) {
          typingIndicator = '.';
        }
        messages[typingMessageIndex] = {
          'text': 'CalorieHelper is typing$typingIndicator',
          'isUser': false
        };
      });
    });

    await Future.delayed(const Duration(seconds: 3));
    timer.cancel();

    String response = await chatbotResponse(dailyGoal, consumedKcal, message);

    setState(() {
      messages[typingMessageIndex] = {'text': response, 'isUser': false};
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: cs.secondary,
        title: const Center(
          child: MyText('CalorieHelper', "l", "b"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Align(
                    alignment: message['isUser']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width*0.7,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(25),
                          topRight: const Radius.circular(25),
                          bottomLeft: message['isUser']
                              ? const Radius.circular(25)
                              : const Radius.circular(0),
                          bottomRight: message['isUser']
                              ? const Radius.circular(0)
                              : const Radius.circular(25),
                        ),
                        color: message['isUser'] ? cs.primary : cs.tertiary,
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(
                          color:
                              message['isUser'] ? Colors.white : Colors.black,
                              fontSize: 16
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Type your message',
                  suffixIcon: IconButton(
                    icon: _controller.text == "" ? const Icon(Icons.send) : Container(),
                    onPressed: () async {
                      if (_controller.text == "") return;
                      var value = _controller.text;
                      setState(() {
                        _controller.clear();
                      });
                      await sendMessage(value);
                    },
                  ),
                ),
                onSubmitted: (value) async {
                 if (_controller.text == "") return;
                  var value = _controller.text;
                  setState(() {
                    _controller.clear();
                  });
                  await sendMessage(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}