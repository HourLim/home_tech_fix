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
  static const orange = Color(0xFFF39C12);

  final List<Map<String, dynamic>> services = const [
    {"name": "Air Conditioner", "color": Colors.blue, "icon": Icons.ac_unit},
    {"name": "Light", "color": Colors.lightBlue, "icon": Icons.lightbulb},
    {"name": "Refrigerator", "color": Color(0xFFFFB84D), "icon": Icons.kitchen},
    {"name": "Washing Machine", "color": Color(0xFF4A90E2), "icon": Icons.local_laundry_service},
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ——— Header ———
            Container(
              height: 100,
              decoration: const BoxDecoration(
                color: orange,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Row(
                children: [
                  Image.asset('assets/logo.png', height: 60, fit: BoxFit.contain),
                  const SizedBox(width: 10),
                  const Text(
                    'HomeTechFix',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        splashRadius: 22,
                        icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
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
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Text(
                              '$_unread',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            //space below header
            const SizedBox(height: 20),

            // ——— Scrollable Grid ———
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final gridVerticalPadding = 16.0 * 2;
                  final spacing = 12.0;
                  final availableH = constraints.maxHeight - gridVerticalPadding - spacing;
                  final tileHeight = (availableH / 2);
                  final tileWidth = (constraints.maxWidth - 12.0) / 2;
                  final childAspectRatio = tileWidth / tileHeight;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: GridView.builder(
                      // enable scrolling
                      physics: const BouncingScrollPhysics(),
                      itemCount: services.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        final s = services[index];
                        return _ServiceTile(
                          name: s["name"] as String,
                          color: s["color"] as Color,
                          icon: s["icon"] as IconData,
                          onTap: () => _openService(s),
                        );
                      },
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

//Service Tile 
class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.name,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String name;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = color.withOpacity(0.12);

    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.06),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, tint],
              stops: const [0.6, 1.0],
            ),
            border: Border.all(color: Colors.black12.withOpacity(0.06)),
          ),
          child: Stack(
            children: [
              // background icon watermark
              Positioned(
                right: -6,
                bottom: -6,
                child: Icon(icon, size: 90, color: color.withOpacity(0.10)),
              ),
              // main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: Colors.white, size: 30),
                  ),
                  const Spacer(),
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Text(
                        'View details',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF39C12),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFFF39C12)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
