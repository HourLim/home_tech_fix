import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String contactName;
  final String avatarAsset;

  const ChatScreen({
    super.key,
    required this.contactName,
    required this.avatarAsset,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  final List<_Message> _messages = [
    _Message(text: "Hello! I want you to clean my AC", isMe: false),
    _Message(text: "Hello! how can I help you", isMe: true),
    _Message(text: "My AC was broke ytd", isMe: false),
    _Message(text: "Thank you for booking our service", isMe: true),
  ];

  Future<void> _sendText() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text: text, isMe: true));
      _textCtrl.clear();
    });
    _scrollToBottom();
  }

  Future<void> _sendImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? x = await picker.pickImage(source: source, imageQuality: 85);
    if (x == null) return;
    setState(() => _messages.add(_Message(imageFile: File(x.path), isMe: true)));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _bubble(_Message m) {
    final isMe = m.isMe;
    final bubbleColor = isMe ? const Color(0xFFDDEFF5) : const Color(0xFFEFEFEF);
    final align = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: m.imageFile != null
          ? const EdgeInsets.all(6)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: Radius.circular(isMe ? 12 : 3),
          bottomRight: Radius.circular(isMe ? 3 : 12),
        ),
      ),
      child: m.imageFile != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(m.imageFile!, width: 220, fit: BoxFit.cover),
            )
          : Text(m.text ?? '', style: const TextStyle(fontSize: 13.5)),
    );

    final avatar = CircleAvatar(
      radius: 16,
      backgroundImage: AssetImage(widget.avatarAsset),
    );

    return Row(
      mainAxisAlignment: align,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe) ...[
          avatar,
          const SizedBox(width: 8),
          bubble,
        ] else
          bubble,
      ],
    );
  }

  Widget _inputBar() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.photo_outlined),
              onPressed: () => _sendImage(ImageSource.gallery),
              tooltip: 'Send photo from gallery',
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () => _sendImage(ImageSource.camera),
              tooltip: 'Take photo',
            ),
            Expanded(
              child: TextField(
                controller: _textCtrl,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Type something",
                  filled: true,
                  fillColor: const Color(0xFFEFEFEF),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _sendText(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.lightBlue.shade200,
              child: IconButton(
                icon: const Icon(Icons.send, size: 18, color: Colors.white),
                onPressed: _sendText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFDF9F6),
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.contactName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: _messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _bubble(_messages[i]),
            ),
          ),
          const SizedBox(height: 6),
          _inputBar(),
        ],
      ),
    );
  }
}

class _Message {
  final String? text;
  final File? imageFile;
  final bool isMe;
  _Message({this.text, this.imageFile, required this.isMe});
}
