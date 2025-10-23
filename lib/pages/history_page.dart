import 'package:flutter/material.dart';
import 'package:hometechfix/pages/chat_texting.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HistoryScreen(),
  ));
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  static List<Map<String, dynamic>> history = [
    {
      "shop": "Monita repair's shop",
      "date": "26/08/2025", // dd/MM/yyyy
      "time": "3:20 PM",
      "status": "Finished",
      "device": "AC",
      "technician": "Hhour",
      "address": "79 Kampuchea Krom Blvd (128), Phnom Penh",
      "services": [
        {"name": "Clean", "price": 8.0},
        {"name": "gas", "price": 2.0},
      ],
    },
    {
      "shop": "Monita repair's shop",
      "date": "26/08/2025",
      "time": "3:20 PM",
      "status": "Finished",
      "device": "Light",
      "technician": "Limm",
      "address": "79 Kampuchea Krom Blvd (128), Phnom Penh",
      "services": [
        {"name": "1 light", "price": 10.0},
        {"name": "Servivce", "price": 2.0},
      ],
    },
  ];

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 26),
              color: Colors.orange.shade300,
              child: const Center(
                child: Text(
                  "Booking History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // History List
            Expanded(
              child: ListView.separated(
                itemCount: HistoryScreen.history.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 0, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  final item = HistoryScreen.history[index];
                  final status = (item["status"] ?? "").toString();

                  return ListTile(
                    title: Text(
                      item["shop"] ?? "Unknown shop",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Date: ${item["date"] ?? "--/--/----"}    ${item["time"] ?? "--:--"}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _StatusChip(status: status),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RepairDetailsScreen(
                            item: item,
                            // When rebooked, insert the new "In progress" booking at the top
                            onRebooked: (newBooking) {
                              setState(() {
                                HistoryScreen.history.insert(0, newBooking);
                              });
                            },
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final s = status.trim().toLowerCase();
    Color color;
    switch (s) {
      case "finished":
        color = Colors.green;
        break;
      case "in progress":
        color = Colors.blue;
        break;
      case "cancelled":
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class RepairDetailsScreen extends StatelessWidget {
  const RepairDetailsScreen({
    Key? key,
    required this.item,
    this.onRebooked,
  }) : super(key: key);

  final Map<String, dynamic> item;
  final ValueChanged<Map<String, dynamic>>? onRebooked;

  @override
  Widget build(BuildContext context) {
    final shop = (item["shop"] ?? "Unknown shop").toString();
    final status = (item["status"] ?? "-").toString();
    final isFinished = status.trim().toLowerCase() == "finished";
    final isInProgress = status.trim().toLowerCase() == "in progress";

    final date = (item["date"] ?? "-").toString();
    final time = (item["time"] ?? "-").toString();
    final technician = (item["technician"] ?? "-").toString();
    final device = (item["device"] ?? "-").toString();
    final address = (item["address"] ?? "-").toString();

    final services =
        (item["services"] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final total = services.fold<double>(
      0.0,
      (sum, s) => sum + ((s["price"] as num?)?.toDouble() ?? 0.0),
    );

    // Warranty
    final serviceDate = _parseDdMMyyyy(date);
    final warrantyUntil =
        isFinished && serviceDate != null ? serviceDate.add(const Duration(days: 30)) : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade300,
        title: Text(shop),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (address.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(icon: Icons.event, label: "Date", value: date),
                    _InfoChip(icon: Icons.schedule, label: "Time", value: time),
                    _InfoChip(
                        icon: Icons.devices,
                        label: "Device",
                        value: device.isEmpty ? "-" : device),
                    _InfoChip(
                        icon: Icons.person,
                        label: "Technician",
                        value: technician),
                    _StatusChip(status: status),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Services performed
          _SectionCard(
            title: "Services performed",
            child: services.isEmpty
                ? Text(
                    isFinished
                        ? "No service details found."
                        : "To be confirmed after inspection.",
                  )
                : Column(
                    children: [
                      for (final s in services) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                (s["name"] ?? "-").toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            Text(_currency((s["price"] as num?) ?? 0)),
                          ],
                        ),
                        const Divider(height: 16),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isFinished ? "Total" : "Total (est.)",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _currency(total),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 12),

          // Warranty
          _SectionCard(
            title: "Warranty",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("1-month warranty on this repair."),
                const SizedBox(height: 6),
                if (isFinished && warrantyUntil != null)
                  Text(
                    "Valid until ${_prettyDate(warrantyUntil)}",
                    style: TextStyle(color: Colors.grey.shade700),
                  )
                else
                  Text(
                    "Starts after completion.",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
              ],
            ),
          ),
        ],
      ),

      // Bottom CTA
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: isInProgress
              ? SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: const Text(
                      "Chat with technician",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            contactName: technician.isEmpty ? shop : technician,
                            avatarAsset: 'assets/profile.jpg', 
                          ),
                        ),
                      );
                    },
                  ),
                )
              : isFinished
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.star_outline),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade400,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            label: const Text(
                              "Rate this service",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => _showRatingDialog(context, shop),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.calendar_month),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade400,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            label: const Text(
                              "Rebook this shop",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => _handleRebook(
                              context,
                              item,
                              onRebooked: onRebooked,
                            ),
                          ),
                        ),
                      ],
                    )
                  : null,
        ),
      ),
    );
  }
}

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key, required this.booking});

  final Map<String, dynamic> booking;

  @override
  Widget build(BuildContext context) {
    final shop = (booking["shop"] ?? "Unknown shop").toString();
    final date = (booking["date"] ?? "-").toString();
    final time = (booking["time"] ?? "-").toString();
    final device = (booking["device"] ?? "-").toString();
    final technician = (booking["technician"] ?? "-").toString();
    final address = (booking["address"] ?? "-").toString();
    final status = (booking["status"] ?? "In progress").toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade300,
        title: const Text("Booking"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green.shade400,
              ),
              const SizedBox(height: 24),
              const Text(
                "Your re-booking is complete",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.description),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                    foregroundColor: Colors.white,
                  ),
                  label: const Text("View details"),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RepairDetailsScreen(item: booking),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.history),
                  label: const Text("Back to History"),
                  onPressed: () {
                    // Return to the first route (HistoryScreen).
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({super.key, this.title, required this.child});
  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(
            "$label: ",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

String _currency(num n) => "\$${n.toStringAsFixed(2)}";

Future<void> _handleRebook(
  BuildContext context,
  Map<String, dynamic> item, {
  ValueChanged<Map<String, dynamic>>? onRebooked,
}) async {
  // Pick new date/time
  final now = DateTime.now();
  final initialDate = now.add(const Duration(days: 1));
  final firstDate = now;
  final lastDateAllowed = now.add(const Duration(days: 365));

  final pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDateAllowed,
  );
  if (pickedDate == null) return;

  final pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (pickedTime == null) return;

  final scheduled = DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );

  // Build the new booking (status: In progress)
  final Map<String, dynamic> newBooking = {
    "shop": item["shop"],
    "date": _prettyDate(scheduled),
    "time": _prettyTime(pickedTime),
    "status": "In progress",
    "device": item["device"],
    "technician": item["technician"],
    "address": item["address"],
    "services": <Map<String, dynamic>>[],
  };

  onRebooked?.call(newBooking);

  // Confirmation dialog
  await _showInfoDialog(
    context,
    title: "Rebooking confirmed",
    message:
        "Scheduled with ${item["shop"] ?? "the shop"} for ${_prettyDate(scheduled)} at ${_prettyTime(pickedTime)}.",
  );

  // go to the booking screen to show the new booking
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => BookingScreen(booking: newBooking),
    ),
  );
}

Future<void> _showInfoDialog(BuildContext context,
    {required String title, required String message}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text("OK"),
        )
      ],
    ),
  );
}

DateTime? _parseDdMMyyyy(String input) {
  try {
    final parts = input.split("/");
    if (parts.length != 3) return null;
    final d = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final y = int.parse(parts[2]);
    return DateTime(y, m, d);
  } catch (_) {
    return null;
  }
}

String _prettyDate(DateTime dt) =>
    "${_pad(dt.day)}/${_pad(dt.month)}/${dt.year}";

String _prettyTime(TimeOfDay t) {
  final hour12 = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
  final period = t.period == DayPeriod.am ? "AM" : "PM";
  return "$hour12:${_pad(t.minute)} $period";
}

String _pad(int n) => n.toString().padLeft(2, '0');

Future<void> _showRatingDialog(BuildContext context, String shopName) async {
  int selectedRating = 0;
  final commentCtrl = TextEditingController();

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text(
          'Rate Service',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How was your experience with $shopName?',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedRating = starValue);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          starValue <= selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          size: 40,
                          color: Colors.amber.shade600,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (selectedRating > 0) ...[
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _getRatingText(selectedRating),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              TextField(
                controller: commentCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add a comment (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: selectedRating > 0
                ? () => Navigator.of(ctx).pop(true)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade400,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    ),
  );

  if (result == true && selectedRating > 0) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you for rating! You gave $selectedRating star${selectedRating > 1 ? 's' : ''}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  commentCtrl.dispose();
}

String _getRatingText(int rating) {
  switch (rating) {
    case 1:
      return 'Poor';
    case 2:
      return 'Fair';
    case 3:
      return 'Good';
    case 4:
      return 'Very Good';
    case 5:
      return 'Excellent';
    default:
      return '';
  }
}
