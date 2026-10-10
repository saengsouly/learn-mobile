import 'package:flutter/material.dart';

/// ສູນລວມ theme ຂອງແອັບ — ແກ້ບ່ອນດຽວ ມີຜົນທົ່ວແອັບ
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  );
}
