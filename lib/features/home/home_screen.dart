import 'package:flutter/material.dart';
import '../../core/widget/category_chip_component.dart';
import '../../core/widget/service_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text("Home", style: TextStyle(fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// Browse by Category
            Text("Browse by category",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                "Quickly find trusted local pros across popular services near you.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryChip(
                    title: "Personal Trainer",
                    subtitle: "Guided fitness",
                    imageUrl:
                    "https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg",
                    onTap: () {},
                  ),
                  const SizedBox(width: 20),
                  CategoryChip(
                    title: "Furniture",
                    subtitle: "Carpentry",
                    imageUrl:
                    "https://images.pexels.com/photos/279645/pexels-photo-279645.jpeg",
                    onTap: () {},
                  ),
                  const SizedBox(width: 20),
                  CategoryChip(
                    title: "Barbers",
                    subtitle: "Hairdresser",
                    imageUrl:
                    "https://images.pexels.com/photos/3992878/pexels-photo-3992878.jpeg",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// Services Near You
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Services Near You",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("View All", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "No services found",
                  style:
                  TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Popular Near You
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Popular Near You",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("View All", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ServiceCard(
                    imageUrl:
                    "https://images.pexels.com/photos/607812/pexels-photo-607812.jpeg",
                    title: "Demo Business",
                    location: "Benin City, Edo",
                    category: "IT Support",
                    description: "My business",
                    rating: 0,
                    onTap: () {},
                  ),
                  ServiceCard(
                    imageUrl:
                    "https://images.pexels.com/photos/3184431/pexels-photo-3184431.jpeg",
                    title: "Fola Consultants",
                    location: "Lagos, Nigeria",
                    category: "Consulting",
                    description: "We help businesses grow",
                    rating: 0,
                    onTap: () {},
                  ),
                  ServiceCard(
                    imageUrl:
                    "https://images.pexels.com/photos/169190/pexels-photo-169190.jpeg",
                    title: "Fav Events",
                    location: "Benin City, Edo",
                    category: "Event Planner",
                    description: "We plan your events.",
                    rating: 0,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
