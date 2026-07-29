import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../generated/l10n.dart';
import '../status/apis.dart';
import 'mk_image.dart';

class LoadingCircularProgress extends StatelessWidget {
  const LoadingCircularProgress({
    super.key,
    this.size = 32,
    this.strokeWidth = 6,
    this.color,
    this.backgroundColor,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        strokeCap: StrokeCap.round,
        backgroundColor:
            backgroundColor ?? Theme.of(context).primaryColor.withAlpha(32),
        color: color ?? Theme.of(context).primaryColor.withAlpha(200),
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeCap: StrokeCap.round,
            backgroundColor: Theme.of(context).primaryColor.withAlpha(32),
            color: Theme.of(context).primaryColor.withAlpha(200),
            strokeWidth: 6,
          ),
          const SizedBox(height: 8),
          Text(S.current.loadingServers),
        ],
      ),
    );
  }
}

class MkErrorState extends ConsumerWidget {
  const MkErrorState({
    super.key,
    this.onRetry,
    this.message,
    this.compact = false,
  });

  final VoidCallback? onRetry;
  final String? message;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverErrorImageUrl = ref.watch(
      instanceMetaProvider.select((value) => value.value?.serverErrorImageUrl),
    );
    final hasServerErrorImage =
        serverErrorImageUrl != null && serverErrorImageUrl.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!compact) ...[
              if (hasServerErrorImage)
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: MkImage(
                    serverErrorImageUrl,
                    width: 112,
                    height: 112,
                    fit: BoxFit.contain,
                  ),
                )
              else
                Icon(
                  Icons.error_outline_rounded,
                  size: 72,
                  color: Theme.of(context).colorScheme.error,
                ),
              const SizedBox(height: 16),
            ],
            Text(message ?? S.current.notifyActionFailed),
            if (onRetry != null) ...[
              SizedBox(height: compact ? 4 : 12),
              if (compact)
                TextButton(onPressed: onRetry, child: Text(S.current.refresh))
              else
                FilledButton.tonal(
                  onPressed: onRetry,
                  child: Text(S.current.refresh),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyWidget extends ConsumerWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var infoUrl = ref.watch(
      instanceMetaProvider.select((value) => value.value?.infoImageUrl),
    );
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (infoUrl != null) ...[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: MkImage(
                infoUrl,
                width: 128,
                height: 128,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(S.current.noLists),
        ],
      ),
    );
  }
}

class LoadingAndEmpty extends StatelessWidget {
  final bool loading;
  final bool empty;
  final Widget child;
  final void Function() refresh;

  const LoadingAndEmpty({
    super.key,
    required this.loading,
    required this.empty,
    required this.child,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    if (loading && empty) {
      return const LoadingWidget();
    }
    if (empty) {
      return GestureDetector(
        onTap: refresh,
        behavior: HitTestBehavior.opaque,
        child: const EmptyWidget(),
      );
    }
    return child;
  }
}
