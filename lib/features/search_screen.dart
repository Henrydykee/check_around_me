import 'package:flutter/material.dart';
import '../core/widget/service_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  final List<String> filters = [
    "Cleaner",
    "Electrician",
    "Plumber",
    "Mechanic",
    "Painter",
    "Photographer",
    "Event Planner",
    "Handyman",
    "Barber",
  ];

  String activeFilter = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Search", style: TextStyle(fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),

            /// Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search for a service or provider...",
                    icon: Icon(Icons.search),
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// Filter Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, i) {
                  final f = filters[i];
                  final isActive = f == activeFilter;

                  return ChoiceChip(
                    label: Text(f),
                    selected: isActive,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    selectedColor: Colors.blue.shade100,
                    onSelected: (_) {
                      setState(() => activeFilter = isActive ? "" : f);
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemCount: filters.length,
              ),
            ),

            const SizedBox(height: 20),

            /// Search Results
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmall =
                      constraints.maxWidth < 380; // Tighter spacing on small phones

                  return Wrap(
                    runSpacing: 20,
                    spacing: isSmall ? 12 : 16,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth / 2 - (isSmall ? 12 : 16),
                        child: ServiceCard(
                          imageUrl:
                          "https://images.pexels.com/photos/607812/pexels-photo-607812.jpeg",
                          title: "Demo Business",
                          location: "Benin City, Edo",
                          category: "IT Support",
                          description: "My Business",
                          rating: 0,
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth / 2 - (isSmall ? 12 : 16),
                        child: ServiceCard(
                          imageUrl:
                          "https://images.pexels.com/photos/393149/pexels-photo-393149.jpeg",
                          title: "G ba",
                          location: "Twon Brass, Bayelsa",
                          category: "Cleaner",
                          description: "Checking acct",
                          rating: 0,
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth / 2 - (isSmall ? 12 : 16),
                        child: ServiceCard(
                          imageUrl:
                          "https://cdn-icons-png.flaticon.com/512/2748/2748558.png",
                          title: "Esther",
                          location: "Alafia Crescent",
                          category: "Barbers & Hairdresser",
                          description: "I'm an hairstylist",
                          rating: 0,
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth / 2 - (isSmall ? 12 : 16),
                        child: ServiceCard(
                          imageUrl:
                          "https://images.pexels.com/photos/585804/pexels-photo-585804.jpeg",
                          title: "Link Cars",
                          location: "Ifo, Ogun State",
                          category: "Car Rentals",
                          description: "Vehicle rentals",
                          rating: 0,
                          onTap: () {},
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
