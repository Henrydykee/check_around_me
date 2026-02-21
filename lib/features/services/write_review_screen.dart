import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/vm/provider_initilizers.dart';
import 'package:check_around_me/core/vm/provider_view_model.dart';
import 'package:check_around_me/core/widget/error.dart';
import 'package:check_around_me/core/widget/loader_wrapper.dart';
import 'package:check_around_me/data/model/business_model.dart';
import 'package:check_around_me/data/model/create_review_payload.dart';
import 'package:check_around_me/vm/business_provider.dart';
import 'package:flutter/material.dart';

import '../../core/services/local_storage.dart';

class WriteReviewScreen extends StatefulWidget {
  final BusinessModel businessModel;

  const WriteReviewScreen({super.key, required this.businessModel});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  final _recommendationController = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _recommendationController.dispose();
    super.dispose();
  }

  Future<void> _submit(BusinessProvider vm) async {
    if (!_formKey.currentState!.validate()) return;
    if (_rating < 1 || _rating > 5) {
      showErrorDialog(context, "Rating required", "Please select a star rating from 1 to 5.");
      return;
    }
    final userId = await inject<LocalStorageService>().getString("userId");
    if (userId == null || userId.isEmpty) {
      showErrorDialog(context, "Sign in required", "You need to be signed in to write a review.");
      return;
    }
    final businessId = widget.businessModel.id;
    if (businessId == null || businessId.isEmpty) {
      showErrorDialog(context, "Error", "Invalid business.");
      return;
    }
    final payload = CreateReviewPayload(
      businessId: businessId,
      userId: userId,
      rating: _rating,
      title: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
      text: _textController.text.trim().isEmpty ? null : _textController.text.trim(),
      recommendation: _recommendationController.text.trim().isEmpty ? null : _recommendationController.text.trim(),
    );
    final success = await vm.createReview(payload);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop(true);
    } else {
      showErrorDialog(
        context,
        "Could not submit review",
        vm.error?.message ?? "Something went wrong. Please try again.",
      );
    }
  }

  static const _ratingLabels = ['Poor', 'Fair', 'Good', 'Very good', 'Excellent'];

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: AppTheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusMd,
        borderSide: BorderSide(color: AppTheme.onSurfaceVariant.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusMd,
        borderSide: BorderSide(color: AppTheme.onSurfaceVariant.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusMd,
        borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.5), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusMd,
        borderSide: const BorderSide(color: AppTheme.primary, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusMd,
        borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      viewModel: inject<BusinessProvider>(),
      builder: (context, vm, _) {
        return LoaderWrapper(
          isLoading: vm.isLoading,
          view: Scaffold(
            backgroundColor: AppTheme.surface,
            appBar: AppBar(
              backgroundColor: AppTheme.surface,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: AppTheme.onSurface, size: 22),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Write a review',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBusinessHeader(),
                      const SizedBox(height: 28),
                      _buildSectionLabel('Your rating'),
                      const SizedBox(height: 12),
                      _buildStarRating(),
                      const SizedBox(height: 28),
                      _buildSectionLabel('Title (optional)'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: _inputDecoration('Summarize your experience'),
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 120,
                        style: const TextStyle(color: AppTheme.onSurface),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionLabel('Your review'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _textController,
                        decoration: _inputDecoration('Share your experience with others'),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 5,
                        maxLength: 1000,
                        style: const TextStyle(color: AppTheme.onSurface),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Please write a short review.";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildSectionLabel('Recommendation (optional)'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _recommendationController,
                        decoration: _inputDecoration('e.g. Yes, I’d recommend this place'),
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 200,
                        style: const TextStyle(color: AppTheme.onSurface),
                      ),
                      const SizedBox(height: 32),
                      _buildSubmitButton(vm),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBusinessHeader() {
    final name = widget.businessModel.name ?? "Business";
    final category = widget.businessModel.category;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: AppTheme.borderRadiusMd,
        border: Border.all(color: AppTheme.onSurfaceVariant.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: AppTheme.borderRadiusSm,
            ),
            child: Icon(Icons.store_outlined, color: AppTheme.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                if (category != null && category.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.onSurface,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildStarRating() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: AppTheme.borderRadiusMd,
        border: Border.all(color: AppTheme.onSurfaceVariant.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final star = i + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  icon: Icon(
                    _rating >= star ? Icons.star : Icons.star_border,
                    size: 40,
                    color: _rating >= star ? Colors.amber.shade700 : AppTheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  onPressed: () => setState(() => _rating = star),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            _rating == 0 ? 'Tap to rate' : '${_ratingLabels[_rating - 1]} · $_rating out of 5',
            style: TextStyle(
              fontSize: 14,
              color: _rating == 0 ? AppTheme.onSurfaceVariant : AppTheme.onSurface,
              fontWeight: _rating == 0 ? FontWeight.w400 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BusinessProvider vm) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () => _submit(vm),
        icon: const Icon(Icons.send_rounded, size: 20, color: Colors.white),
        label: const Text(
          'Submit review',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusMd),
          elevation: 0,
        ),
      ),
    );
  }
}
