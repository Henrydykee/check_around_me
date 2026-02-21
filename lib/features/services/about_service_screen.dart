import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/utils/app_config.dart';
import 'package:check_around_me/core/utils/router.dart';
import 'package:check_around_me/data/model/business_model.dart';
import 'package:check_around_me/data/model/review_model.dart';
import 'package:check_around_me/features/services/rquest_quote_screen.dart';
import 'package:check_around_me/features/services/write_review_screen.dart';
import 'package:check_around_me/vm/business_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class AboutServiceScreen extends StatefulWidget {
  final BusinessModel businessModel;
  AboutServiceScreen({super.key, required this.businessModel});

  @override
  State<AboutServiceScreen> createState() => _AboutServiceScreenState();
}

class _AboutServiceScreenState extends State<AboutServiceScreen> {
  final currencyFormatter = NumberFormat.currency(locale: "en_NG", symbol: "NGN ");

  List<ReviewModel>? _reviews;
  int? _reviewsTotal;
  bool _loadingReviews = false;
  String? _reviewsError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReviews());
  }

  Future<void> _loadReviews() async {
    final businessId = widget.businessModel.id;
    if (businessId == null || businessId.isEmpty) return;
    if (!mounted) return;
    final vm = context.read<BusinessProvider>();
    setState(() {
      _loadingReviews = true;
      _reviewsError = null;
    });
    final result = await vm.getBusinessReviews(businessId);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loadingReviews = false;
        _reviewsError = failure.message;
        _reviews = null;
        _reviewsTotal = null;
      }),
      (response) => setState(() {
        _loadingReviews = false;
        _reviewsError = null;
        _reviews = response.reviews ?? [];
        _reviewsTotal = response.total;
      }),
    );
  }

  String _formatNum(num? value) {
    if (value == null) return "";
    return currencyFormatter.format(value);
  }

  Future<void> _shareBusiness(BusinessModel business) async {
    final name = business.name ?? "This place";
    final category = business.category;
    final list = _reviews ?? [];
    double ratingValue;
    if (list.isNotEmpty) {
      final sum = list.fold<int>(0, (s, r) => s + (r.rating ?? 0));
      ratingValue = sum / list.length;
    } else {
      ratingValue = (business.rating ?? 0).toDouble();
    }
    final rating = ratingValue.toStringAsFixed(1);
    final parts = <String>[name];
    if (category != null && category.isNotEmpty) parts.add("($category)");
    parts.add("— $rating★ on Check Around Me.");
    final text = parts.join(" ");
    await Share.share(
      text,
      subject: "Check out $name",
    );
  }

  @override
  Widget build(BuildContext context) {
    BusinessModel business = widget.businessModel;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        foregroundColor: AppTheme.onSurface,
        title: const Text("Service Details", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image
            _buildHeaderImage(business),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    business.name ?? "",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if ((business.category ?? "").isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      ),
                      child: Text(
                        business.category!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  _buildRatingRow(business),
                  const SizedBox(height: 8),
                  _buildOpenStatusRow(),
                  const SizedBox(height: 20),

                  // ACTION BUTTONS
                  Column(
                    children: [
                      _actionButton(
                        Icons.star_border,
                        "Write a review",
                        onTap: () async {
                        final refreshed = await router.push(WriteReviewScreen(businessModel: business));
                        if (mounted && refreshed == true) _loadReviews();
                      },
                      ),
                      const SizedBox(height: 10),
                      _actionButton(
                        Icons.request_quote,
                        "Request Quote",
                        filled: true,
                        onTap: () => _showServicePricesDialog(business),
                      ),
                      const SizedBox(height: 10),
                      _actionButton(
                        Icons.share,
                        "Share",
                        onTap: () => _shareBusiness(business),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  _sectionTitle("Photos & Videos"),
                  const SizedBox(height: 12),
                  _buildPhotosSection(business),
                  const SizedBox(height: 28),
                  _sectionTitle("Services Offered"),
                  const SizedBox(height: 12),
                  _bulletGrid(business.services ?? []),

                  const SizedBox(height: 28),
                  _sectionTitle("Amenities & Details"),
                  const SizedBox(height: 12),
                  _amenityRow(
                    icon: Icons.attach_money,
                    title: "Price Range",
                    value: _formatPriceRange(business.minPrice, business.maxPrice),
                  ),
                  _amenityRow(
                    icon: Icons.credit_card,
                    title: "Accepts",
                    value: (business.paymentOptions ?? []).isEmpty
                        ? "—"
                        : (business.paymentOptions!.join(", ")),
                  ),

                  const SizedBox(height: 28),
                  _sectionTitle("About the Business"),
                  const SizedBox(height: 12),
                  Text(
                    business.about ?? "No description available.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 28),
                  _sectionTitle("Reviews"),
                  const SizedBox(height: 12),
                  _buildReviewsSection(),

                  const SizedBox(height: 28),
                  _sectionTitle("Location & Hours"),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, size: 20, color: AppTheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              business.addressLine1 ?? "Address not set",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ..._buildWorkingHours(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(BusinessModel business) {
    final imageUrl = (business.id ?? "").isEmpty
        ? null
        : AppConfig.businessPrimaryImageUrl(business.id!);
    return Container(
      width: double.infinity,
      height: 200,
      color: AppTheme.surfaceVariant,
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _headerPlaceholder(),
            )
          : _headerPlaceholder(),
    );
  }

  Widget _headerPlaceholder() {
    return Center(
      child: Icon(Icons.store_outlined, size: 64, color: AppTheme.onSurfaceVariant.withOpacity(0.5)),
    );
  }

  Widget _buildRatingRow(BusinessModel business) {
    double rating;
    final list = _reviews ?? [];
    if (list.isNotEmpty) {
      final sum = list.fold<int>(0, (s, r) => s + (r.rating ?? 0));
      rating = sum / list.length;
    } else {
      rating = (business.rating ?? 0).toDouble();
    }
    final reviewCount = _reviewsTotal ?? business.reviewCount ?? 0;
    final filled = rating.floor().clamp(0, 5);
    final hasHalf = rating - filled >= 0.25;
    return Row(
      children: [
        ...List.generate(filled, (_) => Icon(Icons.star, size: 18, color: Colors.amber.shade700)),
        if (hasHalf) Icon(Icons.star_half, size: 18, color: Colors.amber.shade700),
        ...List.generate(5 - filled - (hasHalf ? 1 : 0), (_) => Icon(Icons.star_border, size: 18, color: Colors.amber.shade700)),
        const SizedBox(width: 8),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "($reviewCount reviews)",
          style: TextStyle(fontSize: 14, color: AppTheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildOpenStatusRow() {
    final now = DateTime.now();
    final weekday = now.weekday;
    final isWeekday = weekday >= 1 && weekday <= 6;
    final isOpenNow = isWeekday && now.hour >= 9 && now.hour < 18;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isOpenNow ? Colors.green.shade50 : AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          ),
          child: Text(
            isOpenNow ? "Open now" : (isWeekday ? "Opens 09:00" : "Closed today"),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isOpenNow ? Colors.green.shade700 : AppTheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    if (_loadingReviews) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_reviewsError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          _reviewsError!,
          style: TextStyle(fontSize: 14, color: AppTheme.onSurfaceVariant),
        ),
      );
    }
    final list = _reviews ?? [];
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          "No reviews yet.",
          style: TextStyle(fontSize: 14, color: AppTheme.onSurfaceVariant),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list.map((r) => _buildReviewCard(r)).toList(),
    );
  }

  Widget _buildReviewCard(ReviewModel r) {
    final rating = (r.rating ?? 0).toDouble();
    final filled = rating.floor().clamp(0, 5);
    final hasHalf = rating - filled >= 0.25;
    DateTime? date;
    if (r.createdAt != null && r.createdAt!.isNotEmpty) {
      date = DateTime.tryParse(r.createdAt!);
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: AppTheme.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(filled, (_) => Icon(Icons.star, size: 16, color: Colors.amber.shade700)),
              if (hasHalf) Icon(Icons.star_half, size: 16, color: Colors.amber.shade700),
              ...List.generate(5 - filled - (hasHalf ? 1 : 0), (_) => Icon(Icons.star_border, size: 16, color: Colors.amber.shade700)),
              if (date != null) ...[
                const SizedBox(width: 8),
                Text(
                  DateFormat.yMMMd().format(date),
                  style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
          if ((r.title ?? "").isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              r.title!,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
            ),
          ],
          if ((r.text ?? "").isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              r.text!,
              style: TextStyle(fontSize: 14, height: 1.4, color: AppTheme.onSurfaceVariant),
            ),
          ],
          if ((r.recommendation ?? "").isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              r.recommendation!,
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: AppTheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }

  String _formatPriceRange(num? min, num? max) {
    final a = _formatNum(min);
    final b = _formatNum(max);
    if (a.isEmpty && b.isEmpty) return "—";
    if (a.isEmpty) return "Up to $b";
    if (b.isEmpty) return "From $a";
    return "$a – $b";
  }

  Widget _buildPhotosSection(BusinessModel business) {
    final primaryUrl = (business.id ?? "").isEmpty
        ? null
        : AppConfig.businessPrimaryImageUrl(business.id!);
    final urls = <String>[
      if (primaryUrl != null) primaryUrl,
      "https://images.pexels.com/photos/607812/pexels-photo-607812.jpeg",
      "https://images.pexels.com/photos/106344/pexels-photo-106344.jpeg",
    ].take(3).toList();
    if (urls.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            "No photos yet",
            style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
          ),
        ),
      );
    }
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: urls.map((url) => _photoBox(url)).toList(),
      ),
    );
  }

  /// ====== REQUEST QUOTE DIALOG ======
  void _showServicePricesDialog(BusinessModel business) {
    final services = business.servicesPrices ?? {};

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusLg),
          title: const Text("Service Prices", style: TextStyle(color: AppTheme.onSurface)),
          content: services.isEmpty
              ? Text(
                  "No pricing information available.",
                  style: TextStyle(color: AppTheme.onSurfaceVariant),
                )
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    children: services.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              router.push(RequestQuoteScreen(
                                businessModel: business,
                                services: entry.key,
                              ));
                            },
                            borderRadius: AppTheme.borderRadiusMd,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceVariant,
                                borderRadius: AppTheme.borderRadiusMd,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _formatNum(entry.value),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        );
      },
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String t) {
    return Text(
      t,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppTheme.onSurface,
      ),
    );
  }

  /// ACTION BUTTON
  Widget _actionButton(IconData icon, String text, {bool filled = false, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.borderRadiusMd,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: filled ? AppTheme.primary : Colors.white,
            borderRadius: AppTheme.borderRadiusMd,
            border: Border.all(
              color: filled ? AppTheme.primary : AppTheme.onSurfaceVariant.withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: filled ? Colors.white : AppTheme.onSurface),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: filled ? Colors.white : AppTheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// PHOTO BOX
  Widget _photoBox(String img) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        img,
        fit: BoxFit.cover,
        width: 160,
        height: 160,
        errorBuilder: (_, __, ___) => Container(
          width: 160,
          height: 160,
          color: AppTheme.surfaceVariant,
          child: Icon(Icons.image_not_supported_outlined, color: AppTheme.onSurfaceVariant),
        ),
      ),
    );
  }

  /// SERVICES GRID
  Widget _bulletGrid(List<String> items) {
    return Wrap(
      spacing: 20,
      runSpacing: 12,
      children: [
        for (var i in items)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check, size: 16, color: AppTheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(i, overflow: TextOverflow.ellipsis, maxLines: 2),
              ),
            ],
          )
      ],
    );
  }

  /// AMENITY ROW
  Widget _amenityRow({required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// WORKING HOURS ROW
  Widget _workingHoursRow(String day, String hours, {required bool isOpen, bool closed = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 44, child: Text(day, style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14))),
          if (isOpen)
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(AppTheme.radiusPill),
              ),
              child: const Text("Open now", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
            ),
          Text(
            hours,
            style: TextStyle(
              fontSize: 14,
              color: closed ? Colors.red.shade700 : AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  /// BUILD WORKING HOURS
  List<Widget> _buildWorkingHours() {
    final now = DateTime.now();
    final currentWeekday = now.weekday;
    const openHours = "09:00 - 18:00";
    const closedHours = "Closed";
    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    List<Widget> rows = [];

    for (int i = 0; i < weekdays.length; i++) {
      final day = weekdays[i];
      if (i < 6) {
        final isOpenNow = (i + 1) == currentWeekday && now.hour >= 9 && now.hour < 18;
        rows.add(_workingHoursRow(day, openHours, isOpen: isOpenNow));
      } else {
        rows.add(_workingHoursRow(day, closedHours, isOpen: false, closed: true));
      }
    }
    return rows;
  }

}
