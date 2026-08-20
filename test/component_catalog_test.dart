import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_quiz_app/design_system/components/safe_access_async_state.dart';
import 'package:training_quiz_app/design_system/components/safe_access_button.dart';
import 'package:training_quiz_app/design_system/components/safe_access_section_card.dart';
import 'package:training_quiz_app/design_system/components/safe_access_status_card.dart';

void main() {
  group('Pruebas del Catálogo de Componentes - SafeAccess 90', () {
    // -------------------------------------------------------------------------
    // COMPONENTE 1: SafeAccessButton
    // -------------------------------------------------------------------------
    group('SafeAccessButton', () {
      testWidgets('Renderiza etiqueta y responde a interacción de toque', (tester) async {
        bool pressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SafeAccessButton(
                label: 'Probar Botón',
                onPressed: () => pressed = true,
              ),
            ),
          ),
        );

        expect(find.text('Probar Botón'), findsOneWidget);
        await tester.tap(find.text('Probar Botón'));
        expect(pressed, isTrue);
      });

      testWidgets('Muestra indicador de carga cuando isLoading es verdadero', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SafeAccessButton(
                label: 'Guardando',
                isLoading: true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('Se deshabilita cuando onPressed es nulo', (tester) async {
        bool pressed = false;

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SafeAccessButton(
                label: 'Inhabilitado',
                onPressed: null,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Inhabilitado'));
        expect(pressed, isFalse);
      });
    });

    // -------------------------------------------------------------------------
    // COMPONENTE 2: SafeAccessStatusCard
    // -------------------------------------------------------------------------
    group('SafeAccessStatusCard', () {
      testWidgets('Renderiza título, mensaje e ícono según el estado semántico', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SafeAccessStatusCard(
                title: 'Conexión Exitosa',
                message: 'Servidor operativo.',
                status: SafeAccessStatus.success,
              ),
            ),
          ),
        );

        expect(find.text('Conexión Exitosa'), findsOneWidget);
        expect(find.text('Servidor operativo.'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      });

      testWidgets('Ejecuta la acción secundaria al presionar el botón de acción', (tester) async {
        bool actionTriggered = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SafeAccessStatusCard(
                title: 'Error de Red',
                message: 'Falla al conectar.',
                status: SafeAccessStatus.error,
                actionLabel: 'Reintentar',
                onAction: () => actionTriggered = true,
              ),
            ),
          ),
        );

        expect(find.text('Reintentar'), findsOneWidget);
        await tester.tap(find.text('Reintentar'));
        expect(actionTriggered, isTrue);
      });
    });

    // -------------------------------------------------------------------------
    // COMPONENTE 3: SafeAccessAsyncState
    // -------------------------------------------------------------------------
    group('SafeAccessAsyncState', () {
      testWidgets('Muestra vista de Carga cuando isLoading es verdadero', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SafeAccessAsyncState(
                isLoading: true,
                child: Text('Contenido Principal'),
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Contenido Principal'), findsNothing);
      });

      testWidgets('Muestra vista de Error cuando hay un error definido', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SafeAccessAsyncState(
                error: 'Error 500: Internal Server Error',
                child: Text('Contenido Principal'),
              ),
            ),
          ),
        );

        expect(find.text('Error de conexión'), findsOneWidget);
        expect(find.text('Error 500: Internal Server Error'), findsOneWidget);
        expect(find.text('Contenido Principal'), findsNothing);
      });

      testWidgets('Muestra vista Vacía cuando isEmpty es verdadero', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SafeAccessAsyncState(
                isEmpty: true,
                child: Text('Contenido Principal'),
              ),
            ),
          ),
        );

        expect(find.text('Sin información'), findsOneWidget);
        expect(find.text('Contenido Principal'), findsNothing);
      });

      testWidgets('Renderiza el widget hijo en estado exitoso', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SafeAccessAsyncState(
                child: Text('Contenido Exitoso Cargado'),
              ),
            ),
          ),
        );

        expect(find.text('Contenido Exitoso Cargado'), findsOneWidget);
      });
    });

    // -------------------------------------------------------------------------
    // COMPONENTE 4: SafeAccessSectionCard
    // -------------------------------------------------------------------------
    group('SafeAccessSectionCard', () {
      testWidgets('Renderiza título, subtítulo e ícono leading', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SafeAccessSectionCard(
                title: 'Título Sección',
                subtitle: 'Subtítulo explicativo',
                leadingIcon: Icons.star,
                child: Text('Hijo interno'),
              ),
            ),
          ),
        );

        expect(find.text('Título Sección'), findsOneWidget);
        expect(find.text('Subtítulo explicativo'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Hijo interno'), findsOneWidget);
      });
    });
  });
}
