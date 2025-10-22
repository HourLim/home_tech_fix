import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  bool _isLoading = true;
  
  // User data
  String _username = '';
  String _email = '';
  String _phone = '';
  String _address = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _email = user.email ?? '';
          _username = data['username'] ?? data['email']?.split('@')[0] ?? 'User';
          _phone = data['phone'] ?? 'Not set';
          _address = data['address'] ?? 'Not set';
          _isLoading = false;
        });
      } else {
        setState(() {
          _email = user.email ?? '';
          _username = user.email?.split('@')[0] ?? 'User';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseAuth.instance.signOut();
        // AuthWrapper will automatically handle navigation to RoleSelectScreen
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error logging out: $e')),
          );
        }
      }
    }
  }

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

  Widget _readonlyField({required String value, bool obscure = false}) {
    return TextField(
      controller: TextEditingController(text: value),
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

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                      child: _profileImage == null
                          ? Text(
                              _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: InkWell(
                        onTap: () async {
                          final result = await Navigator.push<Map<String, dynamic>>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileScreen(
                                initialUsername: _username,
                                initialEmail: _email,
                                initialPhone: _phone,
                                initialAddress: _address,
                              ),
                            ),
                          );
                          
                          if (result != null) {
                            setState(() {
                              _username = result['username'] ?? _username;
                              _phone = result['phone'] ?? _phone;
                              _address = result['address'] ?? _address;
                              if (result['imagePath'] != null) {
                                _profileImage = File(result['imagePath']);
                              }
                            });
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
              _readonlyField(value: _username),
              const SizedBox(height: 14),

              _label("Email"),
              _readonlyField(value: _email),
              const SizedBox(height: 14),

              _label("Phone Number"),
              _readonlyField(value: _phone),
              const SizedBox(height: 14),

              _label("Address"),
              _readonlyField(value: _address),
              const SizedBox(height: 24),

              Center(
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6A55),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _handleLogout,
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