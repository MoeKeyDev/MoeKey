import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/utils/format_duration.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/mk_info_dialog.dart';

typedef NotePollVote = Future<void> Function(String noteId, int choice);

/// A poll attached to a note.
///
/// Poll-specific state and interactions live here so that `NoteCard` only
/// needs to decide where the attachment is rendered.
class NotePoll extends HookConsumerWidget {
  const NotePoll({super.key, required this.data, this.onVote});

  final NoteModel data;
  final NotePollVote? onVote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    final poll = data.poll!;
    final now = useState(DateTime.now());
    final loadingChoice = useState<int?>(null);
    final rebuild = useState(0);

    final count = poll.choices.fold<int>(
      0,
      (total, choice) => total + choice.votes,
    );
    final hasVotedChoice = poll.choices.any((choice) => choice.isVoted);
    final singleChoiceCompleted = !poll.multiple && hasVotedChoice;
    final duration = poll.expiresAt?.difference(now.value).inMilliseconds;
    final isExpired = duration != null && duration <= 0;
    final showResult = useState(singleChoiceCompleted || isExpired);

    useEffect(() {
      if (poll.expiresAt == null || isExpired) {
        return null;
      }
      final timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => now.value = DateTime.now(),
      );
      return timer.cancel;
    }, [poll.expiresAt, isExpired]);

    useEffect(() {
      if (singleChoiceCompleted || isExpired) {
        showResult.value = true;
      }
      return null;
    }, [singleChoiceCompleted, isExpired]);

    Future<void> vote(int index) async {
      final currentPoll = data.poll!;
      final choice = currentPoll.choices[index];
      final alreadyCompleted =
          !currentPoll.multiple &&
          currentPoll.choices.any((item) => item.isVoted);
      if (loadingChoice.value != null ||
          isExpired ||
          alreadyCompleted ||
          choice.isVoted) {
        return;
      }

      final confirmed =
          await MkConfirm.show(
            context: context,
            children: [
              Icon(
                TablerIcons.help_circle,
                size: 36,
                color: themes.accentColor,
              ),
              const SizedBox(height: 12),
              Text(
                S.current.voteConfirm(choice.text),
                textAlign: TextAlign.center,
              ),
            ],
          ) ??
          false;
      if (!confirmed || !context.mounted) {
        return;
      }

      loadingChoice.value = index;
      try {
        if (onVote != null) {
          await onVote!(data.id, index);
        } else {
          await ref
              .read(misskeyApisProvider)
              .notes
              .votePoll(noteId: data.id, choice: index);
        }

        final latestPoll = data.poll!;
        final choices = [...latestPoll.choices];
        final latestChoice = choices[index];
        choices[index] = latestChoice.copyWith(
          votes: latestChoice.votes + 1,
          isVoted: true,
        );
        data.poll = latestPoll.copyWith(choices: choices);
        if (!latestPoll.multiple) {
          showResult.value = true;
        }
        rebuild.value++;
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(S.current.voteFailed)));
        }
      } finally {
        if (context.mounted) {
          loadingChoice.value = null;
        }
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, item) in poll.choices.indexed)
          Builder(
            builder: (context) {
              final canVote =
                  loadingChoice.value == null &&
                  !isExpired &&
                  !singleChoiceCompleted &&
                  !item.isVoted;
              return MouseRegion(
                cursor: canVote
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: canVote ? () => vote(index) : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: themes.accentedBgColor,
                              ),
                            ),
                            AnimatedFractionallySizedBox(
                              duration: const Duration(milliseconds: 300),
                              widthFactor: count == 0 || !showResult.value
                                  ? 0
                                  : item.votes / count,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: themes.accentColor,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Container(
                                margin: const EdgeInsets.only(left: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: themes.panelColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (item.isVoted)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4,
                                        ),
                                        child: Icon(
                                          TablerIcons.check,
                                          size: 16,
                                          color: themes.accentColor,
                                        ),
                                      ),
                                    Text(item.text),
                                    if (showResult.value)
                                      Opacity(
                                        opacity: 0.7,
                                        child: Text(
                                          ' ${S.current.voteCount(item.votes)} ',
                                        ),
                                      ),
                                    if (loadingChoice.value == index) ...[
                                      const SizedBox(width: 6),
                                      const LoadingCircularProgress(
                                        size: 14,
                                        strokeWidth: 2,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(S.current.voteAllCount(count)),
            if (!isExpired && !singleChoiceCompleted) ...[
              const Text(' · '),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => showResult.value = !showResult.value,
                child: Text(
                  showResult.value ? S.current.vote : S.current.voteShowResult,
                  style: TextStyle(color: themes.accentColor),
                ),
              ),
            ] else if (singleChoiceCompleted)
              Text(' · ${S.current.voteVoted}')
            else
              Text(' · ${S.current.voteExpired}'),
            if (!isExpired && duration != null) ...[
              const Text(' · '),
              Text(S.current.voteWillExpired(formatDuration(duration))),
            ],
          ],
        ),
      ],
    );
  }
}
