import 'package:blurhash_shader/blurhash_shader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/index.dart';
import 'package:moekey/apis/models/emojis.dart';
import 'package:moekey/apis/models/login_user.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/notification.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/services/following_service.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/pages/notifications/notifications_group_list.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/status/themes.dart';

/// Shared annotation for MoeKey notification item previews.
final class MoeKeyNotificationPreview extends Preview {
  const MoeKeyNotificationPreview({
    required String name,
    Size size = const Size(460, 250),
  }) : super(
         name: name,
         group: 'MoeKey notifications',
         size: size,
         wrapper: notificationPreviewWrapper,
         theme: notificationPreviewTheme,
         localizations: notificationPreviewLocalizations,
       );
}

/// Supplies the app-level Riverpod state needed by a notification card.
Widget notificationPreviewWrapper(Widget child) {
  return _NotificationPreviewBootstrap(
    child: Builder(
      builder: (context) {
        final brightness = Theme.of(context).brightness;
        return ProviderScope(
          overrides: [
            themeColorsProvider.overrideWith(
              () => NotificationPreviewThemeColors(brightness),
            ),
            currentLoginUserProvider.overrideWith(
              NotificationPreviewCurrentLoginUser.new,
            ),
            instanceMetaProvider.overrideWith((ref) async => null),
            apiEmojisProvider.overrideWith(
              (ref) async => <String, EmojiSimple>{},
            ),
            misskeyApisProvider.overrideWith(
              (ref) => notificationPreviewApis(),
            ),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final colors = ref.watch(themeColorsProvider);
              return Scaffold(
                backgroundColor: colors.bgColor,
                body: SafeArea(child: child),
              );
            },
          ),
        );
      },
    ),
  );
}

Future<void>? _notificationPreviewShader;

Future<void> _loadNotificationPreviewShader() {
  return _notificationPreviewShader ??= BlurHash.loadShader();
}

class _NotificationPreviewBootstrap extends StatefulWidget {
  const _NotificationPreviewBootstrap({required this.child});

  final Widget child;

  @override
  State<_NotificationPreviewBootstrap> createState() =>
      _NotificationPreviewBootstrapState();
}

class _NotificationPreviewBootstrapState
    extends State<_NotificationPreviewBootstrap> {
  late final Future<void> _shaderReady = _loadNotificationPreviewShader();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _shaderReady,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Unable to load the BlurHash shader:\n${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return widget.child;
      },
    );
  }
}

/// Uses only web-safe Material themes so the previewer can toggle brightness.
PreviewThemeData notificationPreviewTheme() {
  const seed = Color(0xFF98C934);
  return PreviewThemeData(
    materialLight: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seed),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      useMaterial3: true,
    ),
    materialDark: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF171717),
      useMaterial3: true,
    ),
  );
}

/// Loads MoeKey's Simplified Chinese strings in the preview environment.
PreviewLocalizationsData notificationPreviewLocalizations() {
  return PreviewLocalizationsData(
    locale: const Locale('zh', 'CN'),
    supportedLocales: S.delegate.supportedLocales,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
  );
}

class NotificationPreviewThemeColors extends ThemeColors {
  NotificationPreviewThemeColors(this.brightness);

  final Brightness brightness;

  @override
  ThemeColorModel build() {
    final colors = ThemeColorModel();
    if (brightness == Brightness.dark) {
      colors
        ..isDark = true
        ..bgColor = const Color(0xFF171717)
        ..fgColor = const Color(0xFFE7E7E7)
        ..panelColor = const Color(0xFF242424)
        ..navBgColor = const Color(0xFF242424)
        ..headerColor = const Color(0xE6222222)
        ..dividerColor = const Color(0x26FFFFFF)
        ..buttonBgColor = const Color(0x14FFFFFF)
        ..buttonHoverBgColor = const Color(0x24FFFFFF)
        ..shadowColor = const Color(0x66000000)
        ..windowHeaderColor = const Color(0xE6222222)
        ..folderHeaderBg = const Color(0x14FFFFFF);
    }
    return colors;
  }
}

class NotificationPreviewCurrentLoginUser extends CurrentLoginUser {
  @override
  LoginUser? build() {
    return LoginUser(
      serverUrl: 'https://preview.example',
      token: 'preview-token',
      name: 'Moe',
      id: 'preview-current-user',
      userInfo: UserFullModel(
        avatarUrl: 'https://api.dicebear.com/9.x/thumbs/png?seed=Moe',
        createdAt: DateTime(2024),
        followersCount: 256,
        followingCount: 128,
        id: 'preview-current-user',
        name: 'Moe',
        notesCount: 1024,
        onlineStatus: OnlineStatus.ONLINE,
        username: 'moe',
      ),
    );
  }
}

class NotificationPreviewFollowingService extends FollowingService {
  NotificationPreviewFollowingService({required super.client});

  @override
  Future<void> requestsAccept({required String userId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> requestsReject({required String userId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }
}

MisskeyApis notificationPreviewApis() {
  final apis = MisskeyApis(
    instance: 'https://preview.example',
    accessToken: 'preview-token',
    onUnauthorized: null,
  );
  apis.following = NotificationPreviewFollowingService(client: apis.client);
  return apis;
}

const notificationPreviewAlice = UserLiteModel(
  avatarBlurhash: 'LKO2?U%2Tw=w]~RBVZRi};RPxuwH',
  avatarDecorations: [],
  avatarUrl: 'https://api.dicebear.com/9.x/thumbs/png?seed=Alice',
  emojis: {},
  host: null,
  id: 'preview-alice',
  makeNotesFollowersOnlyBefore: null,
  makeNotesHiddenBefore: null,
  name: '爱丽丝',
  onlineStatus: OnlineStatus.ONLINE,
  username: 'alice',
);

const notificationPreviewBob = UserLiteModel(
  avatarBlurhash: null,
  avatarDecorations: [],
  avatarUrl: 'https://api.dicebear.com/9.x/thumbs/png?seed=Bob',
  emojis: {},
  host: 'remote.example',
  id: 'preview-bob',
  makeNotesFollowersOnlyBefore: null,
  makeNotesHiddenBefore: null,
  name: 'Bob',
  onlineStatus: OnlineStatus.ACTIVE,
  username: 'bob',
);

const notificationPreviewCarol = UserLiteModel(
  avatarBlurhash: null,
  avatarDecorations: [],
  avatarUrl: 'https://api.dicebear.com/9.x/thumbs/png?seed=Carol',
  emojis: {},
  host: null,
  id: 'preview-carol',
  makeNotesFollowersOnlyBefore: null,
  makeNotesHiddenBefore: null,
  name: 'Carol',
  onlineStatus: OnlineStatus.OFFLINE,
  username: 'carol',
);

const notificationPreviewCurrentUser = UserLiteModel(
  avatarBlurhash: null,
  avatarDecorations: [],
  avatarUrl: 'https://api.dicebear.com/9.x/thumbs/png?seed=Moe',
  emojis: {},
  host: null,
  id: 'preview-current-user',
  makeNotesFollowersOnlyBefore: null,
  makeNotesHiddenBefore: null,
  name: 'Moe',
  onlineStatus: OnlineStatus.ONLINE,
  username: 'moe',
);

NoteModel notificationPreviewNote({
  required String id,
  required UserLiteModel user,
  required String text,
  NoteModel? renote,
  NotePollModel? poll,
  NoteReactionAcceptance? reactionAcceptance,
}) {
  return NoteModel(
    id: id,
    createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
    files: const [],
    localOnly: false,
    reactionAcceptance: reactionAcceptance,
    reactionEmojis: const {},
    reactions: const {},
    renote: renote,
    text: text,
    user: user,
    userId: user.id,
    visibility: NoteVisibility.public,
    poll: poll,
  );
}

NotificationModel notificationPreviewData(
  String type, {
  bool groupedLikeOnly = true,
}) {
  final createdAt = DateTime.now().subtract(const Duration(minutes: 3));
  final aliceNote = notificationPreviewNote(
    id: 'preview-note-alice',
    user: notificationPreviewAlice,
    text: '今天也要开心地使用 MoeKey！',
  );
  final bobNote = notificationPreviewNote(
    id: 'preview-note-bob',
    user: notificationPreviewBob,
    text: '@moe 这是来自远端实例的回复。',
  );

  switch (type) {
    case 'note':
      return NotificationModel(
        id: 'preview-note',
        createdAt: createdAt,
        type: type,
        user: notificationPreviewAlice,
        userId: notificationPreviewAlice.id,
        note: aliceNote,
      );
    case 'follow':
      return NotificationModel(
        id: 'preview-follow',
        createdAt: createdAt,
        type: type,
        user: notificationPreviewBob,
        userId: notificationPreviewBob.id,
      );
    case 'mention':
      return NotificationModel(
        id: 'preview-mention',
        createdAt: createdAt,
        type: type,
        user: notificationPreviewAlice,
        userId: notificationPreviewAlice.id,
        note: notificationPreviewNote(
          id: 'preview-note-mention',
          user: notificationPreviewAlice,
          text: '@moe 一起来看看这条帖子。',
        ),
      );
    case 'reply':
      return NotificationModel(
        id: 'preview-reply',
        createdAt: createdAt,
        type: type,
        user: notificationPreviewBob,
        userId: notificationPreviewBob.id,
        note: bobNote,
      );
    case 'renote':
      return NotificationModel(
        id: 'preview-renote',
        createdAt: createdAt,
        type: type,
        user: notificationPreviewCarol,
        userId: notificationPreviewCarol.id,
        note: notificationPreviewNote(
          id: 'preview-note-renote',
          user: notificationPreviewCarol,
          text: '',
          renote: aliceNote,
        ),
      );
    case 'quote':
      return NotificationModel(
        id: 'preview-quote',
        createdAt: createdAt,
        type: type,
        user: notificationPreviewAlice,
        userId: notificationPreviewAlice.id,
        note: notificationPreviewNote(
          id: 'preview-note-quote',
          user: notificationPreviewAlice,
          text: '引用并补充一点自己的想法。',
          renote: bobNote,
        ),
      );
    case 'reaction':
      return NotificationModel(
        id: 'preview-reaction',
        createdAt: createdAt,
        type: type,
        user: notificationPreviewBob,
        userId: notificationPreviewBob.id,
        note: aliceNote,
        reaction: '❤️',
      );
    case 'pollEnded':
      return NotificationModel(
        id: 'preview-poll-ended',
        createdAt: createdAt,
        type: type,
        user: notificationPreviewAlice,
        userId: notificationPreviewAlice.id,
        note: notificationPreviewNote(
          id: 'preview-note-poll',
          user: notificationPreviewAlice,
          text: '你最喜欢哪种通知样式？',
          poll: const NotePollModel(
            multiple: false,
            choices: [
              NotePollModelChoices(votes: 18, text: '简洁', isVoted: true),
              NotePollModelChoices(votes: 12, text: '详细', isVoted: false),
            ],
          ),
        ),
      );
    case 'scheduledNotePosted':
      return NotificationModel(
        id: 'preview-scheduled-posted',
        createdAt: createdAt,
        type: type,
        note: notificationPreviewNote(
          id: 'preview-note-scheduled',
          user: notificationPreviewCurrentUser,
          text: '这是一条已经按计划发布的帖子。',
        ),
      );
    case 'scheduledNotePostFailed':
      return NotificationModel(
        id: 'preview-scheduled-failed',
        createdAt: createdAt,
        type: type,
        noteDraft: const NotificationNoteDraft(
          cw: '内容警告',
          text: '未能发布的定时帖子草稿。',
        ),
      );
    case 'receiveFollowRequest':
      return NotificationModel(
        id: 'preview-follow-request',
        createdAt: createdAt,
        type: type,
        user: notificationPreviewCarol,
        userId: notificationPreviewCarol.id,
      );
    case 'followRequestAccepted':
      return NotificationModel(
        id: 'preview-follow-accepted',
        createdAt: createdAt,
        type: type,
        user: notificationPreviewBob,
        userId: notificationPreviewBob.id,
        message: '很高兴认识你！',
      );
    case 'roleAssigned':
      return NotificationModel(
        id: 'preview-role',
        createdAt: createdAt,
        type: type,
        role: const NotificationRole(name: '社区贡献者'),
      );
    case 'chatRoomInvitationReceived':
      return NotificationModel(
        id: 'preview-chat',
        createdAt: createdAt,
        type: type,
      );
    case 'achievementEarned':
      return NotificationModel(
        id: 'preview-achievement',
        createdAt: createdAt,
        type: type,
        achievement: 'notes100',
      );
    case 'exportCompleted':
      return NotificationModel(
        id: 'preview-export',
        createdAt: createdAt,
        type: type,
        exportedEntity: 'following',
        fileId: 'preview-export-file',
      );
    case 'login':
      return NotificationModel(
        id: 'preview-login',
        createdAt: createdAt,
        type: type,
      );
    case 'createToken':
      return NotificationModel(
        id: 'preview-token',
        createdAt: createdAt,
        type: type,
      );
    case 'app':
      return NotificationModel(
        id: 'preview-app',
        createdAt: createdAt,
        type: type,
        header: 'MoeKey Preview App',
        body: r'$[jelly 这是一条支持 MFM 的应用通知。] :sparkles:',
      );
    case 'test':
      return NotificationModel(
        id: 'preview-test',
        createdAt: createdAt,
        type: type,
      );
    case 'reaction:grouped':
      return NotificationModel(
        id: groupedLikeOnly
            ? 'preview-reaction-grouped-like'
            : 'preview-reaction-grouped',
        createdAt: createdAt,
        type: type,
        note: notificationPreviewNote(
          id: 'preview-note-reaction-grouped',
          user: notificationPreviewCurrentUser,
          text: '这条帖子收到了多位用户的回应。',
          reactionAcceptance: groupedLikeOnly
              ? NoteReactionAcceptance.likeOnly
              : null,
        ),
        reactions: const [
          NoteReaction(reaction: '❤️', user: notificationPreviewAlice),
          NoteReaction(reaction: '🎉', user: notificationPreviewBob),
          NoteReaction(reaction: '👍', user: notificationPreviewCarol),
        ],
      );
    case 'renote:grouped':
      return NotificationModel(
        id: 'preview-renote-grouped',
        createdAt: createdAt,
        type: type,
        note: aliceNote,
        users: const [
          notificationPreviewAlice,
          notificationPreviewBob,
          notificationPreviewCarol,
        ],
      );
    default:
      return NotificationModel(
        id: 'preview-unknown',
        createdAt: createdAt,
        type: type,
      );
  }
}

Widget notificationPreviewItem(String type, {bool groupedLikeOnly = true}) {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text(
        type,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 8),
      NotificationItemCard(
        data: notificationPreviewData(type, groupedLikeOnly: groupedLikeOnly),
        borderRadius: BorderRadius.circular(12),
        navigationEnabled: false,
      ),
    ],
  );
}

class NotificationPreviewGallery extends StatelessWidget {
  const NotificationPreviewGallery({super.key});

  static const types = <String>[
    'note',
    'follow',
    'mention',
    'reply',
    'renote',
    'quote',
    'reaction',
    'pollEnded',
    'scheduledNotePosted',
    'scheduledNotePostFailed',
    'receiveFollowRequest',
    'followRequestAccepted',
    'roleAssigned',
    'chatRoomInvitationReceived',
    'achievementEarned',
    'exportCompleted',
    'login',
    'createToken',
    'app',
    'test',
    'reaction:grouped',
    'reaction:grouped (non-likeOnly)',
    'renote:grouped',
    'futureNotification',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: types.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final label = types[index];
        final isGroupedVariant = label == 'reaction:grouped (non-likeOnly)';
        final wireType = isGroupedVariant ? 'reaction:grouped' : label;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. $label',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 6),
            NotificationItemCard(
              data: notificationPreviewData(
                wireType,
                groupedLikeOnly: !isGroupedVariant,
              ),
              borderRadius: BorderRadius.circular(12),
              navigationEnabled: false,
            ),
          ],
        );
      },
    );
  }
}

@MoeKeyNotificationPreview(
  name: '00 All 22 types + variants',
  size: Size(480, 1000),
)
Widget previewAllNotifications() => const NotificationPreviewGallery();

@MoeKeyNotificationPreview(name: '01 note')
Widget previewNotificationNote() => notificationPreviewItem('note');

@MoeKeyNotificationPreview(name: '02 follow')
Widget previewNotificationFollow() => notificationPreviewItem('follow');

@MoeKeyNotificationPreview(name: '03 mention')
Widget previewNotificationMention() => notificationPreviewItem('mention');

@MoeKeyNotificationPreview(name: '04 reply')
Widget previewNotificationReply() => notificationPreviewItem('reply');

@MoeKeyNotificationPreview(name: '05 renote')
Widget previewNotificationRenote() => notificationPreviewItem('renote');

@MoeKeyNotificationPreview(name: '06 quote')
Widget previewNotificationQuote() => notificationPreviewItem('quote');

@MoeKeyNotificationPreview(name: '07 reaction')
Widget previewNotificationReaction() => notificationPreviewItem('reaction');

@MoeKeyNotificationPreview(name: '08 pollEnded')
Widget previewNotificationPollEnded() => notificationPreviewItem('pollEnded');

@MoeKeyNotificationPreview(name: '09 scheduledNotePosted')
Widget previewNotificationScheduledPosted() =>
    notificationPreviewItem('scheduledNotePosted');

@MoeKeyNotificationPreview(name: '10 scheduledNotePostFailed')
Widget previewNotificationScheduledFailed() =>
    notificationPreviewItem('scheduledNotePostFailed');

@MoeKeyNotificationPreview(name: '11 receiveFollowRequest')
Widget previewNotificationFollowRequest() =>
    notificationPreviewItem('receiveFollowRequest');

@MoeKeyNotificationPreview(name: '12 followRequestAccepted')
Widget previewNotificationFollowAccepted() =>
    notificationPreviewItem('followRequestAccepted');

@MoeKeyNotificationPreview(name: '13 roleAssigned')
Widget previewNotificationRoleAssigned() =>
    notificationPreviewItem('roleAssigned');

@MoeKeyNotificationPreview(name: '14 chatRoomInvitationReceived')
Widget previewNotificationChatUnsupported() =>
    notificationPreviewItem('chatRoomInvitationReceived');

@MoeKeyNotificationPreview(name: '15 achievementEarned')
Widget previewNotificationAchievement() =>
    notificationPreviewItem('achievementEarned');

@MoeKeyNotificationPreview(name: '16 exportCompleted')
Widget previewNotificationExport() =>
    notificationPreviewItem('exportCompleted');

@MoeKeyNotificationPreview(name: '17 login')
Widget previewNotificationLogin() => notificationPreviewItem('login');

@MoeKeyNotificationPreview(name: '18 createToken')
Widget previewNotificationCreateToken() =>
    notificationPreviewItem('createToken');

@MoeKeyNotificationPreview(name: '19 app')
Widget previewNotificationApp() => notificationPreviewItem('app');

@MoeKeyNotificationPreview(name: '20 test')
Widget previewNotificationTest() => notificationPreviewItem('test');

@MoeKeyNotificationPreview(name: '21 reaction:grouped likeOnly')
Widget previewNotificationReactionGroupedLikeOnly() =>
    notificationPreviewItem('reaction:grouped');

@MoeKeyNotificationPreview(name: '22 reaction:grouped default')
Widget previewNotificationReactionGrouped() =>
    notificationPreviewItem('reaction:grouped', groupedLikeOnly: false);

@MoeKeyNotificationPreview(name: '23 renote:grouped')
Widget previewNotificationRenoteGrouped() =>
    notificationPreviewItem('renote:grouped');

@MoeKeyNotificationPreview(name: '24 future unknown')
Widget previewNotificationUnknown() =>
    notificationPreviewItem('futureNotification');
