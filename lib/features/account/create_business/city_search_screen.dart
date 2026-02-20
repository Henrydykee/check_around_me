import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/router.dart';
import '../../../data/model/country_state_city.dart';

/// Searchable list of cities. Pops with [CityModel] on selection.
class CitySearchScreen extends StatefulWidget {
  final List<CityModel> cities;

  const CitySearchScreen({super.key, required this.cities});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final _searchController = TextEditingController();
  late List<CityModel> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = List.from(widget.cities);
  }

  void _onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.from(widget.cities);
      } else {
        _filtered = widget.cities.where((c) => c.name.toLowerCase().contains(q)).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: AppTheme.onSurface, size: 28),
          onPressed: () => router.pop(),
        ),
        title: Text(
          'Select city',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search cities...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: AppTheme.borderRadiusMd),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      'No cities match your search',
                      style: TextStyle(color: AppTheme.onSurfaceVariant),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final c = _filtered[index];
                      return ListTile(
                        title: Text(c.name),
                        onTap: () => router.pop(c),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
