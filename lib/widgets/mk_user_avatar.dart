import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mk_image.dart';

/// A user avatar with an optional online indicator.
///
/// Pass [onlineStatus] only when the surrounding API payload contains a user
/// online state. Omitting it intentionally renders a plain avatar.
class MkUserAvatar extends ConsumerWidget {
  const MkUserAvatar({
    super.key,
    required this.size,
    this.avatarUrl,
    this.avatarBlurhash,
    this.onlineStatus,
    this.statusIndicatorSize,
    this.fit = BoxFit.cover,
  });

  final double size;
  final String? avatarUrl;
  final String? avatarBlurhash;
  final OnlineStatus? onlineStatus;
  final double? statusIndicatorSize;
  final BoxFit fit;

  bool get _isOnline =>
      onlineStatus == OnlineStatus.online ||
      onlineStatus == OnlineStatus.active;

  Color _indicatorColor(ThemeColorModel themes) {
    return switch (onlineStatus) {
      OnlineStatus.active => const Color(0xFFE4BC48),
      _ => themes.successColor,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    final indicatorSize = statusIndicatorSize ?? (size * 0.24).clamp(7.0, 12.0);
    final indicatorBorder = (size * 0.05).clamp(1.5, 2.5);
    final hasAvatar = avatarUrl?.isNotEmpty == true;

    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: hasAvatar
                ? MkImage(
                    avatarUrl!,
                    width: size,
                    height: size,
                    blurHash: avatarBlurhash,
                    fit: fit,
                    shape: BoxShape.circle,
                  )
                : DecoratedBox(
                    decoration: BoxDecoration(
                      color: themes.buttonHoverBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(TablerIcons.user, size: size * 0.45),
                  ),
          ),
          if (_isOnline)
            Positioned(
              left: -indicatorBorder / 2,
              bottom: -indicatorBorder / 2,
              child: DecoratedBox(
                key: const ValueKey('mk-user-avatar-online-indicator'),
                decoration: BoxDecoration(
                  color: themes.panelColor,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(indicatorBorder),
                  child: SizedBox.square(
                    dimension: indicatorSize,
                    child: DecoratedBox(
                      key: const ValueKey(
                        'mk-user-avatar-online-indicator-fill',
                      ),
                      decoration: BoxDecoration(
                        color: _indicatorColor(themes),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
