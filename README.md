# Cinzas do Juramento — M3-A: O Cemitério dos Esquecidos

**M3-A e M3-A-FIX01 homologados funcionalmente pelo responsável em
03/11/2026.** M0/M1/M2 continuam homologados historicamente. A aprovação
não inicia M3-B nem autoriza etapas posteriores.
Baseline conferido: branch `main`, HEAD M2
`c58690bbb3dfe122bb8e1ff8de05b966f17dd772`, Git inicialmente limpo.

## Jogar o M3-A

Abra `C:\PROJETOS\CINZAS DO JURAMENTO\project.godot` na Godot e pressione **F5**.
O projeto inicia a nova fase. **A/D ou setas** movimentam, **Espaço/W/seta para
cima** saltam, **J** usa a espada existente. Não há menu ou áudio.

Percorra os setores da esquerda para a direita:

1. Portões do Cemitério — início seguro e instruções.
2. Caminho das Lápides — três vãos simples de 32 px.
3. Jardim dos Mortos — blocos com subida de 24 px e marcação CP1 FUTURO.
4. Catacumbas — passagem por baixo do teto identificado, descida e escada de saída.
5. Ponte das Almas — vãos de 32/40/40 px e marcação CP2 FUTURO.
6. Portão da Catedral — piso seguro e faixa de FIM PROVISÓRIO.

As marcações de checkpoints **não ativam retorno nem curam**. Cair vivo de um
vão retorna ao início (48,156), sem cura, usando a regra existente de M0/M2.
A vida, espada e HUD são os componentes existentes, sem mudança de parâmetros.
Não foram adicionados inimigos, IA, armadilhas, chefe, arte final ou música.
Tela interna 320×180 e escala inteira preservadas.

O protótipo M0/M1/M2 permanece disponível: abra
`scenes/levels/prototype_stage.tscn` e pressione **F6** para testar o alvo,
espinhos e checkpoint antigos. Esses elementos não foram incluídos na nova fase.

## Validação e playtest do M3-A

- Especificação/layout: `docs/M3_A.md`.
- Resultados, inventário e roteiro histórico de playtest: `tests/VALIDACAO_M3_A.md`.
- Godot executada: **4.7.2.stable.official.ed1daf0bf**.
- Importação e inicialização headless concluídas. Regressões: **14 M0 + 36 M1
  + 59 M2**, zero falhas. Nova suíte: **51 verificações M3-A**, zero falhas.
- Percurso automatizado contínuo nos dois sentidos, sem teleporte ou reinício
  durante o percurso; seis quedas e integração de respawn verificadas à parte.
- Seis capturas renderizadas inspecionadas; sensação de controle e dificuldade
  não são certificados pelas capturas; a homologação funcional foi informada
  pelo responsável. Houve aviso de certificados do Windows
  na captura gráfica; detalhes no relatório.

### Correção M3-A-FIX01 — homologada funcionalmente

O bloco alto das Catacumbas é `CryptRoof`, um teto fora da rota, agora escurecido,
com borda inferior e indicação “TETO - PASSAGEM ABAIXO”. A ponte teve dois pisos
alargados e o segundo rebaixado em 8 px; a câmera antecipa os degraus inferiores
nas Catacumbas. Nenhum parâmetro, controle ou sistema homologado foi alterado.

Medição física: salto de aproximadamente **40,9 px**, deslocamento em piso
nivelado **70 px correndo / 66,7 px partindo parado**. Os degraus obrigatórios
sobem no máximo 24 px. A auditoria nova verifica 30 transições dirigidas nos seis
setores, com quatro aproximações por transição: **120 ensaios físicos** e 35
verificações. Na regressão final passaram **195 verificações**, sem falhas
(14 M0 + 36 M1 + 59 M2 + 51 M3-A + 35 de navegabilidade).

Coordenadas antes/depois, resultados pré-correção, limites do teste e checklist:
`tests/VALIDACAO_M3_A_FIX01.md`. O teste original contínuo passa nos dois sentidos;
os ensaios locais adicionais usam reposicionamento declarado entre tentativas.
O responsável informou a homologação funcional conjunta do M3-A e do FIX01.
Os resultados automatizados continuam separados dessa aprovação humana.

Após importar, execute também:

```powershell
godot --headless --path . --fixed-fps 60 --log-file .godot/m3a-test.log --script res://tests/cemetery_test.gd
godot --headless --path . --fixed-fps 60 --log-file .godot/fix01-reachability.log --script res://tests/reachability_test.gd
```

As três suítes antigas agora carregam `tests/fixtures/baseline_main.tscn`, cópia
da entrada M2. Só esse caminho foi alterado nos testes antigos; suas verificações
permanecem idênticas. A nova suíte carrega a entrada real de F5.

## Homologação funcional registrada — 03/11/2026

O responsável informou a **homologação funcional do M3-A e da correção
M3-A-FIX01** e autorizou registrar a implementação homologada em um único
commit local. Esta aprovação é atribuída ao responsável, não a um playtest
realizado pelo agente nesta etapa.

Foram preservados os resultados anteriores: 160 verificações na entrega
original e 195 na regressão final do FIX01, incluindo 35 verificações de
navegabilidade com 120 ensaios físicos agregados. Falhas de diagnóstico antes
da correção, limites dos testes e mensagens de ambiente continuam documentados.
Nenhum teste da engine foi repetido nesta etapa; foram feitas somente revisões
de documentação e versionamento. Não houve alteração de jogabilidade.

A homologação é funcional e restrita ao M3-A com FIX01. **M3-B não iniciado**;
qualquer etapa posterior exige autorização própria. Não há push ou publicação
no escopo deste registro.

O registro reúne a implementação M3-A e FIX01 em um único commit local,
sem push, alteração de remoto ou publicação. M3-B/C/D e M4 não iniciados.

---

## Registro histórico M0/M1/M2 — cenário de protótipo

As posições de alvo, espinhos, checkpoint, limite Y=224 e câmera de 960 px
descritas abaixo referem-se ao protótipo preservado, executado com F6, e não
ao novo greybox de F5. Relatórios históricos não foram reescritos.

### Entrega histórica M2

Fundação de plataforma 2D para Windows. Aren anda, salta e retorna ao ponto
inicial após cair. O combate M1 homologado foi preservado; M2 acrescenta vida,
dano recebido, invulnerabilidade, morte, checkpoint e respawn.

Baseline M2: `main`, commit M1 `c7a82dcd527ba7cf754878da6bad449f5f75e08d`.
**M2 homologado funcionalmente pelo responsável: playtest manual 11/11 PASSOU, sem observações.**

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
O alvo de treino continua sem HP, morte, IA ou ataque. Dano ao jogador e morte
são responsabilidade do sistema de sobrevivência M2, descrito a seguir.

## Sobrevivência M2

A HUD discreta mostra **VIDA 5/5**. `Knight/Survival` expõe vida máxima (5),
invulnerabilidade (0,80 s) e intervalo de morte (0,60 s). O método central
`Knight.receive_damage(amount)` delega a validação ao componente de vida,
que emite `health_changed`, `died` e `respawn_requested`. Valores de dano zero
ou negativos são ignorados. A armadilha aplica sempre exatamente um ponto.

A armadilha de espinhos em **(490,156)** é estática e não sólida. Ao tocá-la,
Aren perde 1 HP e pisca em vermelho durante a proteção. Continuar sobre os
espinhos permite novo contato válido depois dos 0,8 s; ficar parado ali esgota
a vida e permite testar a morte. Saltar sobre a armadilha evita o contato.
Não há knockback neste escopo.

Em zero HP, Aren entra em DEAD, assume uma pose caída e interrompe o golpe.
Ataque, movimento e salto ficam bloqueados até o respawn. Após 0,6 s, volta ao
último checkpoint, recuperando HP máximo, velocidade zero, controle e aparência
normal. Os temporizadores de dano/morte/invulnerabilidade e os comandos de
salto/ataque pendentes são limpos. Não há Game Over nem menu de continuação.

O ponto padrão seguro é **(48,156)**. A bandeira em **(690,156)** ativa o
checkpoint ao contato; sua cor muda de azul para âmbar. O Marker2D
`RespawnPoint` da cena reutilizável determina o retorno, inicialmente **(666,156)**.
Outra instância pode ser colocada pelo editor sem mudar scripts da fase.
Só o último checkpoint fica ativo, e contatos repetidos não repetem a ativação.
O estado é local à sessão, sem save permanente.

Antes da ativação e novamente no respawn, o marcador é verificado contra
sólidos e fontes de dano, com apoio de chão até 3 px abaixo. Um checkpoint
inválido não é ativado; se o ativo ficar inseguro depois, usa-se o início
padrão seguro. Se ambos forem inválidos, a morte é mantida e um aviso é emitido,
sem colocar Aren dentro de um obstáculo. Não há busca automática de posições.
A configuração atual tem ambos os pontos seguros; não precisa adicionar uma
nova invulnerabilidade ao reaparecer.

**Compatibilidade com a queda M0:** cair vivo além de Y=224 continua retornando
para o início original (48,156), com velocidade zero e ataque cancelado. Isso
não cura HP, não troca o checkpoint e não reinicia a proteção que já estivesse
em andamento. A única adaptação é ignorar esse retorno durante DEAD: uma morte
ocorrida junto ao vão deve completar seu intervalo e voltar ao checkpoint.
A câmera continua seguindo o retorno no mesmo passo de física.

Camadas adicionais: PlayerHurtbox=5/bit 16, DamageSource=6/bit 32,
Checkpoint=7/bit 64. A hurtbox consulta somente DamageSource; o ataque M1
continua consultando somente TrainingTarget. As formas são separadas.

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
- `tests/combat_test.gd`: testes de física e input do M1, preservados.
- `scripts/player/knight_survival.gd`: HP, sinais, proteção e intervalo de morte.
- `scripts/player/knight_hurtbox.gd`: consulta defensiva de contato.
- `scenes/props/damage_source.tscn` e `scripts/props/damage_source.gd`: espinhos.
- `scenes/props/respawn_checkpoint.tscn` e `scripts/props/respawn_checkpoint.gd`:
  checkpoint reutilizável e marcador de retorno.
- `scenes/ui/health_hud.tscn` e `scripts/ui/health_hud.gd`: HUD ligada aos sinais.
- `tests/survival_test.gd`: testes de sobrevivência e integração com M0/M1.
- `tests/VALIDACAO_M2.md`: inventário, resultados desta execução e checklist manual.

Fase de 960 px de largura, piso em Y=156 e vão entre X=560 e X=624. Plataformas
em Y=124, 94, 72 e 120. Início em (48,156), sobre chão seguro. O vão tem bordas
âmbar; cair nele testa o retorno. O salto padrão sobe aproximadamente 37 px
na integração discreta de 60 Hz; as plataformas formam uma escada alcançável.
Geometria é sólida por todos os lados; plataformas não são unidirecionais.

Os documentos originais `GDD.md`, `ARQUITETURA.md` e `ROADMAP.md` estavam na raiz
e foram preservados no local. Não foram criados diretórios vazios de assets,
autoloads, managers, inimigos ofensivos ou sistemas de marcos posteriores.

## Validação automatizada

Com o executável disponível, execute (substitua `godot` pelo caminho local):

```powershell
godot --version
godot --headless --path . --import
godot --headless --path . --quit-after 10
godot --headless --path . --log-file .godot/m0-test.log --script res://tests/smoke_test.gd
godot --headless --path . --log-file .godot/m1-test.log --script res://tests/combat_test.gd
godot --headless --path . --log-file .godot/m2-test.log --script res://tests/survival_test.gd
```

Na implementação original do M1 foram executados versão, importação, inicialização e smoke test M0
(14 verificações, zero falhas) e suíte M1 (36 verificações, zero falhas).
Os detalhes de execução estão em
`tests/VALIDACAO_M1.md`. Houve diagnósticos de ambiente relativos à loja de
certificados do Windows e ao acesso aos logs/configurações do perfil; não houve
erros de script nos testes. Os logs das suítes foram direcionados a `.godot/`.

Na execução M2, importação e inicialização concluíram com código 0. Passaram
novamente 14 verificações M0, 36 M1 e 59 M2, sem falhas. Permaneceram os
diagnósticos de ambiente já documentados. Resultados e comandos exatos estão
em `tests/VALIDACAO_M2.md`. A homologação manual do M2 foi informada pelo responsável; nesta etapa de documentação e versionamento, a engine não foi reexecutada.

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
sem falhas) e os diagnósticos de ambiente foram preservados. Na etapa de
documentação e versionamento do M1, a engine não foi reexecutada. Os resultados
da execução do M2 estão em `tests/VALIDACAO_M2.md`.

Não há áudio.

## Homologação manual do M2 — APROVADA PELO RESPONSÁVEL

O responsável informou **11/11 PASSOU**, sem observações: vida inicial,
recebimento de dano, invulnerabilidade, feedback visual, novo dano, ativação do
checkpoint, morte, respawn, controles após respawn, queda do cenário e regressão.
Este registro atribui o resultado ao usuário; o agente não realizou o playtest
manual nem apresenta a homologação como auditoria própria. O detalhamento está
em `tests/VALIDACAO_M2.md`.

## Encerramento de escopo

M0, M1 e M2 estão homologados pelo responsável. Os relatórios históricos M0/M1
foram preservados, assim como os resultados automatizados anteriores do M2:
14 verificações M0, 36 M1 e 59 M2, sem falhas, com os diagnósticos de ambiente
registrados. A engine não foi reexecutada nesta etapa.

O responsável autorizou exclusivamente registrar a homologação funcional e
versionar o M2 em um único commit local na branch `main`, sem alterações
adicionais de jogabilidade. Caches, logs e arquivos temporários ficam fora do
commit. Não houve push, deploy, alteração de remoto ou publicação.
**M3 não iniciado.** Qualquer nova implementação exige autorização expressa.
