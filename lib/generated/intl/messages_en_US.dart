// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en_US';

  static String m0(selectListLength, maxSelect) =>
      "Confirm(${selectListLength}/${maxSelect})";

  static String m1(error) => "Failed to create\n\n ${error}";

  static String m2(days) => "${days}d ago";

  static String m3(thing) => "Should I delete ‘${thing}’?";

  static String m4(name) =>
      "Are you sure you want to delete the file \"${name}\"? Notes with this file attached will also be deleted.";

  static String m5(name) =>
      "Want to delete the \"${name}\" folder? If there are contents in the folder, please delete the contents of the folder first.";

  static String m6(day, hour, minute, second) =>
      "${day}d ${hour}h ${minute}m ${second}s";

  static String m7(hour, minute, second) => "${hour}h ${minute}m ${second}s";

  static String m8(minute, second) => "${minute}m ${second}s";

  static String m9(second) => "${second}s";

  static String m10(error) => "Failed to send note\n\n${error}";

  static String m11(hours) => "${hours}h Ago";

  static String m12(server) => "Logging in ${server}";

  static String m13(minutes) => "${minutes}m ago";

  static String m14(months) => "${months}mo ago";

  static String m15(language) => "Translation from ${language} \n";

  static String m16(type) => "Unsupported notification types:${type}";

  static String m17(seconds) => "${seconds}s ago";

  static String m18(msg) => "Upload Failed\n ${msg}";

  static String m19(count) => "Total Vote ${count}";

  static String m20(count) => "Voted ${count}";

  static String m21(index) => "The Option ${index}";

  static String m22(index) => "The option ${index} cannot be null.";

  static String m23(datetime) => "Deadline after ${datetime}";

  static String m24(years) => "${years}y ago";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addAccount": MessageLookupByLibrary.simpleMessage("Add Account"),
    "addFile": MessageLookupByLibrary.simpleMessage("Add File"),
    "addTitle": MessageLookupByLibrary.simpleMessage("Add Title"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "announcementActive": MessageLookupByLibrary.simpleMessage("Now"),
    "announcementExpired": MessageLookupByLibrary.simpleMessage("Past"),
    "announcements": MessageLookupByLibrary.simpleMessage("Announcements"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "Cancel Mark as NSFW",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clip": MessageLookupByLibrary.simpleMessage("Clips"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "Really remove from favorites?",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage("Create new clip"),
    "clipFavorite": MessageLookupByLibrary.simpleMessage("Add To Favorites"),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage("Favorites"),
    "clipRemove": MessageLookupByLibrary.simpleMessage("Remove Clip"),
    "clipUpdate": MessageLookupByLibrary.simpleMessage("Update clip"),
    "clips": MessageLookupByLibrary.simpleMessage("Clips"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("Copy Content"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copy link"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("Copy RSS"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "Copy User Home Address",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage("Copy Username"),
    "createFolder": MessageLookupByLibrary.simpleMessage("New Folder"),
    "createNote": MessageLookupByLibrary.simpleMessage("Post New Note"),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "Create note from drivers",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage(
      "What\'s happening...",
    ),
    "createdDate": MessageLookupByLibrary.simpleMessage("Creation date"),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("Show Less"),
    "day": MessageLookupByLibrary.simpleMessage("Day"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "download": MessageLookupByLibrary.simpleMessage("Download"),
    "drive": MessageLookupByLibrary.simpleMessage("Driver"),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "emoji": MessageLookupByLibrary.simpleMessage("Emojis"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "Please input a new filename",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "Please enter a new title",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage("Please Enter URL"),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "Body cannot be empty.",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "Body cannot be empty.",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("Explore"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("Popular"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage("Popular users"),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "Newly login users",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage("Pinned users"),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "Recently active users",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("Users"),
    "favorite": MessageLookupByLibrary.simpleMessage("Add to Favorites"),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "folderName": MessageLookupByLibrary.simpleMessage("Folder Name"),
    "follow": MessageLookupByLibrary.simpleMessage("Follow"),
    "followed": MessageLookupByLibrary.simpleMessage("Followed"),
    "followers": MessageLookupByLibrary.simpleMessage("Followers"),
    "following": MessageLookupByLibrary.simpleMessage("Following"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("From Drivers"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
    "hashtag": MessageLookupByLibrary.simpleMessage("Hashtag"),
    "hostnames": MessageLookupByLibrary.simpleMessage("Domain"),
    "hour": MessageLookupByLibrary.simpleMessage("Hours"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("Picture"),
    "inputServer": MessageLookupByLibrary.simpleMessage(
      "Enter the server manually",
    ),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage(
      "Insert Attachment",
    ),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage("Following you"),
    "justNow": MessageLookupByLibrary.simpleMessage("Just now"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage("Keep original image"),
    "loadingServers": MessageLookupByLibrary.simpleMessage("Server Loading"),
    "local": MessageLookupByLibrary.simpleMessage("Local"),
    "localUpload": MessageLookupByLibrary.simpleMessage("Local Upload"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Login failed"),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "Login failed: App creation failed",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "Login failed: token fetch failed",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage("Login Successful"),
    "manageAccount": MessageLookupByLibrary.simpleMessage("Manage Accounts"),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage("Mark as NSFW"),
    "mention": MessageLookupByLibrary.simpleMessage("Mentions"),
    "minute": MessageLookupByLibrary.simpleMessage("Minute"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("More"),
    "myCLips": MessageLookupByLibrary.simpleMessage("My Clips"),
    "name": MessageLookupByLibrary.simpleMessage("name"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "The name cannot be empty",
    ),
    "next": MessageLookupByLibrary.simpleMessage("Next Steps"),
    "noLists": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any lists",
    ),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "Your server was not found?",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "Copy this site link",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("Hide"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage("Show more"),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "Non-participation in joint",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "View on remote instance",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("Pinned note"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("References"),
    "noteReNote": MessageLookupByLibrary.simpleMessage("Forward"),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Forwarded"),
    "noteTranslate": MessageLookupByLibrary.simpleMessage("Translate Post"),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("Visibility"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage(
      "Followers",
    ),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "Post to Followers only",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("Home Page"),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "Post to home timeline only",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("Public"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "Your note will be visible for all users",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "Specified",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "Post to specified users only",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("Notes"),
    "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
    "notification": MessageLookupByLibrary.simpleMessage("Notifications"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "notifyAll": MessageLookupByLibrary.simpleMessage("All"),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("Filter"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "Your follow request was passed",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage("Followed you"),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "Mark All as Read",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage("Mentions"),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("Specified"),
    "notifyNotSupport": m16,
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "Go to browser display",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("Overview"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Follow request pending",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Preview"),
    "previewNote": MessageLookupByLibrary.simpleMessage("Preview post"),
    "processing": MessageLookupByLibrary.simpleMessage("Processing"),
    "public": MessageLookupByLibrary.simpleMessage("Public"),
    "publish": MessageLookupByLibrary.simpleMessage("Publish"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage("Quote this note..."),
    "reNoteText": MessageLookupByLibrary.simpleMessage("Quote Note"),
    "reaction": MessageLookupByLibrary.simpleMessage("Reactions"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "Accept Emoticon Response",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("All"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "Only likes",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "Only likes for remote instances",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "Non-sensitive only",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "Non-sensitive only(Only likes from remote)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage("Recipient"),
    "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
    "remote": MessageLookupByLibrary.simpleMessage("Remote"),
    "rename": MessageLookupByLibrary.simpleMessage("Rename"),
    "renameFile": MessageLookupByLibrary.simpleMessage("Rename File"),
    "renameFolder": MessageLookupByLibrary.simpleMessage("Rename Folder"),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "Reply to this note...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage("Reply to Note"),
    "saveFailed": MessageLookupByLibrary.simpleMessage("Save Failed"),
    "saveImage": MessageLookupByLibrary.simpleMessage("Save picture"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage("Save successful"),
    "search": MessageLookupByLibrary.simpleMessage("Search for"),
    "searchAll": MessageLookupByLibrary.simpleMessage("All"),
    "searchHost": MessageLookupByLibrary.simpleMessage("Specify Domain"),
    "searchLocal": MessageLookupByLibrary.simpleMessage("Local"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("Remote"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
    "secondsAgo": m17,
    "selectHashtag": MessageLookupByLibrary.simpleMessage("Select tag"),
    "selectServer": MessageLookupByLibrary.simpleMessage(
      "Please Select Your Server",
    ),
    "selectUser": MessageLookupByLibrary.simpleMessage("Select Users"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage("Tap to show"),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage("Sensitive"),
    "serverAddr": MessageLookupByLibrary.simpleMessage("Hostname"),
    "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
    "showConversation": MessageLookupByLibrary.simpleMessage(
      "View Conversation",
    ),
    "somebodyNote": MessageLookupByLibrary.simpleMessage(" \'s Posts"),
    "timeline": MessageLookupByLibrary.simpleMessage("Timeline"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage("Global"),
    "timelineHome": MessageLookupByLibrary.simpleMessage("Home"),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("Hybrid"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("Local"),
    "translate": MessageLookupByLibrary.simpleMessage("Translation"),
    "uncategorized": MessageLookupByLibrary.simpleMessage("Uncategorized"),
    "unfollow": MessageLookupByLibrary.simpleMessage("Unfollow"),
    "updatedDate": MessageLookupByLibrary.simpleMessage("Update Date"),
    "uploadFailed": m18,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage("Upload from URL"),
    "user": MessageLookupByLibrary.simpleMessage("Users"),
    "userAll": MessageLookupByLibrary.simpleMessage("All"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "This user has not written their bio yet.",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage("Attachments"),
    "userHot": MessageLookupByLibrary.simpleMessage("Users"),
    "userNote": MessageLookupByLibrary.simpleMessage("Notes"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("Joined on"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "Widget List (Not Completed)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("Username"),
    "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
    "video": MessageLookupByLibrary.simpleMessage("Videos"),
    "view": MessageLookupByLibrary.simpleMessage("View"),
    "viewMore": MessageLookupByLibrary.simpleMessage("View More"),
    "vote": MessageLookupByLibrary.simpleMessage("Vote"),
    "voteAllCount": m19,
    "voteCount": m20,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("Due Date"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "Multiple votes allowed",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage("Voting has ended"),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("Permanently"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "The number of votes cannot be less than two",
    ),
    "voteOptionHint": m21,
    "voteOptionNullIndex": m22,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "Vote results generated",
    ),
    "voteWillExpired": m23,
    "yearsAgo": m24,
  };
}
