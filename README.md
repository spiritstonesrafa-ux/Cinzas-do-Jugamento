# Cinzas do Juramento — M0

Fundação de plataforma 2D para Windows. Aren anda, salta e retorna ao ponto
inicial após cair. A espada embainhada é exclusivamente decorativa.

## Ambiente e execução

- Requer Godot **4.3 ou superior**, edição padrão com GDScript; renderer Compatibility.
- Versão instalada: **não detectada neste ambiente**. `godot --version` falhou
  porque o comando não está no PATH. Nenhuma engine, extensão ou asset foi instalado.
- Abra a Godot, escolha **Importar**, selecione `project.godot` e pressione **F6**
  para a cena aberta ou **F5** para iniciar o projeto pela cena principal.
- Alternativamente, no PowerShell, dentro desta pasta:

```powershell
& 'C:\caminho\Godot_v4.x-stable_win64.exe' --path . --editor
& 'C:\caminho\Godot_v4.x-stable_win64.exe' --path .
```

Tela interna 320 × 180; janela inicial 960 × 540. Escala inteira, aspecto
preservado, filtro nearest e renderização alinhada a pixels. Ao redimensionar,
podem aparecer barras para preservar pixels quadrados. Física a 60 Hz;
câmera sem suavização para evitar deslocamentos fracionários.

## Controles

| Ação | Teclas |
|---|---|
| Esquerda | A / seta esquerda |
| Direita | D / seta direita |
| Saltar | Espaço / W / seta para cima |

Segurar salto não repete o salto automaticamente. Não há ataque nem menu.

## Arquivos e responsabilidades

- `project.godot`: configuração de vídeo, inputs, camadas físicas e cena inicial.
- `scenes/main.tscn`: instancia a fase.
- `scenes/player/knight.tscn`: CharacterBody2D e retângulo físico de 12 × 24 px.
- `scripts/player/knight_controller.gd`: movimento tipado, orientação e estados
  IDLE/RUN/JUMP/FALL. Ajustes no Inspector: velocidade 100 px/s, aceleração
  1200 px/s², desaceleração 1600 px/s², gravidade 680 px/s², salto -230 px/s,
  velocidade máxima de queda 360 px/s, coyote time e buffer de 0,10 s.
- `scripts/player/knight_visual.gd`: capacete, armadura, capa e bainha geométricos;
  apenas o visual é espelhado, mantendo o colisor inalterado.
- `scenes/levels/prototype_stage.tscn`: dois pisos, duas paredes, quatro
  plataformas sólidas, Marker2D inicial, jogador e Camera2D.
- `scripts/levels/prototype_stage.gd`: retorno após Y > 224 com velocidade e
  temporizadores zerados; câmera horizontal inteira com limites 0–960 × 0–180.
- `scripts/levels/stage_visual.gd`: fundo original sem colisão.
- `tests/smoke_test.gd`: testes de física sem dependências externas.

Fase de 960 px de largura, piso em Y=156 e vão entre X=560 e X=624. Plataformas
em Y=124, 94, 72 e 120. Início em (48,156), sobre chão seguro. O vão tem bordas
âmbar; cair nele testa o retorno. O salto padrão sobe aproximadamente 37 px
na integração discreta de 60 Hz; as plataformas formam uma escada alcançável.
Geometria é sólida por todos os lados; plataformas não são unidirecionais.

Os documentos originais `GDD.md`, `ARQUITETURA.md` e `ROADMAP.md` estavam na raiz
e foram preservados no local. Não foram criados diretórios vazios de assets,
autoloads, managers, combate, HP, inimigos ou sistemas de marcos posteriores.

## Validação automatizada

Com o executável disponível, execute (substitua `godot` pelo caminho local):

```powershell
godot --version
godot --headless --path . --import
godot --headless --path . --quit-after 10
godot --headless --path . --script res://tests/smoke_test.gd
```

Status desta entrega: **NÃO EXECUTADOS NA ENGINE**. O comando de versão falhou;
importação, inicialização e smoke test não puderam ser executados. O smoke test
foi escrito para verificar chão, movimento, orientação, salto e aterrissagem,
paredes, câmera e queda com retorno, mas seu resultado depende de execução real.
Revisão estática de recursos e configurações consta em `tests/VALIDACAO_M0.md`.

## Checklist manual — PENDENTE PLAYTEST

- [ ] Importar sem referências ausentes nem erros de script no Debugger.
- [ ] Iniciar e encerrar pelo menos três vezes sem erros.
- [ ] Testar A/D, setas, Espaço e W individualmente.
- [ ] Andar nos dois sentidos e inverter direção; conferir capa e bainha.
- [ ] Saltar e observar IDLE, RUN, JUMP e FALL; segurar salto sem multissalto.
- [ ] Saltar até cada plataforma; colidir também por baixo e pelas laterais.
- [ ] Pular até 0,10 s após sair de uma borda (coyote time).
- [ ] Apertar salto até 0,10 s antes de aterrissar (buffer).
- [ ] Tentar novo salto no ar fora do coyote time: não deve ocorrer.
- [ ] Percorrer os dois extremos e conferir paredes e limites da câmera.
- [ ] Atravessar o vão com salto; cair nele e conferir retorno sem velocidade.
- [ ] Conferir legibilidade no topo do salto, ausência de tremor e pixels nítidos
  em 960 × 540 e ao redimensionar a janela.

Headless não substitui esta avaliação. Sensação de controle, câmera e legibilidade
visual permanecem pendentes de homologação humana. Não há áudio neste marco.

## Encerramento de escopo

Nenhum repositório Git foi detectado e nenhuma operação de staging, histórico,
commit ou push foi realizada. Não houve exportação nem publicação.
Próximo marco previsto: **M1 — combate com espada**, somente após homologação
do M0 e autorização expressa; nenhuma parte do M1 foi implementada.
