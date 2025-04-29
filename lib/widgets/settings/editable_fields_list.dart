import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:moekey/widgets/mk_button.dart';
import 'package:moekey/widgets/mk_input.dart';
import 'package:moekey/status/themes.dart';

class EditableFieldsList extends HookConsumerWidget {
  final List<Field> initialFields;
  final Future<void> Function(List<Field>) onSave;

  const EditableFieldsList({
    super.key,
    required this.initialFields,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fields = useState<List<Field>>(() {
      final initialList = List<Field>.from(initialFields);
      while (initialList.length < 4) {
        initialList.add(Field(name: '', value: ''));
      }
      return initialList;
    }());
    // final isDeleting = useState(false); // 确认移除 isDeleting 状态
    final isSaving = useState(false);

    void handleReorder(int oldIndex, int newIndex) {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = fields.value.removeAt(oldIndex);
      // Create a new list instance to trigger rebuild
      fields.value = List.from(fields.value)..insert(newIndex, item);
      // fields.notifyListeners(); // Remove unnecessary notifyListeners
    }

    void handleAdd() {
      final newField = Field(name: '', value: '');
      fields.value = [
        ...fields.value,
        newField
      ]; // Assigning new list triggers rebuild
      // fields.notifyListeners(); // Remove unnecessary notifyListeners
    }

    void handleDelete(int index) {
      final updatedFields = List<Field>.from(fields.value)..removeAt(index);
      fields.value = updatedFields; // Assigning new list triggers rebuild
      // fields.notifyListeners(); // Remove unnecessary notifyListeners
    }

    void handleSave() async {
      if (isSaving.value) return; // 防止重复点击
      isSaving.value = true;
      try {
        final fieldsToSave = fields.value
            .where((field) => field.name.isNotEmpty || field.value.isNotEmpty)
            .toList();
        await onSave(fieldsToSave);
        // isDeleting.value = false; // 确认移除
      } finally {
        // 确保在组件仍然挂载时才更新状态
        if (context.mounted) {
          isSaving.value = false;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8,
        ),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: fields.value.length,
          itemBuilder: (context, index) {
            final field = fields.value[index];
            var themes = ref.watch(themeColorsProvider);

            return Container(
              key: ObjectKey(fields.value[index]),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              // padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: themes.bgColor,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // 垂直居中
                  children: [
                    // 拖拽图标
                    MouseRegion(
                      cursor: SystemMouseCursors.move,
                      child: ReorderableDragStartListener(
                        index: index,
                        child: GestureDetector(
                          // 使用 GestureDetector 包裹
                          behavior: HitTestBehavior.opaque, // 使 padding 区域可命中
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 16, top: 8, bottom: 8),
                            child: const Icon(
                              TablerIcons.menu,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 输入框部分
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final bool isHorizontal = constraints.maxWidth >= 400;
                          final Axis direction =
                              isHorizontal ? Axis.horizontal : Axis.vertical;
                          final double spacing = 8.0;

                          final nameInput = MkInput(
                            value: field.name,
                            hintText: "标签",
                            onChanged: (newName) {
                              final updatedFields =
                                  List<Field>.from(fields.value);
                              if (index < updatedFields.length) {
                                updatedFields[index] =
                                    Field(name: newName, value: field.value);
                                fields.value = updatedFields;
                              }
                            },
                          );
                          final valueInput = MkInput(
                            value: field.value,
                            hintText: "内容",
                            onChanged: (newValue) {
                              final updatedFields =
                                  List<Field>.from(fields.value);
                              if (index < updatedFields.length) {
                                updatedFields[index] =
                                    Field(name: field.name, value: newValue);
                                fields.value = updatedFields;
                              }
                            },
                          );

                          // 使用 Flex 替代 Row/Column
                          return Flex(
                            direction: direction,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(child: nameInput), // 使用 Flexible 适应空间
                              SizedBox(
                                width: isHorizontal ? spacing : 0,
                                height: isHorizontal ? 0 : spacing,
                              ),
                              Flexible(child: valueInput), // 使用 Flexible 适应空间
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8), // 添加间距

                    // 删除按钮
                    IconButton(
                      icon: const Icon(
                        TablerIcons.trash,
                        color: Colors.red,
                        size: 18,
                      ),
                      onPressed: () => handleDelete(index),
                      tooltip: '删除此项',
                    )
                  ],
                ),
              ),
            );
          },
          onReorder: handleReorder,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 8),
            MkPrimaryButton(
              onPressed: handleSave,
              child: isSaving.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text("保存"),
            ),
            const SizedBox(width: 8),
            MkSecondaryButton(
              onPressed: handleAdd,
              child: const Text("添加"),
            ),
            // 确认移除底部的删除按钮和相关 SizedBox
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class Field {
  String name;
  String value;
  Field({required this.name, required this.value});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Field &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
