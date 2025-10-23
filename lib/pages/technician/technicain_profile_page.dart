import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hometechfix/pages/choose_role.dart';
import 'technician_home_page.dart';
import 'technician_chat_page.dart';
import 'technician_job_page.dart';

Future<String?> _choosePhotoSourceAndPick(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Take a photo'),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from gallery'),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  if (source == null) return null;

  final picker = ImagePicker();
  final img = await picker.pickImage(
    source: source,
    imageQuality: 85,
    preferredCameraDevice: CameraDevice.rear,
  );
  return img?.path;
}

ImageProvider? _avatarProvider(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http')) return NetworkImage(path);
  return FileImage(File(path));
}

class TechnicianProfile {
  final String name;
  final String phoneNumber;
  final double rating;
  final String address;
  final String? specialty;
  final int? yearsOfExperience;
  final String? bio;
  final bool isAvailable;
  final String? avatarPath;

  const TechnicianProfile({
    required this.name,
    required this.phoneNumber,
    required this.rating,
    required this.address,
    this.specialty,
    this.yearsOfExperience,
    this.bio,
    this.isAvailable = true,
    this.avatarPath,
  });

  get jobsCompleted => null;

  TechnicianProfile copyWith({
    String? name,
    String? phoneNumber,
    double? rating,
    String? address,
    String? specialty,
    int? yearsOfExperience,
    String? bio,
    bool? isAvailable,
    String? avatarPath,
  }) {
    return TechnicianProfile(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      rating: rating ?? this.rating,
      address: address ?? this.address,
      specialty: specialty ?? this.specialty,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      bio: bio ?? this.bio,
      isAvailable: isAvailable ?? this.isAvailable,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}

class TechnicianProfileStore {
  TechnicianProfileStore._();
  static final TechnicianProfileStore I = TechnicianProfileStore._();

  final ValueNotifier<TechnicianProfile> profile =
      ValueNotifier<TechnicianProfile>(
    const TechnicianProfile(
      name: 'Lam hour',
      phoneNumber: '+855 12 345 678',
      rating: 4.8,
      address: 'Phnom Penh, Cambodia',
      specialty: 'AC & Electrical Technician',
      yearsOfExperience: 7,
      bio:
          'Specialized in AC installation, deep cleaning, and electrical diagnostics.',
      isAvailable: true,
      avatarPath: null,
    ),
  );

  void update(TechnicianProfile next) => profile.value = next;
}

class TechnicianProfilePage extends StatefulWidget {
  const TechnicianProfilePage({Key? key}) : super(key: key);

  @override
  State<TechnicianProfilePage> createState() => _TechnicianProfilePageState();
}

class _TechnicianProfilePageState extends State<TechnicianProfilePage> {
  void _goTo(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  Future<void> _openEditSheet(TechnicianProfile current) async {
    final updated = await showModalBottomSheet<TechnicianProfile>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _ProfileEditSheet(initial: current),
    );
    if (updated != null) {
      TechnicianProfileStore.I.update(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      setState(() {});
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
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
        // Sign out from Firebase
        await FirebaseAuth.instance.signOut();
        
        if (!mounted) return;
        
        
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const RoleSelectScreen(),
          ),
          (route) => false,
        );
        
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orangeScheme = ColorScheme.fromSeed(seedColor: const Color(0xFFF09013));
    return Theme(
      data: Theme.of(context).copyWith(colorScheme: orangeScheme, useMaterial3: true),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Technician Profile'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: ValueListenableBuilder<TechnicianProfile>(
          valueListenable: TechnicianProfileStore.I.profile,
          builder: (_, p, __) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundImage: _avatarProvider(p.avatarPath),
                              child: p.avatarPath == null
                                  ? Text(
                                      _initials(p.name),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: -4,
                              right: -4,
                              child: Material(
                                color: orangeScheme.primary,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () async {
                                    final path =
                                        await _choosePhotoSourceAndPick(context);
                                    if (path == null) return;
                                    TechnicianProfileStore.I
                                        .update(p.copyWith(avatarPath: path));
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Icon(Icons.edit,
                                        size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                p.specialty ?? 'Technician',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: orangeScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  _StarBar(rating: p.rating),
                                  Text(p.rating.toStringAsFixed(1)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: p.isAvailable
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      p.isAvailable
                                          ? 'Available'
                                          : 'Not available',
                                      style: TextStyle(
                                        color: p.isAvailable
                                            ? Colors.green[700]
                                            : Colors.red[700],
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () => _openEditSheet(p),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(title: 'Contact', children: [
                  _InfoRow(label: 'Phone', value: p.phoneNumber),
                  _InfoRow(label: 'Address', value: p.address),
                ]),
                const SizedBox(height: 12),
                _SectionCard(title: 'Professional', children: [
                  if (p.specialty != null && p.specialty!.isNotEmpty)
                    _InfoRow(label: 'Specialty', value: p.specialty!),
                  if (p.yearsOfExperience != null)
                    _InfoRow(
                        label: 'Experience',
                        value: '${p.yearsOfExperience} year(s)'),
                  _InfoRow(
                      label: 'Availability',
                      value: p.isAvailable ? 'Available' : 'Not available'),
                  if (p.bio != null && p.bio!.isNotEmpty)
                    _MultilineValue(label: 'About', value: p.bio!),
                ]),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 3,
          backgroundColor: Color.fromARGB(255, 250, 206, 149),
          onDestinationSelected: (index) {
            if (index == 3) return;
            switch (index) {
              case 0:
                _goTo(context, const TechnicianHomePage());
                break;
              case 1:
                _goTo(context, const TechnicianJobPage());
                break;
              case 2:
                _goTo(context, const MessagesScreen());
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
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'T';
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    final result = (first + last).toUpperCase();
    return result.isEmpty ? 'T' : result;
  }
}

class _ProfileEditSheet extends StatefulWidget {
  final TechnicianProfile initial;
  const _ProfileEditSheet({required this.initial});

  @override
  State<_ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<_ProfileEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late double _rating;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _specialtyCtrl;
  late final TextEditingController _yearsCtrl;
  late final TextEditingController _bioCtrl;
  bool _isAvailable = true;
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _nameCtrl = TextEditingController(text: p.name);
    _phoneCtrl = TextEditingController(text: p.phoneNumber);
    _rating = p.rating;
    _addressCtrl = TextEditingController(text: p.address);
    _specialtyCtrl = TextEditingController(text: p.specialty ?? '');
    _yearsCtrl = TextEditingController(
      text: p.yearsOfExperience?.toString() ?? '',
    );
    _bioCtrl = TextEditingController(text: p.bio ?? '');
    _isAvailable = p.isAvailable;
    _avatarPath = p.avatarPath;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _specialtyCtrl.dispose();
    _yearsCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final years = int.tryParse(_yearsCtrl.text.trim());
    final updated = TechnicianProfile(
      name: _nameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      rating: _rating.clamp(0.0, 5.0),
      address: _addressCtrl.text.trim(),
      specialty:
          _specialtyCtrl.text.trim().isEmpty ? null : _specialtyCtrl.text.trim(),
      yearsOfExperience: years,
      bio: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
      isAvailable: _isAvailable,
      avatarPath: _avatarPath,
    );
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    final orangeScheme = ColorScheme.fromSeed(seedColor: const Color(0xFFF09013));
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Theme(
      data: Theme.of(context).copyWith(colorScheme: orangeScheme, useMaterial3: true),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: _avatarProvider(_avatarPath),
                          child: _avatarPath == null
                              ? const Icon(Icons.person, size: 36)
                              : null,
                        ),
                        Positioned(
                          bottom: -6,
                          right: -6,
                          child: Material(
                            color: orangeScheme.primary,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () async {
                                final path =
                                    await _choosePhotoSourceAndPick(context);
                                if (path == null) return;
                                setState(() => _avatarPath = path);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.camera_alt,
                                    size: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final t = (v ?? '').trim();
                      if (t.isEmpty) return 'Please enter a name';
                      if (t.length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            final t = (v ?? '').trim();
                            if (t.isEmpty) return 'Please enter a phone number';
                            if (t.replaceAll(RegExp(r'[^0-9]'), '').length < 8) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _specialtyCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Specialty (optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressCtrl,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      hintText: 'Street, city, region',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v ?? '').trim().isEmpty
                        ? 'Please enter an address'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _yearsCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Years of experience',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Available for jobs'),
                          value: _isAvailable,
                          onChanged: (v) => setState(() => _isAvailable = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Rating: ${_rating.toStringAsFixed(1)} / 5.0'),
                  Slider(
                    value: _rating,
                    min: 0,
                    max: 5,
                    divisions: 50,
                    label: _rating.toStringAsFixed(1),
                    onChanged: (v) => setState(() => _rating = v),
                  ),
                  _StarBar(rating: _rating),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatefulWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  List<Widget> _withDividers(List<Widget> items) {
    final list = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      list.add(items[i]);
      if (i != items.length - 1) list.add(const Divider(height: 16));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ..._withDividers(widget.children),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatefulWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  State<_InfoRow> createState() => _InfoRowState();
}

class _InfoRowState extends State<_InfoRow> {
  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        );
    const valueStyle = TextStyle(fontWeight: FontWeight.w700);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            widget.label,
            style: labelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            widget.value,
            style: valueStyle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MultilineValue extends StatefulWidget {
  final String label;
  final String value;
  const _MultilineValue({required this.label, required this.value});

  @override
  State<_MultilineValue> createState() => _MultilineValueState();
}

class _MultilineValueState extends State<_MultilineValue> {
  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        );
    const valueStyle = TextStyle(fontWeight: FontWeight.w700);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: labelStyle),
        const SizedBox(height: 6),
        Text(widget.value, style: valueStyle),
      ],
    );
  }
}

class _StarBar extends StatefulWidget {
  final double rating;
  const _StarBar({required this.rating});

  @override
  State<_StarBar> createState() => _StarBarState();
}

class _StarBarState extends State<_StarBar> {
  @override
  Widget build(BuildContext context) {
    final full = widget.rating.floor();
    final half = (widget.rating - full) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < full) {
          return const Icon(Icons.star_rounded, size: 18, color: Colors.amber);
        }
        if (i == full && half) {
          return const Icon(Icons.star_half_rounded,
              size: 18, color: Colors.amber);
        }
        return const Icon(Icons.star_outline_rounded,
            size: 18, color: Colors.amber);
      }),
    );
  }
}