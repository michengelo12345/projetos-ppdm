# PPDM — Dispositivos Móveis e Criação de Interface

Projeto Flutter com três exercícios práticos:

1. **Cartão de Perfil do Desenvolvedor** — `CircleAvatar`, `Column`, `Row`, `Icon` e `TextStyle`.
2. **Catálogo Dinâmico** — `ListView.builder`, `Card` e `ListTile`.
3. **Formulário Interativo** — `StatefulWidget`, `TextFormField`, `TextEditingController` e `setState()`.

## Requisitos

- Flutter instalado e configurado.
- Dart instalado (incluído no Flutter).
- VS Code ou Android Studio (opcional, conforme o ambiente).

## Como executar

No terminal, dentro da pasta do projeto:

```bash
flutter pub get
flutter run
```

Para executar no navegador:

```bash
flutter run -d chrome
```

## Personalização

Abra `lib/screens/profile_screen.dart` e substitua os valores de exemplo:
- `Seu Nome`
- `seu.email@exemplo.com`

O turno e a turma já estão preenchidos conforme o enunciado: **Noturno** e **T2DEV-T3**.

## Estrutura

```text
ppdm_dispositivos_interface/
├── lib/
│   ├── main.dart
│   └── screens/
│       ├── home_screen.dart
│       ├── profile_screen.dart
│       ├── catalog_screen.dart
│       └── registration_screen.dart
├── .gitignore
├── pubspec.yaml
└── README.md
```

As pastas `build/` e `.dart_tool/` são geradas localmente pelo Flutter e estão incluídas no `.gitignore`; não devem ser enviadas ao GitHub.
