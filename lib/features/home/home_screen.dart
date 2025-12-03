import 'package:check_around_me/features/about_service_screen.dart';
import 'package:check_around_me/features/search_screen.dart';
import 'package:flutter/material.dart';

import '../../core/utils/router.dart';
import '../../core/vm/provider_initilizers.dart';
import '../../core/vm/provider_view_model.dart';
import '../../core/widget/category_chip_component.dart';
import '../../core/widget/service_card.dart';
import '../../vm/business_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      viewModel: inject<BusinessProvider>(),
      onModelReady: (vm) {
        vm.getCategory();
        vm.getBusinesses();
      },
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: RefreshIndicator(
            onRefresh: () async {
              await vm.getCategory();
              await vm.getBusinesses();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // required for RefreshIndicator
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  const Text(
                    "Browse by category",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Quickly find trusted local pros across popular services near you.",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 10),

                  // Categories horizontal list
                  SizedBox(
                    height: 120,
                    child: vm.categoryList.isEmpty
                        ? Center(child: Text("No categories found"))
                        : ListView.builder(
                      itemCount: vm.categoryList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (c, i) {
                        final category = vm.categoryList[i];
                        return CategoryChip(
                          title: category.name ?? "",
                          subtitle: category.description ?? "",
                          imageUrl: category.imageUrl ?? "",
                          onTap: () {
                            router.push(SearchScreen(
                              filter: category.name ?? "",
                            ));
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  Divider(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Services Near You",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "View All",
                          style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            "No services found",
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Check back soon for new services",
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Divider(),
                  const SizedBox(height: 20),

                  /// Popular Near You Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Popular Near You",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "View All",
                          style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Services horizontal list
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: vm.businessList.length > 5 ? 5 : vm.businessList.length,
                      itemBuilder: (c,i){
                        final business = vm.businessList[i];
                       return ServiceCard(
                          imageUrl: "https://images.pexels.com/photos/607812/pexels-photo-607812.jpeg",
                          title: business.name.toString(),
                          location: business.addressLine1.toString(),
                          category: business.category.toString(),
                          description: business.about.toString(),
                          rating: 0,
                          onTap: () {
                            router.push(AboutServiceScreen(
                              businessModel: business,
                            ));
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
