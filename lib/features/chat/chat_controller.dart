import 'dart:async';
import '../../services/chat_api.dart';

class ChatController {
  final _api = ChatApi();
  final List<Map<String, String>> history = [];
  StreamSubscription<String>? _sub;

  void addUser(String text) {
    history.add({'role': 'user', 'text': text});
  }

  void addModelPlaceholder() {
    history.add({'role': 'model', 'text': ''});
  }

  void updateModel(String text) {
    if (history.isEmpty || history.last['role'] != 'model') return;
    history.last = {'role': 'model', 'text': text};
  }

  Stream<String> askStream(String text, {bool jsonMode = false}) {
    addUser(text);

    final payload = history
        .where((m) => (m['text'] != null && m['text']!.trim().isNotEmpty))
        .toList(growable: false);

    addModelPlaceholder();
    
    return _api.sendStreaming(payload, jsonMode: jsonMode);
  }

  Future<String> askOnce(String text, {bool jsonMode = false}) async {
    addUser(text);
    final payload = history
        .where((m) => (m['text'] != null && m['text']!.trim().isNotEmpty))
        .toList(growable: false);
    addModelPlaceholder();
    final resp = await _api.sendOnce(payload, jsonMode: jsonMode);
    updateModel(resp);
    return resp;
  }

  void cancel() => _sub?.cancel();
}
