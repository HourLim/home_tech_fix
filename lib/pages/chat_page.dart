import 'package:flutter/material.dart';
import 'chat_texting.dart'; // <- import the texting page below

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _selectedIndex = 2;

  // Example chat data (local images in assets/)
  final List<Map<String, dynamic>> messages = [
    {
      "name": "Layy Heng",
      "message": "Can you come early a...",
      "time": "3:31 PM",
      "avatar": "assets/layy.jpg",
    },
    {
      "name": "Jonh Doe",
      "message": "Hello, where are you ?",
      "time": "2:15 PM",
      "avatar": "assets/layy.jpg",
    },
  ];

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

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    // TODO: Navigate to other pages when needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
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

            // Messages List
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final chat = messages[index];
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: GestureDetector(
                      onTap: () => _openChat(chat), // tap avatar -> open chat
                      child: CircleAvatar(
                        backgroundImage: AssetImage(chat["avatar"] as String),
                        radius: 24,
                      ),
                    ),
                    title: Text(
                      chat["name"] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(chat["message"] as String),
                    trailing: Text(
                      chat["time"] as String,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    onTap: () => _openChat(chat), // tap row -> open chat
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // (optional) bottom nav if you need it later
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   selectedItemColor: Colors.orange,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
      //     BottomNavigationBarItem(icon: Icon(Icons.access_time), label: ""),
      //     BottomNavigationBarItem(icon: Icon(Icons.message), label: ""),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      //   ],
      // ),
    );
  }
}
// import 'package:flutter/material.dart';

// class MessagesScreen extends StatefulWidget {
//   const MessagesScreen({Key? key}) : super(key: key);

//   @override
//   State<MessagesScreen> createState() => _MessagesScreenState();
// }

// class _MessagesScreenState extends State<MessagesScreen> {
//   int _selectedIndex = 2;

//   // Example chat data (local images in assets/images/)
//   final List<Map<String, dynamic>> messages = [
//     {
//       "name": "Layy Heng",
//       "message": "Can you come early a...",
//       "time": "3:31 PM",
//       "avatar": "assets/layy.jpg" // your uploaded photo
//     },
//     {
//       "name": "Jonh Doe",
//       "message": "Hello, where are you ?",
//       "time": "3:31 PM",
//       "avatar": "assets/layy.jpg"
//     },
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       // TODO: Navigate to other pages when needed
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Top Bar
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Messages",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.settings, color: Colors.grey),
//                     onPressed: () {
//                       // TODO: Add settings page navigation
//                     },
//                   ),
//                 ],
//               ),
//             ),

//             // Search Bar
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search",
//                   prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.grey.shade200,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Messages List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   final chat = messages[index];
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: AssetImage(chat["avatar"]),
//                       radius: 24,
//                     ),
//                     title: Text(
//                       chat["name"],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Text(chat["message"]),
//                     trailing: Text(
//                       chat["time"],
//                       style: const TextStyle(color: Colors.grey, fontSize: 12),
//                     ),
//                     onTap: () {
//                       // TODO: Navigate to chat detail screen
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
