import 'package:flutter/material.dart';
import '../ui/ui.dart';
import 'dart:math';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _ctrl = TextEditingController();
  final List<_Msg> _messages = <_Msg>[
    _Msg(text: 'Oi! Eu sou a Betsy 🤖\nPosso te ajudar com check-ins, alertas e conta. Pergunte algo!', fromUser: false),
  ];
  bool _sending = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() {
      _messages.add(_Msg(text: text, fromUser: true));
      _sending = true;
      _ctrl.clear();
    });
    await Future.delayed(const Duration(milliseconds: 250));
    final reply = ChatBrain.reply(text);
    setState(() {
      _messages.add(_Msg(text: reply, fromUser: false));
      _sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kGreen, foregroundColor: Colors.white, title: const Text('Betsy – Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              reverse: true,
              itemCount: _messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final m = _messages[_messages.length - 1 - i];
                return _Bubble(msg: m);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0, -2)),
              ]),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: kTile, borderRadius: BorderRadius.circular(999)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _ctrl,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: const InputDecoration(border: InputBorder.none, hintText: 'Digite sua mensagem…'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: kGreen, foregroundColor: Colors.white),
                    onPressed: _sending ? null : _send,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  _Msg({required this.text, required this.fromUser});
  final String text;
  final bool fromUser;
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});
  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    final isUser = msg.fromUser;
    final color = isUser ? kGreen : kTile;
    final fg = isUser ? Colors.white : Colors.black87;

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(14),
                topRight: const Radius.circular(14),
                bottomLeft: Radius.circular(isUser ? 14 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 14),
              ),
            ),
            child: Text(msg.text, style: TextStyle(color: fg)),
          ),
        ),
      ],
    );
  }
}

class ChatBrain {
  static final _rng = Random();

  // respostas acolhedoras
  static const _gratitudeReplies = [
    'Imagina! 😊 Fico feliz em ajudar.',
    'De nada! Se precisar, estou por aqui ❤️',
    'Que bom poder ajudar! Como você está se sentindo hoje?',
    'Disponha 🙌 Se quiser, posso te guiar até o check-in.',
  ];

  // frases para quando está bem 
  static const _feelGoodReplies = [
    'Que ótimo saber! 😊 Quer registrar isso no seu check-in de hoje? Vá em: Menu → “Morning Check-in”.',
    'Fico muito feliz por você estar bem! 💚 Se quiser, anote no check-in para manter o histórico.',
    'Maravilha! 😄 Registrar no check-in ajuda a acompanhar seus dias bons.',
  ];

  // frases para quando está mal 
  static const _feelBadReplies = [
    'Sinto muito que não esteja bem 😔. Se quiser, podemos registrar no check-in e deixar uma notinha.',
    'Obrigado por compartilhar 💛. Tente respirar fundo. Quer anotar isso no check-in?',
    'Estou aqui com você. Se preferir, faça um check-in rápido para acompanhar como está se sentindo.',
  ];

  static final List<_QA> _kb = [
    _QA(
      patterns: ['oi', 'olá', 'ola', 'bom dia', 'boa tarde', 'boa noite'],
      answer: 'Oi! Eu sou a Betsy 🤖. Posso ajudar com:\n• Check-ins matinais\n• Lembretes (depois)\n• Conta/perfil\nComo posso ajudar?',
    ),
    _QA(
      patterns: ['check-in', 'check in', 'checkin', 'matinal', 'manhã'],
      answer: 'Para fazer o check-in: Menu → “Morning Check-in”. Quer abrir agora? (Toque em “Check-in” na Home 😉)',
    ),
    _QA(
      patterns: ['login', 'logar', 'entrar', 'senha', 'conta', 'registrar', 'cadastro'],
      answer: 'Login em duas etapas: 1) Email, 2) Senha. Para criar conta: “Create account”. Esqueceu a senha? Use “Forgot password”.',
    ),
    _QA(
      patterns: ['histórico', 'historico', 'ver check-ins', 'meus check-ins'],
      answer: 'Veja o histórico em: Menu → “Check-in History”.',
    ),
    _QA(
      patterns: ['ajuda', 'help', 'suporte'],
      answer: 'Claro! Me diga o que você quer fazer que eu explico como chegar.',
    ),
  ];

  static String reply(String userText) {
    final t = _norm(userText);

    // agradecimentos
    if (_containsAny(t, [
      'obrigado','brigado','obg','obgd','valeu','vlw','muito obrigado','agradecido','thanks','thank you'
    ])) {
      return _pick(_gratitudeReplies);
    }

    // respostas positivas
    if (_containsAny(t, [
      'me sinto bem','estou bem','to bem','tô bem','me sinto melhor','estou melhor',
      'me sinto otimo','me sinto ótimo','estou otimo','estou ótimo','me sinto feliz','estou feliz',
    ])) {
      return _pick(_feelGoodReplies);
    }

    // respostas negativas
    if (_containsAny(t, [
      'me sinto mal','estou mal','to mal','tô mal','triste','cansado','cansada','ansioso','ansiosa','com dor'
    ])) {
      return _pick(_feelBadReplies);
    }

    // base de conhecimento simples por palavras chave
    int best = 0;
    String? out;
    for (final qa in _kb) {
      final s = qa.patterns.where((p) => t.contains(p)).length;
      if (s > best) { best = s; out = qa.answer; }
    }

    return (best > 0 && out != null)
        ? out
        : 'Não entendi 🤔. Tente: “Como faço o check-in?” ou “Quero ver meu histórico”.';
  }

  static String _norm(String s) {
    final lower = s.toLowerCase().trim();
    const from = 'áàãâäéèêëíìîïóòõôöúùûüç';
    const to   = 'aaaaaeeeeiiiiooooouuuuc';
    var out = lower;
    for (var i = 0; i < from.length; i++) { out = out.replaceAll(from[i], to[i]); }
    return out;
  }

  static bool _containsAny(String text, List<String> needles) {
    for (final n in needles) {
      if (text.contains(n)) return true;
    }
    return false;
  }

  static String _pick(List<String> xs) => xs[_rng.nextInt(xs.length)];
}

class _QA { _QA({required this.patterns, required this.answer}); final List<String> patterns; final String answer; }

