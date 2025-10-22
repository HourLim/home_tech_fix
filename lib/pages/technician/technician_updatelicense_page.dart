import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hometechfix/pages/technician/subscription_screen.dart';

class TechnicianCompleteProfilePage extends StatefulWidget {
  const TechnicianCompleteProfilePage({super.key});

  @override
  State<TechnicianCompleteProfilePage> createState() => _TechnicianCompleteProfilePageState();
}

class _TechnicianCompleteProfilePageState extends State<TechnicianCompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // address
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController(text: 'Cambodia');

  Uint8List? _licenseBytes;
  bool _saving = false;
  AutovalidateMode _av = AutovalidateMode.disabled;

  @override
  void dispose() {
    _address.dispose();
    _city.dispose();
    _country.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    final x = await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (x != null) {
      final bytes = await x.readAsBytes();
      setState(() => _licenseBytes = bytes);
    }
  }

  void _save() async {
    if (_licenseBytes == null) {
      setState(() => _av = AutovalidateMode.onUserInteraction);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your license photo')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      setState(() => _av = AutovalidateMode.onUserInteraction);
      return;
    }

    setState(() => _saving = true);

    try {
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Update Firestore profile
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'address': _address.text.trim(),
        'city': _city.text.trim(),
        'country': _country.text.trim(),
        'licenseUploaded': true,
        'licenseUploadedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('--- Technician License & Address Saved ---');
      debugPrint('License bytes: ${_licenseBytes?.length}');
      debugPrint('Address: ${_address.text}, ${_city.text}, ${_country.text}');
      debugPrint('------------------------------------');

      if (!mounted) return;
      
      // Navigate to subscription screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
      
      setState(() => _saving = false);
    }
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Technician Profile'),
        automaticallyImplyLeading: false, // prevent back button
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Upload your license and enter your address to continue.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // License
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('License Photo', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 96,
                          width: 96,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _licenseBytes == null
                              ? const Icon(Icons.badge_outlined, size: 36)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(_licenseBytes!, height: 96, width: 96, fit: BoxFit.cover),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _saving ? null : () => _pick(ImageSource.camera),
                                icon: const Icon(Icons.photo_camera_outlined),
                                label: const Text('Use camera'),
                              ),
                              OutlinedButton.icon(
                                onPressed: _saving ? null : () => _pick(ImageSource.gallery),
                                icon: const Icon(Icons.photo_library_outlined),
                                label: const Text('From gallery'),
                              ),
                              if (kIsWeb)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'On web, "Use camera" may open the file picker depending on browser support.',
                                    style: TextStyle(color: Colors.black54, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Make sure the ID text is readable.', style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Address form
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _av,
                  child: Column(
                    children: [
                      _Field(controller: _address, label: 'Address', icon: Icons.location_on_outlined, validator: _req),
                      const SizedBox(height: 12),
                      _Field(controller: _city, label: 'City', icon: Icons.location_city_outlined, validator: _req),
                      const SizedBox(height: 12),
                      _Field(controller: _country, label: 'Country', icon: Icons.public_outlined, validator: _req),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_circle_outline),
                label: const Text('Save & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}