import 'package:check_around_me/core/utils/router.dart';
import 'package:check_around_me/data/model/business_model.dart';
import 'package:check_around_me/features/services/rquest_quote_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AboutServiceScreen extends StatefulWidget {
  final BusinessModel businessModel;
  AboutServiceScreen({super.key, required this.businessModel});

  @override
  State<AboutServiceScreen> createState() => _AboutServiceScreenState();
}

class _AboutServiceScreenState extends State<AboutServiceScreen> {
  final currencyFormatter = NumberFormat.currency(locale: "en_NG", symbol: "NGN ");

  String _formatNum(num? value) {
    if (value == null) return "";
    return currencyFormatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    BusinessModel business = widget.businessModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Service Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // NAME + CATEGORY
            Text(
              business.name ?? "",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(business.category ?? ""),
            ),
            const SizedBox(height: 8),

            // RATING ROW
            Row(
              children: [
                Text(
                  (business.rating?.toStringAsFixed(1)) ?? "0.0",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: List.generate(
                    5,
                        (i) => const Icon(Icons.star_border, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                Text("(${business.reviewCount ?? 0} reviews)"),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: const [
                Text(
                  "Open 09:00 - 18:00",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ACTION BUTTONS
            Column(
              children: [
                _actionButton(
                  Icons.star_border,
                  "Write a review",
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                _actionButton(
                  Icons.request_quote,
                  "Request Quote",
                  filled: true,
                  onTap: () => _showServicePricesDialog(business),
                ),
                const SizedBox(height: 10),
                _actionButton(
                  Icons.share,
                  "Share",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 25),

            _sectionTitle("Photos & Videos"),
            const SizedBox(height: 10),

            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _photoBox("https://images.pexels.com/photos/607812/pexels-photo-607812.jpeg"),
                  _photoBox("https://images.pexels.com/photos/106344/pexels-photo-106344.jpeg"),
                ],
              ),
            ),

            const SizedBox(height: 25),
            _sectionTitle("Services Offered"),
            const SizedBox(height: 10),
            _bulletGrid(business.services ?? []),

            const SizedBox(height: 25),
            _sectionTitle("Amenities & Details"),
            const SizedBox(height: 10),

            _amenityRow(
              icon: Icons.attach_money,
              title: "Price Range",
              value: "${_formatNum(business.minPrice)} - ${_formatNum(business.maxPrice)}",
            ),
            _amenityRow(
              icon: Icons.credit_card,
              title: "Accepts",
              value: (business.paymentOptions ?? []).join(", "),
            ),

            const SizedBox(height: 25),
            _sectionTitle("About the Business"),
            const SizedBox(height: 10),
            Text(business.about ?? ""),

            const SizedBox(height: 25),
            _sectionTitle("Location & Hours"),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(business.addressLine1 ?? ""),
                      const SizedBox(height: 15),
                      ..._buildWorkingHours(),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  /// ====== REQUEST QUOTE DIALOG ======
  void _showServicePricesDialog(BusinessModel business) {
    final services = business.servicesPrices ?? {};

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Service Prices"),
          content: services.isEmpty
              ? const Text("No pricing information available.")
              : SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: services.entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    router.push(RequestQuoteScreen(
                      businessModel: business,
                      services: entry.key,
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(entry.key)),
                            Text(_formatNum(entry.value)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String t) {
    return Text(
      t,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  /// ACTION BUTTON
  Widget _actionButton(icon, text, {bool filled = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: filled ? Colors.blue.shade900 : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: filled ? Colors.white : Colors.black),
              const SizedBox(width: 5),
              Text(
                text,
                style: TextStyle(color: filled ? Colors.white : Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// PHOTO BOX
  Widget _photoBox(String img) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
      ),
    );
  }

  /// SERVICES GRID
  Widget _bulletGrid(List<String> items) {
    return Wrap(
      spacing: 20,
      runSpacing: 12,
      children: [
        for (var i in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check, size: 16, color: Colors.blue),
              const SizedBox(width: 6),
              Text(i),
            ],
          )
      ],
    );
  }

  /// AMENITY ROW
  Widget _amenityRow({required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }

  /// WORKING HOURS ROW
  Widget _workingHoursRow(String day, String hours, {required bool isOpen, bool closed = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(day)),
          if (isOpen)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text("Open now", style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          const SizedBox(width: 10),
          Text(hours, style: TextStyle(color: closed ? Colors.red : Colors.black)),
        ],
      ),
    );
  }

  /// BUILD WORKING HOURS
  List<Widget> _buildWorkingHours() {
    final now = DateTime.now();
    final currentWeekday = now.weekday;
    const openHours = "09:00 - 18:00";
    const closedHours = "Closed";
    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    List<Widget> rows = [];

    for (int i = 0; i < weekdays.length; i++) {
      final day = weekdays[i];
      if (i < 6) {
        final isOpenNow = (i + 1) == currentWeekday && now.hour >= 9 && now.hour < 18;
        rows.add(_workingHoursRow(day, openHours, isOpen: isOpenNow));
      } else {
        rows.add(_workingHoursRow(day, closedHours, isOpen: false, closed: true));
      }
    }
    return rows;
  }

}
