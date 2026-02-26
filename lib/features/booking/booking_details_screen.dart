import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/utils/router.dart';
import 'package:check_around_me/core/vm/provider_initilizers.dart';
import 'package:check_around_me/core/widget/error.dart';
import 'package:check_around_me/data/model/booking_list_response.dart';
import 'package:check_around_me/data/repositories/conversation_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'booking_chat_screen.dart';
import '../../vm/auth_provider.dart';
import '../../vm/business_provider.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsScreen({super.key, required this.booking});

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, y • h:mm a').format(date);
    } catch (_) {
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

  Color _statusColor(String? status) {
    final display = _getDisplayStatus(status);
    switch (display) {
      case 'Pending':
        return const Color(0xFFD97706);
      case 'Active':
        return AppTheme.primary;
      case 'Completed':
        return const Color(0xFF059669);
      case 'Cancelled':
        return AppTheme.onSurfaceVariant;
      case 'Disputed':
        return const Color(0xFFDC2626);
      default:
        return AppTheme.primary;
    }
  }

  bool _shouldShowCancelButton(BookingModel b) {
    final s = b.status?.toLowerCase() ?? '';
    return s == 'accepted' || s == 'in_progress';
  }

  bool _shouldShowPayButton(BookingModel b) {
    final s = b.status?.toLowerCase() ?? '';
    return s == 'accepted';
  }

  Future<void> _openChat(BuildContext context) async {
    final bookingId = booking.id;
    final otherUserId = booking.userId;
    if (bookingId == null || bookingId.isEmpty) {
      showErrorDialog(context, 'Error', 'Booking ID is missing.');
      return;
    }
    if (otherUserId == null || otherUserId.isEmpty) {
      showErrorDialog(context, 'Error', 'Cannot start chat: customer not linked to this booking.');
      return;
    }
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.userModel?.id == null || auth.userModel!.id!.isEmpty) {
      showErrorDialog(context, 'Error', 'You must be signed in to message.');
      return;
    }
    final repo = inject<ConversationRepository>();
    final currentUserId = auth.userModel!.id!;
    // API requires exactly 2 user IDs: both participants in the conversation.
    final result = await repo.getOrCreateConversation(
      userIds: [currentUserId, otherUserId],
      bookingId: bookingId,
    );
    if (!context.mounted) return;
    result.fold(
      (failure) => showErrorDialog(context, 'Error', failure.message),
      (conversation) {
        if (conversation.id == null || conversation.id!.isEmpty) {
          showErrorDialog(context, 'Error', 'Could not open conversation.');
          return;
        }
        router.push(BookingChatScreen(
          conversationId: conversation.id!,
          otherParticipantName: booking.userDetails?.name,
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayStatus = _getDisplayStatus(booking.status);
    final statusBg = _statusColor(booking.status).withOpacity(0.12);
    final statusFg = _statusColor(booking.status);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.onSurface, size: 22),
          onPressed: () => router.pop(),
        ),
        title: Text(
          'Booking details',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined, color: AppTheme.onSurface, size: 22),
            onPressed: () => _openChat(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status card
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: AppTheme.borderRadiusPill,
                  ),
                  child: Text(
                    displayStatus,
                    style: GoogleFonts.poppins(
                      color: statusFg,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Service
              _SectionCard(
                title: 'Service',
                icon: Icons.work_outline_rounded,
                children: [
                  _DetailRow(label: 'Type', value: booking.type ?? '—'),
                  _DetailRow(label: 'Service', value: booking.serviceName ?? '—'),
                  if (booking.message != null && booking.message!.isNotEmpty)
                    _DetailRow(label: 'Message', value: booking.message!),
                ],
              ),
              const SizedBox(height: 16),

              // Date & time
              _SectionCard(
                title: 'Date & time',
                icon: Icons.schedule_rounded,
                children: [
                  if (booking.scheduledAt != null)
                    _DetailRow(label: 'Scheduled', value: _formatDate(booking.scheduledAt)),
                  _DetailRow(label: 'Created', value: _formatDate(booking.createdAt)),
                  if (booking.acceptedAt != null)
                    _DetailRow(label: 'Accepted', value: _formatDate(booking.acceptedAt)),
                  if (booking.completedAt != null)
                    _DetailRow(label: 'Completed', value: _formatDate(booking.completedAt)),
                  if (booking.cancelledAt != null)
                    _DetailRow(label: 'Cancelled', value: _formatDate(booking.cancelledAt)),
                ],
              ),
              const SizedBox(height: 16),

              // Customer / user details
              if (booking.userDetails != null) ...[
                _SectionCard(
                  title: 'Customer details',
                  icon: Icons.person_outline_rounded,
                  children: [
                    if (booking.userDetails!.name != null && booking.userDetails!.name!.isNotEmpty)
                      _DetailRow(label: 'Name', value: booking.userDetails!.name!),
                    if (booking.userDetails!.address != null && booking.userDetails!.address!.isNotEmpty)
                      _DetailRow(label: 'Address', value: booking.userDetails!.address!),
                    if (booking.userDetails!.note != null && booking.userDetails!.note!.isNotEmpty)
                      _DetailRow(label: 'Note', value: booking.userDetails!.note!),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Payment
              if ((booking.amount != null && booking.amount! > 0) || (booking.fee != null && booking.fee! > 0)) ...[
                _SectionCard(
                  title: 'Payment',
                  icon: Icons.payments_outlined,
                  children: [
                    if (booking.amount != null && booking.amount! > 0)
                      _DetailRow(
                        label: 'Amount',
                        value: '${booking.currency ?? 'NGN'} ${NumberFormat('#,###').format(booking.amount)}',
                      ),
                    if (booking.fee != null && booking.fee! > 0)
                      _DetailRow(
                        label: 'Fee',
                        value: '${booking.currency ?? 'NGN'} ${NumberFormat('#,###').format(booking.fee)}',
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Cancellation reason if present
              if (booking.cancellationReason != null && booking.cancellationReason!.isNotEmpty) ...[
                _SectionCard(
                  title: 'Cancellation',
                  icon: Icons.cancel_outlined,
                  children: [
                    _DetailRow(label: 'Reason', value: booking.cancellationReason!),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Actions
              if (_shouldShowPayButton(booking) || _shouldShowCancelButton(booking)) ...[
                if (_shouldShowPayButton(booking))
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment functionality coming soon')),
                        );
                      },
                      icon: const Icon(Icons.payment, size: 20, color: Colors.white),
                      label: const Text('Pay booking fee'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme.borderRadiusMd,
                        ),
                      ),
                    ),
                  ),
                if (_shouldShowPayButton(booking) && _shouldShowCancelButton(booking)) const SizedBox(height: 12),
                if (_shouldShowCancelButton(booking))
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelDialog(context),
                      icon: Icon(Icons.cancel_outlined, size: 20, color: const Color(0xFFDC2626)),
                      label: Text(
                        'Cancel booking',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFDC2626),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFDC2626)),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme.borderRadiusMd,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusLg),
        title: Text('Cancel booking', style: GoogleFonts.poppins()),
        content: Text(
          'Are you sure you want to cancel this booking?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('No', style: GoogleFonts.poppins(color: AppTheme.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final vm = Provider.of<BusinessProvider>(context, listen: false);
              await vm.cancelBooking(booking.id ?? '');
              if (!context.mounted) return;
              if (vm.error != null) {
                showErrorDialog(context, 'Error', vm.error!.message);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking cancelled successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                router.pop(true);
              }
            },
            child: Text('Yes, cancel', style: GoogleFonts.poppins(color: AppTheme.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusXl,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurface,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
