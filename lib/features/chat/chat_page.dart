import 'package:flutter/material.dart';
import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = ChatController();
  final input = TextEditingController();
  bool loading = false;
  String? error;

  void _send() {
    final text = input.text.trim();
    if (text.isEmpty || loading) return;

    setState(() {
      error = null;
      loading = true;
    });

    final stream = controller.askStream(text);
    stream.listen((partial) {
      setState(() {
        controller.updateModel(partial);
      });
    }, onError: (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }, onDone: () {
      setState(() {
        loading = false;
      });
    });

    input.clear();
  }

  @override
  void dispose() {
    controller.cancel();
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final msgs = controller.history;

    return Scaffold(
      appBar: AppBar(title: const Text('Betsy')),
      body: Column(
        children: [
          if (error != null)
            Container(
              color: Colors.red.shade900,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              child: Text(error!, style: const TextStyle(color: Colors.white)),
            ),
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
                      color: isUser ? const Color.fromARGB(255, 181, 244, 198) : const Color.fromARGB(255, 122, 220, 153),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(m['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    decoration: const InputDecoration(
                      hintText: 'Pergunte à Betsy...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: loading ? null : _send,
                  child: loading ? const CircularProgressIndicator() : const Text('Enviar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
