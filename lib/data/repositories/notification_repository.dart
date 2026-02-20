import 'package:dartz/dartz.dart';

import '../../core/services/api_client.dart';
import '../../core/services/api_urls.dart';
import '../../core/services/request_failure.dart';
import '../model/notification_model.dart';

class NotificationRepository {
  final ApiClient _client;
  NotificationRepository(this._client);

  Future<Either<RequestFailure, NotificationsResponse>> getNotifications() async {
    try {
      final response = await _client.get(ApiUrls.getNotifications);
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : null;
      if (data == null) {
        return Left(RequestFailure("Invalid response format"));
      }
      return Right(NotificationsResponse.fromJson(data));
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, void>> markAllAsRead() async {
    try {
      await _client.post(ApiUrls.markAllNotificationsAsRead);
      return const Right(null);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }
}
