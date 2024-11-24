import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/clips/clips.dart';
import 'package:moekey/widgets/clips/clips_create_dialog_state.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_input.dart';
import 'package:moekey/widgets/mk_modal.dart';
import 'package:moekey/widgets/mk_switch.dart';

import '../../apis/models/clips.dart';
import '../../status/themes.dart';

class ClipCreateDialog extends HookConsumerWidget {
  const ClipCreateDialog({
    super.key,
    this.clipId,
  });

  final String? clipId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var provider = clipCreateDialogStateProvider(clipId: clipId);
    var state = ref.watch(provider);
    var clipData = useState<ClipsModel?>(null);
    var loading = useState<bool>(false);
    useEffect(() {
      if (clipId == null) return;
      ref.read(clipsShowProvider(clipId!).future).then((value) {
        clipData.value = value;
        if (value == null) {
          return;
        }
        var notifier = ref.read(provider.notifier);
        notifier.updateName(value.name);
        notifier.updateDescription(value.description ?? '');
        notifier.updateIsPublic(value.isPublic);
      });
      return null;
    }, [clipId]);
    return MkModal(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              if (clipId == null ||
                  (clipId != null && clipData.value != null)) ...[
                MkInput(
                    label: "名称",
                    initialValue: state.name,
                    onChanged: (name) {
                      ref.read(provider.notifier).updateName(name);
                    }),
                const SizedBox(
                  height: 24,
                ),
                MkInput(
                  label: "描述",
                  initialValue: state.description,
                  maxLines: 6,
                  onChanged: (description) {
                    ref.read(provider.notifier).updateDescription(description);
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTapUp: (details) {
                      ref
                          .read(provider.notifier)
                          .updateIsPreview(!state.isPreview);
                    },
                    child: Text(
                      "预览",
                      style: TextStyle(color: themes.accentColor),
                    ),
                  ),
                ),
                if (state.isPreview) ...[
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: themes.bgColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: MFMText(text: state.description),
                  )
                ],
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    MkSwitch(
                      value: state.isPublic,
                      onChanged: (value) {
                        ref.read(provider.notifier).updateIsPublic(value);
                      },
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text("公开")
                  ],
                )
              ]
            ],
          ),
        ),
      ),
      appbar: Row(
        children: [
          const SizedBox(
            width: 4,
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              TablerIcons.x,
              size: 18,
              color: themes.fgColor,
            ),
          ),
          Text(
            clipId != null ? "更新便签" : "新建便签",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            onPressed: loading.value
                ? null
                : () async {
                    loading.value = true;
                    var data = await ref.read(provider.notifier).send(context);
                    loading.value = false;
                    if (data != null) {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
            icon: Icon(
              TablerIcons.check,
              size: 18,
              color: themes.fgColor,
            ),
          )
        ],
      ),
    );
  }
}
