import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/services/api_client.dart';
import '../../core/services/api_urls.dart';
import '../../core/services/request_failure.dart';
import '../model/conversation_model.dart';
import '../model/message_model.dart';
import '../model/user_conversations_response.dart';

class ConversationRepository {
  final ApiClient _client;
  ConversationRepository(this._client);

  /// List all conversations for a user (inbox). GET /users/{userId}/conversations
  Future<Either<RequestFailure, UserConversationsResponse>> getUserConversations(String userId) async {
    try {
      final response = await _client.get(ApiUrls.getUserConversations(userId));
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);
      return Right(UserConversationsResponse.fromJson(data));
    } on DioException catch (e) {
      return Left(RequestFailure(
        e.response?.data is Map && (e.response?.data as Map).containsKey('message')
            ? (e.response!.data as Map)['message'] as String
            : e.message ?? 'Failed to load conversations',
      ));
    } catch (e) {
      return Left(RequestFailure('Unexpected error: $e'));
    }
  }

  /// Get or create a conversation for a booking. Returns the conversation (existing or new).
  Future<Either<RequestFailure, ConversationModel>> getOrCreateConversation({
    required List<String> userIds,
    required String bookingId,
  }) async {
    try {
      final response = await _client.post(
        ApiUrls.getOrCreateConversation,
        data: {'userIds': userIds, 'bookingId': bookingId},
      );
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);
      return Right(ConversationModel.fromJson(data));
    } on DioException catch (e) {
      return Left(RequestFailure(
        e.response?.data is Map && (e.response?.data as Map).containsKey('message')
            ? (e.response!.data as Map)['message'] as String
            : e.message ?? 'Failed to get or create conversation',
      ));
    } catch (e) {
      return Left(RequestFailure('Unexpected error: $e'));
    }
  }

  /// Fetch messages for a conversation.
  Future<Either<RequestFailure, List<MessageModel>>> getConversationMessages(String conversationId) async {
    try {
      final response = await _client.get(ApiUrls.getConversationMessages(conversationId));
      final data = response.data;
      List<dynamic> list = const [];
      if (data is List) {
        list = data;
      } else if (data is Map && data['messages'] != null) {
        list = data['messages'] as List;
      } else if (data is Map && data['data'] != null) {
        list = data['data'] is List ? data['data'] as List : [];
      }
      final messages = list
          .map((e) => MessageModel.fromJson(e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e)))
          .toList();
      return Right(messages);
    } on DioException catch (e) {
      return Left(RequestFailure(
        e.response?.data is Map && (e.response?.data as Map).containsKey('message')
            ? (e.response!.data as Map)['message'] as String
            : e.message ?? 'Failed to load messages',
      ));
    } catch (e) {
      return Left(RequestFailure('Unexpected error: $e'));
    }
  }

  /// Send a text message (optionally with imageId).
  Future<Either<RequestFailure, MessageModel>> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    String? imageId,
  }) async {
    try {
      final payload = <String, dynamic>{
        'conversationId': conversationId,
        'senderId': senderId,
        'text': text,
        'image': null,
      };
      if (imageId != null && imageId.isNotEmpty) payload['imageId'] = imageId;

      final response = await _client.post(ApiUrls.sendMessage, data: payload);
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);
      return Right(MessageModel.fromJson(data));
    } on DioException catch (e) {
      return Left(RequestFailure(
        e.response?.data is Map && (e.response?.data as Map).containsKey('message')
            ? (e.response!.data as Map)['message'] as String
            : e.message ?? 'Failed to send message',
      ));
    } catch (e) {
      return Left(RequestFailure('Unexpected error: $e'));
    }
  }
}
