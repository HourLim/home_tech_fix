import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HistoryScreen(),
  ));
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 1;

  // Sample history data
  final List<Map<String, dynamic>> history = [
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // TODO: Hook up BottomNavigationBar if/when you add it.
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
                itemCount: history.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 0, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  final item = history[index];
                  final status = (item["status"] ?? "").toString();

                  return ListTile(
                    // No photo/avatar before the shop name
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
                      // ✅ Always open details — finished or in-progress
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RepairDetailsScreen(
                            item: item,
                            // When rebooked, insert the new "In progress" booking at the top
                            onRebooked: (newBooking) {
                              setState(() {
                                history.insert(0, newBooking);
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

/// ---------- DETAILS SCREEN (works for Finished & In progress) ----------

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

    // Warranty: 1 month — for Finished we show the exact expiry; for In progress we show "starts after completion".
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
          // Header (no avatar)
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

          // Services performed (or placeholder if in progress)
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
                const Text("1‑month warranty on this repair."),
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

      // Bottom CTA: only for Finished (to avoid double-booking while in progress)
      bottomNavigationBar: isFinished
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  height: 48,
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
              ),
            )
          : null,
    );
  }
}

/// ---------- BOOKING SCREEN (shows the new "In progress" booking) ----------

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
    child: Text(
      "Your re-booking is complete",
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
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

/// ---------- Helpers & UI bits ----------

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
    // (Usually empty until the work is done)
    "services": <Map<String, dynamic>>[],
  };

  // Let HistoryScreen insert it at the top
  onRebooked?.call(newBooking);

  // Confirmation dialog
  await _showInfoDialog(
    context,
    title: "Rebooking confirmed",
    message:
        "Scheduled with ${item["shop"] ?? "the shop"} for ${_prettyDate(scheduled)} at ${_prettyTime(pickedTime)}.",
  );

  // Navigate to the Booking page that shows "In progress"
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
        ),
      ],
    ),
  );
}

// ---- parsing & formatting helpers ----

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


// import 'package:flutter/material.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({Key? key}) : super(key: key);

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   int _selectedIndex = 1;

//   final List<Map<String, String>> history = [
//     {
//       "shop": "Monita repair's shop",
//       "date": "26/08/2025",
//       "time": "3:20 PM",
//       "status": "Finished"
//     },
//     {
//       "shop": "Monita repair's shop",
//       "date": "26/08/2025",
//       "time": "3:20 PM",
//       "status": "Finished"
//     },
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       // TODO: Navigate to other pages when needed
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Top Bar
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               color: Colors.orange.shade300,
//               child: const Center(
//                 child: Text(
//                   "History",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 8),

//             // History List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: history.length,
//                 itemBuilder: (context, index) {
//                   final item = history[index];
//                   return ListTile(
//                     title: Text(
//                       item["shop"]!,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     subtitle: Text(
//                       "Date: ${item["date"]}    ${item["time"]}",
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                     trailing: Text(
//                       item["status"]!,
//                       style: const TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
