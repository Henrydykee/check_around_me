import 'package:check_around_me/data/model/business_model.dart';
import 'package:flutter/material.dart';

class AboutServiceScreen extends StatefulWidget {
  final BusinessModel businessModel;
  AboutServiceScreen({super.key, required this.businessModel});

  @override
  State<AboutServiceScreen> createState() => _AboutServiceScreenState();
}

class _AboutServiceScreenState extends State<AboutServiceScreen> {
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

            /// NAME + CATEGORY
            Text(
              business.name.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(business.category.toString()),
            ),
            const SizedBox(height: 8),

            /// RATING ROW
            Row(
              children: [
                const Text(
                  "0.0",
                  style: TextStyle(
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
                const Text("(0 reviews)"),
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

            /// ACTION BUTTONS
            Column(
              children: [
                _actionButton(Icons.star_border, "Write a review"),
                const SizedBox(height: 10),
                _actionButton(Icons.request_quote, "Request Quote", filled: true),
                const SizedBox(height: 10),
                _actionButton(Icons.share, "Share"),
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
                  _photoBox(
                      "https://images.pexels.com/photos/607812/pexels-photo-607812.jpeg"),
                  _photoBox(
                      "https://images.pexels.com/photos/106344/pexels-photo-106344.jpeg"),
                ],
              ),
            ),

            const SizedBox(height: 25),
            _sectionTitle("Services Offered"),
            const SizedBox(height: 10),
            _bulletGrid(business.services!.map((e) => e).toList()),

            const SizedBox(height: 25),
            _sectionTitle("Amenities & Details"),
            const SizedBox(height: 10),

            _amenityRow(
              icon: Icons.attach_money,
              title: "Price Range",
              value: "NGN ${business.minPrice} - NGN ${business.maxPrice}",
            ),
            _amenityRow(
              icon: Icons.credit_card,
              title: "Accepts",
              value: business.paymentOptions.toString().replaceAll("[", "").replaceAll("]", ""),
            ),

            const SizedBox(height: 25),
            _sectionTitle("About the Business"),
            const SizedBox(height: 10),
            Text(business.about.toString()),

            const SizedBox(height: 25),
            _sectionTitle("Location & Hours"),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 20),
                const SizedBox(width: 8),

                /// ADDRESS + HOURS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${business.addressLine1}"),
                      const SizedBox(height: 15),
                      ..._buildWorkingHours(), // dynamically build working hours
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            _sectionTitle("Reviews"),
            const SizedBox(height: 10),
            _reviewSummary(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String t) {
    return Text(
      t,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  /// ACTION BUTTONS
  Widget _actionButton(icon, text, {bool filled = false}) {
    return SizedBox(
      height: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: filled ? Colors.blue : Colors.white,
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
              style: TextStyle(
                  color: filled ? Colors.white : Colors.black, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// PHOTO SLIDER BOX
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

  /// SERVICES OFFERED GRID
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
  Widget _amenityRow(
      {required IconData icon, required String title, required String value}) {
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
  Widget _workingHoursRow(String day, String hours,
      {required bool isOpen, bool closed = false}) {
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
              child: const Text(
                "Open now",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          const SizedBox(width: 10),
          Text(
            hours,
            style: TextStyle(color: closed ? Colors.red : Colors.black),
          )
        ],
      ),
    );
  }

  /// Generate working hours dynamically
  List<Widget> _buildWorkingHours() {
    final now = DateTime.now();
    final currentWeekday = now.weekday; // Monday = 1, Sunday = 7

    const openHours = "09:00 - 18:00";
    const closedHours = "Closed";

    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    List<Widget> rows = [];

    for (int i = 0; i < weekdays.length; i++) {
      final day = weekdays[i];
      if (i < 6) {
        // Mon-Sat
        final isOpenNow =
            (i + 1) == currentWeekday && now.hour >= 9 && now.hour < 18;
        rows.add(_workingHoursRow(day, openHours, isOpen: isOpenNow));
      } else {
        // Sunday
        rows.add(_workingHoursRow(day, closedHours, isOpen: false, closed: true));
      }
    }
    return rows;
  }

  /// REVIEW SUMMARY COMPONENT
  Widget _reviewSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: [
          const Text(
            "0.0",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const Text("0 reviews"),
          const SizedBox(height: 15),
          Column(
            children: List.generate(
              5,
                  (i) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text("${5 - i} stars"),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
