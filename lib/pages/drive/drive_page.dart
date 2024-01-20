import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/driver/driver_list.dart';

class DrivePage extends HookConsumerWidget {
  const DrivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: DriverList(id: ''),
    );
  }
}
