import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_nuevo/main.dart';
import 'package:proyecto_nuevo/core/accessibility_controller.dart';

import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Configuramos almacenamiento simulado para las pruebas.
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('La aplicación Vynta se inicia correctamente', (
    WidgetTester tester,
  ) async {
    final accessibilityController = AccessibilityController();

    await tester.pumpWidget(
      VyntaApp(accessibilityController: accessibilityController),
    );

    await tester.pump();

    expect(find.byType(VyntaApp), findsOneWidget);
  });
}
