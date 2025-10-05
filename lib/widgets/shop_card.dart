import 'package:flutter/material.dart';

class ShopItem {
  final String name;
  final double rating;      // ⭐ rating instead of price
  final String imageAsset;
  const ShopItem({
    required this.name,
    required this.rating,
    required this.imageAsset,
  });
}

class ShopCard extends StatefulWidget {
  const ShopCard({super.key, required this.shop, required this.onTap});

  final ShopItem shop;
  final VoidCallback onTap;

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  @override
  Widget build(BuildContext context) {
    const grey = Color(0xFFE5E5E5);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(color: grey, borderRadius: BorderRadius.circular(18)),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.shop.imageAsset,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.shop.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12.5, color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            // ⭐ Rating chip (top-right)
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA000),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.white),
                    const SizedBox(width: 2),
                    Text(
                      widget.shop.rating.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
