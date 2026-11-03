# M3-B1 — Esqueleto Patrulheiro

Data: 03/11/2026. **M3-B1 — HOMOLOGADO FUNCIONALMENTE PELO RESPONSÁVEL.**

**11/11 PASSOU — Nenhuma observação.** Homologação manual informada pelo
responsável; testes anteriores e limitações abaixo foram preservados.

## 1. Auditoria e baseline

Projeto: `C:\PROJETOS\CINZAS DO JURAMENTO`. Branch `main`, HEAD
`3e5a89781788a09f759e1bc21d6931c498cf2470`. Status inicial limpo, sem índice
staged e sem diferenças inesperadas. Nenhum AGENTS.md encontrado nas consultas
ao projeto/diretórios pais. Nenhum repositório, branch ou remoto foi criado.

Foram examinados README, GDD, arquitetura, roadmap, relatórios M0/M1/M2/M3-A e
FIX01, cenas reais, controlador, espada, hurtbox, sobrevivência, fontes de dano,
alvo, integração da fase e testes existentes. M0/M1/M2/M3-A/FIX01 permanecem
homologados historicamente pelo responsável; o estado atual é implementação B1.

Arquitetura encontrada: espada com janela ativa e deduplicação por instance ID,
mas cast exclusivo para TrainingTarget; defesa consultando DamageSource e
chamando o método central de dano; KnightSurvival com proteção de 0,8 s, morte e
respawn por sinal. Geometria M3-A explícita com 19 sólidos e uma rota nos dois
sentidos. Godot disponível: **4.7.2.stable.official.ed1daf0bf**, sem instalação.

## 2. Arquivos

Modificados (11):

- `README.md`: instruções atuais, resultados e registro de homologação;
  conteúdo M3-A anterior preservado como histórico.
- `project.godot`: nome da camada 8, EnemyBody.
- `scenes/levels/forgotten_cemetery.tscn`: um container Enemies e uma instância.
- `scripts/levels/forgotten_cemetery.gd`: vínculo de alvo e restauração local.
- `scripts/player/sword_attack.gd`: cast para receptor de espada compartilhado.
- `scripts/targets/training_target.gd`: herança desse contrato.
- `scripts/props/damage_source.gd`: contrato de entrega do dano de contato.
- `scripts/player/knight_hurtbox.gd`: consulta desse contrato.
- `scripts/player/knight_controller.gd`: encaminha a quantidade de contato para
  o mesmo método central de dano existente.
- `tests/cemetery_test.gd` e `tests/reachability_test.gd`: isolamento explícito
  da IA durante regressões estruturais do terreno, mantendo todas as asserções.

Criados (12, incluindo cinco UIDs):

- `scenes/enemies/skeleton_patrol.tscn`.
- `scripts/combat/sword_receiver.gd` e `.gd.uid`.
- `scripts/enemies/skeleton_patrol.gd` e `.gd.uid`.
- `scripts/enemies/skeleton_attack_source.gd` e `.gd.uid`.
- `scripts/enemies/skeleton_visual.gd` e `.gd.uid`.
- `tests/skeleton_test.gd` e `.gd.uid`.
- `tests/VALIDACAO_M3_B1.md`.

## 3. Arquitetura e posicionamento

SkeletonPatrol é CharacterBody2D, com retângulo físico de 12×24, desenho local,
SwordReceiver separado e SkeletonAttackSource separado. Não há autoload, manager
global, lookup absoluto de Aren ou dependência externa. A fase injeta a referência
do jogador. `hit_received` encaminha a recepção da espada; `defeated` notifica
a derrota uma vez por vida do esqueleto.

Há somente um inimigo, em **(744,140)**, sobre GraveSlabC, piso X=672–848 no
Caminho das Lápides. Limites relativos -40/+40 produzem patrulha X=704–784,
distante do início (48,156) e afastada das bordas do piso. Raios adicionais de
chão e parede protegem patrulha e perseguição. O corpo não colide com Aren ou
irmãos: o inimigo não forma um bloqueio obrigatório e não causa dano por toque.
Um teste de input real também passa pelo encontro vivo com salto, sem perder HP.

Camadas/máscaras explícitas:

| Parte | Camada (bitmask) | Máscara |
|---|---:|---:|
| Corpo do inimigo | EnemyBody, 8 (128) | World (1) |
| SwordReceiver | Camada histórica TrainingTarget, 4 (8) | SwordAttack (4) |
| SkeletonAttackSource | DamageSource, 6 (32) | PlayerHurtbox (16) |

A ordem de física do inimigo é -1, antes da ordem 0 de Aren. A fonte ativa é
consultada pela hurtbox M2; o golpe de Aren pode interromper o ataque do inimigo
antes dessa consulta no mesmo passo. Tudo permanece em física de 60 Hz.

## 4. Estados e parâmetros

| Estado | Comportamento e saída |
|---|---|
| IDLE | Pausa breve; detecta Aren ou inicia patrulha após o intervalo |
| PATROL | Anda e inverte ao alcançar limite, parede ou borda; detecção leva a CHASE |
| CHASE | Aproxima dentro da faixa segura; exige visão, distância e diferença vertical; perda por tempo leva a IDLE/PATROL |
| ATTACK | Movimento horizontal parado, direção fixa; preparação → ativa → recuperação; depois IDLE, respeitando cooldown |
| HURT | Feedback claro e breve atordoamento; cancela ataque; depois IDLE |
| DEAD | Velocidade zero, espada e colisores desativados; corpo caído inativo até a próxima restauração |

| Parâmetro exportado | Padrão |
|---|---:|
| max_health | 3 HP |
| damage | 1 HP |
| patrol_speed / chase_speed | 25 / 35 px/s |
| detection_distance / attack_distance | 85 / 24 px |
| attack_interval | 1,2 s entre inícios |
| patrol_left / patrol_right | -40 / +40 px relativos à origem |
| lost_target_delay / idle_duration | 0,6 / 0,3 s |
| windup_duration / active_duration / recovery_duration | 0,25 / 0,12 / 0,35 s |
| hurt_duration | 0,18 s |

Visão exige diferença vertical até 18 px e ausência de sólido World no raio
entre os torsos. A perseguição mantém os mesmos limites autorados e não salta.
Limites ordenados e pontos sobre chão seguro devem ser configurados pelo editor.
Os números são provisórios; não há afirmação de balanceamento final.

## 5. Integração mínima com M1 e M2

**M1:** SwordReceiver formaliza o `receive_hit()` já existente. TrainingTarget
herda esse tipo e preserva o próprio contador/feedback. A única mudança no
script da espada é o cast de TrainingTarget para SwordReceiver. Fases, formas,
alcance, cooldown, controles, bloqueio por World e lista de IDs por golpe foram
preservados. A hurtbox do esqueleto emite hit_received, reduzindo um HP; ao
terceiro acerto, o inimigo entra em DEAD. Novos eventos após morte são ignorados.

**M2:** DamageSource passa a expor `contact_damage(receiver_id)`, que continua
retornando 1 na armadilha antiga. A fonte do esqueleto herda esse contrato,
retorna zero fora da janela ativa e registra IDs de contatos por golpe. Um
contato já protegido pela invulnerabilidade também consome a tentativa desse
golpe: não há nova tentativa depois que a proteção expira dentro da mesma janela.
Hurtbox encaminha no máximo uma quantidade positiva por passo ao mesmo
`Knight.receive_damage()` / KnightSurvival. Vida, proteção, morte e controles de
Aren não têm implementação paralela nem parâmetros alterados.

A fonte ofensiva verifica lado do golpe, DEAD de Aren e corredor sólido World,
inclusive se uma parede aparecer depois de iniciar a preparação. Sua forma fica
desabilitada fora da janela. HURT/DEAD do inimigo cancelam a fonte imediatamente;
ao observar DEAD de Aren, o inimigo suspende o encontro sem aplicar novos danos.

**Retorno do jogador:** a fase conecta um segundo callback ao sinal existente
respawn_requested, depois do callback que restaura Aren. Cada inimigo local
restaura origem, HP máximo, velocidade zero, direção direita, estado IDLE,
fase de preparação, posição da fonte, temporizadores e colisores. A lista de
contatos é limpa. Quedas vivas também restauram os inimigos após o retorno
homologado de Aren ao início, sem curar Aren. A regra é local à fase e à sessão;
não persiste derrotas, não muda checkpoints e não usa gerenciador global.

## 6. Execuções e resultados reais da implementação anterior

Executável identificado:
`C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`.
Diretório de trabalho: raiz do projeto; abaixo, `godot` representa esse binário.

| Argumentos/comando | Resultado final |
|---|---|
| `godot --version` | Código 0, 4.7.2 confirmada |
| `--headless --path . --log-file .godot/b1-import.log --import` | Código 0, classes importadas |
| `--headless --path . --log-file .godot/b1-import-final.log --import` | Código 0, importação final e UIDs |
| `--headless --path . --log-file .godot/b1-startup-final.log --quit-after 60` | Código 0, main real de F5 inicia e encerra |
| `--headless --path . --fixed-fps 60 --log-file .godot/b1-smoke_test.log --script res://tests/smoke_test.gd` | Código 0, **14 M0**, zero falhas |
| `--headless --path . --fixed-fps 60 --log-file .godot/b1-combat_test.log --script res://tests/combat_test.gd` | Código 0, **36 M1**, zero falhas |
| `--headless --path . --fixed-fps 60 --log-file .godot/b1-survival_test.log --script res://tests/survival_test.gd` | Código 0, **59 M2**, zero falhas |
| `--headless --path . --fixed-fps 60 --log-file .godot/b1-cemetery_test.log --script res://tests/cemetery_test.gd` | Código 0, **52 M3-A**, zero falhas |
| `--headless --path . --fixed-fps 60 --log-file .godot/b1-reachability_test.log --script res://tests/reachability_test.gd` | Código 0, **35**, zero falhas; 120 ensaios físicos de navegação agregados |
| `--headless --path . --fixed-fps 60 --log-file .godot/b1-skeleton_test.log --script res://tests/skeleton_test.gd` | Código 0, **49 M3-B1**, zero falhas |

**Total final: 245 verificações, zero falhas.** As execuções incrementais do
teste novo passaram antes de sua ampliação; o resultado final acima contém
as asserções adicionais de bypass e restauração completa do ataque.

Os testes M0/M1/M2 foram executados sem editar seus arquivos. As duas suítes
estruturais M3-A/FIX01 agora desativam o processamento do nó Enemies para isolar
terreno/câmera da IA. A contagem M3-A subiu de 51 para 52 porque o laço existente
também inspeciona o novo nó raiz Enemies. Nenhuma asserção original foi removida.
Essa travessia isolada não é apresentada como teste de dificuldade com inimigos:
o encontro vivo, o bypass por salto e o combate estão na suíte B1.

Cobertura B1: estado/HP iniciais, patrulha com inversão, limites, paredes,
bordas reais em patrulha e chase, visão bloqueada, detecção e perda de alvo,
leash, range, preparação, fases/forma ativa, intervalo, dano exato, proteção M2,
deduplicação mesmo com proteção menor que a janela em uma sondagem explícita,
direção esquerda/direita e bloqueio por parede/posição atrás, espada real,
atordoamento, HP e derrota única, cadáver inerte, múltiplos inimigos e
restauração após morte/queda de Aren. Fixtures são a cena real de F5 e instâncias
extras temporárias; reposicionamento/ajustes de parâmetros são declarados no
código de teste. Não são um playtest humano contínuo.

Verificações estáticas executadas por Python/Git em leitura:

- Todos os blocos de nós existentes, posições, dimensões, formas de colisão,
  marcadores e câmera da cena M3-A comparados com HEAD: preservados.
- Núcleo de movimento de Aren idêntico salvo encaminhamento do contato M2;
  espada idêntica salvo cast do receptor. KnightSurvival e parâmetros intactos.
- Cenário protótipo, seu script, visual de Aren, desenho do cemitério, suítes
  M0/M1/M2 e relatórios históricos comparados com HEAD: preservados.
- `git diff --check` sem erros de whitespace; Git apenas emitiu avisos LF→CRLF.

## 7. Inspeção visual e diagnósticos

A engine gráfica Compatibility/NVIDIA RTX 2060 SUPER executou um roteiro
temporário em `.godot/b1_visual.gd`, carregando a cena real, com reposicionamento
e inputs explícitos para capturar os estados. Foram renderizadas e inspecionadas
seis imagens: patrulha, perseguição, preparação, janela ativa, HURT e DEAD.
Caveira, membros, armadura, direção, arma, clarão e corpo caído ficaram legíveis.
A captura ativa mostra VIDA 4/5 depois do contato; HURT mostra a espada de Aren
e a coloração clara do inimigo. As imagens/script são locais em `.godot/`,
ignorados pelo Git; não são assets finais nem fazem parte da entrega versionável.

O helper de computer use não enumerou a janela desta prévia: seleção retornou
zero candidatas, `Expected one preview window`; a atualização listou somente
instâncias anteriores. Por isso a inspeção usou as capturas nativas da engine,
sem controlar as janelas antigas. A prévia criada para esta tarefa foi encerrada
por seu PID/título verificados; as demais instâncias foram preservadas.

**Na entrega original, o playtest manual estava pendente:** capturas e ensaios de física não certificam a
experiência interativa completa, cadência percebida, clareza durante movimento
ou balanceamento. Naquela etapa de implementação não havia homologação;
a aprovação manual posterior está registrada na seção própria abaixo.

Diagnósticos de ambiente observados: `Failed to read the root certificate store`
nas execuções e falha de escrita de `editor_settings-4.7.tres` nas importações.
São mensagens já presentes no histórico, sem mudança de certificados/permissões.
Não houve erro de script, recurso ausente ou asserção falha nas suítes finais.

## 8. Roteiro histórico do playtest

- [ ] F8/F5 para abrir a versão nova; chegar ao esqueleto nas Lápides.
- [ ] Observar pausa inicial, caminhada, direção e inversão nos dois limites.
- [ ] Aproximar/afastar Aren: confirmar detecção, chase limitado e retorno à patrulha.
- [ ] Conferir que o inimigo respeita paredes/bordas e não bloqueia o corpo de Aren.
- [ ] Desviar com salto ou passar pelo encontro, sem combate obrigatório.
- [ ] Observar espada erguida antes do golpe, janela ativa e recuperação clara.
- [ ] Receber um golpe: VIDA cai exatamente 1; conferir proteção/piscar M2 de 0,8 s.
- [ ] Conferir golpes nas duas direções e que ficar atrás/fora do alcance evita dano.
- [ ] Usar J: cada golpe válido tira 1 HP do esqueleto; observar HURT/interrupção.
- [ ] Acertar três golpes: corpo cai, não ataca nem bloqueia; não há loot ou progressão.
- [ ] Morrer e reaparecer: Aren volta com HP/restauração M2 e o esqueleto volta à origem com 3 HP.
- [ ] Cair vivo: sem cura de Aren; inimigo restaurado e nenhuma hitbox residual.
- [ ] Repetir o encontro e os seis setores; avaliar câmera e conforto dos saltos.
- [ ] No protótipo F6, repetir alvo, espinhos, proteção, checkpoint e respawn homologados.

## Homologação manual informada pelo responsável — 03/11/2026

**M3-B1 — HOMOLOGADO FUNCIONALMENTE PELO RESPONSÁVEL.**

**11/11 PASSOU — Nenhuma observação.**

Funcionalidades aprovadas no playtest do responsável:

1. Aparência.
2. Patrulhamento.
3. Detecção.
4. Perseguição.
5. Ataque.
6. Dano causado.
7. Invulnerabilidade.
8. Dano recebido.
9. Morte do inimigo.
10. Restauração após morte ou queda de Aren.
11. Regressão dos sistemas anteriores.

A homologação acima foi realizada e informada pelo responsável. Ela é distinta
das 245 verificações automatizadas executadas anteriormente pelo agente,
incluindo 49 do inimigo, da importação/inicialização e das seis capturas
renderizadas já registradas. Resultados, diagnósticos de ambiente e limitações
foram preservados. A engine não foi reexecutada nesta tarefa de documentação
e versionamento. Nenhum código funcional, cena ou parâmetro foi alterado.

**M3-B2 e o Corvo Amaldiçoado permanecem não iniciados.** A homologação do B1
não autoriza nova implementação, M3-B3 ou M3-C. Não há push, deploy ou publicação.

## 9. Limitações e Git ao encerrar a implementação

IA terrestre simples, sem saltos, navegação global ou previsão de obstáculos
móveis. A proteção por raios considera os retângulos World do greybox. O cooldown
é entre inícios; a fase ativa pode ser interrompida pelo golpe de Aren. Um
contato protegido é consumido naquele golpe. O cadáver permanece até restauração;
inimigos derrotados retornam após morte ou queda de Aren. Os parâmetros
continuam provisórios de balanceamento, apesar da homologação funcional. Não há áudio, arte final, HP de inimigo na HUD ou novos checkpoints.

Branch `main`, HEAD preservado em `3e5a89781788a09f759e1bc21d6931c498cf2470`.
Entrega local: onze arquivos rastreados modificados e doze novos, incluindo
cinco UIDs. Nada staged. Não houve git add/commit/push, mudança de branch/remoto,
exportação, deploy, publicação ou dependência instalada.

Pendência para eventual M3-B2: somente após playtest e homologação do B1 e nova
autorização. **Corvo Amaldiçoado, M3-B2/B3, M3-C e marcos posteriores não iniciados.**
Execução encerrada no M3-B1.

## 10. Auditoria e registro local da entrega homologada

Nesta tarefa foram confirmados raiz exata, branch main e HEAD baseline
`3e5a89781788a09f759e1bc21d6931c498cf2470`, onze arquivos modificados e doze
novos, sem staging. Os diffs completos e novos arquivos correspondem somente
à implementação B1 já entregue. Nenhuma alteração inesperada foi encontrada.
Somente README e este relatório receberam a homologação; código, cenas,
parâmetros, testes e relatórios anteriores foram preservados.

Verificações desta tarefa, separadas das execuções da engine anteriores:

- Inventário e conteúdo dos candidatos revisados; nenhum cache, temporário,
  credencial ou segredo identificado. Os cinco novos UIDs são preservados.
- `.gitignore` e `git check-ignore` confirmaram exclusão de .godot, imports,
  temporários, logs, exportações e credenciais; o arquivo de mensagem do commit
  fica dentro de .godot, fora do conjunto versionado.
- Referências res:// e IDs das cenas verificados estaticamente; preservação do
  terreno/câmera, sistemas históricos e conteúdos funcionais conferida.
- `git fsck --no-reflogs` concluiu com código 0. Foram listadas quatro árvores
  dangling (não referenciadas), sem erro de integridade; nada foi apagado.
- `git diff --check` e a revisão do diff staged completo fazem parte da auditoria
  antes do commit. Nenhuma reexecução da Godot foi necessária ou declarada.

Registro autorizado em exatamente um commit local, com a mensagem:
`feat(m3-b1): homologa esqueleto patrulheiro`.
Autoria já configurada: Rafael `<spiritstonesrafa@gmail.com>`.
O hash resultante, o inventário registrado e a limpeza final do índice/árvore
serão conferidos e apresentados na entrega. Sem alteração de branch, remoto,
histórico anterior, push, deploy ou publicação. **M3-B2 não iniciado.**
