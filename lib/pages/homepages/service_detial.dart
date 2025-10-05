import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String shopName;
  final double rating;
  final String imageAsset;
  final Color headerColor;

  // Optional info (defaults so you can call with only the 4 required above)
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
    this.workingHours = '8:00 am – 6:00 pm',
    this.address = '79 Kampuchea Krom Blvd (128), Phnom Penh',
    this.description =
        "We can help you make your repair easy, fast and acceptable.",
    this.offers = const [
      ServiceOffer(name: '1h Cleaning AC', price: 8.00),
      ServiceOffer(name: '2h Cleaning AC', price: 15.00),
      ServiceOffer(name: '1h Cleaning AC', price: 8.00),
    ],
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ---------- HERO HEADER ----------
              Stack(
                children: [
                  Container(
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.headerColor.withOpacity(.25),
                          Colors.white
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    right: 4,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 28),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFA000),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                widget.rating.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 220,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          widget.imageAsset,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ---------- DETAILS ----------
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.shopName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 14),

                    // Working hours
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.schedule,
                              color: cs.primary, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 14),
                              children: [
                                TextSpan(text: "${widget.workingHours}  "),
                                TextSpan(
                                  text: "(Working hour)",
                                  style: TextStyle(
                                      color: cs.primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.place_outlined, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Address: ${widget.address}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Description
                    const Text("Description",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15.5)),
                    const SizedBox(height: 6),
                    Text(widget.description,
                        style: TextStyle(
                            color: Colors.grey.shade800, height: 1.35)),
                    const SizedBox(height: 18),

                    // Services section
                    const Text("Services type",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15.5)),
                    const SizedBox(height: 10),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.offers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _ServiceCard(
                        offer: widget.offers[i],
                        accent: cs.primary,
                        onBook: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Booked: ${widget.offers[i].name}')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceOffer {
  final String name;
  final double price;
  const ServiceOffer({required this.name, required this.price});
}

class _ServiceCard extends StatefulWidget {
  const _ServiceCard(
      {required this.offer, required this.onBook, required this.accent});
  final ServiceOffer offer;
  final VoidCallback onBook;
  final Color accent;

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 6))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.cleaning_services_outlined,
                color: Colors.white70),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(widget.offer.name,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("\$ ${widget.offer.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: widget.accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
              const SizedBox(height: 6),
              SizedBox(
                height: 34,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.accent,
                    side: BorderSide(color: widget.accent),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: widget.onBook,
                  child: const Text("Book"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
