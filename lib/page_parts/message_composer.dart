import 'package:flutter/material.dart';

import '../helpers/api_helper.dart';
import '../helpers/rsa_helper.dart';

class MessageComposer extends StatefulWidget {
  final String addressee;
  const MessageComposer({required this.addressee, Key? key}) : super(key: key);

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;
  RSAHelper rsa = RSAHelper();
  APIHelper api = APIHelper();

  void _handleSubmitted(String text) async {
    var resp = await api.sendMessage(text, widget.addressee);
    if (resp != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wystąpił problem z wysyłaniem wiadomości!'), backgroundColor: Colors.red,),
      );
    }
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  controller: _textController,
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.isNotEmpty;
                    });
                  },
                  onSubmitted: _isComposing ? _handleSubmitted : null,
                  decoration: const InputDecoration.collapsed(hintText: 'Wprowadź wiadomość...'),
                  focusNode: _focusNode,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                ),
              ),
            ],
          ),
        )
    );
  }
}
