English | [简体中文](./README.zh_CN.md)

![](./docs/banner.png)

[![Crowdin](https://badges.crowdin.net/moekey/localized.svg)](https://crowdin.com/project/moekey)

# MoeKey

MoeKey is a cross-platform misskey client made by Flutter.

## Features

MoeKey is a cross-platform Misskey client built with Flutter, with a UI that follows the original Misskey style.

> MoeKey is still under development. This list is based on pages, interactions, and API calls in the current source, not live verification against every server version. Published releases may lag behind the source.

### Supported

- **Accounts**: sign in to multiple accounts, switch accounts, and remove accounts.
- **Timelines**: home, local, social (hybrid), and global timelines, with pagination and live updates.
- **Search and discovery**: note and user search, Explore, popular content, and hashtag browsing.
- **Posting**: text and attachments, replies, quote renotes, polls, content warnings (CW), visibility, specified recipients, and local-only posting.
- **Note actions**: renotes, emoji reactions, voting, copying and sharing links; edit, delete, and delete-and-redraft your own notes. Direct editing requires server support for `notes/update`.
- **Translation**: available when the connected server provides a translation service.
- **Users and following**: profiles, notes, media, reactions, clips, following and follower lists; follow/unfollow, accept or reject incoming follow requests, and view or cancel sent requests.
- **Notifications**: grouped notifications, mentions, notes with specified recipients, unread counts, and achievement-earned notifications.
- **Profile editing**: avatar, banner, display name, bio, location, birthday, language, custom profile fields, and followed message.
- **Drive**: browse files and folders, upload local files or import from a URL, create folders, rename and delete items, and edit file descriptions and sensitivity flags.
- **Clips**: create, edit, delete, and favorite clips, and add or remove notes.
- **Media and announcements**: image preview and saving, video playback, and announcement browsing and read confirmation.

### Not yet supported or incomplete

- Dedicated browsing and management pages for antennas, channels, and user lists.
- User widgets: currently display an unsupported message.
- Complete Misskey settings: profile editing and account management are implemented; the privacy settings entry is not connected yet.
- Achievement lists and detail pages: achievement-earned notifications are supported, but full achievement browsing is not.

## Download

- [GitHub Releases](https://github.com/MoeKeyDev/MoeKey/releases/latest)

## Screenshot

![](./docs/Screenshot.png)

## Developers

### Localize

Help us translate MoeKey into your language on [Crowdin](https://crowdin.com/project/moekey)

riverpod code gen

```shell
 dart run build_runner watch --use-polling-watcher
```
