# 功能核对记录

核对日期：2026-09-29。代码基准：`9ce2cab`。

本次通过路由、页面操作、状态管理和实际 API 调用核对功能，不以接口声明、翻译文本或测试预览单独认定为已支持。未运行登录后的客户端或对真实服务器进行操作，因此此记录不保证服务器兼容性或运行时无缺陷，也不表示最新发布包已包含这些功能。

| 功能 | 实现依据（相对仓库根目录） |
| --- | --- |
| 多账号登录、切换与移除 | `lib/pages/settings/account_manager/account_manager_page.dart`、`lib/status/user_login.dart`、`lib/pages/home/home_page.dart` |
| 四种时间线及实时更新 | `lib/pages/timeline/timeline_page.dart`、`lib/status/timeline.dart` |
| 搜索、发现与话题 | `lib/pages/search/`、`lib/pages/explore/`、`lib/pages/hashtag/hashtag_page.dart`，均有 `lib/router/router.dart` 路由 |
| 发布、回复、引用、投票、可见范围和附件 | `lib/widgets/note_create_dialog/note_create_dialog.dart`、`note_create_dialog_state.dart` 中表单操作与 `notes/create` 调用 |
| 编辑、删除及删除后重发 | `lib/widgets/notes/note_card.dart` 的本人帖子菜单；编辑器状态调用 `notes/update`、`notes/delete`、`notes/create`。直接编辑依赖服务器接口支持 |
| 表情回应、转发、投票与翻译 | `lib/widgets/notes/note_card.dart`、`lib/widgets/reactions.dart`、`lib/widgets/notes/note_poll.dart`；翻译入口受 `meta.translatorAvailable` 限制 |
| 用户浏览、关注与关注请求 | `lib/pages/users/`、`lib/status/user.dart`、`lib/pages/notifications/notifications_group_list.dart`、`sent_follow_requests_list.dart` |
| 通知与成就获得提醒 | `lib/pages/notifications/notifications_page.dart`、`notifications_group_list.dart`、`lib/status/unread_notification_count.dart` |
| 个人资料编辑 | `lib/pages/settings/router.dart` 已注册资料页；`profile/profile.dart`、`member_info_state.dart` 与 `lib/widgets/settings/fields.dart` 接通 `account.update` |
| 网盘 | `lib/widgets/driver/driver_list.dart`、`drive_thumbnail.dart`、`drive.dart` 提供上传、文件夹和文件管理操作 |
| 便签管理与收藏 | `lib/widgets/clips/clips_create_dialog_state.dart`、`lib/pages/clips/clips_notes.dart`；帖子菜单接通添加便签 |
| 媒体与公告 | `lib/pages/image_preview/image_preview.dart` 接通保存和视频播放；`lib/pages/announcements/announcements.dart` 接通公告查询与已读确认 |

## 仍需明确的边界

- 隐私菜单在 `lib/pages/settings/settings_page.dart` 引用 `settingsTest2`，但设置路由未注册该名称；不能据菜单入口声明隐私设置已支持。
- `lib/pages/user_widgets/widgets_list/view.dart` 仍只显示未支持提示。
- 当前路由和页面中未找到天线、频道、用户列表管理以及成就列表/详情实现。通知类型和 API 模型中出现这些名称，不代表已有对应功能页面。
- 成就获得通知已经有显示分支，因此旧文档中的“用户成就未实现”改为“成就浏览未完成”。

本次同步更新中英文 README 与本地静态首页功能区；未修改 App 行为。
