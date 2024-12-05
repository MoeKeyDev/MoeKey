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

  /// `请选择服务器`
  String get selectServer {
    return Intl.message(
      '请选择服务器',
      name: 'selectServer',
      desc: '',
      args: [],
    );
  }

  /// `服务器列表`
  String get serverList {
    return Intl.message(
      '服务器列表',
      name: 'serverList',
      desc: '',
      args: [],
    );
  }

  /// `帖子数`
  String get notesCount {
    return Intl.message(
      '帖子数',
      name: 'notesCount',
      desc: '',
      args: [],
    );
  }

  /// `用户数`
  String get usersCount {
    return Intl.message(
      '用户数',
      name: 'usersCount',
      desc: '',
      args: [],
    );
  }

  /// `注册模式`
  String get registration {
    return Intl.message(
      '注册模式',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `开放`
  String get registrationOpen {
    return Intl.message(
      '开放',
      name: 'registrationOpen',
      desc: '',
      args: [],
    );
  }

  /// `邀请制`
  String get registrationClosed {
    return Intl.message(
      '邀请制',
      name: 'registrationClosed',
      desc: '',
      args: [],
    );
  }

  /// `搜索服务器名称或者域名`
  String get searchServers {
    return Intl.message(
      '搜索服务器名称或者域名',
      name: 'searchServers',
      desc: '',
      args: [],
    );
  }

  /// `服务器正在加载`
  String get loadingServers {
    return Intl.message(
      '服务器正在加载',
      name: 'loadingServers',
      desc: '',
      args: [],
    );
  }

  /// `过滤`
  String get filter {
    return Intl.message(
      '过滤',
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

  /// `查看更多`
  String get viewMore {
    return Intl.message(
      '查看更多',
      name: 'viewMore',
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

  /// `列表为空`
  String get noLists {
    return Intl.message(
      '列表为空',
      name: 'noLists',
      desc: '',
      args: [],
    );
  }

  /// `我明白了`
  String get gotIt {
    return Intl.message(
      '我明白了',
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

  /// `名称`
  String get name {
    return Intl.message(
      '名称',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `描述`
  String get description {
    return Intl.message(
      '描述',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `预览`
  String get preview {
    return Intl.message(
      '预览',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `公开`
  String get public {
    return Intl.message(
      '公开',
      name: 'public',
      desc: '',
      args: [],
    );
  }

  /// `名称不能为空`
  String get nameCannotBeEmpty {
    return Intl.message(
      '名称不能为空',
      name: 'nameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `创建失败\n\n {error}`
  String creationFailedDialog(Object error) {
    return Intl.message(
      '创建失败\n\n $error',
      name: 'creationFailedDialog',
      desc: '',
      args: [error],
    );
  }

  /// `刚刚`
  String get justNow {
    return Intl.message(
      '刚刚',
      name: 'justNow',
      desc: '',
      args: [],
    );
  }

  /// `{seconds}秒前`
  String secondsAgo(Object seconds) {
    return Intl.message(
      '$seconds秒前',
      name: 'secondsAgo',
      desc: '',
      args: [seconds],
    );
  }

  /// `{minutes}分钟前`
  String minutesAgo(Object minutes) {
    return Intl.message(
      '$minutes分钟前',
      name: 'minutesAgo',
      desc: '',
      args: [minutes],
    );
  }

  /// `{hours}小时前`
  String hoursAgo(Object hours) {
    return Intl.message(
      '$hours小时前',
      name: 'hoursAgo',
      desc: '',
      args: [hours],
    );
  }

  /// `{days}天前`
  String daysAgo(Object days) {
    return Intl.message(
      '$days天前',
      name: 'daysAgo',
      desc: '',
      args: [days],
    );
  }

  /// `{months}个月前`
  String monthsAgo(Object months) {
    return Intl.message(
      '$months个月前',
      name: 'monthsAgo',
      desc: '',
      args: [months],
    );
  }

  /// `{years}年前`
  String yearsAgo(Object years) {
    return Intl.message(
      '$years年前',
      name: 'yearsAgo',
      desc: '',
      args: [years],
    );
  }

  /// `保留原图`
  String get keepOriginal {
    return Intl.message(
      '保留原图',
      name: 'keepOriginal',
      desc: '',
      args: [],
    );
  }

  /// `添加文件`
  String get addFile {
    return Intl.message(
      '添加文件',
      name: 'addFile',
      desc: '',
      args: [],
    );
  }

  /// `本地上传`
  String get localUpload {
    return Intl.message(
      '本地上传',
      name: 'localUpload',
      desc: '',
      args: [],
    );
  }

  /// `从网盘中`
  String get fromCloud {
    return Intl.message(
      '从网盘中',
      name: 'fromCloud',
      desc: '',
      args: [],
    );
  }

  /// `从网址上传`
  String get uploadFromUrl {
    return Intl.message(
      '从网址上传',
      name: 'uploadFromUrl',
      desc: '',
      args: [],
    );
  }

  /// `请输入URL`
  String get enterUrl {
    return Intl.message(
      '请输入URL',
      name: 'enterUrl',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get cancel {
    return Intl.message(
      '取消',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `上传失败\n {msg}`
  String uploadFailed(Object msg) {
    return Intl.message(
      '上传失败\n $msg',
      name: 'uploadFailed',
      desc: '',
      args: [msg],
    );
  }

  /// `重命名`
  String get rename {
    return Intl.message(
      '重命名',
      name: 'rename',
      desc: '',
      args: [],
    );
  }

  /// `删除`
  String get delete {
    return Intl.message(
      '删除',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `标记为敏感内容`
  String get markAsSensitive {
    return Intl.message(
      '标记为敏感内容',
      name: 'markAsSensitive',
      desc: '',
      args: [],
    );
  }

  /// `取消标记为敏感内容`
  String get cancelSensitive {
    return Intl.message(
      '取消标记为敏感内容',
      name: 'cancelSensitive',
      desc: '',
      args: [],
    );
  }

  /// `添加标题`
  String get addTitle {
    return Intl.message(
      '添加标题',
      name: 'addTitle',
      desc: '',
      args: [],
    );
  }

  /// `请输入新标题`
  String get enterNewTitle {
    return Intl.message(
      '请输入新标题',
      name: 'enterNewTitle',
      desc: '',
      args: [],
    );
  }

  /// `从文件创建帖子`
  String get createNoteFormFile {
    return Intl.message(
      '从文件创建帖子',
      name: 'createNoteFormFile',
      desc: '',
      args: [],
    );
  }

  /// `复制链接`
  String get copyLink {
    return Intl.message(
      '复制链接',
      name: 'copyLink',
      desc: '',
      args: [],
    );
  }

  /// `下载`
  String get download {
    return Intl.message(
      '下载',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `重命名文件`
  String get renameFile {
    return Intl.message(
      '重命名文件',
      name: 'renameFile',
      desc: '',
      args: [],
    );
  }

  /// `重命名文件夹`
  String get renameFolder {
    return Intl.message(
      '重命名文件夹',
      name: 'renameFolder',
      desc: '',
      args: [],
    );
  }

  /// `请输入新文件名`
  String get enterNewFileName {
    return Intl.message(
      '请输入新文件名',
      name: 'enterNewFileName',
      desc: '',
      args: [],
    );
  }

  /// `要删除「{name}」文件吗？附加此文件的帖子也会被删除。`
  String deleteFileConfirmation(Object name) {
    return Intl.message(
      '要删除「$name」文件吗？附加此文件的帖子也会被删除。',
      name: 'deleteFileConfirmation',
      desc: '',
      args: [name],
    );
  }

  /// `要删除「{name}」文件夹吗？ 如果文件夹中存在内容，请先删除文件夹中的内容。`
  String deleteFolderConfirmation(Object name) {
    return Intl.message(
      '要删除「$name」文件夹吗？ 如果文件夹中存在内容，请先删除文件夹中的内容。',
      name: 'deleteFolderConfirmation',
      desc: '',
      args: [name],
    );
  }

  /// `刷新`
  String get refresh {
    return Intl.message(
      '刷新',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `新建文件夹`
  String get createFolder {
    return Intl.message(
      '新建文件夹',
      name: 'createFolder',
      desc: '',
      args: [],
    );
  }

  /// `文件夹名称`
  String get folderName {
    return Intl.message(
      '文件夹名称',
      name: 'folderName',
      desc: '',
      args: [],
    );
  }

  /// `确定`
  String get ok {
    return Intl.message(
      '确定',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `确定({selectListLength}/{maxSelect})`
  String confirmSelection(Object selectListLength, Object maxSelect) {
    return Intl.message(
      '确定($selectListLength/$maxSelect)',
      name: 'confirmSelection',
      desc: '',
      args: [selectListLength, maxSelect],
    );
  }

  /// `完成`
  String get done {
    return Intl.message(
      '完成',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `选择标签`
  String get selectHashtag {
    return Intl.message(
      '选择标签',
      name: 'selectHashtag',
      desc: '',
      args: [],
    );
  }

  /// `登录`
  String get login {
    return Intl.message(
      '登录',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `登录成功`
  String get loginSuccess {
    return Intl.message(
      '登录成功',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `正在登录{server}`
  String loginLoading(Object server) {
    return Intl.message(
      '正在登录$server',
      name: 'loginLoading',
      desc: '',
      args: [server],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
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
