# Changelog
# 0.9.1
- update flutter 3.32

# 0.9.0
- Add ios ipa releases
- Add User profile


## 0.8.7
- Update Flutter dependencies version
- Enable Impeller support

## 0.8.5

- Add Freezed instead Menual JSON Serialize

## 0.8.1

### Feature

- Add Android Adaptive Icon support

## 0.8.0

### Feature

- Add HashTag Page

## 0.7.4

### Chore

- Update Flutter 3.27

### Fixed

- Fixed Image Preview Load

## 0.7.3

### Fixed

- Fixed Hero animation conflict during image preview
- Fixed translation issues

### Added

- More translations

## 0.7.2

### Added

- Added Korean language support by [@everyscreennetwork](https://crowdin.com/profile/everyscreennetwork)

## 0.7.1

### Fixed

- fix: blurhash flickering

### Feature

- Image preview click to hidden app bar

## 0.7.0

- Add English language support
- Add Japanese language support

## 0.6.1

### Fixed

- Fix Note loading issue

## 0.6.0

### Feature

- Add `go_router` for routing

### Fixed

- Fix issue where the soft keyboard would not open when creating a post

## 0.5.3

### Feature

- Add Driver page menus

### Fixed

- Fix list load more sometimes can't be triggered

## 0.5.0

### Feature

- Add search page

## 0.4.0

### Feature

- Add announcement list page
- Empty page add info image

### Refactor

- refactor: emoji select list fix: image width

## 0.3.13

### fix:

- Error when switching users
- User follow list can't load
- Fix duplicate loading of timeline
- Fix image save failed

### refactor

move logger.dart file update loading state in list riverpod

## 0.3.12

### Feature

- add user follow list page

## 0.3.10

### refactor

Timeline list

### fix

fail to save Image in image preview

## 0.3.9+31

## Feature

- Add Explore Page

### Refactored

- Refactored timeline

## 0.3.8+30

### Refactored

- timeline note reaction algorithm

### Fixed

- note image preview Hero animations occasionally not working

## 0.3.5+27

### Feature

- add timeline cache

### Refactor

- notes update listener

## 0.3.4+26

### Feature

- add Hive

## 0.3.3

### Chore

- update flutter version to 3.22
- update dependencies version

## 0.3.1

### Feature

- Update Clip feature

### Refactor

- Network code move to Api Folder

## 0.2.18

### Feature

- Update Clips page

## 0.2.17

### Fixed

- Fixed save url error when user login
- Optimize image loading performance.

## 0.2.16

### Fixed

- add macOS network permission #10

## 0.2.15

### Fixed

- fix note page conversation can't load

## 0.2.14

### Fixed

- Update padding for login page Logo

## 0.2.13

### Feature

- add macOS build (#9)

## 0.2.12

### Feature

- Note list context menu
- Note translate

### Change

- image save webp to png

## 0.2.11

### Feature

- image save webp to jpeg

## 0.2.10

### Feature

- Clicking on the link preview will now open the link.

## 0.2.9

### Feature

- Add link preview

## 0.2.7

### Fixed

- Android image save album

## 0.2.6

### Fixed

- Image preview gestures

## 0.2.5

### Feature

- User profile page update

## 0.2.3

### Feature

- Adding a transition animation to a preview image
- Preload image preview
- Add double-click to zoom in and out to preview
- Saving images is faster

### Fixed

- Fix the crash that may occur due to oversized images.

## 0.2.2

### Fixed

- fix crashes when note create dialog uploading image

## 0.2.1

### Fixed

- Notify Card note preview
- Add websocket heartbeat packets
- Fix crashes when links contain non-text content

### Feature

- User follow

## 0.2.0

### Feature

- The preview of the original note is now displayed in the note create dialog
- The username mention is now automatically added to the reply dialog

### Fixed

- Some mention avatars on the notes page don't display in some cases
- The link for MFM is not opening

### Other

- Upgrade flutter dependencies