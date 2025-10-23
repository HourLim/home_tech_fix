import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'technician_chat_page.dart';
import 'technicain_profile_page.dart';
import 'technician_job_page.dart';


const kBgPeach        = Color(0xFFFFF3EF); 
const kCardPeach      = Color(0xFFFCEEE3); 


const kOrangeSoft     = Color(0xFFF0BB86); 
const kOrangeSoftDark = Color(0xFFE3A667); 
const kOrangeInk      = Color(0xFFD28540); 


const kInk            = Color(0xFF2B2623); 
const kInkMuted       = Color(0xFF6B615B); 


const kMintChip       = Color(0xFFE6F5EA);
const kMintInk        = Color(0xFF2D6B3E);


const kStar           = Color(0xFFFFC857);

class Technician {
  final String name;
  final String specialty;
  final double rating;
  final int jobsCompleted;
  final String profileImage;

  const Technician({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.jobsCompleted,
    required this.profileImage,
  });
}

class ServiceOffer {
  final String name;
  final String description;
  final double price;

  const ServiceOffer({
    required this.name,
    required this.description,
    required this.price,
  });
}

class ServiceStore {
  ServiceStore._();
  static final ServiceStore I = ServiceStore._();

  final ValueNotifier<List<ServiceOffer>> services =
      ValueNotifier<List<ServiceOffer>>(<ServiceOffer>[]);

  void add(ServiceOffer s) => services.value = [...services.value, s];
  void removeAt(int index) =>
      services.value = List<ServiceOffer>.from(services.value)..removeAt(index);
  void insert(int index, ServiceOffer s) {
    final next = List<ServiceOffer>.from(services.value)..insert(index, s);
    services.value = next;
  }

  void clear() => services.value = <ServiceOffer>[];
}

/// ---------- Technician Home Page ----------
class TechnicianHomePage extends StatefulWidget {
  const TechnicianHomePage({Key? key}) : super(key: key);

  @override
  State<TechnicianHomePage> createState() => _TechnicianHomePageState();
}

class _TechnicianHomePageState extends State<TechnicianHomePage> {
  static const technician = Technician(
    name: 'Lam hour',
    specialty: 'AC & Electrical Technician',
    rating: 4.8,
    jobsCompleted: 410,
    profileImage: 'assets/profile.jpg',
  );

  void _goTo(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    setState(() {});
  }

  Future<void> _openCreateServiceSheet() async {
    final created = await showModalBottomSheet<ServiceOffer>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: kCardPeach,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => const _ServiceCreateSheet(),
    );
    if (created != null) {
      ServiceStore.I.add(created);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service "${created.name}" created successfully'),
          backgroundColor: kOrangeSoftDark,
        ),
      );
      setState(() {});
    }
  }

  Future<void> _confirmDelete({required int index, required ServiceOffer service}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCardPeach,
        title: const Text('Delete Service', style: TextStyle(color: kInk)),
        content: Text('Are you sure you want to delete "${service.name}"?',
            style: const TextStyle(color: kInk)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: kInk)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: kOrangeInk)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ServiceStore.I.removeAt(index);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service "${service.name}" deleted'),
          action: SnackBarAction(
            label: 'Undo',
            textColor: kOrangeInk,
            onPressed: () {
              ServiceStore.I.insert(index, service);
              setState(() {});
            },
          ),
          backgroundColor: kCardPeach,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: kBgPeach,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kOrangeSoft,
        primary: kOrangeSoftDark,
        onPrimary: Colors.white,
        secondary: kOrangeSoft,
        onSecondary: Colors.white,
        background: kBgPeach,
        onBackground: kInk,
        surface: kCardPeach,
        onSurface: kInk,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: kBgPeach,
        surfaceTintColor: kBgPeach,
        elevation: 0,
        foregroundColor: kInk,
        centerTitle: true,
      ),
      cardColor: kCardPeach,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: kInk,
            displayColor: kInk,
          ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: kOrangeSoftDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kOrangeSoft, 
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kOrangeInk,
          side: const BorderSide(color: kOrangeInk),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      iconTheme: const IconThemeData(color: kOrangeInk),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: kOrangeSoftDark),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: kOrangeSoft, // bar background like screenshot
        indicatorColor: kOrangeSoftDark, // rounded selection pill
        labelTextStyle: WidgetStatePropertyAll(TextStyle(color: Colors.black87)),
      ),
      snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(color: kInk),
        behavior: SnackBarBehavior.floating,
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Technician Home'),
        ),
        body: RefreshIndicator(
          color: kOrangeSoftDark,
          onRefresh: _onRefresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ProfileHeaderCard(technician: technician),
              const SizedBox(height: 16),
              _ResponsiveStatsRow(
                bookings: technician.jobsCompleted,
                rating: technician.rating,
              ),
              const SizedBox(height: 24),

              // Manage Services
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Manage Services',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700, color: kInk)),
                      const SizedBox(height: 8),
                      Text(
                        'Create and view all services you offer.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kInkMuted),
                      ),
                      const SizedBox(height: 12),

                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kOrangeSoft,
                            foregroundColor: Colors.black87,
                          ),
                          onPressed: _openCreateServiceSheet,
                          child: const Text('Create Service'),
                        ),
                      ),
                      const SizedBox(height: 12),

                      ValueListenableBuilder<List<ServiceOffer>>(
                        valueListenable: ServiceStore.I.services,
                        builder: (_, list, __) {
                          if (list.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'No services created yet.',
                                style: TextStyle(color: kInkMuted),
                              ),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              ...List.generate(list.length, (i) {
                                final s = list[i];
                                return Dismissible(
                                  key: ValueKey('service-${s.name}-$i'),
                                  background: _swipeBg(alignRight: true, context: context),
                                  secondaryBackground: _swipeBg(alignRight: false, context: context),
                                  confirmDismiss: (_) async {
                                    await _confirmDelete(index: i, service: s);
                                    return false;
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: kCardPeach,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  s.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    color: kOrangeSoftDark,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  s.description,
                                                  style: const TextStyle(
                                                    color: kInkMuted,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  '\$${s.price.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kOrangeInk,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: 'Delete',
                                            icon: const Icon(Icons.delete_outline, color: kOrangeInk),
                                            onPressed: () => _confirmDelete(index: i, service: s),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: NavigationBar(
          selectedIndex: 0,
          backgroundColor: Color.fromARGB(255, 250, 206, 149),
          onDestinationSelected: (index) {
            if (index == 0) return;
            switch (index) {
              case 1:
                _goTo(context, const TechnicianJobPage());
                break;
              case 2:
                _goTo(context, const MessagesScreen());
                break;
              case 3:
                _goTo(context, const TechnicianProfilePage());
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

        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kOrangeSoftDark,
          foregroundColor: Colors.white,
          onPressed: _openCreateServiceSheet,
          icon: const Icon(Icons.add),
          label: const Text('Create Service'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

Widget _swipeBg({required bool alignRight, required BuildContext context}) {
  return Container(
    color: kOrangeSoft,
    alignment: alignRight ? Alignment.centerLeft : Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: const Icon(Icons.delete, color: Colors.black87),
  );
}

// Profile Header Card
class _ProfileHeaderCard extends StatefulWidget {
  final Technician technician;
  const _ProfileHeaderCard({required this.technician});

  @override
  State<_ProfileHeaderCard> createState() => _ProfileHeaderCardState();
}

class _ProfileHeaderCardState extends State<_ProfileHeaderCard> {
  @override
  Widget build(BuildContext context) {
    final t = widget.technician;
    return Card(
      elevation: 0,
      color: kCardPeach,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(radius: 36, backgroundImage: AssetImage(t.profileImage)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: const [
                   
                  ]),
                  Row(
                    children: [
                      Text(t.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700, color: kInk)),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: kOrangeInk, size: 18),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t.specialty,
                    style: const TextStyle(
                      color: kInkMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Stars(rating: t.rating),
                      const SizedBox(width: 6),
                      Text(t.rating.toStringAsFixed(1), style: const TextStyle(color: kInk)),
                      const SizedBox(width: 12),
                      const Icon(Icons.assignment_turned_in, color: kOrangeInk, size: 18),
                      const SizedBox(width: 4),
                      Text('${t.jobsCompleted}+ jobs',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: kInk)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kMintChip,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('Available',
                        style: TextStyle(color: kMintInk, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponsiveStatsRow extends StatefulWidget {
  final int bookings;
  final double rating;
  const _ResponsiveStatsRow({required this.bookings, required this.rating});

  @override
  State<_ResponsiveStatsRow> createState() => _ResponsiveStatsRowState();
}

class _ResponsiveStatsRowState extends State<_ResponsiveStatsRow> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isNarrow = constraints.maxWidth < 360;
      final items = <Widget>[
        _StatCard(icon: Icons.event_available, label: 'Bookings', value: '${widget.bookings}'),
        _StatCard(icon: Icons.star_rate_rounded, label: 'Rating', value: widget.rating.toStringAsFixed(1)),
      ];

      if (isNarrow) {
        return GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: items,
        );
      }
      return Row(
        children: [
          Expanded(child: items[0]),
          const SizedBox(width: 12),
          Expanded(child: items[1]),
        ],
      );
    });
  }
}

class _StatCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: kCardPeach,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icon, color: kOrangeInk),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.label,
                      style: const TextStyle(
                          color: kInkMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kInk),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stars extends StatefulWidget {
  final double rating;
  const _Stars({required this.rating});

  @override
  State<_Stars> createState() => _StarsState();
}

class _StarsState extends State<_Stars> {
  @override
  Widget build(BuildContext context) {
    final full = widget.rating.floor();
    final half = (widget.rating - full) >= 0.5;
    return Row(
      children: List.generate(5, (i) {
        if (i < full) return const Icon(Icons.star_rounded, size: 18, color: kStar);
        if (i == full && half) {
          return const Icon(Icons.star_half_rounded, size: 18, color: kStar);
        }
        return const Icon(Icons.star_outline_rounded, size: 18, color: kStar);
      }),
    );
  }
}

class _ServiceCreateSheet extends StatefulWidget {
  const _ServiceCreateSheet();

  @override
  State<_ServiceCreateSheet> createState() => _ServiceCreateSheetState();
}

class _ServiceCreateSheetState extends State<_ServiceCreateSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final price = double.tryParse(_priceCtrl.text.trim());
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }
    final service = ServiceOffer(
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: price,
    );
    Navigator.of(context).pop(service);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
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
                Row(
                  children: [
                    const Expanded(
                      child: Text('New Service',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kInk)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: kOrangeInk),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Service name',
                    hintText: 'e.g., AC Installation',
                    prefixIcon: Icon(Icons.work_outline, color: kOrangeInk),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return 'Please enter a service name';
                    if (t.length < 2) return 'Name must be at least 2 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descCtrl,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined, color: kOrangeInk),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return 'Please add a short description';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixIcon: Icon(Icons.attach_money, color: kOrangeInk),
                    suffixText: 'USD',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    final p = double.tryParse(t);
                    if (t.isEmpty) return 'Please enter a price';
                    if (p == null) return 'Enter a valid number';
                    if (p <= 0) return 'Price must be greater than 0';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save Service'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
