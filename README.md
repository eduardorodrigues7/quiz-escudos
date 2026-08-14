# Quiz dos Escudos — Série A

App mobile em Flutter: o app mostra um escudo e o usuário precisa adivinhar de qual time da Série A ele é.

- 20 clubes cadastrados
- 4 alternativas por rodada, sorteadas a cada partida
- Botão de dica (apelido + estado do clube)
- Placar, barra de progresso e tela de resultado

Os escudos são **desenhados dentro do app** com `CustomPainter` (formato do brasão + padrão do uniforme: listras, faixa diagonal, tricolor, etc.). Isso evita usar logos oficiais, que são marcas registradas dos clubes, e ainda rende um ponto legal para comentar no vídeo.

---

## 1. Setup do Flutter

```bash
# 1. Baixe o SDK em https://docs.flutter.dev/get-started/install
#    e adicione a pasta flutter/bin ao PATH

flutter --version      # confirma a instalação
flutter doctor          # checa Android SDK, licenças, emulador, etc.
flutter doctor --android-licenses   # se aparecer pendência de licença
flutter devices         # lista emulador / celular conectado
```

Checklist do `flutter doctor` que precisa estar OK para rodar no Android:
- Flutter SDK
- Android toolchain (Android Studio + SDK + licenças aceitas)
- Um device conectado (emulador ou celular com depuração USB ativada)

## 2. Criar o projeto e colar o código

```bash
flutter create quiz_escudos
cd quiz_escudos
```

Depois substitua a pasta `lib/` e o arquivo `pubspec.yaml` pelos deste projeto. A estrutura fica assim:

```
lib/
├── main.dart                     # entrada do app + tema
├── models/team.dart              # modelo Team + enum ShieldPattern
├── data/teams.dart               # os 20 clubes da Série A
├── widgets/team_shield.dart      # CustomPainter que desenha o escudo
└── screens/
    ├── home_screen.dart          # tela inicial (escolhe nº de rodadas)
    ├── quiz_screen.dart          # lógica do jogo
    └── result_screen.dart        # placar final
```

## 3. Rodar

```bash
flutter pub get
flutter run              # roda no device selecionado
flutter build apk        # gera o APK em build/app/outputs/flutter-apk/
```

---

## Como o jogo funciona (para explicar no vídeo)

1. `_buildQuestions()` embaralha a lista de clubes e pega N times.
2. Para cada time sorteado, monta 3 distratores aleatórios + a resposta certa e embaralha as 4 alternativas.
3. Ao tocar numa alternativa, `_answer()` trava a rodada, pinta verde/vermelho e incrementa o placar.
4. Na última rodada, navega para a `ResultScreen` com o aproveitamento.

O estado é controlado com `StatefulWidget` + `setState` — sem pacote externo de gerenciamento de estado, para manter o projeto simples e fácil de defender na apresentação.

---

## Roteiro do vídeo (~4 min)

1. **Abertura (20s)** — seu nome, disciplina e o que o app faz.
2. **Setup (60s)** — terminal com `flutter --version`, `flutter doctor` e `flutter devices`. Mostre o Android Studio / VS Code com o emulador aberto.
3. **Código-fonte (90s)** — abra na ordem: `main.dart` (tema), `models/team.dart`, `data/teams.dart` (mostre 1 ou 2 times), `widgets/team_shield.dart` (o `CustomPainter` — é o diferencial) e `screens/quiz_screen.dart` (o sorteio das perguntas e a verificação da resposta).
4. **Projeto rodando (60s)** — `flutter run`, escolha 5 rodadas, acerte uma, erre outra de propósito para mostrar o feedback, use o botão de dica e chegue na tela de resultado.
5. **Fechamento (20s)** — o que dá para evoluir: ranking local, cronômetro por rodada, escudos por asset e mais divisões.

## Ideias para incrementar (se quiser mais nota)

- Cronômetro de 10s por rodada usando `Timer.periodic`
- Salvar o recorde com `shared_preferences`
- Modo difícil: escrever o nome do time em vez de escolher alternativa
- Trocar o `CustomPainter` por imagens em `assets/escudos/` (declare em `pubspec.yaml` e use `Image.asset`)

> A lista em `lib/data/teams.dart` segue a Série A de 2025. Se a temporada atual mudou, é só editar essa lista — nenhum outro arquivo precisa ser alterado.
