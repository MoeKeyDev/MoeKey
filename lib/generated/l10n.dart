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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `请选择服务器`
  String get selectServer {
    return Intl.message('请选择服务器', name: 'selectServer', desc: '', args: []);
  }

  /// `服务器列表`
  String get serverList {
    return Intl.message('服务器列表', name: 'serverList', desc: '', args: []);
  }

  /// `帖子数`
  String get notesCount {
    return Intl.message('帖子数', name: 'notesCount', desc: '', args: []);
  }

  /// `用户数`
  String get usersCount {
    return Intl.message('用户数', name: 'usersCount', desc: '', args: []);
  }

  /// `注册模式`
  String get registration {
    return Intl.message('注册模式', name: 'registration', desc: '', args: []);
  }

  /// `开放`
  String get registrationOpen {
    return Intl.message('开放', name: 'registrationOpen', desc: '', args: []);
  }

  /// `邀请制`
  String get registrationClosed {
    return Intl.message('邀请制', name: 'registrationClosed', desc: '', args: []);
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
    return Intl.message('服务器正在加载', name: 'loadingServers', desc: '', args: []);
  }

  /// `过滤`
  String get filter {
    return Intl.message('过滤', name: 'filter', desc: '', args: []);
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
    return Intl.message('手动输入服务器', name: 'inputServer', desc: '', args: []);
  }

  /// `服务器地址`
  String get serverAddr {
    return Intl.message('服务器地址', name: 'serverAddr', desc: '', args: []);
  }

  /// `下一步`
  String get next {
    return Intl.message('下一步', name: 'next', desc: '', args: []);
  }

  /// `时间线`
  String get timeline {
    return Intl.message('时间线', name: 'timeline', desc: '', args: []);
  }

  /// `通知`
  String get notifications {
    return Intl.message('通知', name: 'notifications', desc: '', args: []);
  }

  /// `便签`
  String get clips {
    return Intl.message('便签', name: 'clips', desc: '', args: []);
  }

  /// `网盘`
  String get drive {
    return Intl.message('网盘', name: 'drive', desc: '', args: []);
  }

  /// `发现`
  String get explore {
    return Intl.message('发现', name: 'explore', desc: '', args: []);
  }

  /// `公告`
  String get announcements {
    return Intl.message('公告', name: 'announcements', desc: '', args: []);
  }

  /// `搜索`
  String get search {
    return Intl.message('搜索', name: 'search', desc: '', args: []);
  }

  /// `更多`
  String get more {
    return Intl.message('更多', name: 'more', desc: '', args: []);
  }

  /// `查看更多`
  String get viewMore {
    return Intl.message('查看更多', name: 'viewMore', desc: '', args: []);
  }

  /// `设置`
  String get settings {
    return Intl.message('设置', name: 'settings', desc: '', args: []);
  }

  /// `列表为空`
  String get noLists {
    return Intl.message('列表为空', name: 'noLists', desc: '', args: []);
  }

  /// `我明白了`
  String get gotIt {
    return Intl.message('我明白了', name: 'gotIt', desc: '', args: []);
  }

  /// `返回`
  String get back {
    return Intl.message('返回', name: 'back', desc: '', args: []);
  }

  /// `名称`
  String get name {
    return Intl.message('名称', name: 'name', desc: '', args: []);
  }

  /// `描述`
  String get description {
    return Intl.message('描述', name: 'description', desc: '', args: []);
  }

  /// `预览`
  String get preview {
    return Intl.message('预览', name: 'preview', desc: '', args: []);
  }

  /// `公开`
  String get public {
    return Intl.message('公开', name: 'public', desc: '', args: []);
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
    return Intl.message('刚刚', name: 'justNow', desc: '', args: []);
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
    return Intl.message('$hours小时前', name: 'hoursAgo', desc: '', args: [hours]);
  }

  /// `{days}天前`
  String daysAgo(Object days) {
    return Intl.message('$days天前', name: 'daysAgo', desc: '', args: [days]);
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
    return Intl.message('$years年前', name: 'yearsAgo', desc: '', args: [years]);
  }

  /// `保留原图`
  String get keepOriginal {
    return Intl.message('保留原图', name: 'keepOriginal', desc: '', args: []);
  }

  /// `添加文件`
  String get addFile {
    return Intl.message('添加文件', name: 'addFile', desc: '', args: []);
  }

  /// `本地上传`
  String get localUpload {
    return Intl.message('本地上传', name: 'localUpload', desc: '', args: []);
  }

  /// `从网盘中`
  String get fromCloud {
    return Intl.message('从网盘中', name: 'fromCloud', desc: '', args: []);
  }

  /// `从网址上传`
  String get uploadFromUrl {
    return Intl.message('从网址上传', name: 'uploadFromUrl', desc: '', args: []);
  }

  /// `请输入URL`
  String get enterUrl {
    return Intl.message('请输入URL', name: 'enterUrl', desc: '', args: []);
  }

  /// `取消`
  String get cancel {
    return Intl.message('取消', name: 'cancel', desc: '', args: []);
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
    return Intl.message('重命名', name: 'rename', desc: '', args: []);
  }

  /// `删除`
  String get delete {
    return Intl.message('删除', name: 'delete', desc: '', args: []);
  }

  /// `标记为敏感内容`
  String get markAsSensitive {
    return Intl.message('标记为敏感内容', name: 'markAsSensitive', desc: '', args: []);
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
    return Intl.message('添加标题', name: 'addTitle', desc: '', args: []);
  }

  /// `请输入新标题`
  String get enterNewTitle {
    return Intl.message('请输入新标题', name: 'enterNewTitle', desc: '', args: []);
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
    return Intl.message('复制链接', name: 'copyLink', desc: '', args: []);
  }

  /// `下载`
  String get download {
    return Intl.message('下载', name: 'download', desc: '', args: []);
  }

  /// `重命名文件`
  String get renameFile {
    return Intl.message('重命名文件', name: 'renameFile', desc: '', args: []);
  }

  /// `重命名文件夹`
  String get renameFolder {
    return Intl.message('重命名文件夹', name: 'renameFolder', desc: '', args: []);
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
    return Intl.message('刷新', name: 'refresh', desc: '', args: []);
  }

  /// `新建文件夹`
  String get createFolder {
    return Intl.message('新建文件夹', name: 'createFolder', desc: '', args: []);
  }

  /// `文件夹名称`
  String get folderName {
    return Intl.message('文件夹名称', name: 'folderName', desc: '', args: []);
  }

  /// `确定`
  String get ok {
    return Intl.message('确定', name: 'ok', desc: '', args: []);
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
    return Intl.message('完成', name: 'done', desc: '', args: []);
  }

  /// `选择标签`
  String get selectHashtag {
    return Intl.message('选择标签', name: 'selectHashtag', desc: '', args: []);
  }

  /// `登录`
  String get login {
    return Intl.message('登录', name: 'login', desc: '', args: []);
  }

  /// `登录成功`
  String get loginSuccess {
    return Intl.message('登录成功', name: 'loginSuccess', desc: '', args: []);
  }

  /// `登录失败`
  String get loginFailed {
    return Intl.message('登录失败', name: 'loginFailed', desc: '', args: []);
  }

  /// `登录失败: 应用创建失败`
  String get loginFailedWithAppCreate {
    return Intl.message(
      '登录失败: 应用创建失败',
      name: 'loginFailedWithAppCreate',
      desc: '',
      args: [],
    );
  }

  /// `登录失败: token获取失败`
  String get loginFailedWithToken {
    return Intl.message(
      '登录失败: token获取失败',
      name: 'loginFailedWithToken',
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

  /// `回复帖子`
  String get replyNoteText {
    return Intl.message('回复帖子', name: 'replyNoteText', desc: '', args: []);
  }

  /// `回复这个帖子...`
  String get replyNoteHint {
    return Intl.message('回复这个帖子...', name: 'replyNoteHint', desc: '', args: []);
  }

  /// `引用帖子`
  String get reNoteText {
    return Intl.message('引用帖子', name: 'reNoteText', desc: '', args: []);
  }

  /// `引用这个帖子...`
  String get reNoteHint {
    return Intl.message('引用这个帖子...', name: 'reNoteHint', desc: '', args: []);
  }

  /// `发布新帖子`
  String get createNote {
    return Intl.message('发布新帖子', name: 'createNote', desc: '', args: []);
  }

  /// `发生了什么...`
  String get createNoteHint {
    return Intl.message('发生了什么...', name: 'createNoteHint', desc: '', args: []);
  }

  /// `发布`
  String get publish {
    return Intl.message('发布', name: 'publish', desc: '', args: []);
  }

  /// `收件人`
  String get recipient {
    return Intl.message('收件人', name: 'recipient', desc: '', args: []);
  }

  /// `添加`
  String get add {
    return Intl.message('添加', name: 'add', desc: '', args: []);
  }

  /// `投票`
  String get vote {
    return Intl.message('投票', name: 'vote', desc: '', args: []);
  }

  /// `投票数量不能少于两个`
  String get voteOptionAtLeastTwo {
    return Intl.message(
      '投票数量不能少于两个',
      name: 'voteOptionAtLeastTwo',
      desc: '',
      args: [],
    );
  }

  /// `选项{index}不能为空`
  String voteOptionNullIndex(Object index) {
    return Intl.message(
      '选项$index不能为空',
      name: 'voteOptionNullIndex',
      desc: '',
      args: [index],
    );
  }

  /// `选项{index}`
  String voteOptionHint(Object index) {
    return Intl.message(
      '选项$index',
      name: 'voteOptionHint',
      desc: '',
      args: [index],
    );
  }

  /// `允许多个投票`
  String get voteEnableMultiChoice {
    return Intl.message(
      '允许多个投票',
      name: 'voteEnableMultiChoice',
      desc: '',
      args: [],
    );
  }

  /// `截止日期`
  String get voteDueDate {
    return Intl.message('截止日期', name: 'voteDueDate', desc: '', args: []);
  }

  /// `永久`
  String get voteNoDueDate {
    return Intl.message('永久', name: 'voteNoDueDate', desc: '', args: []);
  }

  /// `投票结果已经生成`
  String get voteResult {
    return Intl.message('投票结果已经生成', name: 'voteResult', desc: '', args: []);
  }

  /// `天`
  String get day {
    return Intl.message('天', name: 'day', desc: '', args: []);
  }

  /// `小时`
  String get hour {
    return Intl.message('小时', name: 'hour', desc: '', args: []);
  }

  /// `分钟`
  String get minute {
    return Intl.message('分钟', name: 'minute', desc: '', args: []);
  }

  /// `插入附件`
  String get insertDriverFile {
    return Intl.message('插入附件', name: 'insertDriverFile', desc: '', args: []);
  }

  /// `隐藏内容`
  String get cw {
    return Intl.message('隐藏内容', name: 'cw', desc: '', args: []);
  }

  /// `提及`
  String get mention {
    return Intl.message('提及', name: 'mention', desc: '', args: []);
  }

  /// `话题标签`
  String get hashtag {
    return Intl.message('话题标签', name: 'hashtag', desc: '', args: []);
  }

  /// `表情符号`
  String get emoji {
    return Intl.message('表情符号', name: 'emoji', desc: '', args: []);
  }

  /// `预览帖子`
  String get previewNote {
    return Intl.message('预览帖子', name: 'previewNote', desc: '', args: []);
  }

  /// `回应`
  String get reaction {
    return Intl.message('回应', name: 'reaction', desc: '', args: []);
  }

  /// `接受表情回应`
  String get reactionAccepting {
    return Intl.message(
      '接受表情回应',
      name: 'reactionAccepting',
      desc: '',
      args: [],
    );
  }

  /// `全部`
  String get reactionAcceptingAll {
    return Intl.message('全部', name: 'reactionAcceptingAll', desc: '', args: []);
  }

  /// `远程仅点赞`
  String get reactionAcceptingLikeOnlyRemote {
    return Intl.message(
      '远程仅点赞',
      name: 'reactionAcceptingLikeOnlyRemote',
      desc: '',
      args: [],
    );
  }

  /// `仅限非敏感内容`
  String get reactionAcceptingNoneSensitive {
    return Intl.message(
      '仅限非敏感内容',
      name: 'reactionAcceptingNoneSensitive',
      desc: '',
      args: [],
    );
  }

  /// `仅限非敏感内容（远程仅点赞）`
  String get reactionAcceptingNoneSensitiveOrLocal {
    return Intl.message(
      '仅限非敏感内容（远程仅点赞）',
      name: 'reactionAcceptingNoneSensitiveOrLocal',
      desc: '',
      args: [],
    );
  }

  /// `仅点赞`
  String get reactionAcceptingLikeOnly {
    return Intl.message(
      '仅点赞',
      name: 'reactionAcceptingLikeOnly',
      desc: '',
      args: [],
    );
  }

  /// `帖子`
  String get notes {
    return Intl.message('帖子', name: 'notes', desc: '', args: []);
  }

  /// `不参与联合`
  String get noteLocalOnly {
    return Intl.message('不参与联合', name: 'noteLocalOnly', desc: '', args: []);
  }

  /// `可见性`
  String get noteVisibility {
    return Intl.message('可见性', name: 'noteVisibility', desc: '', args: []);
  }

  /// `公开`
  String get noteVisibilityPublic {
    return Intl.message('公开', name: 'noteVisibilityPublic', desc: '', args: []);
  }

  /// `您的帖子将出现在全局时间线上`
  String get noteVisibilityPublicText {
    return Intl.message(
      '您的帖子将出现在全局时间线上',
      name: 'noteVisibilityPublicText',
      desc: '',
      args: [],
    );
  }

  /// `首页`
  String get noteVisibilityHome {
    return Intl.message('首页', name: 'noteVisibilityHome', desc: '', args: []);
  }

  /// `仅发送至首页的时间线`
  String get noteVisibilityHomeText {
    return Intl.message(
      '仅发送至首页的时间线',
      name: 'noteVisibilityHomeText',
      desc: '',
      args: [],
    );
  }

  /// `关注者`
  String get noteVisibilityFollowers {
    return Intl.message(
      '关注者',
      name: 'noteVisibilityFollowers',
      desc: '',
      args: [],
    );
  }

  /// `仅发送至关注者`
  String get noteVisibilityFollowersText {
    return Intl.message(
      '仅发送至关注者',
      name: 'noteVisibilityFollowersText',
      desc: '',
      args: [],
    );
  }

  /// `私信`
  String get noteVisibilitySpecified {
    return Intl.message(
      '私信',
      name: 'noteVisibilitySpecified',
      desc: '',
      args: [],
    );
  }

  /// `仅发送至指定用户`
  String get noteVisibilitySpecifiedText {
    return Intl.message(
      '仅发送至指定用户',
      name: 'noteVisibilitySpecifiedText',
      desc: '',
      args: [],
    );
  }

  /// `内容不能为空`
  String get exceptionContentNull {
    return Intl.message(
      '内容不能为空',
      name: 'exceptionContentNull',
      desc: '',
      args: [],
    );
  }

  /// `内容不能为空`
  String get exceptionCwNull {
    return Intl.message('内容不能为空', name: 'exceptionCwNull', desc: '', args: []);
  }

  /// `发送帖子失败\n\n{error}`
  String exceptionSendNote(Object error) {
    return Intl.message(
      '发送帖子失败\n\n$error',
      name: 'exceptionSendNote',
      desc: '',
      args: [error],
    );
  }

  /// `已置顶的帖子`
  String get notePined {
    return Intl.message('已置顶的帖子', name: 'notePined', desc: '', args: []);
  }

  /// `从{language}翻译 \n`
  String noteFormLanguageTranslation(Object language) {
    return Intl.message(
      '从$language翻译 \n',
      name: 'noteFormLanguageTranslation',
      desc: '',
      args: [language],
    );
  }

  /// `显示内容`
  String get noteCwShow {
    return Intl.message('显示内容', name: 'noteCwShow', desc: '', args: []);
  }

  /// `收起`
  String get noteCwHide {
    return Intl.message('收起', name: 'noteCwHide', desc: '', args: []);
  }

  /// `转发了`
  String get noteReNoteByUser {
    return Intl.message('转发了', name: 'noteReNoteByUser', desc: '', args: []);
  }

  /// `转发`
  String get noteReNote {
    return Intl.message('转发', name: 'noteReNote', desc: '', args: []);
  }

  /// `引用`
  String get noteQuote {
    return Intl.message('引用', name: 'noteQuote', desc: '', args: []);
  }

  /// `{count}票`
  String voteCount(Object count) {
    return Intl.message('$count票', name: 'voteCount', desc: '', args: [count]);
  }

  /// `总票数 {count}`
  String voteAllCount(Object count) {
    return Intl.message(
      '总票数 $count',
      name: 'voteAllCount',
      desc: '',
      args: [count],
    );
  }

  /// `投票已结束`
  String get voteExpired {
    return Intl.message('投票已结束', name: 'voteExpired', desc: '', args: []);
  }

  /// `{datetime}后截止`
  String voteWillExpired(Object datetime) {
    return Intl.message(
      '$datetime后截止',
      name: 'voteWillExpired',
      desc: '',
      args: [datetime],
    );
  }

  /// `复制内容`
  String get copyContent {
    return Intl.message('复制内容', name: 'copyContent', desc: '', args: []);
  }

  /// `复制本站链接`
  String get noteCopyLocalLink {
    return Intl.message(
      '复制本站链接',
      name: 'noteCopyLocalLink',
      desc: '',
      args: [],
    );
  }

  /// `分享`
  String get share {
    return Intl.message('分享', name: 'share', desc: '', args: []);
  }

  /// `转到所在服务器显示`
  String get noteOpenRemoteLink {
    return Intl.message(
      '转到所在服务器显示',
      name: 'noteOpenRemoteLink',
      desc: '',
      args: [],
    );
  }

  /// `翻译`
  String get translate {
    return Intl.message('翻译', name: 'translate', desc: '', args: []);
  }

  /// `翻译帖子`
  String get noteTranslate {
    return Intl.message('翻译帖子', name: 'noteTranslate', desc: '', args: []);
  }

  /// `便签`
  String get clip {
    return Intl.message('便签', name: 'clip', desc: '', args: []);
  }

  /// `新建便签`
  String get clipCreate {
    return Intl.message('新建便签', name: 'clipCreate', desc: '', args: []);
  }

  /// `更新便签`
  String get clipUpdate {
    return Intl.message('更新便签', name: 'clipUpdate', desc: '', args: []);
  }

  /// `查看`
  String get view {
    return Intl.message('查看', name: 'view', desc: '', args: []);
  }

  /// `敏感内容`
  String get sensitiveContent {
    return Intl.message('敏感内容', name: 'sensitiveContent', desc: '', args: []);
  }

  /// `图片`
  String get image {
    return Intl.message('图片', name: 'image', desc: '', args: []);
  }

  /// `视频`
  String get video {
    return Intl.message('视频', name: 'video', desc: '', args: []);
  }

  /// `点击显示`
  String get sensitiveClickShow {
    return Intl.message('点击显示', name: 'sensitiveClickShow', desc: '', args: []);
  }

  /// `选择用户`
  String get selectUser {
    return Intl.message('选择用户', name: 'selectUser', desc: '', args: []);
  }

  /// `用户名`
  String get username {
    return Intl.message('用户名', name: 'username', desc: '', args: []);
  }

  /// `用户`
  String get user {
    return Intl.message('用户', name: 'user', desc: '', args: []);
  }

  /// `域名`
  String get hostnames {
    return Intl.message('域名', name: 'hostnames', desc: '', args: []);
  }

  /// `正在关注你`
  String get isFollowingYouNow {
    return Intl.message('正在关注你', name: 'isFollowingYouNow', desc: '', args: []);
  }

  /// `此用户尚无自我介绍`
  String get userDescriptionIsNull {
    return Intl.message(
      '此用户尚无自我介绍',
      name: 'userDescriptionIsNull',
      desc: '',
      args: [],
    );
  }

  /// `关注`
  String get follow {
    return Intl.message('关注', name: 'follow', desc: '', args: []);
  }

  /// `取消关注`
  String get unfollow {
    return Intl.message('取消关注', name: 'unfollow', desc: '', args: []);
  }

  /// `已关注`
  String get followed {
    return Intl.message('已关注', name: 'followed', desc: '', args: []);
  }

  /// `关注者`
  String get followers {
    return Intl.message('关注者', name: 'followers', desc: '', args: []);
  }

  /// `关注中`
  String get following {
    return Intl.message('关注中', name: 'following', desc: '', args: []);
  }

  /// `{day}天{hour}小时{minute}分钟{second}秒`
  String durationDay(Object day, Object hour, Object minute, Object second) {
    return Intl.message(
      '$day天$hour小时$minute分钟$second秒',
      name: 'durationDay',
      desc: '',
      args: [day, hour, minute, second],
    );
  }

  /// `{hour}小时{minute}分钟{second}秒`
  String durationHour(Object hour, Object minute, Object second) {
    return Intl.message(
      '$hour小时$minute分钟$second秒',
      name: 'durationHour',
      desc: '',
      args: [hour, minute, second],
    );
  }

  /// `{minute}分钟{second}秒`
  String durationMinute(Object minute, Object second) {
    return Intl.message(
      '$minute分钟$second秒',
      name: 'durationMinute',
      desc: '',
      args: [minute, second],
    );
  }

  /// `{second}秒`
  String durationSecond(Object second) {
    return Intl.message(
      '$second秒',
      name: 'durationSecond',
      desc: '',
      args: [second],
    );
  }

  /// `未分类`
  String get uncategorized {
    return Intl.message('未分类', name: 'uncategorized', desc: '', args: []);
  }

  /// `现在的公告`
  String get announcementActive {
    return Intl.message(
      '现在的公告',
      name: 'announcementActive',
      desc: '',
      args: [],
    );
  }

  /// `过去的公告`
  String get announcementExpired {
    return Intl.message(
      '过去的公告',
      name: 'announcementExpired',
      desc: '',
      args: [],
    );
  }

  /// `创建日期`
  String get createdDate {
    return Intl.message('创建日期', name: 'createdDate', desc: '', args: []);
  }

  /// `更新日期`
  String get updatedDate {
    return Intl.message('更新日期', name: 'updatedDate', desc: '', args: []);
  }

  /// `移除便签`
  String get clipRemove {
    return Intl.message('移除便签', name: 'clipRemove', desc: '', args: []);
  }

  /// `编辑`
  String get edit {
    return Intl.message('编辑', name: 'edit', desc: '', args: []);
  }

  /// `收藏`
  String get favorite {
    return Intl.message('收藏', name: 'favorite', desc: '', args: []);
  }

  /// `我的便签`
  String get myCLips {
    return Intl.message('我的便签', name: 'myCLips', desc: '', args: []);
  }

  /// `收藏`
  String get clipFavoriteList {
    return Intl.message('收藏', name: 'clipFavoriteList', desc: '', args: []);
  }

  /// `要删掉「{thing}」吗？`
  String deleteConfirm(Object thing) {
    return Intl.message(
      '要删掉「$thing」吗？',
      name: 'deleteConfirm',
      desc: '',
      args: [thing],
    );
  }

  /// `添加到收藏`
  String get clipFavorite {
    return Intl.message('添加到收藏', name: 'clipFavorite', desc: '', args: []);
  }

  /// `确定要取消收藏吗？`
  String get clipCancelFavoriteText {
    return Intl.message(
      '确定要取消收藏吗？',
      name: 'clipCancelFavoriteText',
      desc: '',
      args: [],
    );
  }

  /// `热门`
  String get exploreHot {
    return Intl.message('热门', name: 'exploreHot', desc: '', args: []);
  }

  /// `用户`
  String get exploreUsers {
    return Intl.message('用户', name: 'exploreUsers', desc: '', args: []);
  }

  /// `本地`
  String get local {
    return Intl.message('本地', name: 'local', desc: '', args: []);
  }

  /// `远程`
  String get remote {
    return Intl.message('远程', name: 'remote', desc: '', args: []);
  }

  /// `热门用户`
  String get exploreUserHot {
    return Intl.message('热门用户', name: 'exploreUserHot', desc: '', args: []);
  }

  /// `最近登录的用户`
  String get exploreUserLast {
    return Intl.message('最近登录的用户', name: 'exploreUserLast', desc: '', args: []);
  }

  /// `最近投稿的用户`
  String get exploreUserUpdated {
    return Intl.message(
      '最近投稿的用户',
      name: 'exploreUserUpdated',
      desc: '',
      args: [],
    );
  }

  /// `置顶用户`
  String get exploreUserPined {
    return Intl.message('置顶用户', name: 'exploreUserPined', desc: '', args: []);
  }

  /// `添加账号`
  String get addAccount {
    return Intl.message('添加账号', name: 'addAccount', desc: '', args: []);
  }

  /// `管理账号`
  String get manageAccount {
    return Intl.message('管理账号', name: 'manageAccount', desc: '', args: []);
  }

  /// `账号`
  String get account {
    return Intl.message('账号', name: 'account', desc: '', args: []);
  }

  /// `保存图片`
  String get saveImage {
    return Intl.message('保存图片', name: 'saveImage', desc: '', args: []);
  }

  /// `保存成功`
  String get saveSuccess {
    return Intl.message('保存成功', name: 'saveSuccess', desc: '', args: []);
  }

  /// `保存失败`
  String get saveFailed {
    return Intl.message('保存失败', name: 'saveFailed', desc: '', args: []);
  }

  /// ` 的帖子`
  String get somebodyNote {
    return Intl.message(' 的帖子', name: 'somebodyNote', desc: '', args: []);
  }

  /// `查看对话`
  String get showConversation {
    return Intl.message('查看对话', name: 'showConversation', desc: '', args: []);
  }

  /// `通知`
  String get notification {
    return Intl.message('通知', name: 'notification', desc: '', args: []);
  }

  /// `你有新的关注者`
  String get notifyFollowedYou {
    return Intl.message(
      '你有新的关注者',
      name: 'notifyFollowedYou',
      desc: '',
      args: [],
    );
  }

  /// `你的关注请求被通过了`
  String get notifyFollowedAccepted {
    return Intl.message(
      '你的关注请求被通过了',
      name: 'notifyFollowedAccepted',
      desc: '',
      args: [],
    );
  }

  /// `不支持的通知类型:{type}`
  String notifyNotSupport(Object type) {
    return Intl.message(
      '不支持的通知类型:$type',
      name: 'notifyNotSupport',
      desc: '',
      args: [type],
    );
  }

  /// `全部`
  String get notifyAll {
    return Intl.message('全部', name: 'notifyAll', desc: '', args: []);
  }

  /// `提到我的`
  String get notifyMention {
    return Intl.message('提到我的', name: 'notifyMention', desc: '', args: []);
  }

  /// `私信`
  String get notifyMessage {
    return Intl.message('私信', name: 'notifyMessage', desc: '', args: []);
  }

  /// `筛选`
  String get notifyFilter {
    return Intl.message('筛选', name: 'notifyFilter', desc: '', args: []);
  }

  /// `全部标记为已读`
  String get notifyMarkAllRead {
    return Intl.message(
      '全部标记为已读',
      name: 'notifyMarkAllRead',
      desc: '',
      args: [],
    );
  }

  /// `全部`
  String get all {
    return Intl.message('全部', name: 'all', desc: '', args: []);
  }

  /// `指定域名`
  String get searchHost {
    return Intl.message('指定域名', name: 'searchHost', desc: '', args: []);
  }

  /// `全部`
  String get searchAll {
    return Intl.message('全部', name: 'searchAll', desc: '', args: []);
  }

  /// `本站`
  String get searchLocal {
    return Intl.message('本站', name: 'searchLocal', desc: '', args: []);
  }

  /// `远程`
  String get searchRemote {
    return Intl.message('远程', name: 'searchRemote', desc: '', args: []);
  }

  /// `首页`
  String get timelineHome {
    return Intl.message('首页', name: 'timelineHome', desc: '', args: []);
  }

  /// `本地`
  String get timelineLocal {
    return Intl.message('本地', name: 'timelineLocal', desc: '', args: []);
  }

  /// `全局`
  String get timelineGlobal {
    return Intl.message('全局', name: 'timelineGlobal', desc: '', args: []);
  }

  /// `社交`
  String get timelineHybrid {
    return Intl.message('社交', name: 'timelineHybrid', desc: '', args: []);
  }

  /// `小部件列表(未完成)`
  String get userWidgetUnSupport {
    return Intl.message(
      '小部件列表(未完成)',
      name: 'userWidgetUnSupport',
      desc: '',
      args: [],
    );
  }

  /// `用户`
  String get userHot {
    return Intl.message('用户', name: 'userHot', desc: '', args: []);
  }

  /// `帖子`
  String get userNote {
    return Intl.message('帖子', name: 'userNote', desc: '', args: []);
  }

  /// `全部`
  String get userAll {
    return Intl.message('全部', name: 'userAll', desc: '', args: []);
  }

  /// `附件`
  String get userFile {
    return Intl.message('附件', name: 'userFile', desc: '', args: []);
  }

  /// `注册于`
  String get userRegisterBy {
    return Intl.message('注册于', name: 'userRegisterBy', desc: '', args: []);
  }

  /// `复制用户名`
  String get copyUsername {
    return Intl.message('复制用户名', name: 'copyUsername', desc: '', args: []);
  }

  /// `复制RSS`
  String get copyRSS {
    return Intl.message('复制RSS', name: 'copyRSS', desc: '', args: []);
  }

  /// `转到浏览器显示`
  String get openInNewTab {
    return Intl.message('转到浏览器显示', name: 'openInNewTab', desc: '', args: []);
  }

  /// `复制用户主页地址`
  String get copyUserHomeLink {
    return Intl.message(
      '复制用户主页地址',
      name: 'copyUserHomeLink',
      desc: '',
      args: [],
    );
  }

  /// `关注请求批准中`
  String get pendingFollowRequest {
    return Intl.message(
      '关注请求批准中',
      name: 'pendingFollowRequest',
      desc: '',
      args: [],
    );
  }

  /// `处理中`
  String get processing {
    return Intl.message('处理中', name: 'processing', desc: '', args: []);
  }

  /// `概览`
  String get overviews {
    return Intl.message('概览', name: 'overviews', desc: '', args: []);
  }

  /// `关闭`
  String get close {
    return Intl.message('关闭', name: 'close', desc: '', args: []);
  }

  /// `登录信息已经过期，请重新登录`
  String get loginExpired {
    return Intl.message(
      '登录信息已经过期，请重新登录',
      name: 'loginExpired',
      desc: '',
      args: [],
    );
  }

  /// `清除`
  String get clear {
    return Intl.message('清除', name: 'clear', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'af', countryCode: 'ZA'),
      Locale.fromSubtags(languageCode: 'ar', countryCode: 'SA'),
      Locale.fromSubtags(languageCode: 'ca', countryCode: 'ES'),
      Locale.fromSubtags(languageCode: 'cs', countryCode: 'CZ'),
      Locale.fromSubtags(languageCode: 'da', countryCode: 'DK'),
      Locale.fromSubtags(languageCode: 'de', countryCode: 'DE'),
      Locale.fromSubtags(languageCode: 'el', countryCode: 'GR'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'es', countryCode: 'ES'),
      Locale.fromSubtags(languageCode: 'fi', countryCode: 'FI'),
      Locale.fromSubtags(languageCode: 'fr', countryCode: 'FR'),
      Locale.fromSubtags(languageCode: 'he', countryCode: 'IL'),
      Locale.fromSubtags(languageCode: 'hu', countryCode: 'HU'),
      Locale.fromSubtags(languageCode: 'it', countryCode: 'IT'),
      Locale.fromSubtags(languageCode: 'ja', countryCode: 'JP'),
      Locale.fromSubtags(languageCode: 'ko', countryCode: 'KR'),
      Locale.fromSubtags(languageCode: 'nl', countryCode: 'NL'),
      Locale.fromSubtags(languageCode: 'no', countryCode: 'NO'),
      Locale.fromSubtags(languageCode: 'pl', countryCode: 'PL'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'PT'),
      Locale.fromSubtags(languageCode: 'ro', countryCode: 'RO'),
      Locale.fromSubtags(languageCode: 'ru', countryCode: 'RU'),
      Locale.fromSubtags(languageCode: 'sr', countryCode: 'SP'),
      Locale.fromSubtags(languageCode: 'sv', countryCode: 'SE'),
      Locale.fromSubtags(languageCode: 'tr', countryCode: 'TR'),
      Locale.fromSubtags(languageCode: 'uk', countryCode: 'UA'),
      Locale.fromSubtags(languageCode: 'vi', countryCode: 'VN'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
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
