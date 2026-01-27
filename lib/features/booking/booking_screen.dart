import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/vm/provider_initilizers.dart';
import '../../core/vm/provider_view_model.dart';
import '../../core/widget/loader_wrapper.dart';
import '../../core/widget/error.dart';
import '../../data/model/booking_list_response.dart';
import '../../vm/business_provider.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All Bookings';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, h:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _getDisplayStatus(String? status) {
    if (status == null) return 'Unknown';
    switch (status.toLowerCase()) {
      case 'pending_provider_acceptance':
        return 'Pending';
      case 'accepted':
      case 'in_progress':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'cancelled':
      case 'cancelled_by_user':
        return 'Cancelled';
      case 'disputed':
        return 'Disputed';
      default:
        return status.replaceAll('_', ' ').split(' ').map((word) => 
          word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)
        ).join(' ');
    }
  }

  bool _shouldShowCancelButton(BookingModel booking) {
    final status = booking.status?.toLowerCase() ?? '';
    // Only show cancel button for accepted bookings, not for pending
    return status == 'accepted' || status == 'in_progress';
  }

  bool _shouldShowPayButton(BookingModel booking) {
    final status = booking.status?.toLowerCase() ?? '';
    // Show pay button only for accepted bookings
    return status == 'accepted';
  }

  List<BookingModel> _getFilteredBookings(List<BookingModel> bookings) {
    if (_selectedFilter == 'All Bookings') return bookings;
    
    return bookings.where((booking) {
      final displayStatus = _getDisplayStatus(booking.status);
      return displayStatus == _selectedFilter;
    }).toList();
  }

  int _getActiveBookingsCount(List<BookingModel> bookings) {
    return bookings.where((b) {
      final status = b.status?.toLowerCase() ?? '';
      return status == 'accepted' || status == 'in_progress';
    }).length;
  }

  int _getActionRequiredCount(List<BookingModel> bookings) {
    return bookings.where((b) {
      final status = b.status?.toLowerCase() ?? '';
      return status == 'pending_provider_acceptance';
    }).length;
  }

  int _getCompletedCount(List<BookingModel> bookings) {
    return bookings.where((b) {
      final status = b.status?.toLowerCase() ?? '';
      return status == 'completed';
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      viewModel: inject<BusinessProvider>(),
      onModelReady: (vm) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          vm.getMyBookings();
        });
      },
      builder: (context, vm, child) {
        return LoaderWrapper(
          isLoading: vm.isLoading,
          view: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: vm.error != null && vm.bookingList.isEmpty
                  ? _buildErrorView(vm)
                  : RefreshIndicator(
                      onRefresh: () async {
                        await vm.getMyBookings();
                        if (vm.error != null) {
                          showErrorDialog(context, "Error", vm.error!.message);
                        }
                      },
                      child: CustomScrollView(
                        slivers: [
                          // 1. Header & Title
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Bookings',
                                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Manage your bookings and appointments efficiently.',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 20),
                                  // Tabs
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                    ),
                                    child: TabBar(
                                      controller: _tabController,
                                      labelColor: Colors.blue[700],
                                      unselectedLabelColor: Colors.grey[600],
                                      indicatorColor: Colors.blue[700],
                                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                                      tabs: const [
                                        Tab(text: "My Bookings"),
                                        Tab(text: "Business Bookings"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 2. Stats Cards (Horizontal Scroll)
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 120,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                children: [
                                  _buildStatCard(
                                    icon: Icons.access_time_filled,
                                    color: Colors.blue,
                                    title: "Active Bookings",
                                    count: _getActiveBookingsCount(vm.bookingList).toString(),
                                  ),
                                  const SizedBox(width: 12),
                                  _buildStatCard(
                                    icon: Icons.error_outline,
                                    color: Colors.orange,
                                    title: "Action Required",
                                    count: _getActionRequiredCount(vm.bookingList).toString(),
                                  ),
                                  const SizedBox(width: 12),
                                  _buildStatCard(
                                    icon: Icons.check_circle_outline,
                                    color: Colors.green,
                                    title: "Completed",
                                    count: _getCompletedCount(vm.bookingList).toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 3. Section Title & Filters
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'My Bookings',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 12),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        'All Bookings',
                                        'Pending',
                                        'Active',
                                        'Completed',
                                        'Cancelled'
                                      ].map((filter) {
                                        final isSelected = _selectedFilter == filter;
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: ActionChip(
                                            label: Text(filter),
                                            backgroundColor: isSelected ? Colors.blue[800] : Colors.grey[100],
                                            labelStyle: TextStyle(
                                              color: isSelected ? Colors.white : Colors.grey[700],
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              side: BorderSide.none,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _selectedFilter = filter;
                                              });
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 4. The Bookings List
                          _buildBookingsList(vm.bookingList),

                          // Bottom padding for scroll
                          const SliverToBoxAdapter(child: SizedBox(height: 40)),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorView(BusinessProvider vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error loading bookings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            const SizedBox(height: 8),
            Text(
              vm.error?.message ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                vm.getMyBookings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<BookingModel> bookings) {
    final filteredBookings = _getFilteredBookings(bookings);

    if (filteredBookings.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No bookings found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 8),
              Text(
                _selectedFilter == 'All Bookings'
                    ? 'You don\'t have any bookings yet'
                    : 'No bookings match the selected filter',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildBookingItem(filteredBookings[index]);
          },
          childCount: filteredBookings.length,
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required MaterialColor color,
    required String title,
    required String count,
  }) {
    return Container(
      width: 150,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50], // Very light grey background like screenshot
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingItem(BookingModel booking) {
    final displayStatus = _getDisplayStatus(booking.status);
    Color statusBg;
    Color statusText;

    switch (displayStatus) {
      case 'Pending':
        statusBg = const Color(0xFFFFF7E6); // Light Orange
        statusText = const Color(0xFFD97706); // Dark Orange
        break;
      case 'Active':
        statusBg = Colors.blue.shade50;
        statusText = Colors.blue.shade700;
        break;
      case 'Cancelled':
        statusBg = Colors.grey.shade200;
        statusText = Colors.grey.shade700;
        break;
      case 'Completed':
        statusBg = Colors.green.shade50;
        statusText = Colors.green.shade700;
        break;
      default:
        statusBg = Colors.blue.shade50;
        statusText = Colors.blue.shade700;
    }

    final dateToShow = booking.scheduledAt ?? booking.createdAt ?? '';
    final formattedDate = _formatDate(dateToShow);
    final serviceName = booking.serviceName ?? 'Service';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Box
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Icon(Icons.apartment, color: Colors.black54),
              ),
              const SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            serviceName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            displayStatus,
                            style: TextStyle(
                              color: statusText,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (booking.userDetails?.name != null) ...[
                      Row(
                        children: [
                          Icon(Icons.person, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              booking.userDetails!.name!,
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            formattedDate,
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (booking.amount != null && booking.amount! > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${booking.currency ?? 'NGN'} ${booking.amount}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Action Buttons
          if (_shouldShowPayButton(booking) || _shouldShowCancelButton(booking)) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            if (_shouldShowPayButton(booking)) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement pay booking fee functionality
                    _handlePayBookingFee(context, booking);
                  },
                  icon: const Icon(Icons.payment, size: 18, color: Colors.white),
                  label: const Text("Pay Booking Fee", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              if (_shouldShowCancelButton(booking)) const SizedBox(height: 8),
            ],
            if (_shouldShowCancelButton(booking))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _handleCancelBooking(context, booking);
                  },
                  icon: const Icon(Icons.cancel_outlined, size: 18, color: Colors.white),
                  label: const Text("Cancel booking", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626), // Red color
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ]
        ],
      ),
    );
  }

  void _handlePayBookingFee(BuildContext context, BookingModel booking) {
    // TODO: Implement payment flow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment functionality coming soon')),
    );
  }

  void _handleCancelBooking(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final vm = Provider.of<BusinessProvider>(context, listen: false);
              await vm.cancelBooking(booking.id ?? '');
              if (vm.error != null) {
                if (context.mounted) {
                  showErrorDialog(context, "Error", vm.error!.message);
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking cancelled successfully')),
                  );
                }
                await vm.getMyBookings();
              }
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}