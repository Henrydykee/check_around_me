import 'package:check_around_me/core/utils/router.dart';
import 'package:check_around_me/core/widget/error.dart';
import 'package:check_around_me/data/model/booking_list_response.dart';
import 'package:check_around_me/data/repositories/business_repositories.dart';
import 'package:flutter/material.dart';

import '../../core/vm/provider_initilizers.dart';
import 'booking_payment_webview_screen.dart';

Future<bool> startBookingPaymentFlow(
  BuildContext context,
  BookingModel booking,
) async {
  final bookingId = booking.id;
  if (bookingId == null || bookingId.isEmpty) {
    showErrorDialog(context, 'Error', 'Booking ID is missing.');
    return false;
  }

  final repo = inject<BusinessRepository>();

  final result = await repo.createBookingPayment(bookingId, paymentType: 'booking');

  if (!context.mounted) return false;

  return result.fold(
    (failure) {
      showErrorDialog(context, 'Payment Error', failure.message);
      return false;
    },
    (data) async {
      final authorizationUrl = data['authorizationUrl'];
      final reference = data['reference'];

      if (authorizationUrl == null || authorizationUrl.isEmpty) {
        showErrorDialog(context, 'Payment Error', 'Missing authorization URL from payment response.');
        return false;
      }

      final success = await router.push<bool>(
        BookingPaymentWebViewScreen(
          authorizationUrl: authorizationUrl,
          reference: reference,
        ),
      );

      return success == true;
    },
  );
}

