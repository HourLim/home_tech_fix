import 'dart:io';
import 'package:flutter/material.dart';
import 'profile_edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;

  // display data
  final _username = TextEditingController(text: "Lay Hengg");
  final _email = TextEditingController(text: "layhengg@gmail.com");
  final _phone = TextEditingController(text: "+855882327872");
  final _password = TextEditingController(text: "12345678");
  final _address =
      TextEditingController(text: "79 Kampuchea Krom Blvd (128), Phnom Penh");

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
      );

  InputDecoration _fieldDecoration() => InputDecoration(
        filled: true,
        fillColor: const Color(0xFFEDEDED),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      );

  Widget _readonlyField({required TextEditingController controller, bool obscure = false}) {
    return TextField(
      controller: controller,
      readOnly: true,
      showCursor: false,
      enableInteractiveSelection: false,
      obscureText: obscure,
      decoration: _fieldDecoration(),
      onTap: () => FocusScope.of(context).unfocus(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/profile.jpg') as ImageProvider,
                      backgroundColor: Colors.orange.shade200,
                    ),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: InkWell(
                        onTap: () async {

                          final String? newImagePath = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          );
                          if (newImagePath != null && newImagePath.isNotEmpty) {
                            setState(() => _profileImage = File(newImagePath));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              _label("Username"),
              _readonlyField(controller: _username),
              const SizedBox(height: 14),

              _label("Email"),
              _readonlyField(controller: _email),
              const SizedBox(height: 14),

              _label("Phone Number"),
              _readonlyField(controller: _phone),
              const SizedBox(height: 14),

              _label("Password"),
              _readonlyField(controller: _password, obscure: true),
              const SizedBox(height: 14),

              _label("Address"),
              _readonlyField(controller: _address),
              const SizedBox(height: 24),

              Center(
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6A55),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: const Text("Log out"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'profile_edit_page.dart'; // <-- your edit page

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   int _currentIndex = 3;
//   File? _profileImage;

//   // controllers (profile data)
//   final _username = TextEditingController(text: "Lay Hengg");
//   final _email = TextEditingController(text: "layhengg9@gmail.com");
//   final _phone = TextEditingController(text: "+855882327872");
//   final _password = TextEditingController(text: "12345678");
//   final _address =
//       TextEditingController(text: "79 Kampuchea Krom Blvd (128), Phnom Penh");

//   Widget _label(String text) => Padding(
//         padding: const EdgeInsets.only(bottom: 6),
//         child: Text(
//           text,
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
//         ),
//       );

//   InputDecoration _fieldDecoration() => InputDecoration(
//         filled: true,
//         fillColor: const Color(0xFFEDEDED),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//       );

//   // A helper that renders a NON-editable field
//   Widget _readonlyField({
//     required TextEditingController controller,
//     bool obscure = false,
//   }) {
//     return TextField(
//       controller: controller,
//       readOnly: true,                 // <- prevents editing
//       showCursor: false,              // <- no blinking cursor
//       enableInteractiveSelection: false, // <- no copy/paste handles
//       obscureText: obscure,
//       decoration: _fieldDecoration(),
//       onTap: () => FocusScope.of(context).unfocus(), // <- don't open keyboard
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Avatar with edit button -> goes to EditProfileScreen
//               Center(
//                 child: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 48,
//                       backgroundImage: _profileImage != null
//                           ? FileImage(_profileImage!)
//                           : const AssetImage('assets/profile.png')
//                               as ImageProvider,
//                       backgroundColor: Colors.orange.shade200,
//                     ),
//                     Positioned(
//                       right: 2,
//                       bottom: 2,
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const EditProfileScreen(),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(3),
//                           decoration: BoxDecoration(
//                             color: cs.primary,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.white, width: 2),
//                           ),
//                           child: const Icon(Icons.edit,
//                               size: 14, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 22),

//               _label("Username"),
//               _readonlyField(controller: _username),
//               const SizedBox(height: 14),

//               _label("Email"),
//               _readonlyField(controller: _email),
//               const SizedBox(height: 14),

//               _label("Phone Number"),
//               _readonlyField(controller: _phone),
//               const SizedBox(height: 14),

//               _label("Password"),
//               _readonlyField(controller: _password, obscure: true),
//               const SizedBox(height: 14),

//               _label("Address"),
//               _readonlyField(controller: _address),
//               const SizedBox(height: 24),

//               // Log out button
//               Center(
//                 child: FilledButton.tonal(
//                   style: FilledButton.styleFrom(
//                     backgroundColor: const Color(0xFFFF6A55),
//                     foregroundColor: Colors.white,
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   onPressed: () {
//                     // handle logout
//                   },
//                   child: const Text("Log out"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
