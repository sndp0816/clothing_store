import 'package:flutter/material.dart';

import 'package:clothing_store/app.dart';
import 'package:clothing_store/injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  runApp(const ClothingStoreApp());
}
