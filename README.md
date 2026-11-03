# Cinzas do Juramento — M1

Fundação de plataforma 2D para Windows. Aren anda, salta e retorna ao ponto
inicial após cair. M1 acrescenta um golpe básico de espada contra um alvo estático.

O responsável informou a **homologação manual do M0, sem observações**
(movimento, salto, aterrissagem, paredes, coyote time, buffer, câmera e retorno).
Baseline: `main`, commit `c9cd1f558dc02e83cb81438efa56c7a8fbbff622`.
Essa homologação foi fornecida pelo responsável; os testes desta etapa estão
registrados separadamente em `tests/VALIDACAO_M1.md`. O relatório M0 foi preservado.

## Ambiente e execução

- Requer Godot **4.3 ou superior**, edição padrão com GDScript; renderer Compatibility.
- Engine localizada nesta etapa: **4.7.2.stable.official.ed1daf0bf**, em
  `C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe`. Use o executável
  `_console.exe` dessa pasta para os testes. Nenhuma instalação foi realizada.
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
| Atacar | J |

Segurar salto ou ataque não repete a ação automaticamente. Não há menu.

## Combate M1

Aproxime-se do boneco de treino em **(112,156)**; por exemplo, pare em X≈88 e
olhe à direita. Aperte **J** no chão. O alvo não é sólido e pode ser atravessado.
O feedback é um breve clarão com marcas laterais; `hit_count` fica disponível
no Inspector remoto do alvo, sem criar HUD.

O nó `Knight/SwordAttack` expõe preparação **0,10 s**, janela ativa **0,10 s** e
recuperação **0,20 s**. A espada fica erguida na preparação, horizontal e clara
na execução, e abaixada na recuperação. Só a fase ativa produz acertos.
Outro pressionamento durante o ciclo é descartado, sem combo ou fila.
A direção visual e a área do golpe ficam fixas no lado escolhido ao começar,
mesmo se Aren caminhar para o outro lado. Movimento e salto permanecem livres.
Um golpe iniciado no chão termina normalmente se Aren saltar ou sair da borda;
não é possível iniciar um novo ataque no ar. Cair para fora da fase cancela o golpe.

A hitbox separada mede 22 × 14 px, entre 6 e 28 px à frente do centro de Aren,
centrada em Y=-14. Cada alvo recebe no máximo um acerto por golpe, inclusive
se já estava sobreposto na abertura da janela. Camadas: World=1, Player=2,
SwordAttack=3 (bit 4), TrainingTarget=4 (bit 8). Consultas de forma na física
leem a máscara do ataque; não dependem de sinais de entrada ou sobreposições
armazenadas do frame anterior. A forma fica desabilitada fora da janela ativa.

Uma consulta ao corredor da lâmina, com altura de 14 px entre Aren e o centro
do alvo, bloqueia acertos se encontrar qualquer sólido World. A regra é
conservadora: quinas que tocam esse corredor também impedem o golpe.
Não há HP, morte, IA, knockback ou dano ao jogador.

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
- `scripts/player/sword_attack.gd`: ciclo, hitbox, direção fixa e bloqueio por sólidos.
- `scenes/targets/training_target.tscn` e `scripts/targets/training_target.gd`:
  alvo reutilizável não sólido, contador e feedback, sem vida ou IA.
- `tests/smoke_test.gd`: regressão de física do M0, preservada.
- `tests/combat_test.gd`: testes de física e input do M1.

Fase de 960 px de largura, piso em Y=156 e vão entre X=560 e X=624. Plataformas
em Y=124, 94, 72 e 120. Início em (48,156), sobre chão seguro. O vão tem bordas
âmbar; cair nele testa o retorno. O salto padrão sobe aproximadamente 37 px
na integração discreta de 60 Hz; as plataformas formam uma escada alcançável.
Geometria é sólida por todos os lados; plataformas não são unidirecionais.

Os documentos originais `GDD.md`, `ARQUITETURA.md` e `ROADMAP.md` estavam na raiz
e foram preservados no local. Não foram criados diretórios vazios de assets,
autoloads, managers, HP, inimigos ofensivos ou sistemas de marcos posteriores.

## Validação automatizada

Com o executável disponível, execute (substitua `godot` pelo caminho local):

```powershell
godot --version
godot --headless --path . --import
godot --headless --path . --quit-after 10
godot --headless --path . --log-file .godot/m0-test.log --script res://tests/smoke_test.gd
godot --headless --path . --log-file .godot/m1-test.log --script res://tests/combat_test.gd
```

Na etapa de implementação foram executados versão, importação, inicialização e smoke test M0
(14 verificações, zero falhas) e suíte M1 (36 verificações, zero falhas).
Os detalhes de execução estão em
`tests/VALIDACAO_M1.md`. Houve diagnósticos de ambiente relativos à loja de
certificados do Windows e ao acesso aos logs/configurações do perfil; não houve
erros de script nos testes. Os logs das suítes foram direcionados a `.godot/`.

## Homologação manual do M1 — APROVADA PELO RESPONSÁVEL

O responsável concluiu o playtest manual, informou **“tudo passou”** e
**homologou o M1, sem falhas relatadas**. Aprovações informadas pelo responsável:

- [x] Ataque e recuperação.
- [x] Acerto único por golpe e golpes consecutivos.
- [x] Direção, alcance e bloqueio por paredes.
- [x] Visual da espada e feedback do alvo.
- [x] Cancelamento após queda.
- [x] Regressão das funcionalidades homologadas do M0.

Esse resultado foi informado pelo responsável; o agente não realizou o playtest
manual. Os resultados automatizados anteriores (14 verificações M0 e 36 M1,
sem falhas) e os diagnósticos de ambiente foram preservados. A engine não foi
reexecutada nesta etapa de documentação e versionamento.

Não há áudio.

## Encerramento de escopo

O responsável autorizou o registro da entrega M1 homologada em um único commit
local na branch `main`, com a autoria já configurada, sem alterar a jogabilidade.
O relatório histórico do M0 permanece preservado. Não houve push, exportação
ou publicação. **M2 permanece não iniciado**; qualquer nova implementação exige
autorização expressa.
