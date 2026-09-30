# MoeKey Video Pool

项目内的 Flutter 视频调度库。入口为 `package:moekey_video_pool/moekey_video_pool.dart`，不依赖 Riverpod，也不包含控件或播放器界面。

结构是 `VideoPool → VideoFeedView → 自定义播放器`。默认使用 `video_player`，通过 `PlaybackFactory` 可以替换底层实现。

## 接入列表

```dart
final pool = VideoPool();

VideoPoolViewport(
  pool: pool,
  child: ListView.builder(
    itemCount: notes.length,
    itemBuilder: (context, noteIndex) {
      final note = notes[noteIndex];
      final file = note.video;
      return SizedBox(
        height: 240,
        child: VideoFeedView(
          key: ValueKey('${note.id}/${file.id}'),
          noteId: note.id,
          listIndex: noteIndex,
          listSubIndex: file.attachmentIndex,
          url: file.url,
          enable: !file.isSensitive || file.revealed,
          builder: (context, video) => MyVideoPlayer(video: video),
        ),
      );
    },
  ),
);
```

`VideoPoolViewport` 监听列表滚动通知，按帧合并可见性测量，并转发应用前后台变化。无需列表页面维护滚动计时器。它借用池，不负责销毁池。

视口通过 `ModalRoute.isCurrentOf(context)` 自动判断所在路由是否位于顶层。被其他路由覆盖时，内部视频上报可见性 0，也不再转发滚动事件；返回后恢复测量。`active: false` 可用于停用同一路由中的未选中 Tab。没有路由祖先时默认启用。弹窗也会让底层路由停用；这表示调度资格，不是实际遮挡面积。全屏视口可注册相同位置以共享 `FeedVideo`，各组件仍保留独立的可见性。

`VideoFeedView` 自动注册和注销附件。URL、scope、noteId 或 videoKey 改变时重新注册；索引、enable 更新会保留原状态。使用稳定的附件 Key，附件索引保留图片和隐藏附件的位置。noteId 用于同帖连播，scope 用于区分不同列表；默认 scope 为 `default`，切换列表时调用 `pool.setScope(scope)`。

如果滚动事件来自其他组件，可以设置 `observeScroll: false`，自行接线：

```dart
scrollController.addListener(pool.onScroll);
// 移除列表时解绑
scrollController.removeListener(pool.onScroll);
```

每次 `onScroll()` 会重置池内部的停稳计时器。滚动期间不会自动创建或预加载新会话，但仍会暂停离开可视区域的视频，手动控制也可用。

## 自定义播放器

```dart
ListenableBuilder(
  listenable: video,
  builder: (context, _) {
    final controller = video.controller;
    if (video.isCurrent && controller != null) {
      return VideoPlayer(controller); // 来自 package:video_player
    }
    return MyCover();
  },
);
```

`ready` 表示播放器已初始化且会话归属于这个附件，**不代表原生首帧已显示**。封面、敏感内容遮罩和控制按钮由内部组件绘制；库通过可选的后端 `captureThumbnail()` 获取封面，不引入 Presentation 枚举。

`video.thumbnail` 是可直接传给 `Image(image: ...)` 的可空 `ImageProvider`，不要求当前附件拥有播放器。封面变化通过 `video` 通知。库保留最多 16 个 URL 的图片引用；持久化交给 App 的缩略图服务。

配置 `thumbnailLoader: cache.read` 后，注册时会先读取磁盘封面，不创建播放器。`prepareVisibleThumbnails: true` 会在列表停稳后，为可见且启用的附件初始化暂停的会话并截图；同样受 `maxSessions` 限制，后台、滚动中及隐藏附件不会启动这项准备。默认关闭，未实现截图的后端仍可正常使用。App 的 FVP 后端将截图缩至最长边 320 像素、编码为质量 75 的 JPEG，并用完整 URL 的 SHA-256 存为缓存文件；此处不包含定期清理。

BlurHash、API 封面及图片解码前占位图由播放器界面处理，封面加载不改变播放归属、进度或倍速。

通过 `FeedVideo` 控制视频：

```dart
video.enable = false;
video.listIndex = newNoteIndex;
video.listSubIndex = newAttachmentIndex;
// 一次性修改两个索引，避免中间状态
video.updatePosition(listIndex: newNoteIndex, listSubIndex: newAttachmentIndex);

await video.play();
await video.pause();
await video.seekTo(const Duration(seconds: 5));
await video.setMuted(false);
await video.setPlaybackSpeed(1.5);
await video.setGlobalPlaybackSpeed(2);
// 全局设置也可直接调用池
await pool.setGlobalPlaybackSpeed(2);
```

操作非当前视频会先选择它，再执行命令。跳转、倍速或静音操作不会自行开始播放；`play()` 才会显式开始。全局倍速作用于现有和后续注册的视频，之后可以单独覆盖某个附件的倍速。

进度通过只读 `ValueListenable<Duration> video.progress` 单独通知。使用 `ValueListenableBuilder` 更新进度条，不必让整个视频组件随进度重建。

## 稳定身份与页面共享

可选的 `videoKey` 用于将附件身份与排序位置分离。App 使用 `(listKey, noteId, fileId)`；同一 key 的多次注册返回同一个 `FeedVideo`，以引用计数管理销毁。index/subIndex 变化只调整顺序，不替换状态。没有 videoKey 时保持 scope/index/subIndex 的注册方式。

每个 `VideoFeedView` 独立上报可见性；池取已启用引用中的最大值。child 可通过 `VideoFeedView.isVisibleOf(context)` 或 `visibilityOf(context)` 决定是否渲染纹理。销毁一个视图只释放该视图的引用。

项目中的 `AppVideoViewport` 创建列表唯一身份，`NoteVideoContext` 保存 listKey、noteId、listIndex。详情和预览携带来源上下文，附件从原 Note 的文件顺序获得 subIndex，使用 fileId 组合稳定 key。App 的 Riverpod provider 负责池生命周期，账号/服务器切换时替换池。

## 调度与会话

开始滚动时记录当前视频的可见比例；停止后比例没变就保持播放，变了才重新选取可见比例最大的已启用视频。仍是当前视频时保留会话；否则切换。没有固定的可见比例门槛，全部不可见时暂停。比例相同时按 listIndex、listSubIndex 排序。手动暂停及同帖连播规则继续生效。

默认参数：

| 参数 | 默认值 | 作用 |
| --- | --- | --- |
| maxSessions | 3 | 原生播放器实例上限，淘汰最久未使用且未被占用的会话 |
| scrollIdleDelay | 200ms | 最后一次滚动事件后的等待时间 |
| dwell | 200ms | 候选稳定停留时间 |
| notifyVisibilityChanges | false | 是否把百分比变化通知给附件 UI，调度始终能读取它 |

停稳后还要满足 dwell，两段等待分别判断滚动停止和候选稳定。可见性使用格子与视口的矩形交集，分母为格子面积与视口面积的较小值；它不检测浮层遮挡或额外祖先裁剪。

同帖附件按顺序连播一轮，跳过图片和未启用的视频。手动暂停阻止该帖自动恢复。预加载也受容量和滚动状态约束。

底层会话按 URL 缓存，但每个附件位置独立保存进度、倍速和静音状态。同 URL 切换所有者时恢复目标附件状态，不同步其他卡片的进度。资源操作串行执行，过期自动调度会被取消。

`video.session` 可能是其他附件正在使用的缓存会话；渲染使用 `video.controller`，操作使用 FeedVideo API。URL 是当前唯一缓存键；需要不同认证请求的内容应使用独立池，认证和下载缓存没有接入这个库。

## 放大预览

```dart
try {
  await pool.openPreview(video);
  await Navigator.of(context).push(/* 自定义预览页面 */);
} finally {
  await pool.closePreview();
}
```

预览读取 `pool.previewSession`，复用原播放器。手动翻页时调用 `pool.previewSelect(url, listSubIndex: attachmentIndex)`；图片页传 null。预览控件可调用 `pool.previewCommand((player) => player.seek(position))`。预览锁定期间不自动调度列表，也不自动翻页。返回时保留附件进度和倍速；源组件被销毁时仍可关闭预览并安全暂停。

## 生命周期与调试

池由调用方拥有。离开页面时 `pool.dispose()` 会立即停止接收调度，异步释放资源；需要确认释放完成时使用 `await pool.shutdown()`。shutdown 可以重复调用。手动调用 register 时，最终调用返回的 `FeedVideo.dispose()`，由它注销和清理状态。

Riverpod 只是一个可选的实例管理方式：

```dart
final videoPoolProvider = Provider<VideoPool>((ref) {
  final pool = VideoPool();
  ref.onDispose(pool.dispose);
  return pool;
});
```

调试可监听池，读取只读的 `tiles`、`events`、`current`、`liveCount` 和 `scrolling`。播放器后端仅负责初始化、播放、暂停、跳转、音量、速度和释放，不决定调度。

## 验证

```bash
cd packages/moekey_video_pool
flutter pub get
flutter analyze
flutter test
```
