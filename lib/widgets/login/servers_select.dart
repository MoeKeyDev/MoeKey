import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/parser.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/login/servers_select_state.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_image.dart';

import '../../generated/l10n.dart';
import '../../status/server.dart';
import '../../status/themes.dart';
import '../mk_input.dart';
import 'login_dialog.dart';

class ServersSelectCard extends HookConsumerWidget {
  const ServersSelectCard({super.key});

  login(BuildContext context, WidgetRef ref, String url) {
    ref.read(selectServerHostProvider.notifier).setServer(url);
    // context.go("/login/dialog");
    showDialog(context: context, builder: (context) => LoginDialog());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var list = ref.watch(instanceListStateProvider);
    var url = useState("");
    var filterList = instanceListFilter(list.valueOrNull ?? [], url.value);
    return MkCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(S.current.selectServer),
              ),
            ),
            Divider(color: themes.dividerColor, height: 0.5),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                decoration: inputDecoration(
                  themes,
                  S.current.searchServers,
                  prefixIcon: const Icon(TablerIcons.server),
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  url.value = value;
                },
                onFieldSubmitted: (value) {
                  if (value.isEmpty) return;
                  // 纯域名
                  if (RegExp("^https?://.+").hasMatch(value)) {
                    // 如果最后是以 / 结尾 尝试删除
                    if (value.endsWith('/')) {
                      value = value.substring(0, value.length - 1);
                    }
                    login(context, ref, value);
                    return;
                  }
                  login(context, ref, "https://$value");
                },
              ),
            ),
            Divider(color: themes.dividerColor, height: 0.5),
            Expanded(
                child: LoadingAndEmpty(
              loading: list.isLoading,
              empty: filterList.isEmpty,
              refresh: () {
                ref.invalidate(instanceListStateProvider);
              },
              child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    var data = filterList[index];
                    return ListTile(
                      onTap: () {
                        login(context, ref, data["meta"]["uri"]);
                      },
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: data["meta"]["iconUrl"] != null
                            ? MkImage(
                                data["meta"]["iconUrl"],
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                "assets/favicon.ico",
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                              ),
                      ),
                      //"assets/favicon.ico"
                      title: Text(data["name"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(data["url"]),
                          Text(
                            parse(data['description'] ?? "").body!.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Divider(color: themes.dividerColor, height: 0.5),
                  itemCount: filterList.length),
            ))
          ],
        ));
  }
}
