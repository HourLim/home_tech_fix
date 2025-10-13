import 'package:flutter/material.dart';
import 'package:hometechfix/pages/homepages/service_detial.dart';
import 'package:hometechfix/widgets/shop_card.dart';

class ServiceCatalogScreen extends StatefulWidget {
  final String serviceName;
  final Color headerColor;
  final IconData headerIcon;

  const ServiceCatalogScreen({
    super.key,
    required this.serviceName,
    required this.headerColor,
    required this.headerIcon,
  });

  @override
  State<ServiceCatalogScreen> createState() => _ServiceCatalogScreenState();
}

class _ServiceCatalogScreenState extends State<ServiceCatalogScreen> {
  late final List<ShopItem> _shops;

  @override
  void initState() {
    super.initState();
    _shops = _mockShopsFor(widget.serviceName);
  }

  List<ShopItem> _mockShopsFor(String service) {
    final ratings = [4.9, 4.7, 4.5, 4.3, 4.8, 4.6];
    return List.generate(
      ratings.length,
      (i) => ShopItem(
        name: '$service Repair Shop',
        rating: ratings[i],
        imageAsset: 'assets/ac_worker.png',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // header bar 
            Container(
              height: 72,
              width: double.infinity,
              color: widget.headerColor.withOpacity(0.85),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.serviceName} Service',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                ],
              ),
            ),

            // shop grid 
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                physics: const BouncingScrollPhysics(),
                itemCount: _shops.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final shop = _shops[index];
                  return ShopCard(
                    shop: shop,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServiceDetailScreen(
                            shopName: shop.name,
                            rating: shop.rating,
                            imageAsset: shop.imageAsset,
                            headerColor: widget.headerColor,
                          ),
                        ),
                      );
                    },
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
