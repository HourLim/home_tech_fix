import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialUsername;
  final String initialEmail;
  final String initialPhone;
  final String initialAddress;

  const EditProfileScreen({
    Key? key,
    required this.initialUsername,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialAddress,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  late final TextEditingController _addressController;

  File? _selectedImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialUsername);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

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

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'Not logged in';

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'username': _usernameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Handle password change if provided
      if (_oldPasswordController.text.isNotEmpty && 
          _newPasswordController.text.isNotEmpty) {
        try {
          // Re-authenticate user before changing password
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _oldPasswordController.text,
          );
          await user.reauthenticateWithCredential(credential);
          
          // Update password
          await user.updatePassword(_newPasswordController.text);
          
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully')),
          );
        } on FirebaseAuthException catch (e) {
          if (!mounted) return;
          String message = 'Failed to update password';
          if (e.code == 'wrong-password') {
            message = 'Old password is incorrect';
          } else if (e.code == 'weak-password') {
            message = 'New password is too weak';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          setState(() => _isSaving = false);
          return;
        }
      }

      if (!mounted) return;

      // Return updated data
      Navigator.pop(context, {
        'username': _usernameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'imagePath': _selectedImage?.path,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Saved")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black87)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? Colors.grey[300] : Colors.grey[200],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
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
              // Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.orange,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : const AssetImage("assets/profile.jpg")
                              as ImageProvider,
                      child: _selectedImage == null &&
                              _usernameController.text.isNotEmpty
                          ? Text(
                              _usernameController.text[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
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
                          child: const Icon(Icons.edit,
                              size: 16, color: Colors.orange),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _buildTextField("Username", _usernameController),
              const SizedBox(height: 15),

              _buildTextField("Email", _emailController, readOnly: true),
              const SizedBox(height: 15),

              _buildTextField("Phone Number", _phoneController),
              const SizedBox(height: 15),

              const Divider(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Change Password (Optional)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              _buildTextField("Old Password", _oldPasswordController,
                  isPassword: true),
              const SizedBox(height: 15),

              _buildTextField("New Password", _newPasswordController,
                  isPassword: true),
              const SizedBox(height: 15),

              const Divider(height: 30),

              _buildTextField("Address", _addressController),
            ],
          ),
        ),
      ),
    );
  }
}