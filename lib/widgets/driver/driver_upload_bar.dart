import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/networks/drive.dart';
import 'package:moekey/widgets/blur_widget.dart';
import 'package:path/path.dart';

class DriverUploadBar extends ConsumerWidget {
  const DriverUploadBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var data = ref.watch(driverUploaderProvider);
    var list = [];
    for (var item in data) {
      if (item["done"]) continue;
      list.add(item);
    }
    return Positioned(
      top: 12,
      right: 12,
      child: IgnorePointer(
        ignoring: true,
        child: SizedBox(
          width: 300,
          height: MediaQuery.of(context).size.height,
          child: Material(
            color: Colors.transparent,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                            blurStyle: BlurStyle.outer)
                      ]),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6),
                    ),
                    child: BlurWidget(
                      child: ListTile(
                        leading: [
                          if ([".jpg", ".png", ".jpeg"]
                              .contains(extension(item["path"]).toLowerCase()))
                            Image.file(File(item["path"]),
                                height: 50, width: 50, fit: BoxFit.cover)
                          else
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                  extension(item["path"])
                                      .substring(1)
                                      .toUpperCase(),
                                  style: const TextStyle(fontSize: 18)),
                            )
                        ][0],
                        title: Text(
                          basename(item["path"]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontSize: 12),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: LinearProgressIndicator(
                            backgroundColor:
                                Theme.of(context).primaryColor.withAlpha(32),
                            color:
                                Theme.of(context).primaryColor.withAlpha(200),
                            value: item["progress"] != 1
                                ? item["progress"]
                                : item["done"]
                                    ? 1
                                    : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
