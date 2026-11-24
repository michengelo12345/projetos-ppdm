
import 'package:flutter_test/flutter_test.dart';
import 'package:cracha_app/main.dart';

void main() {
  testWidgets('Exibe os tres crachas de estudantes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MeuCrachaApp());

    expect(find.text('Ana Silva Santos'), findsOneWidget);
    expect(find.text('Carlos Oliveira'), findsOneWidget);
    expect(find.text('Mariana Costa'), findsOneWidget);

    expect(
      find.text('Validar Carteirinha'),
      findsNWidgets(3),
    );

    expect(
      find.text('Status: Matriculado / Ativo'),
      findsNWidgets(3),
    );
  });
}

