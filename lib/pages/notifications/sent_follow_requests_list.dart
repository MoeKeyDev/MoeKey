import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/follow_request.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_info_dialog.dart';
import 'package:moekey/widgets/mk_refresh_load.dart';
import 'package:moekey/widgets/mk_user_avatar.dart';

class SentFollowRequestsList extends ConsumerStatefulWidget {
  const SentFollowRequestsList({super.key});

  @override
  ConsumerState<SentFollowRequestsList> createState() =>
      _SentFollowRequestsListState();
}

class _SentFollowRequestsListState
    extends ConsumerState<SentFollowRequestsList> {
  static const _limit = 10;

  final List<FollowRequestModel> _requests = [];
  final Set<String> _busyRequestIds = {};
  bool _loading = false;
  bool _hasMore = true;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_refresh);
  }

  Future<List<FollowRequestModel>> _fetch({String? untilId}) {
    return ref
        .read(misskeyApisProvider)
        .following
        .requestsSent(limit: _limit, untilId: untilId);
  }

  Future<void> _refresh() async {
    final generation = ++_generation;
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    try {
      final requests = await _fetch();
      if (!mounted || generation != _generation) {
        return;
      }
      setState(() {
        _requests
          ..clear()
          ..addAll(requests);
        _hasMore = requests.length >= _limit;
      });
    } catch (_) {
      if (!mounted || generation != _generation) {
        return;
      }
      setState(() {
        _hasMore = false;
      });
      _showActionFailed();
    } finally {
      if (mounted && generation == _generation) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore || _requests.isEmpty) {
      return;
    }
    final generation = _generation;
    setState(() {
      _loading = true;
    });
    try {
      final requests = await _fetch(untilId: _requests.last.id);
      if (!mounted || generation != _generation) {
        return;
      }
      final existingIds = _requests.map((request) => request.id).toSet();
      setState(() {
        _requests.addAll(
          requests.where((request) => !existingIds.contains(request.id)),
        );
        _hasMore = requests.length >= _limit;
      });
    } catch (_) {
      if (mounted && generation == _generation) {
        _showActionFailed();
      }
    } finally {
      if (mounted && generation == _generation) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _cancel(FollowRequestModel request) async {
    if (_busyRequestIds.contains(request.id)) {
      return;
    }

    final user = request.followee;
    final confirmed = await MkConfirm.show(
      context: context,
      children: [
        Text(
          S.current.withdrawFollowRequestConfirm(user.name ?? user.username),
          textAlign: TextAlign.center,
        ),
      ],
    );
    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _busyRequestIds.add(request.id);
    });
    try {
      await ref
          .read(misskeyApisProvider)
          .following
          .requestsCancel(userId: user.id);
      if (!mounted) {
        return;
      }
      _removeRequest(request.id);
    } catch (_) {
      if (mounted) {
        _showActionFailed();
      }
    } finally {
      if (mounted) {
        setState(() {
          _busyRequestIds.remove(request.id);
        });
      }
    }
  }

  void _removeRequest(String requestId) {
    setState(() {
      _requests.removeWhere((item) => item.id == requestId);
    });
    if (_requests.isEmpty && _hasMore) {
      Future<void>.microtask(_refresh);
    }
  }

  void _showActionFailed() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.current.notifyActionFailed)));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = getPaddingForNote(constraints);
        final themes = ref.watch(themeColorsProvider);
        final listPadding = EdgeInsets.symmetric(horizontal: horizontalPadding);

        return MkRefreshLoadList(
          onLoad: _loadMore,
          onRefresh: _refresh,
          hasMore: _hasMore,
          empty: _requests.isEmpty,
          slivers: [
            SliverList.separated(
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final request = _requests[index];
                return Padding(
                  padding: listPadding,
                  child: _SentFollowRequestItem(
                    request: request,
                    busy: _busyRequestIds.contains(request.id),
                    borderRadius: index == 0
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          )
                        : BorderRadius.zero,
                    onCancel: () => _cancel(request),
                  ),
                );
              },
              separatorBuilder: (_, _) => Padding(
                padding: listPadding,
                child: SizedBox(
                  height: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: themes.dividerColor),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SentFollowRequestItem extends ConsumerWidget {
  const _SentFollowRequestItem({
    required this.request,
    required this.busy,
    required this.borderRadius,
    required this.onCancel,
  });

  final FollowRequestModel request;
  final bool busy;
  final BorderRadius borderRadius;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    final user = request.followee;

    return Material(
      color: themes.panelColor,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/user/${user.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _UserAvatar(user: user),
              const SizedBox(width: 12),
              Expanded(child: _UserInfo(user: user)),
              const SizedBox(width: 8),
              if (busy)
                const SizedBox.square(
                  dimension: 36,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                FilledButton.icon(
                  onPressed: onCancel,
                  style: FilledButton.styleFrom(
                    backgroundColor: themes.errorColor,
                    foregroundColor: themes.fgOnAccentColor,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  icon: const Icon(TablerIcons.x, size: 16),
                  label: Text(S.current.cancel),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.user});

  final UserLiteModel user;

  @override
  Widget build(BuildContext context) {
    return MkUserAvatar(
      size: 44,
      avatarUrl: user.avatarUrl,
      avatarBlurhash: user.avatarBlurhash,
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({required this.user});

  final UserLiteModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle.merge(
          style: const TextStyle(fontWeight: FontWeight.bold),
          child: MFMText(
            text: user.name ?? user.username,
            emojis: user.emojis,
            bigEmojiCode: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            feature: const [MFMFeature.emojiCode],
          ),
        ),
        const SizedBox(height: 2),
        Opacity(
          opacity: 0.7,
          child: Text(
            user.getAtUserName(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
