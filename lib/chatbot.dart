import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_bar.dart';
import 'package:campus_buddy/bottom_nav.dart';

// class ChatbotScreen extends StatefulWidget {
//   const ChatbotScreen({super.key});

//   @override
//   _ChatbotScreenState createState() => _ChatbotScreenState();
// }

// class _ChatbotScreenState extends State<ChatbotScreen> {
//   String chatbotResponse = '';

//   Future<void> sendChatbotRequest() async {
//     // Define the URL of your Flask chatbot endpoint
//     var url = Uri.parse('http://192.168.56.1:5000/api/chatbot');

//     // Define the input text in a map
//     var payload = {'input_text': 'what is the universities mission statement.'};

//     // Send a POST request with JSON payload
//     var response = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(payload),
//     );

//     // Check the response status code
//     if (response.statusCode == 200) {
//       // Parse the JSON response
//       Map<String, dynamic> data = jsonDecode(response.body);
//       var chatbotResponseText = data['response'];
//       setState(() {
//         chatbotResponse = chatbotResponseText;
//         print(chatbotResponse);
//       });
//     } else {
//       setState(() {
//         chatbotResponse = 'Error: ${response.statusCode}';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const MyAppBar(),
//       drawer: const NavBar(),
//       bottomNavigationBar: const BottomNavigation(),
//       body: Container(
//         // Wrap the body in a Container to set the background color
//         color: Colors.black26, // Set your desired background color here
//         child: const Center(
//           child: Text('Home'),
//         ),
//       ),
//     );
//   }
// }

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Widget> _messages = <Widget>[];
  String chatbotResponse = '';

  Future<void> sendChatbotRequest(String load) async {
    // Define the URL of your Flask chatbot endpoint
    var url = Uri.parse('http://ec2-16-171-177-132.eu-north-1.compute.amazonaws.com:5000/api/chatbot');

    // Define the input text in a map
    var payload = {'input_text': load};

    // Send a POST request with JSON payload
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload),
    );

    // Check the response status code
    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> data = jsonDecode(response.body);
      var chatbotResponseText = data['response'];
      _handleChatbotMessage(chatbotResponseText);
      setState(() {
        chatbotResponse = chatbotResponseText;
        ChatbotMessage(
          text: chatbotResponse,
        );
        print(chatbotResponse);
      });
    } else {
      setState(() {
        chatbotResponse = 'Error: ${response.statusCode}';
      });
    }
  }

  void _handleUserMessageSubmitted(String text) {
    sendChatbotRequest(_textController.text);
    _textController.clear();

    setState(() {
      _messages.insert(0, UserMessage(text: text));
    });
  }

  void _handleChatbotMessage(String text) {
    setState(() {
      _messages.insert(0, ChatbotMessage(text: text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const NavBar(),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(20.0), // Adjust the radius to your liking
          color: Colors.blue, // Change the color here
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0), // Adjust padding as needed
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleUserMessageSubmitted,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Ask me a question',
                    hintStyle: TextStyle(
                        color: Colors.white), // Change the hint text color here
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: () =>
                  _handleUserMessageSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatbotMessage extends StatelessWidget {
  const ChatbotMessage({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: const CircleAvatar(
              child: Text('C'),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Chatbot',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserMessage extends StatelessWidget {
  const UserMessage({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const Text('You',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: const CircleAvatar(
              child: Text('U'),
            ),
          ),
        ],
      ),
    );
  }
}
