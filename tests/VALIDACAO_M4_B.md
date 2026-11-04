# M4-B — Combate avançado do Guardião do Juramento

**M4-B — HOMOLOGADO FUNCIONALMENTE PELO RESPONSÁVEL.**

## Homologação funcional informada pelo responsável — 03/11/2026

**M4-B — HOMOLOGADO FUNCIONALMENTE PELO RESPONSÁVEL.**

Aprovação funcional geral recebida: ataques, transformação, segunda fase,
efeitos, morte de Aren, reinício e estabilidade funcionando normalmente;
nenhum bug relatado. O responsável confirmou: “Sim, tudo funcionando normal.”
Esta aprovação não representa preenchimento individual de 29/29 respostas;
o checklist técnico histórico permanece preservado abaixo.

**Decisão de balanceamento: Guardião do Juramento mantido como chefe introdutório.**

O responsável avaliou o boss como fácil e adequado à introdução/tutorial.
Isso não é defeito. HP, dano, velocidades, avisos, cooldowns, recuperações,
padrões e transformação aos 50% permanecem intactos. O próximo chefe deverá
exigir maior domínio por profundidade de padrões, com dificuldade justa;
não será implementado agora. Decisão registrada em ROADMAP.md.

Preservam-se os resultados técnicos anteriores: 946/946 verificações,
152 também em execução gráfica, 29 capturas 4K e dois duelos de 28,15 s,
sem dano e após um erro; medição real de 45,001 s, média 59,999 FPS,
p95 17,047 ms e máximo 24,717 ms. Não houve reexecução da engine nesta
etapa documental/Git. Avaliação humana e testes do agente são distintos.

Autorizado um único commit local M4-B, sem push. M4-C somente após validar
o commit; segunda fase do jogo e próximo chefe não iniciados.

## Histórico técnico da implementação — preservado

Data: 03/11/2026. Windows, Godot 4.7.2 ed1daf0bf, Compatibility/OpenGL,
RTX 2060 SUPER. Não há homologação humana antecipada do M4-B.

## 1. M4-A homologado e publicado antes do desenvolvimento

Pasta confirmada: C:\PROJETOS\CINZAS DO JURAMENTO, branch main. Baseline
anterior 35cc465308d884f826f91eb3586e652b73f2d19a, índice vazio, dois modificados,
20 novos M4-A e 14 locais anteriores preservados. README, relatório M4-A,
proveniência, PNG, scripts, cenas, UIDs, referências, diff staged completo,
.gitignore, whitespace e padrões de credenciais foram auditados.
Sem instruções AGENTS.md aplicáveis encontradas no projeto/pais consultados.

Homologação funcional e visual informada pelo responsável: **18/18 PASSOU,
nenhuma observação**, registrada em README e VALIDACAO_M4_A, distinguindo-a
explicitamente dos resultados técnicos anteriores (794 funcionais e nove de
captura, total distinto histórico 803). A engine não foi repetida nessa etapa
exclusivamente documental. Relatórios históricos preservados.

Único commit M4-A: **ab003475e4a39bc5d0b40d33292b54fd5c745404**.
Mensagem: `feat(m4-a): homologa arena e fundacao do guardiao`.
Autoria local preservada: Rafael <spiritstonesrafa@gmail.com>, branch main.

Após fetch, origin apontava ao repositório autorizado
https://github.com/spiritstonesrafa-ux/Cinzas-do-Jugamento.git, sem divergência.
Um único `git push origin main` concluiu por fast-forward de 3695eb2 para
ab00347. `git ls-remote origin refs/heads/main` confirmou o hash completo acima,
igual a HEAD e origin/main. Foram publicados, em ordem:

- 3af31c31da5f693dfef10db0f709d2e76a674c34 — M3-C homologado.
- 369de2168d798b8e27a92ce406f4cbe666b8207d — M3-D homologado.
- 35cc465308d884f826f91eb3586e652b73f2d19a — M3-E homologado.
- ab003475e4a39bc5d0b40d33292b54fd5c745404 — M4-A homologado.

Auditoria da publicação: só os quatro marcos autorizados; sem caches,
credenciais detectadas, arquivos locais de referência ou sidecars de capturas.
Nenhum force, merge, rebase, tag, release, configuração global ou remoto alterado.
M4-B começou somente depois da confirmação do push.

Arquivos do commit M4-A (22):

```text
README.md
assets/art/m4a/PROVENANCE.md
assets/art/m4a/guardian_poses.png
assets/art/m4a/guardian_poses.png.import
scenes/boss/guardian.tscn
scenes/boss/guardian_arena.tscn
scenes/main.tscn
scripts/boss/arena_visual.gd
scripts/boss/arena_visual.gd.uid
scripts/boss/boss_hud.gd
scripts/boss/boss_hud.gd.uid
scripts/boss/encounter.gd
scripts/boss/encounter.gd.uid
scripts/boss/guardian.gd
scripts/boss/guardian.gd.uid
scripts/boss/guardian_attack.gd
scripts/boss/guardian_attack.gd.uid
scripts/boss/guardian_visual.gd
scripts/boss/guardian_visual.gd.uid
tests/VALIDACAO_M4_A.md
tests/boss_test.gd
tests/boss_test.gd.uid
```

## 2. Escopo e preservação

M4-B estende a mesma máquina de estados, fonte M2 e receiver M1; não substitui
os sistemas homologados. Corpo do boss 28x62, hurtbox 28x56, HP 10; Aren com
5 HP, dano de espada 1, velocidade 100, gravidade 680 e impulso -230 intactos.
Preservados PNG/import do Guardião, escala, sala, geometria, selo, intro,
travamento, câmeras, barra, morte/checkpoints, derrota funcional e retorno.
Os seis setores, arte M3, fontes/receivers comuns, física, espada, vida,
checkpoints e DISPLAY01 permanecem byte a byte iguais ao baseline M4-A.

Não há M4-C, narrativa final, recompensa/save, segunda fase do jogo ou novo setor.

## 3. Padrões, fases e parâmetros

| Padrão | Aviso | Ativo | Recuperação fase 1 / 2 | Movimento / alcance |
|---|---:|---:|---:|---|
| A — pesado original | 0,80 s | 0,18 s | 1,10 / 1,00 s | Hilt (15,-38), ponta (75,-12), espessura 10; preservado |
| B — investida | 0,90 s | 0,50 s | 1,30 / 1,20 s | 144 px/s, máximo 72 px; lâmina (15,-14)–(77,-14) |
| C — varredura baixa | 0,85 s | 0,25 s | 1,20 / 1,10 s | Hilt (8,-14), raio 78, ângulo -0,08 a +0,08 rad |
| D — Onda do Juramento | 1,05 s | impacto 0,22 s | 2,15 / 2,05 s | Crista a 110 px/s, máximo 170 px, núcleo 18x18 |

HP 10 preservado: dez acertos válidos. Limite exportado da fase 2 em 0,50
(5 HP); transformação de 0,90 s, sem dano e com imunidade curta a hits atrasados.
Se o limiar for cruzado durante aviso/ataque comprometido, esse ataque termina
antes da transformação. Fora dele a transição é imediata. Fase 2 mantém os três
padrões anteriores, libera onda e reduz recuperação apenas em 0,10 s; mínimo
absoluto 0,95 s. Não se aumentou HP para prolongar a batalha.

Estados anteriores permanecem; somente PHASE_TRANSITION é novo. Fase é um
campo, não um estado duplicado. Hurt 0,16 s não cancela avisos ou ataques e
não se renova quando atingido novamente em HURT, evitando travamento infinito.

Seleção determinística por distância, direção, último padrão, cooldown e
espaço: dois pesados iniciais ensinam o padrão homologado. Depois, distância
>=96 e espaço disponível >=121 podem selecionar investida; o espaço reserva
72 px de movimento e a lâmina real dentro dos 320 px. Movimento para antes de
X=77/243 se necessário, sem teleporte ou atravessar parede. Varredura exige
86 px de espaço à frente; caso contrário usa pesado. Onda requer fase 2,
5 s de cooldown e não repetir o último padrão. Demais cooldowns 2 s. Direção
fica comprometida no aviso; sem homing, cancelamento de aviso ou combo sem pausa.

A onda nasce na ponta baixa (28,-2 aproximado), ao nível do chão. A fonte
exclusiva é o projétil; o golpe visual no solo não soma outro dano invisível.
Cada ataque ou onda consome uma única entrega de dano 1, inclusive se Aren
estiver protegido. A invulnerabilidade M2 de 0,80 s é preservada. Raios contra
World impedem atravessar paredes; alcance e vida da onda são limitados.
A onda expira em cerca de 1,55 s, antes da recuperação terminar; não há próxima
ofensiva sobreposta ao mesmo projétil. Morte, derrota, transição e reset
eliminam fontes/onda; fase, HP, posição, contagem e cooldowns voltam ao inicial.

## 4. Arte, leitura e origem

Guardião e atlas original não foram alterados. Novas poses articulam a mesma
lâmina e fragmentos raster dos braços, mantendo gauntlet no punho da arma.
Investida tem setas de aviso e postura baixa, varredura ergue e abaixa a arma
com arco lilás; golpe especial levanta a arma e aponta ao chão com runas frias.
Transformação usa filamentos e fissuras sobre a armadura; fase 2 tem realce
frio discreto e indicador II na HUD. A barra e câmera mantêm desenho/enquadramento.

A onda inicial em polígonos foi reprovada na revisão do agente e substituída
por **oath_flame.png**, original image_gen integrado, 1536x1024 RGBA, alpha
verificado; arquivo copiado sem edição. Render usa recorte registrado e
Nearest, no próprio nó físico; cauda e brilho não causam dano. Prompt integral,
método e uso em assets/art/m4b/PROVENANCE.md. Animação dos braços em
assets/art/m4a/M4_B_ANIMATION.md. Sem download de asset ou licença externa nova.

Inspeção gráfica incluiu mãos/arma, salto, antecipações, propagação da onda,
transformação e derrotas. Não é redesenho da identidade aprovada. Limite:
animação articulada sobre quatro poses, não ciclos raster extensos novos;
sem áudio exclusivo adicionado. Aceitação estética e fluidez percebida na TCL
permanecem com o responsável.

## 5. Testes efetivamente executados

**946 verificações funcionais distintas aprovadas: 794 anteriores + 152 M4-B.**
Repetições headless/gráficas não são somadas. As nove verificações de captura
históricas do M4-A permanecem preservadas e separadas dos testes funcionais.

| Suíte herdada reexecutada | PASSOU | Exit |
|---|---:|---:|
| smoke | 14 | 0 |
| combat | 36 | 0 |
| survival | 59 | 0 |
| cemetery | 52 | 0 |
| reachability | 35 | 0 |
| skeleton | 49 | 0 |
| raven | 63 | 0 |
| distribution | 115 | 0 |
| mechanisms | 77 | 0 |
| art | 18 | 0 |
| presentation | 10 | 0 |
| raster_art | 8 | 0 |
| horizontal_attack | 46 | 0 |
| cohesion | 14 | 0 |
| display | 38 | 0 |
| integration | 101 | 0 |
| boss | 59 | 0 |

M4-B final: **152/152 headless e 152/152 gráfico 4K**, zero falhas/erros de
script. M4-A 59/59 repetido novamente após o acabamento final. Importação e
inicialização gráficas finais aprovadas, exit 0. Suíte gráfica auxiliar também
salvou dez imagens de articulação (1/1 verificação de gravação), antes de trocar
a chama vetorial por raster; essas imagens são diagnósticas, não a arte final.
As novas 29 capturas finais são separadas da contagem funcional.

Cobertura: arena/intro/display/HP, pesado preservado, os três novos padrões
em ambos os sentidos, contatos físicos no chão com dano único, saltos reais,
recuperação, direção comprometida, comprimento real da investida e câmera,
invulnerabilidade, limiar/transição não interrompendo golpe, cooldowns/seleção,
onda real com alcance/expiração/parede, morte em fase 1/transição/fase 2,
reset, dois duelos vivos, vitória e caminhada real de saída. A nova textura é
carregada e seu alpha verificado. Regressão inclui 120 ensaios físicos de
navegação e a integração M3-E; nenhum teste anterior foi apagado ou enfraquecido.

Fixtures escolhem padrão e posições entre ensaios isolados. Não representam
percurso humano desde o início. Nos duelos de dez golpes não há teleporte,
cura, congelamento do boss ou manipulação de dano durante a luta; o agente
automático usa somente deslocamento, salto e espada originais.

## 6. Balanceamento observado e diagnóstico preservado

Dois duelos finalizados em **28,15 s** cada (tempo simulado determinístico),
um com **5/5 HP** e outro com **4/5 HP**, após deixar deliberadamente de saltar
o primeiro pesado. Cada um usa dez acertos e exercita pesado, varredura e onda
na seleção natural; investida tem ensaios físicos isolados e seleção por
condições, não é alegada como ataque observado nesses dois duelos próximos.
Isso prova possibilidade de vitória sem dano e com erro, não média humana ou
balanceamento final. Um piloto habilidoso pode vencer mais rápido atacando
mais de uma vez na recuperação, como a suíte histórica demonstra.

Janelas físicas amostradas a 60 Hz, distância inicial 60 px, ambos os sentidos:
investida com salto 0,10/0,16/0,22 s antes da execução; varredura
0,12/0,20/0,26 s; onda 0/0,06/0,12 s. Não significam que todo tempo intermediário
ou toda distância foi exaustivamente provado. Saltos muito antecipados podem
cair sobre a onda; observar emissão/frente luminosa é a orientação de playtest.

Falhas preliminares não ocultadas: varredura alta e investida longa deixavam
saltos de amostra falharem; a varredura foi baixada e a investida passou a 0,50 s
mantendo 72 px. A onda inicial mais lenta exigia salto após emissão; a versão
final a 110 px/s passou três tempos amostrados. Tempos de 0,03/0,07 s para a
investida falharam em ensaios preliminares; a faixa final validada começa em
0,10 s. O bot inicialmente se aproximava durante o pesado e sofria dano;
passou a observar o aviso a cerca de 60 px e aproximar para punir. Não se
alterou a física de Aren para resolver as falhas. Logs preliminares preservados
em .godot e na pasta externa; não entram no total final.

Ainda existe espaço para otimização de proximidade/spam por jogadores; não se
impôs dano corporal invisível ou imunidade arbitrária para compensar. O
percurso desde CP2 permanece o homologado. Julgamento de justiça, repetitividade,
legibilidade e prazer da luta depende de playtest manual; 18 ensaios adicionais
amostram tempos, não substituem essa avaliação.

## 7. Renderização, evidências e desempenho

Pasta persistente: `C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\m4b`.
Resultados/comandos: results.json, complete-results.json e logs por suíte.
Capturas finais: native4k-complete/index.html, **29 PNGs 3840x2160**, sem
ampliação artificial: fase 1, antecipação/execução/esquiva dos quatro padrões
em duas direções, transformação, fase 2 e duas derrotas. Baseline visual:
`C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\m4a\native4k-complete\index.html`.
Comparar especialmente telegraph/attack_evaded do M4-A com warning/active/evade
finais e phase_transition/phase2/victory do M4-B. As capturas iniciais e
native4k-polished preservam as iterações anteriores; a chama final é a raster
na pasta native4k-complete. Galerias não entram no runtime ou no staging.

Medição final real, separada da execução funcional com fixed-fps:
**45.001 s, 2700 quadros, 59.999 FPS médios,
p95 17.047 ms, máximo 24.717 ms**, viewport
(3840, 2160). Sem --fixed-fps, com GPU e configuração gráfica original.
Warmup de 120 quadros antes da medição; sem salvar PNGs dentro da janela medida.
Load automático de combate e tentativas, não playtest humano. Não se afirma
60 FPS travados, benchmark prolongado ou medição da latência/saída física da TV.

Persistem avisos ambientais conhecidos de certificados Windows e gravação de
editor_settings no perfil. Os processos finais encerraram 0; zero erros de
script/parsing. Nenhuma mudança em Windows, TCL, certificados, driver ou permissões.

## 8. Como repetir e jogar

Godot usada: C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe.
Após importação, usar --headless --fixed-fps 60 --script
res://tests/boss_advanced_test.gd para funcional; retirar --headless para o
mesmo teste gráfico (fullscreen nativo). Variável CINZAS_M4B_EVIDENCE aponta
para pasta persistente de saída; sem ela usa .godot/m4b, ignorado. Log pode ser
direcionado com --log-file. Para desempenho usar boss_performance_test.gd
sem --fixed-fps nem --disable-vsync. Para poses usar boss_visual_test.gd.
Comandos completos e duração de cada execução estão nos JSONs citados.

F8/F5 reinicia sessão na Godot 4.7.2. Termine a primeira fase, caminhe à direita
até o Selo do Guardião. A/D ou setas, Espaço/W/cima, J. Observe diferença dos
avisos, salte perto da execução/onda e aproxime na recuperação. Sem dash,
rolamento, escudo ou habilidade nova. Vitória retorna pelo selo esquerdo.

## 9. Playtest manual pendente

Preencher PASSOU / FALHOU / NÃO TESTADO. Todos abaixo **NÃO TESTADO pelo
responsável para o M4-B**; a homologação M4-A 18/18 está preservada.

| Nº | Item | Resultado |
|---|---|---|
| 1 | Entrada na arena | NÃO TESTADO |
| 2 | Introdução do chefe | NÃO TESTADO |
| 3 | Aparência do Guardião | NÃO TESTADO |
| 4 | Barra de vida | NÃO TESTADO |
| 5 | Movimentação | NÃO TESTADO |
| 6 | Golpe pesado | NÃO TESTADO |
| 7 | Investida | NÃO TESTADO |
| 8 | Esquiva da investida | NÃO TESTADO |
| 9 | Varredura | NÃO TESTADO |
| 10 | Esquiva da varredura | NÃO TESTADO |
| 11 | Contra-ataques | NÃO TESTADO |
| 12 | Dano do chefe | NÃO TESTADO |
| 13 | Dano recebido pelo chefe | NÃO TESTADO |
| 14 | Transição para a fase 2 | NÃO TESTADO |
| 15 | Aparência da fase 2 | NÃO TESTADO |
| 16 | Onda amaldiçoada | NÃO TESTADO |
| 17 | Esquiva da onda | NÃO TESTADO |
| 18 | Variedade dos padrões | NÃO TESTADO |
| 19 | Dificuldade justa | NÃO TESTADO |
| 20 | Recuperação após os golpes | NÃO TESTADO |
| 21 | Morte de Aren na fase 1 | NÃO TESTADO |
| 22 | Morte de Aren na fase 2 | NÃO TESTADO |
| 23 | Reset correto | NÃO TESTADO |
| 24 | Derrota do Guardião | NÃO TESTADO |
| 25 | Saída da arena | NÃO TESTADO |
| 26 | Qualidade visual 4K | NÃO TESTADO |
| 27 | Fluidez | NÃO TESTADO |
| 28 | Ausência de bugs graves | NÃO TESTADO |
| 29 | Morte durante a transformação | NÃO TESTADO |

## 10. Arquivos e Git final

Modificados: README.md e cinco scripts boss (guardian, guardian_attack,
guardian_visual, boss_hud, encounter). Novos: oath_wave.gd/UID,
boss_advanced_test.gd/UID, boss_visual_test.gd/UID,
boss_performance_test.gd/UID, tests/VALIDACAO_M4_B.md,
assets/art/m4a/M4_B_ANIMATION.md e assets/art/m4b (PNG/import/PROVENANCE).
Lista literal/status final e hashes: final_inventory.json na pasta de evidências.

Branch main, HEAD e origin/main **ab003475e4a39bc5d0b40d33292b54fd5c745404**,
sem commits à frente/atrás. Índice vazio; seis rastreados modificados, 13 novos
M4-B e os 14 arquivos locais anteriores preservados por SHA-256. Caches/logs
ignorados, UIDs e sidecar de textura novos preservados. Referências/whitespace
revisados. Nenhum segredo detectado nas alterações selecionadas.

**M4-B inteiramente local: sem staging, commit ou push. M4-C não iniciado.
Encerrar e aguardar playtest e homologação manual do responsável.**
