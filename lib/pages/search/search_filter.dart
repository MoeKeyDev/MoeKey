import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/user_full.dart';

enum SearchFilterScope { all, local, remote, host, user }

class SearchFilterModel {
  const SearchFilterModel({
    this.scope = SearchFilterScope.all,
    this.host = '',
    this.rangeStartAt,
    this.rangeEndAt,
    this.user,
  });

  final SearchFilterScope scope;
  final String host;
  final DateTime? rangeStartAt;
  final DateTime? rangeEndAt;
  final UserFullModel? user;
}

class SearchFilter extends Notifier<SearchFilterModel> {
  @override
  SearchFilterModel build() => const SearchFilterModel();

  void update({
    required SearchFilterScope scope,
    required String host,
    DateTime? rangeStartAt,
    DateTime? rangeEndAt,
    UserFullModel? user,
  }) {
    state = SearchFilterModel(
      scope: scope,
      host: host.trim(),
      rangeStartAt: rangeStartAt,
      rangeEndAt: rangeEndAt,
      user: user,
    );
  }
}

final searchFilterProvider = NotifierProvider<SearchFilter, SearchFilterModel>(
  SearchFilter.new,
);
