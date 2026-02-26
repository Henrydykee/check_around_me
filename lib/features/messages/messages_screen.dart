import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/utils/router.dart';
import 'package:check_around_me/core/vm/provider_initilizers.dart';
import 'package:check_around_me/data/model/conversation_model.dart';
import 'package:check_around_me/data/model/message_model.dart';
import 'package:check_around_me/data/model/user_conversations_response.dart';
import 'package:check_around_me/data/repositories/conversation_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../booking/booking_chat_screen.dart';
import '../../vm/auth_provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final ConversationRepository _repo = inject<ConversationRepository>();
  UserConversationsResponse? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.userModel?.id;
    if (userId == null || userId.isEmpty) {
      setState(() {
        _loading = false;
        _data = null;
        _error = null;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await _repo.getUserConversations(userId);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failure.message;
        _data = null;
      }),
      (data) => setState(() {
        _loading = false;
        _data = data;
        _error = null;
      }),
    );
  }

  void _openChat(ConversationModel conv) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = auth.userModel?.id ?? '';
    final otherName = _data?.getOtherParticipantName(conv.id ?? '', currentUserId);
    router.push(BookingChatScreen(
      conversationId: conv.id!,
      otherParticipantName: otherName,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final notSignedIn = auth.userModel?.id == null || auth.userModel!.id!.isEmpty;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: notSignedIn
          ? _buildNotSignedIn(context)
          : _loading && (_data == null || _data!.conversations.isEmpty)
              ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
              : _error != null && (_data == null || _data!.conversations.isEmpty)
                  ? _buildError(context)
                  : _data!.conversations.isEmpty
                      ? _buildEmpty(context)
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            itemCount: _data!.conversations.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final conv = _data!.conversations[index];
                              final lastMsg = conv.id != null ? _data!.lastMessages[conv.id] : null;
                              final unread = conv.id != null ? (_data!.unreadCounts[conv.id] ?? 0) : 0;
                              final otherName = _data!.getOtherParticipantName(
                                conv.id ?? '',
                                auth.userModel?.id ?? '',
                              );
                              return _ConversationTile(
                                conversation: conv,
                                lastMessage: lastMsg,
                                unreadCount: unread,
                                otherParticipantName: otherName,
                                onTap: () => _openChat(conv),
                              );
                            },
                          ),
                        ),
    );
  }

  Widget _buildNotSignedIn(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.message_outlined, size: 64, color: AppTheme.onSurfaceVariant.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            Text(
              'Sign in to see your conversations',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppTheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              _error ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: AppTheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _load,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: AppTheme.onSurfaceVariant.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a chat from a booking to see it here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final MessageModel? lastMessage;
  final int unreadCount;
  final String? otherParticipantName;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.lastMessage,
    required this.unreadCount,
    required this.otherParticipantName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = otherParticipantName?.isNotEmpty == true ? otherParticipantName! : 'Chat';
    final preview = lastMessage?.text ?? 'No messages yet';
    final timeStr = lastMessage?.createdAt != null ? _formatTime(lastMessage!.createdAt!) : null;

    return Material(
      color: Colors.white,
      borderRadius: AppTheme.borderRadiusLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.borderRadiusLg,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppTheme.primaryLight,
                child: Icon(Icons.person_outline, color: AppTheme.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: unreadCount > 0 ? FontWeight.w700 : FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (timeStr != null)
                          Text(
                            timeStr,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preview,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppTheme.onSurfaceVariant,
                        fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (unreadCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: AppTheme.borderRadiusPill,
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : '$unreadCount',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  String _formatTime(String dateString) {
    try {
      final dt = DateTime.parse(dateString);
      final now = DateTime.now();
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return DateFormat('h:mm a').format(dt);
      }
      if (dt.year == now.year) {
        return DateFormat('MMM d').format(dt);
      }
      return DateFormat('MMM d, y').format(dt);
    } catch (_) {
      return dateString;
    }
  }
}
