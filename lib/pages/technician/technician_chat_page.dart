import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'technician_home_page.dart';
import 'technicain_profile_page.dart';
import 'technician_job_page.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<Map<String, dynamic>> messages = const [
    {
      "name": "Layy Heng",
      "message": "Can you come early a...",
      "time": "3:31 PM",
      "avatar": "assets/layy.jpg",
    },
    {
      "name": "John Doe",
      "message": "Hello, Can you clean my AC?",
      "time": "2:15 PM",
      "avatar": "assets/layy.jpg",
    },
  ];

  
  void _goTo(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void _openChat(Map<String, dynamic> chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          contactName: chat["name"] as String,
          avatarAsset: chat["avatar"] as String,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Messages",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

           // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // List
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final chat = messages[index];
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: GestureDetector(
                      onTap: () => _openChat(chat),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(chat["avatar"] as String),
                        radius: 24,
                      ),
                    ),
                    title: Text(
                      chat["name"] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      chat["message"] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      chat["time"] as String,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    onTap: () => _openChat(chat),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 2, 
        backgroundColor: Color.fromARGB(255, 250, 206, 149),
        onDestinationSelected: (index) {
          if (index == 2) return;
          switch (index) {
            case 0:
              _goTo(context, const TechnicianHomePage()); // tov Home
              break;
            case 1:
              _goTo(context, const TechnicianJobPage()); // tov Job page
              break;
            case 3:
              _goTo(context, const TechnicianProfilePage()); // tov Profile
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.assignment), label: 'Job'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

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
    _Message(text: "Sure! How can I help you?", isMe: true),
    _Message(text: "My AC stopped working yesterday.", isMe: false),
    _Message(text: "Thank you for contacting our service!", isMe: true),
  ];

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

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
    final XFile? file = await picker.pickImage(source: source, imageQuality: 85);
    if (file == null) return;
    setState(() => _messages.add(_Message(imageFile: File(file.path), isMe: true)));
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
    final color = isMe ? const Color(0xFFDDEFF5) : const Color(0xFFEFEFEF);
    final align = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: m.imageFile != null
          ? const EdgeInsets.all(6)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
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
          : Text(m.text ?? '', style: const TextStyle(fontSize: 14)),
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
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: "Type message",
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
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(widget.avatarAsset),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.contactName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
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
