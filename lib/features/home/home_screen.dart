import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/utils/app_config.dart';
import 'package:check_around_me/features/services/about_service_screen.dart';
import 'package:check_around_me/vm/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/router.dart';
import '../../core/vm/provider_initilizers.dart';
import '../../core/vm/provider_view_model.dart';
import '../../core/widget/category_chip_component.dart';
import '../../core/widget/service_card.dart';
import '../../vm/business_provider.dart';
import '../../vm/notification_provider.dart';
import '../account/notifications_screen.dart';
import 'popular_categories_screen.dart';
import '../services/search_screen.dart';

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      viewModel: inject<BusinessProvider>(),
      onModelReady: (vm) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          vm.getCategory();
          vm.getBusinesses();
          context.read<AuthProvider>().getCurrentUser();
          context.read<NotificationProvider>().getNotifications();
        });
      },
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: AppTheme.surface,
          body: RefreshIndicator(
            onRefresh: () async {
              await vm.getCategory();
              await vm.getBusinesses();
              context.read<AuthProvider>().getCurrentUser();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 56),
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, auth, _) {
                            final name = auth.userModel?.name?.trim();
                            final greeting = _greeting();
                            return Text(
                              name != null && name.isNotEmpty
                                  ? '$greeting, $name'
                                  : greeting,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppTheme.onSurface,
                              ),
                            );
                          },
                        ),
                      ),
                      Consumer<NotificationProvider>(
                        builder: (context, notificationVm, _) {
                          final count = notificationVm.unreadCount;
                          return IconButton(
                            onPressed: () => router.push(const NotificationsScreen()),
                            icon: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.notifications_outlined,
                                  color: AppTheme.onSurface,
                                  size: 26,
                                ),
                                if (count > 0)
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        count > 99 ? '99+' : '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Browse by category",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppTheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Quickly find trusted local pros across popular services near you.",
                    style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 16),

                  // Categories in rounded section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppTheme.borderRadiusXl,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 120,
                      child: vm.categoryList.isEmpty
                          ? Center(child: Text("No categories found", style: TextStyle(color: AppTheme.onSurfaceVariant)))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: vm.categoryList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (c, i) {
                                final category = vm.categoryList[i];
                                return CategoryChip(
                                  title: category.name ?? "",
                                  subtitle: category.description ?? "",
                                  imageUrl: category.imageUrl ?? "",
                                  onTap: () {
                                    router.push(SearchScreen(filter: category.name ?? ""));
                                  },
                                );
                              },
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Popular Categories section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppTheme.borderRadiusXl,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Popular Categories",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Most requested categories based on local demand.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.onSurfaceVariant,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => router.push(const PopularCategoriesScreen()),
                              label: Text(
                                "View All",
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 72,
                          child: vm.categoryList.isEmpty
                              ? Center(
                                  child: Text(
                                    "No categories found",
                                    style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
                                  ),
                                )
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: vm.categoryList.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                                  itemBuilder: (context, i) {
                                    final category = vm.categoryList[i];
                                    return _PopularCategoryCard(
                                      name: category.name ?? "",
                                      imageUrl: category.imageUrl ?? "",
                                      onTap: () =>
                                          router.push(SearchScreen(filter: category.name ?? "")),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppTheme.borderRadiusXl,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Popular Near You",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.onSurface),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "View All",
                                style: TextStyle(color: AppTheme.primary, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: vm.businessList.length > 5 ? 5 : vm.businessList.length,
                            itemBuilder: (c, i) {
                              final business = vm.businessList[i];
                              return ServiceCard(
                                imageUrl: AppConfig.businessPrimaryImageUrl(business.id ?? ''),
                                title: business.name.toString(),
                                location: business.addressLine1.toString(),
                                category: business.category.toString(),
                                description: business.about.toString(),
                                rating: 0,
                                onTap: () {
                                  router.push(AboutServiceScreen(businessModel: business));
                                },
                              );
                            },
                          ),
                        ),
                      ],
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

/// Horizontal card: small rounded image on left, category name on right.
class _PopularCategoryCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  const _PopularCategoryCard({
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.borderRadiusMd,
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.borderRadiusMd,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppTheme.borderRadiusSm,
                child: Image.network(
                  imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.category_outlined,
                    size: 28,
                    color: AppTheme.primary.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
