import 'package:google_generative_ai/google_generative_ai.dart';

class BetsyChat {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  BetsyChat(String apiKey, {String modelId = 'gemini-1.5-flash'}) {
    _model = GenerativeModel(
      model: modelId,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 1024,
      ),
    );

    _chat = _model.startChat(
      history: [
        Content.text(
          'Você é a Betsy, uma assistente amistosa do app. '
          'Responda curto, em PT-BR, e ofereça ações do app quando fizer sentido.',
        ),
      ],
    );
  }

  Future<String> send(String userMessage) async {
    final resp = await _chat.sendMessage(Content.text(userMessage));
    return resp.text ?? '';
  }

  Stream<String> sendStream(String userMessage) async* {
    final buf = StringBuffer();
    await for (final chunk in _chat.sendMessageStream(Content.text(userMessage))) {
      final piece = chunk.text;
      if (piece != null && piece.isNotEmpty) {
        buf.write(piece);
        yield buf.toString();
      }
    }
  }
}
