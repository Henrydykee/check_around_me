import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/utils/app_config.dart';
import 'package:check_around_me/core/vm/provider_initilizers.dart';
import 'package:check_around_me/core/vm/provider_view_model.dart';
import 'package:check_around_me/vm/business_provider.dart';
import 'package:flutter/material.dart';
import '../../core/utils/router.dart';
import '../../core/widget/service_card.dart';
import 'about_service_screen.dart';

class SearchFilter {
  final String location;
  final double? minPrice;
  final double? maxPrice;

  const SearchFilter({
    this.location = '',
    this.minPrice,
    this.maxPrice,
  });

  bool get hasActive =>
      location.trim().isNotEmpty || minPrice != null || maxPrice != null;
}

class SearchScreen extends StatefulWidget {
  final String filter;
  const SearchScreen({super.key, this.filter = ""});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();
  late String activeFilter;
  SearchFilter filter = const SearchFilter();

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
        // Filtered business list based on search text, active category, and advanced filters
        final filteredList = vm.businessList.where((b) {
          final matchesCategory = activeFilter.isEmpty || b.category.toString() == activeFilter;
          final matchesSearch =
              controller.text.isEmpty || b.name.toString().toLowerCase().contains(controller.text.toLowerCase()) || b.about.toString().toLowerCase().contains(controller.text.toLowerCase());
          final locationText = (b.addressLine1 ?? '').toString().toLowerCase();
          final matchesLocation = filter.location.trim().isEmpty ||
              locationText.contains(filter.location.trim().toLowerCase());

          bool matchesPrice = true;
          final minBusinessPrice = b.minPrice is num ? (b.minPrice as num).toDouble() : null;
          final maxBusinessPrice = b.maxPrice is num ? (b.maxPrice as num).toDouble() : null;
          final representativePrice = minBusinessPrice ?? maxBusinessPrice;

          if (filter.minPrice != null && representativePrice != null) {
            matchesPrice = representativePrice >= filter.minPrice!;
          }
          if (matchesPrice && filter.maxPrice != null && representativePrice != null) {
            matchesPrice = representativePrice <= filter.maxPrice!;
          }

          return matchesCategory && matchesSearch && matchesLocation && matchesPrice;
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
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _openFilterSheet,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: filter.hasActive ? AppTheme.primary : AppTheme.surfaceVariant,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppTheme.borderRadiusPill,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        icon: Icon(
                          Icons.filter_list_rounded,
                          size: 18,
                          color: filter.hasActive ? AppTheme.primary : AppTheme.onSurfaceVariant,
                        ),
                        label: Text(
                          filter.hasActive ? "Filters applied" : "Filters",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: filter.hasActive ? AppTheme.primary : AppTheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (filter.hasActive)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              filter = const SearchFilter();
                            });
                          },
                          child: const Text(
                            "Clear",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
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

  Future<void> _openFilterSheet() async {
    final locationController = TextEditingController(text: filter.location);
    final minPriceController =
        TextEditingController(text: filter.minPrice?.toString() ?? '');
    final maxPriceController =
        TextEditingController(text: filter.maxPrice?.toString() ?? '');

    final result = await showModalBottomSheet<SearchFilter>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Filters",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Location",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "City or area",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: AppTheme.borderRadiusSm,
                    borderSide: BorderSide(color: AppTheme.surfaceVariant),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Price range",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: minPriceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: "Min",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: AppTheme.borderRadiusSm,
                          borderSide:
                              BorderSide(color: AppTheme.surfaceVariant),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: maxPriceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: "Max",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: AppTheme.borderRadiusSm,
                          borderSide:
                              BorderSide(color: AppTheme.surfaceVariant),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        ctx,
                        const SearchFilter(),
                      );
                    },
                    child: const Text(
                      "Clear filters",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      double? parse(String text) {
                        if (text.trim().isEmpty) return null;
                        return double.tryParse(text.trim());
                      }

                      Navigator.pop(
                        ctx,
                        SearchFilter(
                          location: locationController.text.trim(),
                          minPrice: parse(minPriceController.text),
                          maxPrice: parse(maxPriceController.text),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.borderRadiusMd,
                      ),
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        filter = result;
      });
    }
  }
}
