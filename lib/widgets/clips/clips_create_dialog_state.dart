import 'package:dio/dio.dart';
import 'package:moekey/networks/dio.dart';
import 'package:moekey/state/server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../apis/models/clips.dart';
import '../../main.dart';
import '../info_dialog.dart';

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
  ClipCreateDialogStateModel build() {
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
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    try {
      if (state.name.isEmpty) {
        throw Exception("名称不能为空");
      }
      if (state.description.isEmpty) {
        throw Exception("描述不能为空");
      }

      var res = await http.post("/clips/create", data: {
        "name": state.name,
        "description": state.description,
        "isPublic": state.isPublic,
        "i": user?.token
      });

      return ClipsModel.fromMap(res.data);
    } on DioException catch (e) {
      logger.d(e.response);
      InfoDialog.show(
          info: "创建失败\n\n ${e.response?.data.toString() ?? e.toString()}",
          isError: true);
    } catch (e) {
      InfoDialog.show(info: "$e", isError: true);
    }
  }
}
