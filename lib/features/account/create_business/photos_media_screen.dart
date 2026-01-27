import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/local_storage.dart';
import '../../../core/utils/router.dart';
import '../../../core/vm/provider_initilizers.dart';
import '../../../core/vm/provider_view_model.dart';
import '../../../core/widget/loader_wrapper.dart';
import '../../../data/model/create_business_payload.dart';
import '../../../data/model/create_business_payload.dart' as models;
import '../../../vm/business_provider.dart';
import '../../account/my_businesses_screen.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  Future<void> _uploadImages(BusinessProvider vm) async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image')),
      );
      return;
    }

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
      } else {
        final uploadedIndex = index - _selectedImages.length;
        if (uploadedIndex < _uploadedImages.length) {
          _uploadedImages.removeAt(uploadedIndex);
        }
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

    // Upload images if not already uploaded
    if (_selectedImages.isNotEmpty && _uploadedImages.isEmpty) {
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
      country: widget.businessData['country'],
      phoneCountryCode: widget.businessData['phoneCountryCode'],
      phoneNumber: widget.businessData['phoneNumber'],
      email: widget.businessData['email'],
      status: 'active',
      minPrice: widget.businessData['minPrice'],
      maxPrice: widget.businessData['maxPrice'],
      paymentOptions: List<String>.from(widget.businessData['paymentOptions'] ?? []),
      hours: hours,
      images: _uploadedImages,
      bookingFee: widget.businessData['bookingFee'],
      bookingFeeType: widget.businessData['bookingFeeType'],
    );

    // Create business
    final businessId = await vm.createBusiness(payload);

    if (vm.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error!.message)),
      );
      return;
    }

    if (businessId != null) {
      // Show success message first
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Business created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      // Navigate to My Businesses screen after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          router.pushAndRemoveUntil(
            const MyBusinessesScreen(),
            (route) => false,
          );
        }
      });
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
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
                onPressed: () => router.pop(),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Photos & Media',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(3/3)',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
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
                      
                      // Selected Images Grid
                      if (_selectedImages.isNotEmpty || _uploadedImages.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _selectedImages.length + _uploadedImages.length,
                          itemBuilder: (context, index) {
                            final isSelectedImage = index < _selectedImages.length;
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: isSelectedImage
                                        ? Image.file(
                                            _selectedImages[index],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          )
                                        : Image.network(
                                            _uploadedImages[index - _selectedImages.length].imageUrl ?? '',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[200],
                                                child: const Icon(Icons.error),
                                              );
                                            },
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
                              activeColor: Colors.blue.shade900,
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
                                              color: Colors.blue,
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
                            backgroundColor: Colors.blue.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
