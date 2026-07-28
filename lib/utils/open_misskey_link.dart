import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

String? resolveLocalMisskeyRoute({
  required String url,
  required String instanceUrl,
}) {
  final target = Uri.tryParse(url.trim());
  final instance = Uri.tryParse(instanceUrl.trim());
  if (target == null ||
      instance == null ||
      !target.hasAuthority ||
      !instance.hasAuthority ||
      !_isHttpUri(target) ||
      !_isHttpUri(instance) ||
      target.host.toLowerCase() != instance.host.toLowerCase() ||
      _effectivePort(target) != _effectivePort(instance)) {
    return null;
  }

  final segments = target.pathSegments.where((part) => part.isNotEmpty).toList();
  if (segments.length == 2) {
    final id = Uri.encodeComponent(segments[1]);
    switch (segments[0]) {
      case 'notes':
        return '/notes/$id';
      case 'users':
        return '/user/$id';
      case 'tags':
        return '/tags/$id';
      case 'clips':
        return '/clips/$id';
    }
  }

  if (segments.length == 1 && segments.first.startsWith('@')) {
    final account = segments.first.substring(1);
    if (account.isEmpty) return null;

    final hostSeparator = account.lastIndexOf('@');
    if (hostSeparator < 0) {
      return '/user/null/${Uri.encodeComponent(account)}';
    }

    final username = account.substring(0, hostSeparator);
    final host = account.substring(hostSeparator + 1);
    if (username.isEmpty || host.isEmpty) return null;
    return '/user/${Uri.encodeComponent(host)}/${Uri.encodeComponent(username)}';
  }

  return null;
}

Future<void> openMisskeyLink(
  BuildContext context, {
  required String url,
  required String instanceUrl,
}) async {
  final route = resolveLocalMisskeyRoute(
    url: url,
    instanceUrl: instanceUrl,
  );
  if (route != null) {
    context.push(route);
    return;
  }
  await launchUrlString(url);
}

bool _isHttpUri(Uri uri) => uri.scheme == 'http' || uri.scheme == 'https';

int _effectivePort(Uri uri) {
  if (uri.hasPort) return uri.port;
  return uri.scheme == 'https' ? 443 : 80;
}
