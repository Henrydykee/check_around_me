import 'package:check_around_me/core/vm/provider_initilizers.dart';
import 'package:check_around_me/core/vm/provider_view_model.dart';
import 'package:check_around_me/vm/business_provider.dart';
import 'package:flutter/material.dart';
import '../../core/utils/router.dart';
import '../../core/widget/service_card.dart';
import 'about_service_screen.dart';

class SearchScreen extends StatefulWidget {
  final String filter;
  const SearchScreen({super.key, this.filter = ""});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();
  late String activeFilter;

  @override
  void initState() {
    super.initState();
    activeFilter = widget.filter; // Initialize here
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      viewModel: inject<BusinessProvider>(),
      builder: (context, vm, child) {
        // Filtered business list based on search text and active category
        final filteredList = vm.businessList.where((b) {
          final matchesCategory = activeFilter.isEmpty || b.category.toString() == activeFilter;
          final matchesSearch =
              controller.text.isEmpty || b.name.toString().toLowerCase().contains(controller.text.toLowerCase()) || b.about.toString().toLowerCase().contains(controller.text.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            automaticallyImplyLeading: widget.filter.isEmpty ? false : true,
            centerTitle: true,
            title: const Text("Search", style: TextStyle(fontSize: 20)),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(40)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: "Search for a service or provider...", icon: Icon(Icons.search)),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, i) {
                      final f = vm.categoryList[i];
                      final isActive = f.name == activeFilter;
                      return ChoiceChip(
                        label: Text(
                          f.name.toString(),
                          style: TextStyle(color: isActive ? Colors.white : Colors.black, fontWeight: FontWeight.w500),
                        ),
                        selected: isActive,
                        backgroundColor: Colors.white,
                        selectedColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onSelected: (_) {
                          setState(() => activeFilter = isActive ? "" : f.name.toString());
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemCount: vm.categoryList.length,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: filteredList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              activeFilter.isEmpty ? "No services found." : "No services found for the category \"$activeFilter\"",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 16, childAspectRatio: 0.59),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final b = filteredList[index];
                            return ServiceCard(
                              imageUrl: "https://beta.checkaroundme.com/api/v1/businesses/${b.id}/images/primary",
                              title: b.name.toString(),
                              location: b.addressLine1.toString(),
                              category: b.category.toString(),
                              description: b.about.toString(),
                              rating: 0,
                              onTap: () {
                                router.push(AboutServiceScreen(businessModel: b));
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
