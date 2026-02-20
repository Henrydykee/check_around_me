import 'package:check_around_me/data/model/notification_model.dart';
import 'package:check_around_me/data/repositories/notification_repository.dart';
import 'package:flutter/material.dart';

import '../core/services/request_failure.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationProvider(this._repository);

  bool isLoading = false;
  RequestFailure? error;

  List<NotificationModel> notifications = [];
  int total = 0;

  Future<void> getNotifications() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repository.getNotifications();
    result.fold(
      (failure) {
        error = failure;
        notifications = [];
        total = 0;
        isLoading = false;
        notifyListeners();
      },
      (response) {
        notifications = response.notifications ?? [];
        total = response.total ?? 0;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> markAllAsRead() async {
    error = null;
    notifyListeners();
    final result = await _repository.markAllAsRead();
    return result.fold(
      (failure) {
        error = failure;
        notifyListeners();
        return false;
      },
      (_) {
        for (var n in notifications) {
          n.isRead = true;
        }
        notifyListeners();
        return true;
      },
    );
  }

  int get unreadCount =>
      notifications.where((n) => n.isRead != true).length;
}
