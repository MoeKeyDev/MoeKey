import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mfm_parser/mfm_parser.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/widgets/mfm_text/animate/jelly.dart';
import 'package:twemoji_v2/twemoji_v2.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../apis/models/emojis.dart';
import '../../main.dart';
import '../../pages/users/user_page.dart';
import '../../router/main_router_delegate.dart';
import '../../status/themes.dart';
import '../hover_builder.dart';
import '../mk_image.dart';
import 'animate/spin.dart';

class MFMText extends HookConsumerWidget {
  final String text;
  final Map? emojis;
  final int? maxLines;
  final bool bigEmojiCode;
  final bool isSelection;
  final List<InlineSpan>? before;
  final List<InlineSpan>? after;
  final TextOverflow overflow;
  final String? defaultServerHost;
  final List<MFMFeature>? feature;
  final String? currentServerHost;
  final TextAlign? textAlign;

  const MFMText({
    super.key,
    required this.text,
    this.emojis,
    this.maxLines,
    this.bigEmojiCode = true,
    this.before,
    this.after,
    this.overflow = TextOverflow.clip,
    this.defaultServerHost,
    this.feature,
    this.isSelection = false,
    this.currentServerHost,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var meta = ref.watch(instanceMetaProvider);
    var emoji = ref.watch(apiEmojisProvider);
    var lastText = useState<String?>(null);
    var mfmParse = useState<List<MfmNode>>([]);
    var textStyle = DefaultTextStyle.of(context).style;
    if (lastText.value != text) {
      mfmParse.value = const MfmParser().parse(text);
    }
    var parse = _getParse(
      feature: feature,
      emojis: emojis,
      bigEmojiCode: bigEmojiCode,
      defaultServerHost: defaultServerHost,
      themes: themes,
      loginServerUrl: meta.valueOrNull?.uri ?? "",
      currentServerHost: currentServerHost,
      systemEmojis: emoji.valueOrNull ?? {},
    );

    var textSpan = useMemoized(
      () {
        return [
          for (var item in mfmParse.value)
            if (parse[item.type] != null)
              parse[item.type](
                item,
                textStyle,
              )
            else
              TextSpan(text: item.toString()),
        ];
      },
    );

    Widget rich = RepaintBoundary(
      child: Text.rich(
        TextSpan(
          children: [...?before, ...textSpan, ...?after],
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      ),
    );
    lastText.value = text;
    if (isSelection) {
      rich = SelectionArea(
        child: rich,
      );
    }
    return rich;
  }
}

_getParse({
  List<MFMFeature>? feature,
  Map? emojis,
  bool bigEmojiCode = true,
  String? defaultServerHost,
  required ThemeColorModel themes,
  required String loginServerUrl,
  String? currentServerHost,
  required Map<String, EmojiSimple> systemEmojis,
}) {
  feature ??= [
    MFMFeature.hashtag,
    MFMFeature.url,
    MFMFeature.emojiCode,
    MFMFeature.mention,
  ];
  return {
    "text": (MfmText item, TextStyle textStyle) {
      return TextSpan(text: item.props?["text"], style: textStyle);
    },
    "plain": (MfmPlain item, TextStyle textStyle) {
      return TextSpan(text: item.text, style: textStyle);
    },
    "unicodeEmoji": (MfmUnicodeEmoji item, TextStyle textStyle) {
      return TwemojiTextSpan(text: item.props?["emoji"], style: textStyle);
    },
    "hashtag": (MfmHashTag item, TextStyle textStyle) {
      if (feature!.contains(MFMFeature.hashtag)) {
        return TextSpan(
          text: "#${item.props?["hashtag"]}",
          style: textStyle.copyWith(color: themes.accentColor),
        );
      } else {
        return TextSpan(text: "#${item.props?["hashtag"]}");
      }
    },
    "url": (MfmURL item, TextStyle textStyle) {
      if (feature!.contains(MFMFeature.url)) {
        return TextSpan(
          children: [
            TextSpan(
              text: item.props?["url"],
              style: textStyle.copyWith(
                color: themes.accentColor,
              ),
              mouseCursor: SystemMouseCursors.click,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrlString(item.props?["url"]);
                },
            ),
            WidgetSpan(
                child: Icon(
                  TablerIcons.external_link,
                  color: themes.accentColor,
                  size: textStyle.fontSize! + 2,
                ),
                alignment: PlaceholderAlignment.middle)
          ],
        );
      } else {
        return TextSpan(text: item.props?["url"]);
      }
    },
    "link": (MfmLink item, TextStyle textStyle) {
      var a = item.children;
      if (a != null) {
        textStyle = textStyle.copyWith(
          color: themes.accentColor,
        );
        var parse = _getParse(
          themes: themes,
          loginServerUrl: loginServerUrl,
          systemEmojis: systemEmojis,
          emojis: emojis,
          defaultServerHost: currentServerHost,
          bigEmojiCode: bigEmojiCode,
          feature: feature,
          currentServerHost: currentServerHost,
        );
        return WidgetSpan(
          child: Tooltip(
            message: item.url,
            child: GestureDetector(
              onTap: () {
                launchUrlString(item.url);
              },
              child: Text.rich(
                TextSpan(
                  // text: item.url,
                  style: textStyle.copyWith(
                    color: themes.accentColor,
                  ),
                  children: [
                    for (var item1 in a)
                      if (parse[item1.type] != null)
                        parse[item1.type](item1, textStyle)
                      else
                        TextSpan(text: item.toString(), style: textStyle),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          launchUrlString(item.url);
                        },
                        child: Icon(
                          TablerIcons.external_link,
                          color: themes.accentColor,
                          size: textStyle.fontSize! + 2,
                        ),
                      ),
                      alignment: PlaceholderAlignment.middle,
                    )
                  ],
                  mouseCursor: SystemMouseCursors.click,
                ),
              ),
            ),
          ),
        );
      }
    },
    "emojiCode": (MfmEmojiCode item, TextStyle textStyle) {
      if (feature!.contains(MFMFeature.emojiCode)) {
        return WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Builder(
            builder: (context) {
              var url = "";
              if (systemEmojis[item.props!["name"]] != null) {
                url = systemEmojis[item.props!["name"]]!.url;
              } else if (emojis?[item.props!["name"]] != null) {
                url = emojis?[item.props!["name"]];
              }
              return HoverBuilder(
                builder: (context, isHover) {
                  return Tooltip(
                    message: ":${item.props!["name"]}:",
                    child: AnimatedScale(
                      scale: isHover ? 1.3 : 1,
                      duration: const Duration(milliseconds: 100),
                      child: SizedBox(
                        height: bigEmojiCode
                            ? textStyle.fontSize! * 2
                            : textStyle.fontSize! + 1,
                        child: MkImage(
                          url,
                          height: bigEmojiCode
                              ? textStyle.fontSize! * 2
                              : textStyle.fontSize! + 1,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      } else {
        return TextSpan(text: ":${item.props!["name"]}:");
      }
    },
    "mention": (MfmMention item, TextStyle textStyle) {
      if (feature!.contains(MFMFeature.mention)) {
        var currentHost = Uri.parse(loginServerUrl).host;
        return WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Builder(
              builder: (context) {
                String user = item.props?["username"]!;
                var host = item.props?["host"] ?? currentServerHost;
                return GestureDetector(
                  onTap: () {
                    MainRouterDelegate.of(context).setNewRoutePath(RouterItem(
                      path: "user/@$user${host != null ? "@$host" : ""}",
                      page: () {
                        return UserPage(username: user, host: host);
                      },
                    ));
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: themes.mentionColor.withOpacity(0.1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MkImage(
                              "$loginServerUrl/avatar/@$user${host != null ? "@$host" : ""}",
                              height: textStyle.fontSize! * 1.5,
                              shape: BoxShape.circle,
                            ),
                            Expanded(
                                child: Text.rich(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: "@$user",
                                      style: textStyle.copyWith(
                                          color: themes.mentionColor)),
                                  if (host != null && host != currentHost)
                                    TextSpan(
                                        text: "@$host",
                                        style: textStyle.copyWith(
                                          color: themes.mentionColor
                                              .withOpacity(0.5),
                                        )),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ));
      } else {
        return TextSpan(
            text:
                "@${item.props?["username"]!}${item.props?["host"] != null ? "@${item.props?["host"]}" : ""}");
      }
    },
    "bold": (MfmBold item, TextStyle textStyle) {
      var parse = _getParse(
        themes: themes,
        loginServerUrl: loginServerUrl,
        systemEmojis: systemEmojis,
        emojis: emojis,
        defaultServerHost: currentServerHost,
        bigEmojiCode: bigEmojiCode,
        feature: feature,
        currentServerHost: currentServerHost,
      );
      var a = item.children;
      if (a != null) {
        textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
        return TextSpan(children: [
          for (var item in a)
            if (parse[item.type] != null)
              parse[item.type](item, textStyle)
            else
              TextSpan(text: item.toString(), style: textStyle),
        ]);
      }
    },
    "strike": (MfmStrike item, TextStyle textStyle) {
      var parse = _getParse(
        themes: themes,
        loginServerUrl: loginServerUrl,
        systemEmojis: systemEmojis,
        emojis: emojis,
        defaultServerHost: currentServerHost,
        bigEmojiCode: bigEmojiCode,
        feature: feature,
        currentServerHost: currentServerHost,
      );
      var a = item.children;
      if (a != null) {
        textStyle = textStyle.copyWith(decoration: TextDecoration.lineThrough);
        return TextSpan(children: [
          for (var item in a)
            if (parse[item.type] != null)
              parse[item.type](item, textStyle)
            else
              TextSpan(text: item.toString(), style: textStyle),
        ]);
      }
    },
    "inlineCode": (MfmInlineCode item, TextStyle textStyle) {
      return WidgetSpan(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 30, 30, 30),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Text(item.code,
                style: textStyle.copyWith(
                    color: Colors.white, fontFamily: "Consolas")),
          ),
          alignment: PlaceholderAlignment.middle);
    },
    "quote": (MfmQuote item, TextStyle textStyle) {
      var parse = _getParse(
        themes: themes,
        loginServerUrl: loginServerUrl,
        systemEmojis: systemEmojis,
        emojis: emojis,
        defaultServerHost: currentServerHost,
        bigEmojiCode: bigEmojiCode,
        feature: feature,
        currentServerHost: currentServerHost,
      );
      var a = item.children;
      if (a != null) {
        var text = Text.rich(TextSpan(children: [
          for (var item in a)
            if (parse[item.type] != null)
              parse[item.type](item, textStyle)
            else
              TextSpan(text: item.toString(), style: textStyle),
        ]));
        return WidgetSpan(
          child: Opacity(
            opacity: 0.7,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(8, 6, 0, 6),
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(color: themes.fgColor, width: 3))),
                child: text,
              ),
            ),
          ),
        );
      }
      return const TextSpan();
    },
    "blockCode": (MfmCodeBlock item, TextStyle textStyle) {
      return WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 30, 30, 30),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Text(item.code,
                style: textStyle.copyWith(
                    color: Colors.white, fontFamily: "Consolas")),
          ),
        ),
      );
    },
    "center": (MfmCenter item, TextStyle textStyle) {
      var parse = _getParse(
        themes: themes,
        loginServerUrl: loginServerUrl,
        systemEmojis: systemEmojis,
        emojis: emojis,
        defaultServerHost: currentServerHost,
        bigEmojiCode: bigEmojiCode,
        feature: feature,
        currentServerHost: currentServerHost,
      );
      var a = item.children;
      if (a != null) {
        var text = Text.rich(
            TextSpan(children: [
              for (var item in a)
                if (parse[item.type] != null)
                  parse[item.type](item, textStyle)
                else
                  TextSpan(text: item.toString(), style: textStyle),
            ]),
            textAlign: TextAlign.center);
        return WidgetSpan(
          child: SizedBox(
            width: double.infinity,
            child: text,
          ),
        );
      }
      return const TextSpan();
    },
    "small": (MfmInline item, TextStyle textStyle) {
      var parse = _getParse(
        themes: themes,
        loginServerUrl: loginServerUrl,
        systemEmojis: systemEmojis,
        emojis: emojis,
        defaultServerHost: currentServerHost,
        bigEmojiCode: bigEmojiCode,
        feature: feature,
        currentServerHost: currentServerHost,
      );
      var a = item.children;
      if (a != null) {
        if (item.runtimeType == MfmItalic) {
          textStyle = textStyle.copyWith(fontStyle: FontStyle.italic);
        } else {
          textStyle = textStyle.copyWith(
              fontSize: 12, color: textStyle.color?.withOpacity(0.7));
        }
        return TextSpan(children: [
          for (var item in a)
            if (parse[item.type] != null)
              parse[item.type](item, textStyle)
            else
              TextSpan(text: item.toString(), style: textStyle),
        ]);
      }
    },
    "search": (MfmSearch item, TextStyle textStyle) {
      logger.d(item.query);

      return WidgetSpan(
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Text(
                item.query,
                style: textStyle.copyWith(
                    color: themes.accentColor,
                    decoration: TextDecoration.underline),
              ),
              Icon(
                TablerIcons.search,
                size: textStyle.fontSize,
                color: themes.accentColor,
              )
            ],
          ),
        ),
      );
    },
    "fn": (MfmFn item, TextStyle textStyle) {
      // logger.d(item.props?["name"]);
      // logger.d(item.args);
      var parse = _getParse(
        themes: themes,
        loginServerUrl: loginServerUrl,
        systemEmojis: systemEmojis,
        emojis: emojis,
        defaultServerHost: currentServerHost,
        bigEmojiCode: bigEmojiCode,
        feature: feature,
        currentServerHost: currentServerHost,
      );
      var child = TextSpan(children: [
        for (var item in item.children ?? [])
          if (parse[item.type] != null)
            parse[item.type](item, textStyle)
          else
            TextSpan(text: item.toString(), style: textStyle),
      ]);
      switch (item.props?["name"]) {
        case "flip":
          return WidgetSpan(
              child: Transform.flip(
            flipX: item.args["h"] != null || item.args.isEmpty,
            flipY: item.args["v"] != null,
            child: Text.rich(child),
          ));
        case "jelly":
          return WidgetSpan(
              child: MfmJellyCode(
                speed: parseDuration(item.args["speed"]),
                child: Text.rich(child),
              ),
              style: textStyle,
              alignment: PlaceholderAlignment.middle);
        case "tada":
          return child;
        case "jump":
          return child;
        case "bounce":
          return child;
        case "shake":
          return child;
        case "twitch":
          return child;
        case "spin":
          return WidgetSpan(
              child: MfmSpinCode(
                x: item.args["x"] != null,
                y: item.args["y"] != null,
                speed: parseDuration(item.args["speed"]),
                left: item.args["left"] != null,
                alternate: item.args["alternate"] != null,
                child: Text.rich(child),
              ),
              style: textStyle,
              alignment: PlaceholderAlignment.middle);
        case "x2":
          var child = getTextSpan(item, parse,
              textStyle.copyWith(fontSize: textStyle.fontSize! * 2));
          return WidgetSpan(
            child: SizedBox(
              width: double.infinity,
              child: Text.rich(child),
            ),
          );
        case "x3":
          var child = getTextSpan(item, parse,
              textStyle.copyWith(fontSize: textStyle.fontSize! * 4));
          return WidgetSpan(
            child: SizedBox(
              width: double.infinity,
              child: Text.rich(child),
            ),
          );
        case "x4":
          var child = getTextSpan(item, parse,
              textStyle.copyWith(fontSize: textStyle.fontSize! * 6));
          return WidgetSpan(
            child: SizedBox(
              width: double.infinity,
              child: Text.rich(child),
            ),
          );
        case "position":
          return child;
        case "blur":
          return child;
        case "fg":
          return child;
        case "bg":
          return child;
        case "font":
          return child;
        case "rotate":
          return child;
        case "scale":
          return child;
        case "rainbow":
          return child;
        case "sparkle":
          return child;
      }
      return TextSpan(text: item.toString(), style: textStyle);
    }
  };
}

TextSpan getTextSpan(MfmFn item, parse, TextStyle textStyle) {
  return TextSpan(children: [
    for (var item in item.children ?? [])
      if (parse[item.type] != null)
        parse[item.type](item, textStyle)
      else
        TextSpan(text: item.toString(), style: textStyle),
  ]);
}

enum MFMFeature {
  hashtag,
  url,
  emojiCode,
  mention,
}

Duration parseDuration(String? input) {
  if (input == null) {
    return const Duration(milliseconds: 1500);
  }
  Duration duration;
  try {
    duration = Duration(
        milliseconds:
            (double.parse(input.replaceAll(RegExp(r'[^\d\.]'), '')) * 1000)
                .toInt());
  } catch (e) {
    duration = const Duration(milliseconds: 1500);
  }
  return duration;
}
