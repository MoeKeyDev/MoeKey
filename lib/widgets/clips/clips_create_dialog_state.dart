import 'package:dio/dio.dart';
import 'package:moekey/pages/clips/clips.dart';
import 'package:moekey/status/dio.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../apis/models/clips.dart';
import '../../main.dart';
import '../mk_info_dialog.dart';

part 'clips_create_dialog_state.g.dart';

class ClipCreateDialogStateModel {
  String name = "";
  String description = "";
  bool isPublic = false;
  bool isPreview = false;

  @override
  String toString() {
    return 'ClipCreateDialogStateModel{name: $name, description: $description, isPublic: $isPublic, isPreview: $isPreview}';
  }
}

@riverpod
class ClipCreateDialogState extends _$ClipCreateDialogState {
  @override
  ClipCreateDialogStateModel build({String? clipId}) {
    return ClipCreateDialogStateModel();
  }

  updateName(String name) {
    state.name = name;
    ref.notifyListeners();
  }

  updateDescription(String description) {
    state.description = description;
    ref.notifyListeners();
  }

  updateIsPublic(bool isPublic) {
    state.isPublic = isPublic;
    ref.notifyListeners();
  }

  updateIsPreview(bool isPreview) {
    state.isPreview = isPreview;
    ref.notifyListeners();
  }

  send() async {
    var apis = await ref.read(misskeyApisProvider.future);
    try {
      if (state.name.isEmpty) {
        throw Exception("名称不能为空");
      }
      // 更新
      if (clipId != null) {
        var res = await apis.clips.update(
            name: state.name,
            description: state.description,
            isPublic: state.isPublic,
            clipId: clipId!);

        ref.invalidate(clipsProvider);
        ref.invalidate(clipsShowProvider(clipId!));

        return res;
      }

      var res = await apis.clips.create(
        name: state.name,
        description: state.description,
        isPublic: state.isPublic,
      );
      ref.invalidate(clipsProvider);
      return res;
    } on DioException catch (e) {
      logger.d(e.response);
      MkInfoDialog.show(
          info: "创建失败\n\n ${e.response?.data.toString() ?? e.toString()}",
          isError: true);
    } catch (e) {
      MkInfoDialog.show(info: "$e", isError: true);
    }
  }
}
