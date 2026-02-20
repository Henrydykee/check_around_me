import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/utils/app_config.dart';
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
          backgroundColor: AppTheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: widget.filter.isEmpty ? false : true,
            centerTitle: true,
            title: const Text("Search", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppTheme.borderRadiusPill,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: controller,
                      style: TextStyle(fontSize: 15, color: AppTheme.onSurface),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        hintText: "Search for a service or provider...",
                        hintStyle: TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 15,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          child: Icon(Icons.search, color: AppTheme.onSurfaceVariant, size: 22),
                        ),
                        prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
                        isDense: true,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, i) {
                      final f = vm.categoryList[i];
                      final isActive = f.name == activeFilter;
                      return ChoiceChip(
                        label: Text(
                          f.name.toString(),
                          style: TextStyle(
                            color: isActive ? Colors.white : AppTheme.onSurface,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        selected: isActive,
                        backgroundColor: Colors.white,
                        selectedColor: AppTheme.primary,
                        side: BorderSide(color: isActive ? AppTheme.primary : Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusPill),
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
                              imageUrl: AppConfig.businessPrimaryImageUrl(b.id ?? ''),
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
