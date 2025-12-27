


import 'package:check_around_me/data/model/category_response.dart';
import 'package:check_around_me/data/repositories/business_repositories.dart';
import 'package:flutter/cupertino.dart';

import '../core/services/request_failure.dart';
import '../data/model/business_model.dart';
import '../data/model/create_booking_payload.dart';
import '../data/model/booking_list_response.dart';

class BusinessProvider extends ChangeNotifier {
  final BusinessRepository _repository;

  BusinessProvider(this._repository);

  bool isLoading = false;
  RequestFailure? error;

  List<CategoryResponse> categoryList = [];
  List<BusinessModel> businessList = [];
  List<BookingModel> bookingList = [];
  int? totalBookings;




  Future<void> getCategory() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repository.getCategories();
    result.fold(
          (failure) {
        error = failure;
        isLoading = false;
        notifyListeners();
      },
          (success) {
            debugPrint("response");
            debugPrint(success.toString());
            categoryList = success;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> getBusinesses() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repository.getBusinesses();
    debugPrint("response");
    debugPrint(result.toString());
    result.fold(
          (failure) {
        error = failure;
        isLoading = false;
        notifyListeners();
      },
          (success) {
            debugPrint("response");
            debugPrint(success.toString());
            businessList = success;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> createBooking(CreateBookingPayload payload) async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repository.createBooking(payload);
    result.fold(
          (failure) {
        error = failure;
        isLoading = false;
        notifyListeners();
      },
          (success) {
            debugPrint("response");
            debugPrint(success.toString());
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> getMyBookings() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repository.getMyBookings();
    result.fold(
          (failure) {
        error = failure;
        isLoading = false;
        notifyListeners();
      },
          (success) {
            debugPrint("response");
            debugPrint(success.toString());
            bookingList = success.bookings ?? [];
            totalBookings = success.total;
        isLoading = false;
        notifyListeners();
      },
    );
  }

}
