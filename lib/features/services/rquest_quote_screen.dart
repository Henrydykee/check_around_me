import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/utils/router.dart';
import 'package:check_around_me/core/vm/provider_initilizers.dart';
import 'package:check_around_me/core/vm/provider_view_model.dart';
import 'package:check_around_me/core/widget/error.dart';
import 'package:check_around_me/core/widget/loader_wrapper.dart';
import 'package:check_around_me/data/model/business_model.dart';
import 'package:check_around_me/features/booking/booking_success_screen.dart';
import 'package:check_around_me/vm/business_provider.dart';
import 'package:flutter/material.dart';

import '../../core/services/local_storage.dart';
import '../../data/model/create_booking_payload.dart';

class RequestQuoteScreen extends StatefulWidget {
  BusinessModel businessModel;
  String? services;

  RequestQuoteScreen({super.key, required this.businessModel, this.services});

  @override
  State<RequestQuoteScreen> createState() => _RequestQuoteScreenState();
}

class _RequestQuoteScreenState extends State<RequestQuoteScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController serviceAddressCtrl = TextEditingController();
  final TextEditingController additionalNotesCtrl = TextEditingController();

  @override
  void dispose() {
    fullNameCtrl.dispose();
    serviceAddressCtrl.dispose();
    additionalNotesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BusinessProvider viewModel) async {
    if (_formKey.currentState!.validate()) {
      // Get userId first
      final userId = await inject<LocalStorageService>().getString("userId");
      debugPrint("Current userId: $userId");

      // Build payload
      CreateBookingPayload payload = CreateBookingPayload(
        businessId: widget.businessModel.id,
        userId: userId,
        type: "inspection",
        serviceName: widget.services.toString(),
        status: "pending_provider_acceptance",
        userDetails: UserDetails(
          name: fullNameCtrl.text,
          address: serviceAddressCtrl.text,
          note: additionalNotesCtrl.text,
        ),
      );

      // Call API
      await viewModel.createBooking(payload);

      // Handle response
      if (!mounted) return;
      if (viewModel.error != null) {
        return showErrorDialog(
          context,
          "Error",
          viewModel.error?.message.toString() ?? "",
        );
      }
      router.pushReplacement(const BookingSuccessScreen());
    }
  }


  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      viewModel: inject<BusinessProvider>(),
      builder: (context, viewModel, child) {
        return LoaderWrapper(
          isLoading: viewModel.isLoading,
          view: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Request Quote',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FULL NAME Field
                        const Text(
                          'FULL NAME',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: fullNameCtrl,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Full name is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'e.g. John Doe',
                            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.6), width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red, width: 1.5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // SERVICE ADDRESS Field
                        const Text(
                          'SERVICE ADDRESS',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: serviceAddressCtrl,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Service address is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'e.g. 123 Main St, Lagos',
                            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.6), width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red, width: 1.5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ADDITIONAL NOTES Field (Optional)
                        const Text(
                          'ADDITIONAL NOTES (OPTIONAL)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: additionalNotesCtrl,
                          maxLines: 4,
                          validator: (value) {
                            // Optional field, no validation needed
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Any specific instructions or details...',
                            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.6), width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red, width: 1.5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            onPressed: () => _submitForm(viewModel),
                            child: const Text(
                              'Submit Request',

                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
