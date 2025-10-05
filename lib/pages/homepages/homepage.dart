// import 'package:flutter/material.dart';
// import 'service_catalog_screen.dart';

// class HomeServiceScreen extends StatefulWidget {
//   const HomeServiceScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeServiceScreen> createState() => _HomeServiceScreenState();
// }

// class _HomeServiceScreenState extends State<HomeServiceScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   int _unread = 2;

//   // Your services, kept the same but we’ll show them in a grid.
//   final List<Map<String, dynamic>> services = [
//     {"name": "Air Conditioner", "color": Colors.blue, "icon": Icons.ac_unit},
//     {"name": "Light", "color": Colors.lightBlue, "icon": Icons.lightbulb},
//     {"name": "Refrigerator", "color": Colors.brown, "icon": Icons.kitchen},
//     {"name": "Washing Machine", "color": Colors.orange, "icon": Icons.local_laundry_service},
//   ];

//   void _openService(Map<String, dynamic> s) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ServiceCatalogScreen(
//           serviceName: s["name"] as String,
//           headerColor: s["color"] as Color,
//           headerIcon: s["icon"] as IconData,
//         ),
//       ),
//     );
//   }

//   void _toast(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5));
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: [
//           // Gradient SliverAppBar to match login/sign-up
//           SliverAppBar(
//             pinned: true,
//             expandedHeight: 190,
//             backgroundColor: colorScheme.primary,
//             elevation: 0,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
//                   ),
//                 ),
//                 padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
//                 child: SafeArea(
//                   bottom: false,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Top row: logo, name, notifications
//                       Row(
//                         children: [
//                           Image.asset('assets/logo.png', height: 42, fit: BoxFit.contain),
//                           const SizedBox(width: 10),
//                           const Text(
//                             'HomeTech Fix',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: 0.3,
//                             ),
//                           ),
//                           const Spacer(),
//                           Stack(
//                             clipBehavior: Clip.none,
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.notifications_none, color: Colors.white),
//                                 onPressed: () {
//                                   _toast('Open notifications');
//                                   setState(() => _unread = 0);
//                                 },
//                               ),
//                               if (_unread > 0)
//                                 Positioned(
//                                   right: 6,
//                                   top: 6,
//                                   child: Container(
//                                     padding: const EdgeInsets.all(3),
//                                     decoration: const BoxDecoration(
//                                       color: Colors.red,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
//                                     child: Center(
//                                       child: Text(
//                                         '$_unread',
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 14),

//                       // Search bar
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(.08),
//                               blurRadius: 16,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: TextField(
//                           controller: _searchController,
//                           decoration: InputDecoration(
//                             hintText: "Search service or shop…",
//                             prefixIcon: const Icon(Icons.search),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             contentPadding:
//                                 const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                           ),
//                           onSubmitted: (q) => _toast('Search: $q'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Section: Categories
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//               child: Row(
//                 children: const [
//                   Text(
//                     "Categories",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             sliver: SliverGrid(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   final s = services[index];
//                   final Color color = s["color"] as Color;
//                   return InkWell(
//                     borderRadius: BorderRadius.circular(16),
//                     onTap: () => _openService(s),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: color.withOpacity(.12),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(color: color.withOpacity(.2)),
//                       ),
//                       padding: const EdgeInsets.all(14),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: color,
//                             radius: 22,
//                             child: Icon(s["icon"] as IconData, color: Colors.white),
//                           ),
//                           const Spacer(),
//                           Text(
//                             s["name"] as String,
//                             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 childCount: services.length,
//               ),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisExtent: 120,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//               ),
//             ),
//           ),

//           // Section: Quick Actions
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
//               child: Row(
//                 children: const [
//                   Text(
//                     "Quick Actions",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: const [
//                   Expanded(
//                     child: _ActionChipCard(
//                       icon: Icons.bookmark_outline,
//                       label: "Bookings",
//                       color: Color(0xFF1E88E5),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: _ActionChipCard(
//                       icon: Icons.history,
//                       label: "History",
//                       color: Color(0xFF26A69A),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: _ActionChipCard(
//                       icon: Icons.verified_user_outlined,
//                       label: "Warranty",
//                       color: Color(0xFFFF7043),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Section: Recommended shops (simple example list; replace with real data later)
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
//               child: Row(
//                 children: const [
//                   Text(
//                     "Recommended shops",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate.fixed(
//               [
//                 const _ShopCard(
//                   name: "CoolCare AC & Fridge",
//                   tags: "Aircon • Fridge",
//                   rating: 4.8,
//                   distance: "1.2 km",
//                   color: Color(0xFF42A5F5),
//                 ),
//                 const SizedBox(height: 12),
//                 const _ShopCard(
//                   name: "SparkRight Electric",
//                   tags: "Lighting • Wiring",
//                   rating: 4.6,
//                   distance: "2.0 km",
//                   color: Color(0xFFFFB300),
//                 ),
//                 const SizedBox(height: 12),
//                 const _ShopCard(
//                   name: "SpinMaster Laundry",
//                   tags: "Washers • Dryers",
//                   rating: 4.7,
//                   distance: "2.6 km",
//                   color: Color(0xFFFF7043),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActionChipCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;

//   const _ActionChipCard({
//     required this.icon,
//     required this.label,
//     required this.color,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: color.withOpacity(.12),
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: () => ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('Open $label'))),
//         child: Container(
//           height: 64,
//           padding: const EdgeInsets.symmetric(horizontal: 14),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: color,
//                 child: Icon(icon, color: Colors.white),
//               ),
//               const SizedBox(width: 12),
//               Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ShopCard extends StatelessWidget {
//   final String name;
//   final String tags;
//   final double rating;
//   final String distance;
//   final Color color;

//   const _ShopCard({
//     required this.name,
//     required this.tags,
//     required this.rating,
//     required this.distance,
//     required this.color,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: color.withOpacity(.08),
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: () => ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('Open $name profile'))),
//         child: Container(
//           padding: const EdgeInsets.all(14),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: color,
//                 radius: 28,
//                 child: const Icon(Icons.store, color: Colors.white),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(name,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.w800, fontSize: 16)),
//                     const SizedBox(height: 4),
//                     Text(tags, style: TextStyle(color: Colors.grey.shade700)),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         _pill("${rating.toStringAsFixed(1)} ★"),
//                         const SizedBox(width: 8),
//                         _pill(distance),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.chevron_right),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _pill(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(999),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.06),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Text(text,
//           style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:hometechfix/pages/service_catalog_screen.dart';

class HomeServiceScreen extends StatefulWidget {
  const HomeServiceScreen({Key? key}) : super(key: key);

  @override
  State<HomeServiceScreen> createState() => _HomeServiceScreenState();
}

class _HomeServiceScreenState extends State<HomeServiceScreen> {
  final List<Map<String, dynamic>> services = [
    {"name": "Air Conditioner", "color": Colors.blue, "icon": Icons.ac_unit},
    {"name": "Light", "color": Colors.lightBlue, "icon": Icons.lightbulb},
    {"name": "Refrigerator", "color": Colors.brown, "icon": Icons.kitchen},
    {"name": "Washing Machine", "color": Colors.orange, "icon": Icons.local_laundry_service},
  ];

  int _unread = 2;

  void _openService(Map<String, dynamic> s) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceCatalogScreen(
          serviceName: s["name"] as String,
          headerColor: s["color"] as Color,
          headerIcon: s["icon"] as IconData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- Top header: logo + app name (left) + notifications (right) ---
            Container(
              color: const Color(0xFFF09013),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  Image.asset('assets/logo.png', height: 50, fit: BoxFit.contain),
                  const SizedBox(width: 10),
                  const Text(
                    'HomeTechFix',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Open notifications')),
                          );
                          setState(() => _unread = 0);
                        },
                      ),
                      if (_unread > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Center(
                              child: Text('$_unread',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Service cards ---
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final s = services[index];
                  final color = s["color"] as Color;
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _openService(s),
                    child: Container(
                      height: 145,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            s["name"] as String,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          CircleAvatar(
                            backgroundColor: color,
                            radius: 26,
                            child: Icon(s["icon"] as IconData, color: Colors.white, size: 26),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
