// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that looks up messages for specific locales by
// delegating to the appropriate library.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:implementation_imports, file_names, unnecessary_new
// ignore_for_file:unnecessary_brace_in_string_interps, directives_ordering
// ignore_for_file:argument_type_not_assignable, invalid_assignment
// ignore_for_file:prefer_single_quotes, prefer_generic_function_type_aliases
// ignore_for_file:comment_references

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'messages_af_ZA.dart' as messages_af_za;
import 'messages_ar_SA.dart' as messages_ar_sa;
import 'messages_ca_ES.dart' as messages_ca_es;
import 'messages_cs_CZ.dart' as messages_cs_cz;
import 'messages_da_DK.dart' as messages_da_dk;
import 'messages_de_DE.dart' as messages_de_de;
import 'messages_el_GR.dart' as messages_el_gr;
import 'messages_en_US.dart' as messages_en_us;
import 'messages_es_ES.dart' as messages_es_es;
import 'messages_fi_FI.dart' as messages_fi_fi;
import 'messages_fr_FR.dart' as messages_fr_fr;
import 'messages_he_IL.dart' as messages_he_il;
import 'messages_hu_HU.dart' as messages_hu_hu;
import 'messages_it_IT.dart' as messages_it_it;
import 'messages_ja_JP.dart' as messages_ja_jp;
import 'messages_ko_KR.dart' as messages_ko_kr;
import 'messages_nl_NL.dart' as messages_nl_nl;
import 'messages_no_NO.dart' as messages_no_no;
import 'messages_pl_PL.dart' as messages_pl_pl;
import 'messages_pt_BR.dart' as messages_pt_br;
import 'messages_pt_PT.dart' as messages_pt_pt;
import 'messages_ro_RO.dart' as messages_ro_ro;
import 'messages_ru_RU.dart' as messages_ru_ru;
import 'messages_sr_SP.dart' as messages_sr_sp;
import 'messages_sv_SE.dart' as messages_sv_se;
import 'messages_tr_TR.dart' as messages_tr_tr;
import 'messages_uk_UA.dart' as messages_uk_ua;
import 'messages_vi_VN.dart' as messages_vi_vn;
import 'messages_zh_CN.dart' as messages_zh_cn;
import 'messages_zh_TW.dart' as messages_zh_tw;

typedef Future<dynamic> LibraryLoader();

Map<String, LibraryLoader> _deferredLibraries = {
  'af_ZA': () => new SynchronousFuture(null),
  'ar_SA': () => new SynchronousFuture(null),
  'ca_ES': () => new SynchronousFuture(null),
  'cs_CZ': () => new SynchronousFuture(null),
  'da_DK': () => new SynchronousFuture(null),
  'de_DE': () => new SynchronousFuture(null),
  'el_GR': () => new SynchronousFuture(null),
  'en_US': () => new SynchronousFuture(null),
  'es_ES': () => new SynchronousFuture(null),
  'fi_FI': () => new SynchronousFuture(null),
  'fr_FR': () => new SynchronousFuture(null),
  'he_IL': () => new SynchronousFuture(null),
  'hu_HU': () => new SynchronousFuture(null),
  'it_IT': () => new SynchronousFuture(null),
  'ja_JP': () => new SynchronousFuture(null),
  'ko_KR': () => new SynchronousFuture(null),
  'nl_NL': () => new SynchronousFuture(null),
  'no_NO': () => new SynchronousFuture(null),
  'pl_PL': () => new SynchronousFuture(null),
  'pt_BR': () => new SynchronousFuture(null),
  'pt_PT': () => new SynchronousFuture(null),
  'ro_RO': () => new SynchronousFuture(null),
  'ru_RU': () => new SynchronousFuture(null),
  'sr_SP': () => new SynchronousFuture(null),
  'sv_SE': () => new SynchronousFuture(null),
  'tr_TR': () => new SynchronousFuture(null),
  'uk_UA': () => new SynchronousFuture(null),
  'vi_VN': () => new SynchronousFuture(null),
  'zh_CN': () => new SynchronousFuture(null),
  'zh_TW': () => new SynchronousFuture(null),
};

MessageLookupByLibrary? _findExact(String localeName) {
  switch (localeName) {
    case 'af_ZA':
      return messages_af_za.messages;
    case 'ar_SA':
      return messages_ar_sa.messages;
    case 'ca_ES':
      return messages_ca_es.messages;
    case 'cs_CZ':
      return messages_cs_cz.messages;
    case 'da_DK':
      return messages_da_dk.messages;
    case 'de_DE':
      return messages_de_de.messages;
    case 'el_GR':
      return messages_el_gr.messages;
    case 'en_US':
      return messages_en_us.messages;
    case 'es_ES':
      return messages_es_es.messages;
    case 'fi_FI':
      return messages_fi_fi.messages;
    case 'fr_FR':
      return messages_fr_fr.messages;
    case 'he_IL':
      return messages_he_il.messages;
    case 'hu_HU':
      return messages_hu_hu.messages;
    case 'it_IT':
      return messages_it_it.messages;
    case 'ja_JP':
      return messages_ja_jp.messages;
    case 'ko_KR':
      return messages_ko_kr.messages;
    case 'nl_NL':
      return messages_nl_nl.messages;
    case 'no_NO':
      return messages_no_no.messages;
    case 'pl_PL':
      return messages_pl_pl.messages;
    case 'pt_BR':
      return messages_pt_br.messages;
    case 'pt_PT':
      return messages_pt_pt.messages;
    case 'ro_RO':
      return messages_ro_ro.messages;
    case 'ru_RU':
      return messages_ru_ru.messages;
    case 'sr_SP':
      return messages_sr_sp.messages;
    case 'sv_SE':
      return messages_sv_se.messages;
    case 'tr_TR':
      return messages_tr_tr.messages;
    case 'uk_UA':
      return messages_uk_ua.messages;
    case 'vi_VN':
      return messages_vi_vn.messages;
    case 'zh_CN':
      return messages_zh_cn.messages;
    case 'zh_TW':
      return messages_zh_tw.messages;
    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) {
  var availableLocale = Intl.verifiedLocale(
    localeName,
    (locale) => _deferredLibraries[locale] != null,
    onFailure: (_) => null,
  );
  if (availableLocale == null) {
    return new SynchronousFuture(false);
  }
  var lib = _deferredLibraries[availableLocale];
  lib == null ? new SynchronousFuture(false) : lib();
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  return new SynchronousFuture(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary? _findGeneratedMessagesFor(String locale) {
  var actualLocale = Intl.verifiedLocale(
    locale,
    _messagesExistFor,
    onFailure: (_) => null,
  );
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
