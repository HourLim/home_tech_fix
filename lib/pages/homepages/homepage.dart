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
            // Header
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

      
            const SizedBox(height: 20),

        
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
