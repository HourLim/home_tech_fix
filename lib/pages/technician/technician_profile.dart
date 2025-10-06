// lib/technician_profile.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// OPTIONAL quick start:
// void main() => runApp(const MaterialApp(home: TechnicianProfilePage(), debugShowCheckedModeBanner: false));

class TechnicianProfilePage extends StatefulWidget {
  const TechnicianProfilePage({super.key});

  @override
  State<TechnicianProfilePage> createState() => _TechnicianProfilePageState();
}

class _TechnicianProfilePageState extends State<TechnicianProfilePage> {
  File? _profileImage;

  // display-only data (technician-specific)
  final _fullName   = TextEditingController(text: "Sok Dara");
  final _phone      = TextEditingController(text: "+855 88 555 1122");
  final _experience = TextEditingController(text: "6 years");
  final _skills     = TextEditingController(text: "AC Repair, Wiring, Installations");
  final _area       = TextEditingController(text: "Phnom Penh, Kandal");
  final _hours      = TextEditingController(text: "08:00 AM – 06:00 PM");
  final _bio        = TextEditingController(
    text: "Certified AC & Electrical technician. Fast response, careful work, clear explanations.",
  );

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
      );

  InputDecoration _fieldDecoration() => InputDecoration(
        filled: true,
        fillColor: const Color(0xFFEDEDED),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      );

  Widget _readonlyField({required TextEditingController controller, int maxLines = 1}) {
    return TextField(
      controller: controller,
      readOnly: true,
      showCursor: false,
      enableInteractiveSelection: false,
      maxLines: maxLines,
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
              // Avatar + pencil -> open editor and await result
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
                            MaterialPageRoute(
                              builder: (_) => const EditTechnicianProfileScreen(),
                            ),
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

              _label("Full Name"),
              _readonlyField(controller: _fullName),
              const SizedBox(height: 14),

              _label("Phone Number"),
              _readonlyField(controller: _phone),
              const SizedBox(height: 14),

              _label("Experience"),
              _readonlyField(controller: _experience),
              const SizedBox(height: 14),

              _label("Skills"),
              _readonlyField(controller: _skills),
              const SizedBox(height: 14),

              _label("Service Area"),
              _readonlyField(controller: _area),
              const SizedBox(height: 14),

              _label("Working Hours"),
              _readonlyField(controller: _hours),
              const SizedBox(height: 14),

              _label("About / Bio"),
              _readonlyField(controller: _bio, maxLines: 3),
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

/* ======================= EDIT PAGE (SAME FILE) ======================= */

class EditTechnicianProfileScreen extends StatefulWidget {
  const EditTechnicianProfileScreen({super.key});

  @override
  State<EditTechnicianProfileScreen> createState() => _EditTechnicianProfileScreenState();
}

class _EditTechnicianProfileScreenState extends State<EditTechnicianProfileScreen> {
  // Editable fields (you can wire these to persist later)
  final _fullNameController = TextEditingController(text: "Sok Dara");
  final _emailController    = TextEditingController(text: "sokdara.tech@gmail.com");
  final _phoneController    = TextEditingController(text: "+855 88 555 1122");
  final _experienceCtrl     = TextEditingController(text: "6 years");
  final _skillsCtrl         = TextEditingController(text: "AC Repair, Wiring, Installations");
  final _areaCtrl           = TextEditingController(text: "Phnom Penh, Kandal");
  final _hoursCtrl          = TextEditingController(text: "08:00 AM – 06:00 PM");
  final _bioCtrl            = TextEditingController(
    text: "Certified AC & Electrical technician. Fast response, careful work, clear explanations.",
  );

  File? _selectedImage;

  Future<void> _pick(ImageSource src) async {
    final picker = ImagePicker();
    final XFile? x = await picker.pickImage(source: src);
    if (x != null) setState(() => _selectedImage = File(x.path));
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pick(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pick(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF9F6),
        elevation: 0,
        title: const Text(""),
        actions: [
          TextButton(
            onPressed: () {
              // Return only the selected image path (same flow as user profile)
              final String? imagePath = _selectedImage?.path;
              Navigator.pop(context, imagePath);

              // Optional instantaneous feedback (won't show after pop)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile Saved")),
              );
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Profile Image (tap to change)
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.orange,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : const AssetImage("assets/profile.jpg") as ImageProvider,
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: InkWell(
                        onTap: _showPicker,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.orange, width: 2),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.edit, size: 16, color: Colors.orange),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Editable technician fields (same look as your user editor)
              TextField(controller: _fullNameController, decoration: _decoration("Full Name")),
              const SizedBox(height: 15),
              TextField(controller: _emailController, decoration: _decoration("Email")),
              const SizedBox(height: 15),
              TextField(controller: _phoneController, decoration: _decoration("Phone Number")),
              const SizedBox(height: 15),
              TextField(controller: _experienceCtrl, decoration: _decoration("Experience")),
              const SizedBox(height: 15),
              TextField(controller: _skillsCtrl, decoration: _decoration("Skills")),
              const SizedBox(height: 15),
              TextField(controller: _areaCtrl, decoration: _decoration("Service Area")),
              const SizedBox(height: 15),
              TextField(controller: _hoursCtrl, decoration: _decoration("Working Hours")),
              const SizedBox(height: 15),
              TextField(
                controller: _bioCtrl,
                decoration: _decoration("About / Bio"),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
