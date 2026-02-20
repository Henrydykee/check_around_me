import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/vm/provider_initilizers.dart';
import 'package:check_around_me/core/vm/provider_view_model.dart';
import 'package:check_around_me/data/model/popular_category_response.dart';
import 'package:check_around_me/features/services/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/router.dart';
import '../../vm/auth_provider.dart';
import '../../vm/business_provider.dart';

class PopularCategoriesScreen extends StatelessWidget {
  const PopularCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      viewModel: inject<BusinessProvider>(),
      onModelReady: (vm) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          vm.getPopularCategories();
          context.read<AuthProvider>().getCurrentUser();
        });
      },
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: AppTheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppTheme.onSurface),
              onPressed: () => router.pop(),
            ),
            title: const Text(
              "Popular Categories",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            centerTitle: true,
          ),
          body: vm.isLoading && vm.popularCategoryList.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
              : vm.error != null && vm.popularCategoryList.isEmpty
                  ? _buildError(context, vm)
                  : RefreshIndicator(
                      onRefresh: () => vm.getPopularCategories(),
                      child: vm.popularCategoryList.isEmpty
                          ? _buildEmpty(context)
                          : ListView.separated(
                              padding: const EdgeInsets.all(20),
                              itemCount: vm.popularCategoryList.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, i) {
                                final category = vm.popularCategoryList[i];
                                return _PopularCategoryListCard(
                                  category: category,
                                  onTap: () => router.push(
                                    SearchScreen(filter: category.name ?? ''),
                                  ),
                                );
                              },
                            ),
                    ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, BusinessProvider vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppTheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              vm.error?.message ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => vm.getPopularCategories(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 80),
        Icon(Icons.category_outlined, size: 64, color: AppTheme.onSurfaceVariant.withOpacity(0.6)),
        const SizedBox(height: 16),
        Text(
          'No popular categories yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _PopularCategoryListCard extends StatelessWidget {
  final PopularCategoryResponse category;
  final VoidCallback onTap;

  const _PopularCategoryListCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final count = category.businessCount ?? 0;
    final countLabel = count == 1 ? '1 business' : '$count businesses';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.borderRadiusLg,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.borderRadiusLg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppTheme.borderRadiusMd,
                child: Image.network(
                  category.imageUrl ?? '',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.category_outlined,
                    size: 32,
                    color: AppTheme.primary.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      countLabel,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppTheme.onSurfaceVariant, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
