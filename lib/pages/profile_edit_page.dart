import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Editable fields
  final _usernameController = TextEditingController(text: "Lay Hengg");
  final _emailController    = TextEditingController(text: "layhengg@gmail.com");
  final _phoneController    = TextEditingController(text: "+855882327872");
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _addressController  =
      TextEditingController(text: "79 Kampuchea Krom Blvd (128), Phnom Penh");

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

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

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
              // save and return 
              final String? imagePath = _selectedImage?.path;
              Navigator.pop(context, imagePath);

              // show confirmation 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile Saved")),
              );
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
              // Profile Image and tap to change
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

              _buildTextField("Username", _usernameController),
              const SizedBox(height: 15),

              _buildTextField("Email", _emailController),
              const SizedBox(height: 15),

              _buildTextField("Phone Number", _phoneController),
              const SizedBox(height: 15),

              _buildTextField("Old Password", _oldPasswordController, isPassword: true),
              const SizedBox(height: 15),

              _buildTextField("New Password", _newPasswordController, isPassword: true),
              const SizedBox(height: 15),

              _buildTextField("Address", _addressController),
            ],
          ),
        ),
      ),
    );
  }
}
