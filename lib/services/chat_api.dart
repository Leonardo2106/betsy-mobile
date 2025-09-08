import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../env.dart';

class ChatApi {
  final endpoint = Uri.parse('${Env.apiBase}/chat');

  Stream<String> sendStreaming(List<Map<String, String>> history,
      {String model = 'gemini-1.5-flash', bool jsonMode = false}) async* {
    final req = http.Request('POST', endpoint)
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode({
        'model': model,
        'stream': true,
        'json_mode': jsonMode,
        'temperature': 0.7,
        'max_output_tokens': 1024,
        'messages': history,
      });

    final resp = await req.send();
    if (resp.statusCode >= 400) {
      throw Exception('HTTP ${resp.statusCode}');
    }

    final lines = resp.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    final buf = StringBuffer();
    await for (final line in lines) {
      if (line.startsWith('data: ')) {
        final chunk = line.substring(6);
        if (chunk == '[DONE]') break;
        buf.write(chunk);
        yield buf.toString();
      }
    }
  }

  Future<String> sendOnce(List<Map<String, String>> history,
    {String model = 'gemini-1.5-flash', bool jsonMode = false}) async {
  final resp = await http.post(
    endpoint,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'model': model,
      'stream': false,
      'json_mode': jsonMode,
      'temperature': 0.7,
      'max_output_tokens': 1024,
      'messages': history,
    }),
  );
  if (resp.statusCode >= 400) {
    throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
  }
  final data = jsonDecode(resp.body) as Map<String, dynamic>;
  return (data['text'] as String?) ?? '';
  }
}
