import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriabarat/local_keys.dart';

Future<String> chatbotResponse(int calorieIntakeGoal, int consumedCalories, String message) async {
  if (message.length < 15) return 'Please provide more information.';

  try {
    const String apiKey = OPENAI_API_KEY;
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo-0125",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a professional nutricionist that answers only diet and food related questions. If 'calories' is mentioned, include the food amount in grams and the total meal calories."
          },
          {
            "role": "user",
            "content":
                "Goal: $calorieIntakeGoal calories. Consumed: $consumedCalories today."
          },
          {"role": "user", "content": message}
        ],
        "temperature": 0.5
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String content =
          data['choices'][0]['message']['content'].toString();
      return content;
    } else {
      return 'Sorry, I am having trouble understanding you. Could you please rephrase your question?';
    }
  } catch (e) {
    return "Something went wrong. Please try again later.";
  }
}
