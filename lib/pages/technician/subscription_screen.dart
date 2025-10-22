import 'package:flutter/material.dart';
import 'package:hometechfix/pages/technician/payment_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  String _selected = 'yearly'; 
  final double topSpacing = 80;

  void _continue() {
    final plan = _selected == 'yearly' ? 'Yearly' : 'Monthly';
    final price = _selected == 'yearly' ? 70.0 : 8.0;
    
    // Navigate to Payment Screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          planName: plan,
          amount: price,
        ),
      ),
    );
  }

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
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: topSpacing, bottom: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _planCard(
                  title: 'Monthly Technician',
                  price: '\$8',
                  cadence: 'per month',
                  description: 'Unlimited listings each month.',
                  selected: _selected == 'monthly',
                  accent: Colors.cyan,
                  onTap: () => setState(() => _selected = 'monthly'),
                ),
                const SizedBox(height: 40),
                _planCard(
                  title: 'Yearly Technician',
                  price: '\$70',
                  cadence: 'per year',
                  description: 'Unlimited listings for 12 months.',
                  selected: _selected == 'yearly',
                  accent: Colors.amber,
                  cornerBadge: 'Best value',
                  onTap: () => setState(() => _selected = 'yearly'),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 320,
                  child: ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.amber,
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
                ),
                const SizedBox(height: 12),
                Text(
                  'By continuing you agree to our Terms & Privacy.',
                  textAlign: TextAlign.center,
                  style:
                      theme.textTheme.bodySmall?.copyWith(color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _planCard({
    required String title,
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
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: selected ? 1.03 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 320,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(20),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: accent.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 8,
                      offset: Offset(0, 5),
                    ),
                  ],
            border: Border.all(
              color: selected ? accent : const Color(0xFFE3E8F1),
              width: selected ? 2 : 1,
            ),
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
                            color: accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13.2,
                      height: 1.35,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
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