import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: SubscriptionScreen()));

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selected = 'yearly'; // default

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text('Choose your plan'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _headerCard(),
            ),
            const SizedBox(height: 12),

            // Plan cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _planCard(
                      title: 'Monthly\nTechnician',
                      subTitle: 'Pricing Structure',
                      price: '\$8',
                      cadence: 'per month',
                      description:
                          'Unlimited listings each month. Great for active shops that want steady visibility.',
                      selected: _selected == 'monthly',
                      accent: Colors.cyan,
                      cornerBadge: null,
                      onTap: () => setState(() => _selected = 'monthly'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _planCard(
                      title: 'Yearly\nTechnician',
                      subTitle: 'Pricing Structure',
                      price: '\$70',
                      cadence: 'per year',
                      description:
                          'Unlimited listings for 12 months + priority placement. Best for long-term exposure.',
                      selected: _selected == 'yearly',
                      accent: Colors.indigo,
                      cornerBadge: 'Best value',
                      onTap: () => setState(() => _selected = 'yearly'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Icon(Icons.verified, size: 18, color: Colors.green),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Cancel anytime • Secure payments • Instant activation',
                      style: TextStyle(fontSize: 12.5, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final plan = _selected == 'yearly' ? 'Yearly' : 'Monthly';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Selected: $plan Technician Plan'),
                        ),
                      );
                      // TODO: push to checkout
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          _selected == 'yearly' ? Colors.indigo : Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _selected == 'yearly'
                          ? 'Continue with Yearly'
                          : 'Continue with Monthly',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'By continuing you agree to our Terms & Privacy.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.black45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------- Helpers (still inside the same StatefulWidget) -------

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E8F1)),
      ),
      child: Row(
        children: const [
          Icon(Icons.workspace_premium, color: Colors.indigo),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pick the plan that fits your shop. Switch or cancel anytime.',
              style: TextStyle(fontSize: 13.5, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _planCard({
    required String title,
    required String subTitle,
    required String price,
    required String cadence,
    required String description,
    required bool selected,
    required Color accent,
    String? cornerBadge,
    VoidCallback? onTap,
  }) {
    final base = selected ? Colors.white : const Color(0xFFF0F3F8);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accent.withOpacity(0.22),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
          border: Border.all(
            color: selected ? accent : const Color(0xFFE3E8F1),
            width: selected ? 2 : 1,
          ),
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [base, base.withOpacity(0.96)],
                )
              : null,
        ),
        child: Stack(
          children: [
            if (cornerBadge != null)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    cornerBadge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: accent.withOpacity(.12),
                      child: Icon(Icons.build, color: accent),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        style: TextStyle(
                          height: 1.1,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          // FIX: use accent directly (no shade700)
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  subTitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        cadence,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (cadence.contains('year')) _saveChip('Save 27%'),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13.2,
                    height: 1.35,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: accent),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Unlimited listings • Priority support',
                        style:
                            TextStyle(fontSize: 12.2, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E).withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF22C55E)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF16A34A),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
