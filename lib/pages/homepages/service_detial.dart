import 'package:flutter/material.dart';
import 'book_detail_page.dart';

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

class ServiceDetailScreen extends StatefulWidget {
  final String shopName;
  final double rating;
  final String imageAsset;
  final Color headerColor;
  final String workingHours;
  final String address;
  final String description;
  final List<ServiceOffer> offers;

  const ServiceDetailScreen({
    super.key,
    required this.shopName,
    required this.rating,
    required this.imageAsset,
    required this.headerColor,
    this.workingHours = 'Mon–Sun, 8:00 AM – 9:00 PM',
    this.address = '79 Kampuchea Krom Blvd (128), Phnom Penh, Cambodia',
    this.description =
        'We provide high-quality home services with professional staff.',
    this.offers = const [
      ServiceOffer(
        name: '1hp AC Cleaning',
        description: 'give your ac clean and fresh air',
        price: 8.00,
      ),
      ServiceOffer(
        name: '2hp AC Cleaning',
        description: 'Cleaning AC and gas refill',
        price: 12.00,
      ),
      ServiceOffer(
        name: '3hp AC Cleaning + Gas refill',
        description: 'Give fresh air to ypur room',
        price: 15.00,
      ),
    ],
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget buildHeaderImage() {
      final isNet = widget.imageAsset.startsWith('http');
      final img = isNet
          ? Image.network(widget.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.black12))
          : Image.asset(widget.imageAsset, fit: BoxFit.cover);

      return Stack(
        fit: StackFit.expand,
        children: [
          img,
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(.45),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _HeaderInfo(
              shopName: widget.shopName,
              rating: widget.rating,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 230,
            backgroundColor: widget.headerColor,
            foregroundColor: Colors.white,
            title: const Text('Service Details'),
            flexibleSpace: FlexibleSpaceBar(background: buildHeaderImage()),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    icon: Icons.schedule,
                    label: 'Working Hours',
                    value: widget.workingHours,
                    chipColor: cs.primary.withOpacity(.12),
                    chipTextColor: cs.primary,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.place,
                    label: 'Address',
                    value: widget.address,
                    chipColor: cs.secondaryContainer,
                    chipTextColor: cs.onSecondaryContainer,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'About',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 18),
                  Text(
                    'Services',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    itemCount: widget.offers.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final offer = widget.offers[i];
                      return _ServiceCard(
                        offer: offer,
                        accent: cs.primary,
                        onBook: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BookingDetailPage(
                                vendorName: widget.shopName,
                                serviceTitle: offer.name,
                                unitPrice: offer.price,
                                imageUrl: widget.imageAsset,
                                baseAddress: widget.address,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  const _HeaderInfo({required this.shopName, required this.rating});
  final String shopName;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.store, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shopName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.chipColor,
    required this.chipTextColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color chipColor;
  final Color chipTextColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: chipTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.offer,
    required this.onBook,
    required this.accent,
  });

  final ServiceOffer offer;
  final VoidCallback onBook;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.ac_unit, size: 32), // should change to image 
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  offer.description,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Text(
                '\$${offer.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  onPressed: onBook,
                  child: const Text('Book'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
