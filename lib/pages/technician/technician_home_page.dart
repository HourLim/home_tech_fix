// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// // 👇 import the other two pages
// import 'technician_chat_page.dart';        // MessagesScreen / Chat list
// import 'technicain_profile_page.dart';     // TechnicianProfilePage (note the filename)

// /// ---------- Domain models ----------
// class Technician {
//   final String name;
//   final String specialty;
//   final double rating;
//   final int jobsCompleted;
//   final String profileImage;

//   const Technician({
//     required this.name,
//     required this.specialty,
//     required this.rating,
//     required this.jobsCompleted,
//     required this.profileImage,
//   });
// }

// class ServiceOffer {
//   final String name;
//   final String description;
//   final double price;

//   const ServiceOffer({
//     required this.name,
//     required this.description,
//     required this.price,
//   });
// }

// /// ---------- Shared in-memory store ----------
// class ServiceStore {
//   ServiceStore._();
//   static final ServiceStore I = ServiceStore._();

//   final ValueNotifier<List<ServiceOffer>> services =
//       ValueNotifier<List<ServiceOffer>>(<ServiceOffer>[]);

//   void add(ServiceOffer s) => services.value = [...services.value, s];
//   void removeAt(int index) =>
//       services.value = List<ServiceOffer>.from(services.value)..removeAt(index);
//   void clear() => services.value = <ServiceOffer>[];
// }

// /// ---------- Technician Home Page ----------
// class TechnicianHomePage extends StatefulWidget {
//   const TechnicianHomePage({Key? key}) : super(key: key);

//   @override
//   State<TechnicianHomePage> createState() => _TechnicianHomePageState();
// }

// class _TechnicianHomePageState extends State<TechnicianHomePage> {
//   // Home tab selected here
//   static const technician = Technician(
//     name: 'Sok Dara',
//     specialty: 'AC & Electrical Technician',
//     rating: 4.8,
//     jobsCompleted: 410,
//     profileImage: 'assets/profile.jpg',
//   );

//   // 🔁 small helper to switch pages without main.dart
//   void _goTo(BuildContext context, Widget page) {
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (_) => page),
//       (route) => false,
//     );
//   }

//   Future<void> _onRefresh() async {
//     await Future<void>.delayed(const Duration(milliseconds: 400));
//     setState(() {});
//   }

//   Future<void> _openCreateServiceSheet() async {
//     final created = await showModalBottomSheet<ServiceOffer>(
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       builder: (_) => const _ServiceCreateSheet(),
//     );

//     if (created != null) {
//       ServiceStore.I.add(created);
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Service "${created.name}" created successfully')),
//       );
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Technician Home')),
//       body: RefreshIndicator(
//         onRefresh: _onRefresh,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             _ProfileHeaderCard(technician: technician),
//             const SizedBox(height: 16),
//             _ResponsiveStatsRow(
//               bookings: technician.jobsCompleted,
//               rating: technician.rating,
//             ),
//             const SizedBox(height: 24),

//             // ---- Manage Services ----
//             Card(
//               elevation: 0,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Manage Services',
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleMedium
//                             ?.copyWith(fontWeight: FontWeight.w700)),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Create and view all services you offer.',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                     const SizedBox(height: 12),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _openCreateServiceSheet,
//                         child: const Text('Create Service'),
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     ValueListenableBuilder<List<ServiceOffer>>(
//                       valueListenable: ServiceStore.I.services,
//                       builder: (_, list, __) {
//                         if (list.isEmpty) {
//                           return const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 8),
//                             child: Text(
//                               'No services created yet.',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           );
//                         }
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Divider(),
//                             ...List.generate(list.length, (i) {
//                               final s = list[i];
//                               return Padding(
//                                 key: ValueKey('${s.name}-$i'),
//                                 padding: const EdgeInsets.symmetric(vertical: 8),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       s.name,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       s.description,
//                                       style: const TextStyle(
//                                         color: Colors.black54,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 6),
//                                     Text(
//                                       '\$${s.price.toStringAsFixed(2)}',
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     const Divider(),
//                                   ],
//                                 ),
//                               );
//                             }),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),

//       // ⬇️ Bottom Nav: switch pages
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: 0, // Home is active here
//         onDestinationSelected: (index) {
//           if (index == 0) return;
//           switch (index) {
//             case 1:
//               _goTo(context, const MessagesScreen());         // -> Chat page
//               break;
//             case 2:
//               _goTo(context, const TechnicianProfilePage());  // -> Profile page
//               break;
//           }
//         },
//         destinations: const [
//           NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
//           NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
//           NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
//         ],
//       ),

//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _openCreateServiceSheet,
//         icon: const Icon(Icons.add),
//         label: const Text('Create Service'),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }

// /// ---------- Reusable UI ----------
// class _ProfileHeaderCard extends StatelessWidget {
//   final Technician technician;
//   const _ProfileHeaderCard({required this.technician});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final t = technician;
//     return Card(
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             CircleAvatar(radius: 36, backgroundImage: AssetImage(t.profileImage)),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(children: [
//                     Text(t.name,
//                         style: const TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.w700)),
//                     const SizedBox(width: 6),
//                     const Icon(Icons.verified, color: Colors.green, size: 18),
//                   ]),
//                   const SizedBox(height: 6),
//                   Text(t.specialty,
//                       style: TextStyle(
//                           color: cs.primary, fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       _Stars(rating: t.rating),
//                       const SizedBox(width: 6),
//                       Text(t.rating.toStringAsFixed(1)),
//                       const SizedBox(width: 12),
//                       Icon(Icons.assignment_turned_in, color: cs.primary, size: 18),
//                       const SizedBox(width: 4),
//                       Text('${t.jobsCompleted}+ jobs',
//                           style: const TextStyle(fontWeight: FontWeight.w700)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ResponsiveStatsRow extends StatelessWidget {
//   final int bookings;
//   final double rating;
//   const _ResponsiveStatsRow({required this.bookings, required this.rating});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       final isNarrow = constraints.maxWidth < 360;
//       final items = <Widget>[
//         _StatCard(
//             icon: Icons.event_available,
//             label: 'Bookings',
//             value: '$bookings'),
//         _StatCard(
//             icon: Icons.star_rate_rounded,
//             label: 'Rating',
//             value: rating.toStringAsFixed(1)),
//       ];

//       if (isNarrow) {
//         return GridView.count(
//           crossAxisCount: 2,
//           mainAxisSpacing: 12,
//           crossAxisSpacing: 12,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           children: items,
//         );
//       }
//       return Row(
//         children: [
//           Expanded(child: items[0]),
//           const SizedBox(width: 12),
//           Expanded(child: items[1]),
//         ],
//       );
//     });
//   }
// }

// class _StatCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   const _StatCard({required this.icon, required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Card(
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(icon, color: cs.primary),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(label,
//                       style: TextStyle(
//                           color: Theme.of(context).colorScheme.onSurfaceVariant,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 4),
//                   FittedBox(
//                     fit: BoxFit.scaleDown,
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       value,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.w800),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Stars extends StatelessWidget {
//   final double rating;
//   const _Stars({required this.rating});

//   @override
//   Widget build(BuildContext context) {
//     final full = rating.floor();
//     final half = (rating - full) >= 0.5;
//     return Row(
//       children: List.generate(5, (i) {
//         if (i < full) return const Icon(Icons.star_rounded, size: 18, color: Colors.amber);
//         if (i == full && half) return const Icon(Icons.star_half_rounded, size: 18, color: Colors.amber);
//         return const Icon(Icons.star_outline_rounded, size: 18, color: Colors.amber);
//       }),
//     );
//   }
// }

// /// ---------- Create Service Sheet ----------
// class _ServiceCreateSheet extends StatefulWidget {
//   const _ServiceCreateSheet();

//   @override
//   State<_ServiceCreateSheet> createState() => _ServiceCreateSheetState();
// }

// class _ServiceCreateSheetState extends State<_ServiceCreateSheet> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _descCtrl = TextEditingController();
//   final _priceCtrl = TextEditingController();

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _descCtrl.dispose();
//     _priceCtrl.dispose();
//     super.dispose();
//   }

//   void _submit() {
//     if (!_formKey.currentState!.validate()) return;
//     final price = double.tryParse(_priceCtrl.text.trim());
//     if (price == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid price')),
//       );
//       return;
//     }
//     final service = ServiceOffer(
//       name: _nameCtrl.text.trim(),
//       description: _descCtrl.text.trim(),
//       price: price,
//     );
//     Navigator.of(context).pop(service);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomInset = MediaQuery.of(context).viewInsets.bottom;

//     return Padding(
//       padding: EdgeInsets.only(bottom: bottomInset),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Expanded(
//                       child: Text('New Service',
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.of(context).maybePop(),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: _nameCtrl,
//                   textInputAction: TextInputAction.next,
//                   decoration: const InputDecoration(
//                     labelText: 'Service name',
//                     hintText: 'e.g., AC Installation',
//                     prefixIcon: Icon(Icons.work_outline),
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) {
//                     final t = (v ?? '').trim();
//                     if (t.isEmpty) return 'Please enter a service name';
//                     if (t.length < 2) return 'Name must be at least 2 characters';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: _descCtrl,
//                   minLines: 2,
//                   maxLines: 4,
//                   decoration: const InputDecoration(
//                     labelText: 'Description',
//                     prefixIcon: Icon(Icons.description_outlined),
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) {
//                     final t = (v ?? '').trim();
//                     if (t.isEmpty) return 'Please add a short description';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: _priceCtrl,
//                   keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                   inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
//                   decoration: const InputDecoration(
//                     labelText: 'Price',
//                     prefixIcon: Icon(Icons.attach_money),
//                     suffixText: 'USD',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) {
//                     final t = (v ?? '').trim();
//                     final p = double.tryParse(t);
//                     if (t.isEmpty) return 'Please enter a price';
//                     if (p == null) return 'Enter a valid number';
//                     if (p <= 0) return 'Price must be greater than 0';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   child: FilledButton.icon(
//                     onPressed: _submit,
//                     icon: const Icon(Icons.save_outlined),
//                     label: const Text('Save Service'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'technician_chat_page.dart';     
import 'technicain_profile_page.dart';     


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
  // Home tab selected here
  static const technician = Technician(
    name: 'Sok Dara',
    specialty: 'AC & Electrical Technician',
    rating: 4.8,
    jobsCompleted: 410,
    profileImage: 'assets/profile.jpg',
  );

  // 🔁 small helper to switch pages without main.dart
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
      builder: (_) => const _ServiceCreateSheet(),
    );

    if (created != null) {
      ServiceStore.I.add(created);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service "${created.name}" created successfully')),
      );
      setState(() {});
    }
  }

  Future<void> _confirmDelete({
    required int index,
    required ServiceOffer service,
  }) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete service?'),
        content: Text('Are you sure you want to delete "${service.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (yes == true && mounted) {
      ServiceStore.I.removeAt(index);
      // Undo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted "${service.name}"'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              ServiceStore.I.insert(index, service);
              setState(() {});
            },
          ),
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Technician Home')),
      body: RefreshIndicator(
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

            // ---- Manage Services ----
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
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                      'Create and view all services you offer.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
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
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            ...List.generate(list.length, (i) {
                              final s = list[i];

                              // Dismissible for swipe-to-delete with undo
                              return Dismissible(
                                key: ValueKey('service-${s.name}-$i'),
                                background: _swipeBg(alignRight: true, context: context),
                                secondaryBackground: _swipeBg(alignRight: false, context: context),
                                confirmDismiss: (_) async {
                                  // ask confirmation before deleting
                                  await _confirmDelete(index: i, service: s);
                                  // handle deletion inside confirm; return false to avoid double-remove 
                                  return false;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // name + desc + price
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  s.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  s.description,
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  '\$${s.price.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // delete icon button
                                          IconButton(
                                            tooltip: 'Delete',
                                            icon: const Icon(Icons.delete_outline),
                                            onPressed: () =>
                                                _confirmDelete(index: i, service: s),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Divider(),
                                    ],
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

      // ⬇️ Bottom Nav: switch pages
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0, // Home is active here
        onDestinationSelected: (index) {
          if (index == 0) return;
          switch (index) {
            case 1:
              _goTo(context, const MessagesScreen());         // -> Chat page
              break;
            case 2:
              _goTo(context, const TechnicianProfilePage());  // -> Profile page
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateServiceSheet,
        icon: const Icon(Icons.add),
        label: const Text('Create Service'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Widget _swipeBg({required bool alignRight, required BuildContext context}) {
  final color = Theme.of(context).colorScheme.errorContainer;
  final onColor = Theme.of(context).colorScheme.onErrorContainer;
  return Container(
    color: color,
    alignment: alignRight ? Alignment.centerLeft : Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Icon(Icons.delete, color: onColor),
  );
}

/// ---------- Reusable UI ----------
class _ProfileHeaderCard extends StatelessWidget {
  final Technician technician;
  const _ProfileHeaderCard({required this.technician});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = technician;
    return Card(
      elevation: 0,
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
                  Row(children: [
                    Text(t.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    const Icon(Icons.verified, color: Colors.green, size: 18),
                  ]),
                  const SizedBox(height: 6),
                  Text(t.specialty,
                      style: TextStyle(
                          color: cs.primary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Stars(rating: t.rating),
                      const SizedBox(width: 6),
                      Text(t.rating.toStringAsFixed(1)),
                      const SizedBox(width: 12),
                      Icon(Icons.assignment_turned_in, color: cs.primary, size: 18),
                      const SizedBox(width: 4),
                      Text('${t.jobsCompleted}+ jobs',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
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

class _ResponsiveStatsRow extends StatelessWidget {
  final int bookings;
  final double rating;
  const _ResponsiveStatsRow({required this.bookings, required this.rating});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isNarrow = constraints.maxWidth < 360;
      final items = <Widget>[
        _StatCard(
            icon: Icons.event_available,
            label: 'Bookings',
            value: '$bookings'),
        _StatCard(
            icon: Icons.star_rate_rounded,
            label: 'Rating',
            value: rating.toStringAsFixed(1)),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: cs.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800),
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

class _Stars extends StatelessWidget {
  final double rating;
  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    final half = (rating - full) >= 0.5;
    return Row(
      children: List.generate(5, (i) {
        if (i < full) return const Icon(Icons.star_rounded, size: 18, color: Colors.amber);
        if (i == full && half) return const Icon(Icons.star_half_rounded, size: 18, color: Colors.amber);
        return const Icon(Icons.star_outline_rounded, size: 18, color: Colors.amber);
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
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
                    prefixIcon: Icon(Icons.work_outline),
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
                    prefixIcon: Icon(Icons.description_outlined),
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
                    prefixIcon: Icon(Icons.attach_money),
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
