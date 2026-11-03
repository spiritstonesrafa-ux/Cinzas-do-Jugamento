# M3-B3 — Distribuição, progressão e balanceamento de inimigos

Data: 03/11/2026. **M3-B3 — HOMOLOGADO FUNCIONALMENTE PELO RESPONSÁVEL.**

**Playtest manual: 10/10 PASSOU — Nenhuma observação.**
Homologação realizada e informada pelo responsável, distinta das verificações
automatizadas anteriores. Os ensaios abaixo foram executados na implementação;
a engine não foi reexecutada nesta etapa de documentação e versionamento.

## 1. Baseline e auditoria

Repositório existente confirmado em `C:\PROJETOS\CINZAS DO JURAMENTO`.
Branch `main`, HEAD `56988ead853f65ad19a30036ce534ad5db32d030`, mensagem
`feat(m3-b2): homologa corvo amaldicoado`. Índice e árvore inicialmente limpos.
Nenhum AGENTS.md aplicável encontrado nas consultas ao projeto/diretórios pais.

Lidos README, GDD, ARQUITETURA, ROADMAP e relatórios M3-A/FIX01/B1/B2.
Inspecionados a cena inteira, geometria, inimigos, contratos M1/M2, controlador,
câmera, marcadores, restauração, suíte e executável instalado. Sistemas
homologados de M0 até M3-B2 são o baseline preservado.

Limites por X dos setores: 0, 384, 768, 1152, 1536 e 1984; parede final X=2368.
A classificação usa a origem da instância. O esqueleto original tem patrulha
X=704–784, atravessando a fronteira nominal 768 já homologada; isso foi mantido.
Início real em (48,156); marcadores de checkpoints em (1040,156) e (1936,156)
continuam apenas provisórios. Conclusão em (2288,156). Nenhum novo checkpoint.

## 2. Inventário

Modificados:

- `scenes/levels/forgotten_cemetery.tscn`: quatro novas instâncias; originais intactos.
- `tests/raven_test.gd`: uma asserção atualiza quantidade 2→6 e verifica os dois
  nós originais. Nenhuma verificação foi removida; continuam 63 checks.
- `README.md`: estado atual, distribuição, resultados e instruções. Histórico
  homologado completo preservado abaixo do registro atual.

Criados:

- `tests/distribution_test.gd`: 115 verificações físicas/estruturais M3-B3.
- `tests/distribution_test.gd.uid`: UID gerado pela Godot.
- `tests/VALIDACAO_M3_B3.md`: este relatório.

Não foram editados scripts/cenas reutilizáveis dos inimigos, jogador, espada,
vida, fontes de dano, controlador do cenário, câmera, geometria ou project.godot.
Os demais testes e relatórios históricos permanecem inalterados.

## 3. Distribuição e parâmetros por instância

| Setor | Instância | Origem | Patrulha X | Detecção | Limite da investida |
|---|---|---|---|---:|---:|
| 1 | Nenhuma | — | — | — | — |
| 2 | SkeletonPatrol original | (744,140) | 704–784 | 85 | — |
| 3 | CursedRaven original | (1050,112) | 1030–1070 | 110 | 96 |
| 4 | CryptSkeleton | (1328,220) | 1296–1360 | 65 | — |
| 5 | BridgeRaven | (1552,112) | 1544–1560 | 38 | 48 |
| 6 | CathedralSkeleton | (2120,156) | 2092–2148 | 85 | — |
| 6 | CathedralRaven | (2188,112) | 2176–2200 | 72 | 80 |

Unidades: px, salvo indicação. Total: **seis inimigos, três esqueletos e três
corvos**; contagem por setor **0/1/1/1/1/2**.

Overrides exclusivos das quatro instâncias novas:

- CryptSkeleton: `patrol_left=-32`, `patrol_right=32`, `detection_distance=65`.
- BridgeRaven: `patrol_half_width=8`, `detection_distance=38`, `max_dive_distance=48`.
- CathedralSkeleton: `patrol_left=-28`, `patrol_right=28`.
- CathedralRaven: `patrol_half_width=12`, `detection_distance=72`, `max_dive_distance=80`.

Demais padrões preservados: esqueletos com 3 HP, dano 1, patrulha 25 px/s,
perseguição 35, alcance 24, intervalo 1,2 s; corvos com 2 HP, dano 1,
patrulha 24, investida 85, aviso 0,45 s, intervalo 1,8 s e pausa de recuperação
0,55 s mais viagem física à origem. Aren mantém proteção M2 de 0,8 s, movimento
e golpe M1 originais. Não houve aumento artificial de atributos.

## 4. Justificativas e progressão

**Portões:** vazio. O spawn continua muito distante do primeiro encontro.
Todos os inimigos patrulharam simultaneamente por 600 ticks (10 s de física)
sem fontes ativas ou dano ao jogador no início.

**Lápides/Jardim:** preservados os dois encontros introdutórios homologados,
nos mesmos lugares e com os mesmos parâmetros. Há uma introdução terrestre e
uma aérea, sem acrescentar adversários próximos ao corvo original.

**Catacumbas:** escolhido **um esqueleto**, em vez dos dois propostos. O piso
central é X=1248–1408, Y=220, com apenas 160 px. Uma patrulha de 64 px deixa
48 px de cada lado do centro-limite até a transição das escadas, para aproximação,
recuo e aterrissagem. Duplicar esse espaço de combate, com separação e recuo
compatíveis, concentraria os encontros no corredor ou nas escadas. É uma decisão
conservadora de layout introdutório, não uma alegação de impossibilidade matemática
de colocar dois corpos. A detecção local de 65 evita aquisições mais distantes.
O teto deixa 100 px livres acima do piso; não foi alterado.

**Ponte:** BridgeApproach é um piso firme X=1504–1600, Y=156. O corvo fica em
(1552,112), já no setor 5, e não sobre os vãos. A detecção de 38 px, com alvo
nos pés menos 14, restringe na prática a aquisição no piso a aproximadamente
X=1521–1583 (patrulha 1544–1560 e diferença vertical próxima de 30 px).
Nenhum piso BridgeSpanA (1632–1712, Y=148) ou B (1752–1848, Y=144) entra nesse
alcance. O alcance da detecção é menor que o limite de investida, permitindo
chegar ao alvo fixado. Altitude baixa de recuperação permite J no chão.

Os ensaios iniciam Aren em X=1532 ou 1572, esquivam lateralmente com input real,
viram e aplicam dois golpes. Mantêm apoio no piso e 5 HP. Corvo no acesso é uma
solução de tensão localizada; não há perseguição aérea ao longo dos três vãos.
O início do piso é parte da transição das Catacumbas, mas a origem do inimigo
é do setor 5. O aviso pode começar antes de Aren cruzar X=1536, conforme alcance;
a identificação do HUD continua correta para a posição real de Aren.

**Catedral:** piso contínuo X=1888–2368, Y=156. A faixa do esqueleto começa em
2092, afastando alcance de ataque da entrada nominal em 1984. O corvo patrulha
mais à direita; pode ser separado do esqueleto pelo posicionamento. Na ida,
resolver o esqueleto pela esquerda antes de aproximar o corvo; na volta,
resolver o corvo pela direita e depois caminhar até o esqueleto. Há espaço
para esquiva/recuo, marcador final livre e retorno, sem portas, arena ou chefe.

A dificuldade pretendida cresce por contexto: solo seguro → ameaça terrestre →
aérea → corredor subterrâneo → plataforma com vãos adiante → duas espécies no
mesmo espaço. Catacumbas com um inimigo e Ponte com alcance curto são ajustes
conscientes de justiça; não se afirma aumento numérico de dificuldade em cada
setor. Ritmo, desafio e fluidez foram avaliados pelo responsável na homologação
posterior registrada na seção 12; os limites das simulações permanecem.

## 5. Física, combate e ativação

Usadas cenas, CharacterBody2D, inputs, SwordAttack, KnightHurtbox e contatos M2
reais. O teste não desliga o processamento dos seis inimigos, não altera alvo,
HP máximo, invulnerabilidade, colisão ou dano para facilitar as sequências.
As fixtures restauram o mundo e colocam Aren no início de cenários separados;
isso é explicitamente distinto da travessia contínua.

- CryptSkeleton: três golpes reais, interrupção do aviso, zero HP perdido em
  ambos os lados; morte e fonte inativa confirmadas.
- BridgeRaven: aviso, esquiva andando, investida completa até destino fixado,
  contra-ataques no chão em ambos os lados, um dano por golpe, derrota e zero
  HP perdido. Ensaio separado confirma retorno físico à patrulha, sem alvo nulo.
- Encontro final: duas repetições de cada ordem. Dentro de cada sequência Aren
  caminha entre inimigos; sem teleporte, cura, reset ou alteração de alvo entre
  os participantes. Cada adversário é derrotado pela espada real e Aren mantém
  **5/5 HP**. Os resets ocorrem somente entre cenários independentes.
- Os inimigos distantes mantêm seus estados próprios; não há novo gerenciador
  global, herança de IA terrestre para voadores ou alteração da regra de respawn.
- Recepção, acerto único, paredes, proteção 0,8 s e fontes inertes depois da
  morte continuam cobertos pelas regressões M1/M2/B1/B2, além dos casos B3.

A frenagem importa: ao chegar correndo ao aviso do corvo final, o teste freia
por quatro ticks e então esquiva por 16 ticks. Uma inversão curta de 12 ticks
após corrida não deslocava Aren o suficiente; não se compensou isso alterando
sua aceleração ou a IA. A espada permanece horizontal, X=6–28 à frente e
Y=pés−21 a pés−7. No piso Y=156, sua faixa Y=135–149 alcança o receptor do
corvo centrado próximo de Y=142 durante recuperação.

Esqueletos continuam com sondagens de chão/parede, visão sem sólido World,
diferença vertical até 18 px e perseguição dentro da patrulha. Corvos continuam
exigindo alvo vivo e no chão, ausência de parede e visibilidade na aquisição e
antes do lançamento. Patrulhas fora da tela seguem processando; a quantidade
atual não exigiu sistema de spawn ou otimização novo. Não houve mudança da câmera.
Não se garante nova geometria arbitrária: retorno aéreo continua direto e com
colisão, sem busca de caminho. As áreas escolhidas e os ensaios atuais retornam.

## 6. Navegabilidade e restauração

`distribution_test.gd` percorre continuamente os seis setores até X=2288 e
retorna a X=48 com todos os inimigos ativos. Usa caminhada, saltos por sondas
de borda/degrau e antecipação de ameaças terrestres, além de inputs de J.
Nenhum teleporte, cura, reset, morte ou retorno ao início ocorre entre os
extremos. Queda, retorno brusco ou bloqueio falhariam o teste.

Resultado real: **ida 5→5 HP; volta 5→4 HP**. Percurso subterrâneo, escadas,
ponte, entrada da Catedral e marcador final percorridos nos dois sentidos;
câmera inteira e dentro dos limites. A volta dessa sequência perdeu 1 HP. Uma fixture independente iniciou Aren
na Catedral com os seis inimigos vivos e repetiu o retorno completo, **5→5 HP**,
sem reposição dentro do percurso. Na virada da ida contínua, os seis também
continuavam com HP máximo: [3,2,3,2,3,2]. Os testes exigem zero dano na ida e
nesse retorno independente; fases de patrulha diferentes mudam o resultado.
Isso não prova dano inevitável: ensaios controlados dos novos encontros,
incluindo o combinado, possuem estratégias físicas sem dano. Não foi ensaiada
uma campanha completa matando todos os inimigos com zero dano em qualquer fase
de patrulha; essa limitação dos testes automatizados foi preservada, mesmo
após a homologação manual informada pelo responsável.

Morte de Aren cancela fontes dos seis inimigos; após o ciclo M2, todos recuperam
HP e patrulha junto à origem, Aren volta ao spawn com 5 HP sem dano imediato.
A sondagem de restauração força fontes ativas e dano nos inimigos como fixture
de estados interrompidos, sem mudar o conteúdo jogável. Queda viva na Ponte
restaura todos no mesmo tick, mantendo Aren em 4 HP, sem cura.

Não há checkpoint funcional no cemitério: respawn usa o spawn seguro existente.
A regra de checkpoint ativo continua coberta pela suíte M2 no cenário histórico.
Os dois marcadores de checkpoint da fase permanecem não funcionais.

## 7. Execuções reais da implementação anterior

Engine: **Godot 4.7.2.stable.official.ed1daf0bf**, executável console em
`C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`.
Nenhuma instalação/dependência nova.

| Execução na implementação anterior | Verificações | Falhas | Código |
|---|---:|---:|---:|
| Importação --headless --import | — | — | 0 |
| Inicialização --headless --quit-after 60 | — | — | 0 |
| smoke_test.gd (M0) | 14 | 0 | 0 |
| combat_test.gd (M1) | 36 | 0 | 0 |
| survival_test.gd (M2) | 59 | 0 | 0 |
| cemetery_test.gd (M3-A) | 52 | 0 | 0 |
| reachability_test.gd (FIX01) | 35 | 0 | 0 |
| skeleton_test.gd (M3-B1) | 49 | 0 | 0 |
| raven_test.gd (M3-B2) | 63 | 0 | 0 |
| distribution_test.gd (M3-B3) | 115 | 0 | 0 |
| **Total final** | **423** | **0** | **0** |
| Captura gráfica dos seis setores e Ponte | 8 imagens | — | 0 |

FIX01 inclui **120 ensaios físicos**, agregados nos 35 checks, sem contá-los duas
vezes. M3-A e FIX01 isolam IA para medir terreno como antes; B1/B2 e B3 testam
os encontros vivos. Nenhuma asserção antiga foi retirada para obter aprovação;
apenas a contagem de instâncias B2 foi atualizada de 2 para 6. Relatórios
homologados anteriores foram preservados.

Reprodução, substituindo `godot` pelo executável acima:

```powershell
godot --headless --path . --log-file .godot/b3-import.log --import
godot --headless --path . --log-file .godot/b3-startup.log --quit-after 60
# Repetir para cada uma das oito suites, com nome de log exclusivo:
godot --headless --path . --fixed-fps 60 --log-file .godot/b3-distribution_test.log --script res://tests/distribution_test.gd
```

Logs locais em `.godot/b3-<nome_da_suíte>.log`, mais import/startup/visual.
Versão verificada também com `--version`, código 0.

## 8. Diagnósticos do desenvolvimento e correções

Nenhum ajuste foi necessário no código de produção homologado. Os seguintes
problemas foram encontrados na construção da automação e corrigidos nela:

- Primeira execução: 130 checks, 14 falhas. O fixture de retorno posicionava Aren
  em relação à origem do esqueleto já deslocado e o fazia olhar para o lado errado.
  Um salto disparado antecipadamente pelo aviso do corvo também fazia o bot cair
  antes do salto obrigatório. O bot passou a usar a posição atual do adversário
  e a reservar os saltos da Ponte para as bordas reais. Log preservado em
  `.godot/b3-distribution-initial.log`. O conteúdo da fase não foi alterado.
- Versão intermediária: 136 checks, zero falhas, mas reposicionava Aren entre
  participantes do encontro final. Foi substituída por sequências contínuas mais
  fortes, não incluída outra vez no total final.
- Na sequência contínua, duas falhas de zero dano expuseram a inversão curta de
  movimento após corrida. O ensaio passou a frear e esquivar pelo tempo descrito
  na seção 5. Logs locais: `.godot/b3-distribution-continuous-before.log` e
  `b3-distribution-debug.log`. Nenhuma mudança de física/IA/balanceamento global.

O teste final tem 115 checks: agregou sequências contínuas no lugar de
repetir fixtures locais do encontro final e acrescentou o retorno independente
com todos vivos e as asserções de zero dano nos percursos frescos. A redução refere-se apenas às versões
em desenvolvimento do teste novo; as suítes homologadas mantêm seus checks.

## 9. Inspeção visual e limitações

Execução gráfica nativa, Compatibility, NVIDIA GeForce RTX 2060 SUPER, código 0.
Oito imagens do viewport 320×180 foram abertas e inspecionadas:

- `.godot/b3-visual-sector1.png`: introdução sem inimigos.
- `.godot/b3-visual-sector2.png`: esqueleto original sobre piso largo.
- `.godot/b3-visual-sector3.png`: aviso do corvo original.
- `.godot/b3-visual-sector4.png`: esqueleto no corredor, escadas e teto legíveis.
- `.godot/b3-visual-sector5.png`: corvo no piso firme antes do vão.
- `.godot/b3-visual-sector6.png`: ambas as silhuetas visíveis e espaço livre.
- `.godot/b3-visual-bridge-dive.png`: investida sobre o acesso firme.
- `.godot/b3-visual-bridge-recover.png`: recuperação baixa para contra-ataque.

Instrumentação `.godot/b3_visual.gd` reposiciona Aren entre capturas, mantém IA
ativa e encerra automaticamente. São capturas controladas, não um playtest humano
contínuo ou medição de desempenho. A primeira captura da Ponte enquadrava Aren
antes da fronteira nominal do setor; o fixture gráfico foi corrigido para o piso
à direita do corvo. As oito capturas finais foram reinspecionadas.

Persistem `Failed to read the root certificate store` e, na importação, falha
ao salvar `C:/Users/ovohe/AppData/Roaming/Godot/editor_settings-4.7.tres`.
São diagnósticos conhecidos de ambiente Windows/perfil, separados dos resultados
do projeto. Os processos concluíram com código 0; não foram observados erros de
script/recurso nas execuções finais. Não se alteraram certificados/permissões.

Não houve benchmark de FPS/latência ou playtest humano na execução do agente.
O playtest posterior do responsável foi informado conforme seção 12.
As repetições cobrem condições determinísticas escolhidas, não todas as fases
possíveis de patrulha, entradas ou erros do jogador. O alcance curto da Ponte
prioriza segurança sobre pressão contínua durante saltos. A composição final
pode produzir ataques sobrepostos se o jogador avançar sem separar as ameaças;
os ensaios mostram uma estratégia de separação, não proíbem todo ataque simultâneo.
Dificuldade, reação visual e fluidez receberam a homologação manual informada
pelo responsável; isso não amplia a cobertura dos ensaios automatizados.

## 10. Roteiro histórico do playtest

Roteiro original preservado como referência, sem atribuir resultados individuais
aos 16 itens. O responsável informou 10/10 nas categorias da seção 12.
Instrução original: executar F8/F5 e registrar PASSOU/FALHOU e observações:

1. [ ] Setor inicial livre de inimigos e início seguro.
2. [ ] Primeiro Esqueleto funcionando como homologado.
3. [ ] Primeiro Corvo funcionando como homologado.
4. [ ] Catacumbas com recuo e dificuldade adequados, sem ocupação das escadas.
5. [ ] Ponte atravessável com Corvo presente, nos dois sentidos.
6. [ ] Encontro final com Esqueleto e Corvo identificáveis e separáveis.
7. [ ] Possibilidade de esquivar e contra-atacar usando a espada existente.
8. [ ] Ausência de dano inevitável nas estratégias de cada encontro.
9. [ ] Morte dos inimigos sem fontes ofensivas residuais.
10. [ ] Restauração de todos após morte de Aren, sem dano imediato no início.
11. [ ] Restauração após queda viva, preservando HP e regras anteriores.
12. [ ] Percurso completo de ida até o marcador da Catedral.
13. [ ] Percurso completo de volta.
14. [ ] Câmera revela aviso, adversários e aterrissagens.
15. [ ] Preservação dos sistemas M0/M1/M2 e encontros anteriores.
16. [ ] Desempenho e fluidez durante a fase inteira.

Homologação funcional posteriormente recebida e registrada na seção 12.

## 11. Git ao encerrar a implementação — registro histórico

Entrega local conferida: três arquivos rastreados modificados e três novos,
conforme inventário da seção 2. Índice vazio e HEAD/branch preservados.
Revisão de diff e whitespace, referências, UID e comparação dos blocos existentes
da cena contra HEAD verificaram a seleção restrita ao M3-B3: 118 blocos
preexistentes idênticos e apenas quatro instâncias acrescentadas. Referências
res:// e UIDs passaram na conferência, sem colisões. `git diff --check` passou. `.gitignore` intacto;
logs, capturas, instrumentação e caches em `.godot/` permanecem ignorados.
Nenhuma credencial ou arquivo temporário necessário ao jogo foi acrescentado.

Não executados git add, commit ou push. Sem troca de branch/remoto, deploy,
exportação, publicação, chefes, armadilhas, checkpoints ou novos tipos de inimigo.
**M3-C, M3-D/E e M4 não iniciados.** Checkpoints/armadilhas do M3-C continuam
pendentes para sua própria autorização; não foram implementados nesta entrega.
Naquela entrega, aguardava-se playtest e homologação funcional do M3-B3,
posteriormente recebidos conforme seção 12.

## 12. Homologação manual informada pelo responsável — 03/11/2026

**M3-B3 — HOMOLOGADO FUNCIONALMENTE PELO RESPONSÁVEL.**

**Playtest manual: 10/10 PASSOU — Nenhuma observação.**

Funcionalidades aprovadas no playtest completo realizado pelo responsável:

1. Setor inicial seguro.
2. Caminho das Lápides.
3. Jardim dos Mortos.
4. Catacumbas.
5. Ponte das Almas.
6. Portão da Catedral.
7. Percurso de ida e volta.
8. Morte e restauração.
9. Regressão e câmera.
10. Dificuldade geral.

A homologação foi realizada e informada pelo responsável. Não constitui uma
auditoria independente do agente nem uma nova execução dos testes automatizados.
Preservados os resultados anteriores: 423 verificações, incluindo 115 M3-B3,
ida 5→5 HP, volta 5→4 HP, retorno independente 5→5 HP e encontro final sem dano
nas duas ordens, duas vezes cada. Importação/inicialização, oito capturas,
diagnósticos Windows e limitações técnicas permanecem documentados.

Nesta etapa somente README e relatório foram atualizados. Engine e suítes não
foram reexecutadas. Código, cenas, coordenadas, limites de patrulha, atributos,
IA e balanceamento homologados foram preservados. M3-C permanece não iniciado.

## 13. Auditoria de homologação e versionamento

Estado inicial desta tarefa: `main`, HEAD
`56988ead853f65ad19a30036ce534ad5db32d030`, três arquivos modificados e três
novos, índice vazio. Repositório correto e inventário restrito aos seis arquivos
da seção 2, sem alterações inesperadas. Autoria local existente: Rafael
<spiritstonesrafa@gmail.com>, preservada sem mudar configurações.

Somente os dois documentos receberam alterações nesta etapa; implementação,
testes, UID e distribuição dos seis inimigos foram preservados. Conferências:
inventário, referências res://, IDs de recursos, UIDs, preservação dos sistemas
anteriores e histórico documental, ausência de padrões de credenciais,
`.gitignore`, whitespace e integridade Git. `git fsck --full` concluiu sem erros
de integridade; seis árvores soltas foram informadas e preservadas sem limpeza.
A revisão integral do diff staged
precede o único commit local autorizado, com a mensagem:

`feat(m3-b3): homologa distribuicao e balanceamento de inimigos`

Caches, logs, capturas e instrumentação ficam em `.godot/`, fora da seleção.
O UID do novo teste é mantido. Hash final, autoria, seis arquivos registrados e
limpeza da árvore/índice são conferidos no Git e informados ao encerrar.
Nenhuma nova execução da engine foi declarada. Sem push, deploy, exportação ou
publicação. M3-C e demais marcos posteriores permanecem não iniciados.
