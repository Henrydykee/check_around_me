import 'conversation_model.dart';
import 'message_model.dart';

/// Response from GET /users/{userId}/conversations
class UserConversationsResponse {
  final List<ConversationModel> conversations;
  final Map<String, MessageModel> lastMessages;
  final Map<String, int> unreadCounts;
  final Map<String, dynamic> participants;

  UserConversationsResponse({
    required this.conversations,
    required this.lastMessages,
    required this.unreadCounts,
    required this.participants,
  });

  factory UserConversationsResponse.fromJson(Map<String, dynamic> json) {
    final convList = json['conversations'] as List? ?? [];
    final conversations = convList
        .map((e) => ConversationModel.fromJson(e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e)))
        .toList();

    final lastMessages = <String, MessageModel>{};
    final lastMessagesRaw = json['lastMessages'];
    if (lastMessagesRaw is Map) {
      for (final entry in lastMessagesRaw.entries) {
        final key = entry.key as String;
        final val = entry.value;
        if (val is Map<String, dynamic>) {
          lastMessages[key] = MessageModel.fromJson(val);
        } else if (val is Map) {
          lastMessages[key] = MessageModel.fromJson(Map<String, dynamic>.from(val));
        }
      }
    }

    final unreadCounts = <String, int>{};
    final unreadRaw = json['unreadCounts'];
    if (unreadRaw is Map) {
      for (final entry in unreadRaw.entries) {
        final v = entry.value;
        if (v is int) unreadCounts[entry.key as String] = v;
      }
    }

    final participants = <String, dynamic>{};
    final partRaw = json['participants'];
    if (partRaw is Map) {
      for (final entry in partRaw.entries) {
        participants[entry.key as String] = entry.value;
      }
    }

    return UserConversationsResponse(
      conversations: conversations,
      lastMessages: lastMessages,
      unreadCounts: unreadCounts,
      participants: participants,
    );
  }

  /// Resolve display name for the other participant in a conversation (excludes [currentUserId]).
  String? getOtherParticipantName(String conversationId, String currentUserId) {
    final convList = conversations.where((c) => c.id == conversationId).toList();
    final conv = convList.isEmpty ? null : convList.first;
    if (conv?.participants == null) return null;
    final otherList = conv!.participants!.where((id) => id != currentUserId).toList();
    final otherId = otherList.isEmpty ? null : otherList.first;
    if (otherId == null) return null;
    final p = participants[otherId];
    if (p is Map && p['name'] != null) return p['name'] as String?;
    if (p is Map && p['email'] != null) return p['email'] as String?;
    return null;
  }
}
