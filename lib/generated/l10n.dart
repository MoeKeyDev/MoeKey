// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Please Select Your Server`
  String get selectServer {
    return Intl.message(
      'Please Select Your Server',
      name: 'selectServer',
      desc: '',
      args: [],
    );
  }

  /// `List of Servers`
  String get serverList {
    return Intl.message(
      'List of Servers',
      name: 'serverList',
      desc: '',
      args: [],
    );
  }

  /// `Notes Count`
  String get notesCount {
    return Intl.message(
      'Notes Count',
      name: 'notesCount',
      desc: '',
      args: [],
    );
  }

  /// `Users Count`
  String get usersCount {
    return Intl.message(
      'Users Count',
      name: 'usersCount',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `open`
  String get registrationOpen {
    return Intl.message(
      'open',
      name: 'registrationOpen',
      desc: '',
      args: [],
    );
  }

  /// `closed`
  String get registrationClosed {
    return Intl.message(
      'closed',
      name: 'registrationClosed',
      desc: '',
      args: [],
    );
  }

  /// `Search Servers`
  String get searchServers {
    return Intl.message(
      'Search Servers',
      name: 'searchServers',
      desc: '',
      args: [],
    );
  }

  /// `Server Loading`
  String get loadingServers {
    return Intl.message(
      'Server Loading',
      name: 'loadingServers',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `没有找到你所在的服务器？`
  String get notFindServer {
    return Intl.message(
      '没有找到你所在的服务器？',
      name: 'notFindServer',
      desc: '',
      args: [],
    );
  }

  /// `手动输入服务器`
  String get inputServer {
    return Intl.message(
      '手动输入服务器',
      name: 'inputServer',
      desc: '',
      args: [],
    );
  }

  /// `服务器地址`
  String get serverAddr {
    return Intl.message(
      '服务器地址',
      name: 'serverAddr',
      desc: '',
      args: [],
    );
  }

  /// `下一步`
  String get next {
    return Intl.message(
      '下一步',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `时间线`
  String get timeline {
    return Intl.message(
      '时间线',
      name: 'timeline',
      desc: '',
      args: [],
    );
  }

  /// `通知`
  String get notifications {
    return Intl.message(
      '通知',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `便签`
  String get clips {
    return Intl.message(
      '便签',
      name: 'clips',
      desc: '',
      args: [],
    );
  }

  /// `网盘`
  String get drive {
    return Intl.message(
      '网盘',
      name: 'drive',
      desc: '',
      args: [],
    );
  }

  /// `发现`
  String get explore {
    return Intl.message(
      '发现',
      name: 'explore',
      desc: '',
      args: [],
    );
  }

  /// `公告`
  String get announcements {
    return Intl.message(
      '公告',
      name: 'announcements',
      desc: '',
      args: [],
    );
  }

  /// `搜索`
  String get search {
    return Intl.message(
      '搜索',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `更多`
  String get more {
    return Intl.message(
      '更多',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get settings {
    return Intl.message(
      '设置',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any lists`
  String get noLists {
    return Intl.message(
      'You don\'t have any lists',
      name: 'noLists',
      desc: '',
      args: [],
    );
  }

  /// `Got it!`
  String get gotIt {
    return Intl.message(
      'Got it!',
      name: 'gotIt',
      desc: '',
      args: [],
    );
  }

  /// `返回`
  String get back {
    return Intl.message(
      '返回',
      name: 'back',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);

  @override
  Future<S> load(Locale locale) => S.load(locale);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
