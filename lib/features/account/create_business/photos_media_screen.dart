import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/local_storage.dart';
import '../../../core/utils/router.dart';
import '../../../core/vm/provider_initilizers.dart';
import '../../../core/vm/provider_view_model.dart';
import '../../../core/widget/loader_wrapper.dart';
import '../../../data/model/create_business_payload.dart';
import '../../../data/model/create_business_payload.dart' as models;
import '../../../vm/business_provider.dart';

class PhotosMediaScreen extends StatefulWidget {
  final Map<String, dynamic> businessData;

  const PhotosMediaScreen({super.key, required this.businessData});

  @override
  State<PhotosMediaScreen> createState() => _PhotosMediaScreenState();
}

class _PhotosMediaScreenState extends State<PhotosMediaScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];
  final List<models.Images> _uploadedImages = [];
  bool _termsAccepted = false;
  bool _isUploading = false;

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking images: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _uploadImages(BusinessProvider vm) async {
    if (_selectedImages.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    final userId = inject<LocalStorageService>().getString("userId");
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found. Please login again.')),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    // Upload all selected images
    for (var imageFile in _selectedImages) {
      final uploaded = await vm.uploadImages(imageFile, userId);
      if (uploaded != null && uploaded.isNotEmpty) {
        setState(() {
          _uploadedImages.addAll(uploaded);
        });
      }
    }

    setState(() {
      _isUploading = false;
    });
  }

  void _removeImage(int index) {
    setState(() {
      if (index < _selectedImages.length) {
        _selectedImages.removeAt(index);
      }
    });
  }

  Future<void> _submitBusiness(BusinessProvider vm) async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms and Conditions')),
      );
      return;
    }

    // Upload selected images; we get back URLs and send those in the payload (uploaded images are not shown in the UI)
    if (_selectedImages.isNotEmpty) {
      setState(() => _uploadedImages.clear());
      await _uploadImages(vm);
    }

    // Build hours object
    final hours = models.Hours(
      mon: _buildDayHours(widget.businessData['hours']['Mon']),
      tue: _buildDayHours(widget.businessData['hours']['Tue']),
      wed: _buildDayHours(widget.businessData['hours']['Wed']),
      thu: _buildDayHours(widget.businessData['hours']['Thu']),
      fri: _buildDayHours(widget.businessData['hours']['Fri']),
      sat: _buildDayHours(widget.businessData['hours']['Sat']),
      sun: _buildDayHours(widget.businessData['hours']['Sun']),
    );

    // Build bankDetails from businessData if present
    models.BankDetails? bankDetails;
    final bankData = widget.businessData['bankDetails'];
    if (bankData is Map<String, dynamic>) {
      bankDetails = models.BankDetails.fromJson(bankData);
    }

    // Build payload
    final payload = CreateBusinessPayload(
      name: widget.businessData['name'],
      about: widget.businessData['about'],
      category: widget.businessData['category'],
      services: List<String>.from(widget.businessData['services'] ?? []),
      servicesPrices: Map<String, int>.from(widget.businessData['servicesPrices'] ?? {}),
      addressLine1: widget.businessData['addressLine1'],
      city: widget.businessData['city'],
      state: widget.businessData['state'],
      country: widget.businessData['countryCode'] ?? widget.businessData['country'],
      postalCode: widget.businessData['postalCode']?.toString(),
      paymentOptions: List<String>.from(widget.businessData['paymentOptions'] ?? []),
      coordinates: widget.businessData['coordinates']?.toString(),
      phoneCountryCode: widget.businessData['phoneCountryCode'],
      phoneNumber: widget.businessData['phoneNumber'],
      email: widget.businessData['email'],
      website: widget.businessData['website']?.toString() ?? '',
      status: 'active',
      minPrice: widget.businessData['minPrice'],
      maxPrice: widget.businessData['maxPrice'],
      referralCode: widget.businessData['referralCode']?.toString(),
      bankDetails: bankDetails,
      hours: hours,
      images: _uploadedImages,
      bookingFee: widget.businessData['bookingFee'],
      bookingFeeType: widget.businessData['bookingFeeType'],
    );

    // Create business
    final businessId = await vm.createBusiness(payload);

    if (vm.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.error!.message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    if (businessId != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Business created successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      // Pop back to My Businesses (3 screens: Photos -> Services -> Basic)
      for (var i = 0; i < 3 && mounted; i++) {
        router.pop(true);
      }
    }
  }

  models.Mon? _buildDayHours(Map<String, dynamic>? dayData) {
    if (dayData == null) return null;
    return models.Mon(
      open: dayData['open'] as String?,
      close: dayData['close'] as String?,
      closed: dayData['closed'] as bool? ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      viewModel: inject<BusinessProvider>(),
      onModelReady: (vm) {},
      builder: (context, vm, child) {
        return LoaderWrapper(
          isLoading: vm.isLoading || _isUploading,
          view: Scaffold(
            backgroundColor: AppTheme.surface,
            appBar: AppBar(
              backgroundColor: AppTheme.surface,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.chevron_left, color: AppTheme.onSurface, size: 30),
                onPressed: () => router.pop(),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Photos & Media',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(3/3)',
                    style: TextStyle(fontSize: 14, color: AppTheme.onSurfaceVariant),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: AppTheme.borderRadiusSm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PHOTOS & MEDIA',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add photos to showcase your business',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                  
                      // Image Upload Area
                      GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add Photo',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Selected Images Grid (only local picks; uploaded URLs are sent in payload, not shown)
                      if (_selectedImages.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _selectedImages[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      
                      const SizedBox(height: 32),
                      
                      // Terms and Conditions
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade300),
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _termsAccepted,
                              onChanged: (value) {
                                setState(() {
                                  _termsAccepted = value ?? false;
                                });
                              },
                              activeColor: AppTheme.primary,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                    ),
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            // TODO: Navigate to terms and conditions
                                          },
                                          child: const Text(
                                            'Terms and Conditions',
                                            style: TextStyle(
                                              color: AppTheme.primary,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const TextSpan(text: ' *'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                            shape: RoundedRectangleBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                            ),
                            elevation: 0,
                          ),
                          onPressed: _termsAccepted ? () => _submitBusiness(vm) : null,
                          child: const Text(
                            'Create Business',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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
}
