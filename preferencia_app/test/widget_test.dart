
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:preferencia_app/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Deve exibir a tela de configurações', (tester) async {
    await tester.pumpWidget(const PreferenciaApp());

    await tester.pumpAndSettle();

    expect(find.text('Configurações Locais'), findsOneWidget);
    expect(find.text('Modo Escuro'), findsOneWidget);
    expect(find.text('Receber Notificações'), findsOneWidget);
    expect(find.text('Perfil do Usuário'), findsOneWidget);
    expect(find.text('Acessibilidade'), findsOneWidget);
    expect(find.text('Limpar Configurações'), findsOneWidget);
  });

  testWidgets('Deve apresentar as opções de tamanho da fonte', (tester) async {
    await tester.pumpWidget(const PreferenciaApp());

    await tester.pumpAndSettle();

    expect(find.text('Tamanho da Fonte'), findsOneWidget);
    expect(find.text('Médio'), findsOneWidget);
  });
}

