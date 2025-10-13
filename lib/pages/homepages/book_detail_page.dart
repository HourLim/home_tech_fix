import 'package:hometechfix/pages/history_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailPage extends StatefulWidget {
  const BookingDetailPage({
    super.key,
    required this.vendorName,
    required this.serviceTitle,
    required this.unitPrice,
    required this.imageUrl,
    this.baseAddress = 'Home',
  });

  final String vendorName;
  final String serviceTitle;
  final double unitPrice;
  final String imageUrl; 
  final String baseAddress;

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  final _otherLocationCtrl = TextEditingController();

  // Location — per request: only Home and Other
  final List<String> _locations = ['Home', 'Other'];
  String? _selectedLocation;

  // Date & time
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  // Quantity
  int _qty = 1;

  // VAT removed

  @override
  void initState() {
    super.initState();
    _selectedLocation =
        _locations.contains(widget.baseAddress) ? widget.baseAddress : 'Home';
  }

  double get _subTotal => widget.unitPrice * _qty;
  double get _total => _subTotal;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(now) ? now : _selectedDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // Build a booking map that matches your sample in history_page.dart
  Map<String, dynamic> _buildBookingPayload() {
    final ddMMyyyy = DateFormat('dd/MM/yyyy').format(_selectedDate);
    final time12h = _formatTime(_selectedTime);
    final chosenLocation = _selectedLocation == 'Other'
        ? _otherLocationCtrl.text.trim()
        : _selectedLocation;

    return {
      "shop": widget.vendorName,
      "date": ddMMyyyy,                // e.g., 26/08/2025
      "time": time12h,                 // e.g., 3:20 PM
      "status": "In progress",         // default for new bookings
      "device": widget.serviceTitle,   // map service title to 'device' field in sample
      "technician": "",                // unknown at booking time
      "address": chosenLocation ?? "Home",
      "services": [
        {"name": widget.serviceTitle, "price": widget.unitPrice},
      ],
      // Totals (VAT removed)
      "subtotal": _subTotal,
      "total": _total,
      "qty": _qty,
      "imageUrl": widget.imageUrl,
    };
  }

  void _confirmBooking() {
    final booking = _buildBookingPayload();

    // Navigate to HistoryScreen and pass the new booking.
    // In your HistoryScreen, read:
    // final args = ModalRoute.of(context)?.settings.arguments as Map?;
    // if (args?['newBooking'] != null) { /* insert to top */ }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const HistoryScreen(),
        settings: RouteSettings(arguments: {"newBooking": booking}),
      ),
    );
  }

  @override
  void dispose() {
    _otherLocationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6E40),
        foregroundColor: Colors.white,
        title: const Text('My Booking'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Location
          Text('Location',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: _decor('Choose location'),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLocation,
                isExpanded: true,
                items: _locations
                    .map((loc) =>
                        DropdownMenuItem(value: loc, child: Text(loc)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedLocation = val),
              ),
            ),
          ),
          if (_selectedLocation == 'Other') ...[
            const SizedBox(height: 10),
            TextField(
              controller: _otherLocationCtrl,
              decoration: _decor('Type new location'),
              textInputAction: TextInputAction.done,
            ),
          ],
          const SizedBox(height: 20),

          // Schedule
          Text('Schedule',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _pickerTile(
                  label: 'Date',
                  value:
                      DateFormat('EEE, MMM d, yyyy').format(_selectedDate),
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _pickerTile(
                  label: 'Time',
                  value: _formatTime(_selectedTime),
                  onTap: _pickTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Vendor & service
          _vendorCard(theme, currency),
          const SizedBox(height: 16),

          // Summary
          _summaryRow('Total', currency.format(_total), emphasize: true),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, -1),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Total: ${currency.format(_total)}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6E40),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  onPressed: _confirmBooking,
                  child: const Text('Confirm Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UI helpers
  InputDecoration _decor(String hint) => InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFFFF6E40)),
        ),
      );

  Widget _pickerTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 6),
            Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _vendorCard(ThemeData theme, NumberFormat currency) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: (widget.imageUrl.startsWith('http') ||
                        widget.imageUrl.startsWith('https'))
                    ? Image.network(
                        widget.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.black12,
                          child: const Icon(Icons.image, size: 28),
                        ),
                      )
                    : Image.asset(
                        widget.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(widget.vendorName,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(widget.serviceTitle,
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Row(
                children: [
                  _qtyButton(
                      icon: Icons.remove,
                      onTap: () => setState(
                          () => _qty = (_qty > 1) ? _qty - 1 : 1)),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('$_qty',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700)),
                  ),
                  _qtyButton(
                      icon: Icons.add,
                      onTap: () => setState(() => _qty += 1)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Spacer(),
              Text(currency.format(widget.unitPrice),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  Widget _summaryRow(String k, String v, {bool emphasize = false}) {
    return Row(
      children: [
        Expanded(
            child: Text(k,
                style: const TextStyle(fontWeight: FontWeight.w600))),
        Text(
          v,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: emphasize ? const Color(0xFFE53935) : null,
          ),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay t) {
    final hour12 = (t.hour % 12 == 0) ? 12 : t.hour % 12;
    final period = t.period == DayPeriod.am ? "AM" : "PM";
    return "$hour12:${t.minute.toString().padLeft(2, '0')} $period";
  }
}
