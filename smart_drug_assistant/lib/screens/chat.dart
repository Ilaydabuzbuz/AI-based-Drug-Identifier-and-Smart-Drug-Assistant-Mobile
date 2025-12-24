import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': "Hi, I’m MediScan Bot!  How can I help you today?",
      'isUser': false,
    },
  ];
  bool _isLoading = false;

  static const Color primaryColor = Color(0xFFDB864E);

  // Ollama URL hosting Rag Model
  // FastAPI endpoint
  final String _apiUrl = 'http://127.0.0.1:8000/rag/query';
  //                                            ^^^^ FastAPI port

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _controller.clear();
      _isLoading = true;
    });

    try {
      // Send request to FastAPI
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': text,
          'k': 2,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String botResponse = data['answer'];

        if (mounted) {
          setState(() {
            _messages.add({'text': botResponse, 'isUser': false});
            _isLoading = false;
          });
        }
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.body}');
        if (mounted) {
          setState(() {
            _messages.add({
              'text': "Error: ${response.statusCode}",
              'isUser': false,
            });
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Exception: $e');
      if (mounted) {
        setState(() {
          _messages.add({'text': "Error: $e", 'isUser': false});
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: primaryColor,
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "MediScan Support",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Robot Icon
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.smart_toy_outlined,
                      size: 36,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Chatbot",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            // Chat Container
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.25), // 25% opacity
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20.0),
                        itemCount: _messages.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _messages.length) {
                            // Loading indicator
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: primaryColor.withOpacity(
                                      0.5,
                                    ),
                                    child: const Icon(
                                      Icons.smart_toy,
                                      size: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final msg = _messages[index];
                          final isUser = msg['isUser'];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              mainAxisAlignment: isUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isUser) ...[
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: primaryColor.withOpacity(
                                      0.5,
                                    ),
                                    child: const Icon(
                                      Icons.smart_toy,
                                      size: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? primaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        topRight: const Radius.circular(20),
                                        bottomRight: isUser
                                            ? Radius.zero
                                            : const Radius.circular(20),
                                        bottomLeft: isUser
                                            ? const Radius.circular(20)
                                            : Radius.zero,
                                      ),
                                    ),
                                    child: Text(
                                      msg['text'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isUser
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Input Area
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _controller,
                                enabled: !_isLoading,
                                // Disable input while loading
                                onSubmitted: (_) => _sendMessage(),
                                decoration: const InputDecoration(
                                  hintText: "Type a message...",
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  onPressed: _sendMessage,
                                  icon: const Icon(Icons.send),
                                  color: Colors.black,
                                  iconSize: 28,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bottom Nav Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              height: 60,
              decoration: BoxDecoration(
                color: primaryColor, // 100% opacity
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home_outlined),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {
                      // Navigate home
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {
                      // Navigate profile
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
