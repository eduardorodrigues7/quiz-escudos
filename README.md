# Quiz dos Escudos ⚽

App mobile desenvolvido em Flutter: o jogo exibe o escudo de um clube e o usuário precisa acertar de qual time da Série A do Campeonato Brasileiro ele pertence.

## Sobre o projeto

- 20 clubes cadastrados
- 4 alternativas por rodada, sorteadas aleatoriamente a cada partida
- Botão de dica com o apelido e o estado do clube
- Placar em tempo real, barra de progresso e tela de resultado com aproveitamento
- Partidas de 5, 10 ou 20 rodadas

Os escudos são **desenhados em tempo de execução** com `CustomPainter`, sem uso de imagens externas. Cada brasão é construído no canvas a partir do formato do escudo e do padrão do uniforme do clube (listras verticais, listras horizontais, faixa diagonal, tricolor, entre outros). Essa decisão evita o uso dos logos oficiais, que são marcas registradas dos clubes, e mantém o aplicativo leve, sem pasta de assets.

## Tecnologias

- Flutter (Dart)
- Material 3
- Gerenciamento de estado com `StatefulWidget` + `setState`
- `CustomPainter` para a renderização dos escudos

## Estrutura do projeto

```
lib/
├── main.dart                     # Ponto de entrada e tema do app
├── models/
│   └── team.dart                 # Modelo Team e enum ShieldPattern
├── data/
│   └── teams.dart                # Base com os 20 clubes da Série A
├── widgets/
│   └── team_shield.dart          # CustomPainter que desenha os escudos
└── screens/
    ├── home_screen.dart          # Tela inicial e escolha de rodadas
    ├── quiz_screen.dart          # Lógica do jogo e verificação das respostas
    └── result_screen.dart        # Placar final
```

## Como executar

Pré-requisitos: Flutter SDK instalado e um emulador Android ou dispositivo físico conectado.

```bash
git clone https://github.com/eduardorodrigues7/quiz-escudos.git
cd quiz-escudos
flutter pub get
flutter run
```

Para gerar o APK de release:

```bash
flutter build apk
```

O arquivo é gerado em `build/app/outputs/flutter-apk/`.

## Como funciona

A cada partida, `_buildQuestions()` embaralha a lista de clubes e seleciona a quantidade de rodadas escolhida pelo usuário. Para cada time sorteado, são montadas três alternativas incorretas aleatórias somadas à resposta correta, e a ordem das opções é embaralhada novamente. Por isso nenhuma partida se repete.

Ao selecionar uma alternativa, o método `_answer()` bloqueia novas respostas na rodada, aplica o feedback visual (verde para acerto, vermelho para erro) e atualiza o placar. Na última rodada, o resultado é enviado para a tela final.

## Possíveis melhorias

- Cronômetro por rodada
- Ranking local persistido com `shared_preferences`
- Modo difícil, com o nome do time digitado em vez de alternativas
- Suporte a outras divisões e campeonatos

## Observação

A lista de clubes em `lib/data/teams.dart` corresponde à Série A de 2025. Para atualizar a temporada, basta editar esse arquivo — nenhuma outra parte do código precisa ser alterada.
