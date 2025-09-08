import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/betsy_chat.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final BetsyChat chat;
  final ctrl = TextEditingController();
  final msgs = <Map<String, String>>[];
  Stream<String>? stream;

  @override
  void initState() {
    super.initState();
    chat = BetsyChat(dotenv.env['GEMINI_API_KEY']!);
  }

  void _send() {
    final text = ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      msgs.add({'role': 'user', 'text': text});
      msgs.add({'role': 'bot', 'text': ''});
    });
    ctrl.clear();

    stream = chat.sendStream(text);
    stream!.listen((partial) {
      setState(() {
        msgs.last = {'role': 'bot', 'text': partial};
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Betsy Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: msgs.length,
              itemBuilder: (_, i) {
                final m = msgs[i];
                final isUser = m['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueGrey.shade800 : Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(m['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(child: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Pergunte à Betsy...'))),
              IconButton(onPressed: _send, icon: const Icon(Icons.send)),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
