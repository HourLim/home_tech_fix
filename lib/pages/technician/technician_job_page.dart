import 'package:flutter/material.dart';
import 'technician_home_page.dart' as home_page;
import 'technicain_profile_page.dart';
import 'technician_chat_page.dart';

enum BookingStatus { pending, confirmed, rejected }

class Booking {
  final String id;
  final String customerName;
  final String serviceType;
  final String address;
  final DateTime dateTime;
  BookingStatus status;

  Booking({
    required this.id,
    required this.customerName,
    required this.serviceType,
    required this.address,
    required this.dateTime,
    this.status = BookingStatus.pending,
  });
}

class TechnicianJobPage extends StatefulWidget {
  const TechnicianJobPage({Key? key}) : super(key: key);

  @override
  State<TechnicianJobPage> createState() => _TechnicianJobPageState();
}

class _TechnicianJobPageState extends State<TechnicianJobPage> {
  final List<Booking> _bookings = [
    Booking(
      id: 'B-1001',
      customerName: 'Chantha Sok',
      serviceType: 'AC Installation',
      address: 'Street 271, Phnom Penh',
      dateTime: DateTime.now().add(const Duration(hours: 6)),
    ),
    Booking(
      id: 'B-1002',
      customerName: 'Kim Sopheak',
      serviceType: 'Electrical Repair',
      address: 'Tuol Kork, Phnom Penh',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
    ),
  ];

  void _goTo(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void _confirmBooking(Booking booking) {
    setState(() => booking.status = BookingStatus.confirmed);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookingDetailPage(booking: booking)),
    );
  }

  void _rejectBooking(Booking booking) {
    setState(() => booking.status = BookingStatus.rejected);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking ${booking.id} rejected'),
        backgroundColor: Colors.red[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = ColorScheme.fromSeed(seedColor: const Color(0xFFF09013));
    return Theme(
      data: Theme.of(context).copyWith(colorScheme: cs, useMaterial3: true),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF8F2),
        appBar: AppBar(
          title: const Text('My Jobs'),
          centerTitle: true,
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: _bookings.isEmpty
            ? const Center(child: Text('No bookings yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _bookings.length,
                itemBuilder: (context, i) {
                  final b = _bookings[i];
                  return Card(
                    color: const Color(0xFFFCEEE3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: cs.primary.withOpacity(.15),
                                foregroundColor: cs.primary,
                                child: const Icon(Icons.person),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(b.customerName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 16)),
                                    Text(b.serviceType,
                                        style: TextStyle(
                                            color: cs.primary, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              _StatusChip(status: b.status, cs: cs),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.event, size: 16, color: Colors.black54),
                              const SizedBox(width: 6),
                              Text(
                                '${_d2(b.dateTime.day)}/${_d2(b.dateTime.month)}/${b.dateTime.year}  '
                                '${_d2(b.dateTime.hour)}:${_d2(b.dateTime.minute)}',
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          if (b.status == BookingStatus.pending) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () => _confirmBooking(b),
                                    icon: const Icon(Icons.check),
                                    label: const Text('Confirm'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: cs.primary,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _rejectBooking(b),
                                    icon: const Icon(Icons.close),
                                    label: const Text('Reject'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                      side: const BorderSide(color: Colors.redAccent),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 1,
          backgroundColor: const Color.fromARGB(255, 250, 206, 149),
          onDestinationSelected: (index) {
            if (index == 1) return;
            switch (index) {
              case 0:
                _goTo(context, const home_page.TechnicianHomePage());
                break;
              case 2:
                _goTo(context, const MessagesScreen());
                break;
              case 3:
                _goTo(context, const TechnicianProfilePage());
                break;
            }
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.assignment), label: 'Job'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final BookingStatus status;
  final ColorScheme cs;
  const _StatusChip({required this.status, required this.cs});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    switch (status) {
      case BookingStatus.confirmed:
        bg = const Color(0xFFE6F5EA);
        fg = const Color(0xFF2D6B3E);
        label = 'Confirmed';
        break;
      case BookingStatus.rejected:
        bg = Colors.red.shade50;
        fg = Colors.redAccent;
        label = 'Rejected';
        break;
      default:
        bg = cs.primary.withOpacity(.12);
        fg = cs.primary;
        label = 'Pending';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

String _d2(int v) => v.toString().padLeft(2, '0');

/// booking detail page
class BookingDetailPage extends StatelessWidget {
  final Booking booking;
  const BookingDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final cs = ColorScheme.fromSeed(seedColor: const Color(0xFFF09013));
    return Theme(
      data: Theme.of(context).copyWith(colorScheme: cs, useMaterial3: true),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF8F2),
        appBar: AppBar(
          title: const Text('Booking Detail'),
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: const Color(0xFFFCEEE3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            booking.customerName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.home_repair_service_outlined, color: Colors.black54),
                        const SizedBox(width: 8),
                        Text(booking.serviceType),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, color: Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(child: Text(booking.address)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.event_available, color: Colors.black54),
                        const SizedBox(width: 8),
                        Text(
                          '${_d2(booking.dateTime.day)}/${_d2(booking.dateTime.month)}/${booking.dateTime.year} '
                          '${_d2(booking.dateTime.hour)}:${_d2(booking.dateTime.minute)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: FilledButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
