import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriabarat/my_widgets/my_widgets.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Map<String, dynamic>> messages = [

  ];
  final TextEditingController _controller = TextEditingController();


  Future<void> sendMessage(String message) async {
    String typingIndicator = '';
    int typingMessageIndex=messages.length+1;
    bool isFirstMessage = true;
  // Add the user's message to the chat
    setState(() {
      messages.add({'text': message, 'isUser': true});
    });

    // Add a temporary message to the chat to simulate the chatbot typing
    Timer timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
    setState(() {
      if(isFirstMessage){
        messages.add({'text': 'Kaloriasegéd is typing' + typingIndicator, 'isUser': false});
        isFirstMessage = false;
      }
      typingIndicator += '.';
      if (typingIndicator.length > 3) {
        typingIndicator = '.';
      } 
      messages[typingMessageIndex] = {'text': 'Kalóriasegéd is typing' + typingIndicator, 'isUser': false};
      
    });
    });

    // Remember to cancel the timer when you're done with it
    await Future.delayed(Duration(seconds: 3));
    timer.cancel();

    String response = await chatbotResponse(message);

    // Replace the temporary message with the chatbot's response
    setState(() {
      messages[typingMessageIndex] = {'text': response, 'isUser': false};
    }
  );
}

  Future<String> chatbotResponse(String message) async {
  const String replicateApiToken = 'r8_9Wyb1HuG0EvukZlzQPElonEQanlM0LJ0nzFRF';

    final postResponse = await http.post(
      Uri.parse('https://api.replicate.com/v1/models/meta/meta-llama-3-8b-instruct/predictions'),
      headers: {
        'Authorization': 'Bearer $replicateApiToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'input': {
          'top_k': 0,
          'top_p': 0.9,
          'prompt': message,
          'temperature': 0.6,
          'system_prompt': 'You are a helpful assistant',
          'length_penalty': 1,
          'max_new_tokens': 512,
          'stop_sequences': '<|end_of_text|>,<|eot_id|>',
          'prompt_template': '<|begin_of_text|><|start_header_id|>system<|end_header_id|>\\n\\nYou are a helpful assistant<|eot_id|><|start_header_id|>user<|end_header_id|>\\n\\n{prompt}<|eot_id|><|start_header_id|>assistant<|end_header_id|>\\n\\n',
          'presence_penalty': 0
        }
      }),
    );

    if (postResponse.statusCode == 201) {
      final postResponseData = jsonDecode(postResponse.body);
      final getResponseUrl = postResponseData['urls']['get'];

      while (true) {
        final getResponse = await http.get(
          Uri.parse(getResponseUrl),
          headers: {
            'Authorization': 'Bearer $replicateApiToken',
          },
        );

        if (getResponse.statusCode == 200) {
          final getResponseData = jsonDecode(getResponse.body);
          log(getResponseData.toString());
          List<String> outputLines = getResponseData['output'].cast<String>();
          return outputLines.join(''); // Join the lines with a newline character
        }

        await Future.delayed(Duration(seconds: 1)); // Wait for 1 second before sending the next GET request
      }
    } else {
      throw Exception('Failed to get chatbot response');
    }
  }


  @override
  Widget build(BuildContext context) {
      ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: cs.secondary,
        title: Center(
            child: MyText('Kaloriasegéd', "l","b"),
          ),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Align(
                    alignment: message['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: message['isUser'] ? cs.primary : cs.secondary,
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type your message',
                ),
                onSubmitted: (value) async {
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