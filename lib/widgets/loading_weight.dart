import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class LoadingCircularProgress extends StatelessWidget {
  const LoadingCircularProgress(
      {super.key, this.size = 32, this.strokeWidth = 6});
  final double size;
  final double strokeWidth;
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
        dimension: size,
        child: CircularProgressIndicator(
          strokeCap: StrokeCap.round,
          backgroundColor: Theme.of(context).primaryColor.withAlpha(32),
          color: Theme.of(context).primaryColor.withAlpha(200),
          strokeWidth: strokeWidth,
        ));
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

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
          const SizedBox(
            height: 8,
          ),
          Text(S.current.loadingServers),
        ],
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
  const LoadingAndEmpty(
      {super.key,
      required this.loading,
      required this.empty,
      required this.child,
      required this.refresh});

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
