# M4-A — Guardião do Juramento: planejamento, arena e fundação jogável

**M4-A — HOMOLOGADO FUNCIONAL E VISUALMENTE PELO RESPONSÁVEL.**


## Homologação informada pelo responsável — 03/11/2026

**Playtest manual: 18/18 PASSOU — Nenhuma observação.**

O responsável aprovou selo, apresentação, aparência, escala, travamento da
arena, barra de vida, perseguição, golpe telegrafado, esquiva, dano do chefe,
ataque da espada, reação ao dano, recuperação, derrota, saída, morte durante
a luta, imagem 4K e estabilidade. A avaliação manual foi realizada e informada
pelo responsável, não pelo agente.

Preservam-se os resultados técnicos anteriores: **794/794 verificações
funcionais (735 herdadas + 59 M4-A)** e nove verificações de salvamento de
capturas 4K, total distinto 803. Importação e inicialização anteriores aprovadas.
Nenhuma execução da engine foi repetida na etapa de registro e versionamento.
Os diagnósticos e limitações históricos abaixo permanecem documentados.

Autorizado um único commit M4-A e push fast-forward do histórico homologado.
M4-B será iniciado somente após confirmar o push; M4-C não iniciado.

## Histórico técnico preservado da implementação

Data: 03/11/2026. Godot 4.7.2 stable oficial ed1daf0bf, Windows, Compatibility/OpenGL, NVIDIA RTX 2060 SUPER.

## 1. Baseline e escopo

Pasta confirmada: C:\PROJETOS\CINZAS DO JURAMENTO. Branch main, HEAD `35cc465308d884f826f91eb3586e652b73f2d19a` (M3-E). Commit M3-D `369de2168d798b8e27a92ce406f4cbe666b8207d` presente no histórico. Inicial: nenhum rastreado modificado, índice vazio, 14 arquivos locais conhecidos (dois JPGs/sidecars de referência e dez sidecars de capturas históricas), todos preservados. README/relatório M3-E, final da fase, Aren, espada, dano, HUD, câmera, DISPLAY01 e testes inspecionados. Sem AGENTS.md encontrado no projeto/pais consultados. Manifesto inicial em `C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\m4a\baseline.json`.

M4-A acrescenta uma sala de arena, controlador do encontro, Guardião original, um padrão de ataque, HP/HUD, vitória e reset. Não contém segunda fase do chefe, padrões adicionais, rewards, cinematic final ou M4-B.

## 2. Planejamento de design

O antigo protetor da Catedral é um cavaleiro amaldiçoado de armadura nervurada, elmo fendido turquesa, ombreira-relicário assimétrica, manto vinho e espada cerimonial larga. Aproximadamente 66 px de altura visual, contra 36 px de Aren: presença maior sem ocupar toda a tela. A luta inicial ensina observar antecipação, saltar/recuar e punir a recuperação. Não há aleatoriedade, homing durante o golpe, dano por mero contato corporal ou múltiplas fases.

A imagem fornecida pelo responsável orienta imponência, silhueta, arma e atmosfera gótica. Não foi copiada nem seus pixels reutilizados. Folha original 1264×1244, RGBA, gerada com image_gen integrado e copiada para `assets/art/m4a/guardian_poses.png`. Quatro poses: idle, antecipação, ataque e recuperação. Prompt integral, método e limitações em `assets/art/m4a/PROVENANCE.md`. Não se afirma animação final extensa ou pintura manual pixel a pixel. O runtime usa apenas assets do projeto.

## 3. Arena e integração de baixo risco

O percurso M3, seus 19 sólidos, seis inimigos, três perigos, dois checkpoints e marcador de fim em X=2288 permanecem intactos. Em vez de apertar o chefe no trecho ocupado pelos encontros finais, um selo ao fundo do Portão dá acesso a um vestíbulo da própria Catedral, na mesma cena principal e mundo físico. Não é segunda fase do jogo nem troca de cena/save.

| Elemento | Coordenadas lógicas |
|---|---|
| Trigger no Portão | centro (2344,138), área 24×36; contato do corpo inicia aproximadamente em X=2326 |
| Origem da sala nova | (2560,0) |
| Piso | X local 0–320, topo Y=156; paredes externas em −16–0 e 320–336 |
| Entrada de Aren | local (48,156), global (2608,156) |
| Guardião | local (236,156), global (2796,156) |
| Câmera fixa própria | local (160,90), campo 320×180 |
| Retorno após vitória | fase original (2296,156) |

A sala é criada sob demanda. O Main recebe somente o adaptador GuardianEncounter; cenas/scripts homologados da fase não foram reescritos. A entrada é caminhada real pelo trigger. O piso inteiro suporta esquivas e saltos, sem espinhos ou outros inimigos adicionais. A câmera mostra a arena completa; não muda zoom ou limites da câmera M3. Fundos/materiais aprovados da Catedral são reutilizados, com revestimento em pequenas peças para evitar esticamento. Somente o chefe tem nova arte raster.

## 4. Fluxo, travamento e resets

Ao entrar: HP de Aren é preservado, inimigos/perigos da exploração pausam, aviso de exploração fica oculto e a barra do boss aparece. A HUD de vida original continua ligada ao mesmo sinal M2. A ordem visual de Aren é ajustada temporariamente para não ficar atrás do fundo da sala. A câmera própria assume e o portão físico esquerdo fecha. Aren pode mover-se durante a intro; não há bloqueio de controles ou cura automática.

Ao derrotar: a fonte de dano desativa, receiver deixa de aceitar golpes, HP chega a zero e a HUD indica vitória. O portão abre e um selo luminoso aparece à esquerda. Caminhar até X local menor que 22 retorna à fase, restaurando câmera, ordem visual, avisos e processamento de inimigos/perigos. A vitória é somente estado da sessão, sem recompensa/save; revisitar mostra o chefe vencido. F8/F5 permite um playtest completamente novo.

Na morte durante a sala, as conexões M2 existentes executam o respawn e restauração dos seis inimigos/perigos. O adaptador restaura a exploração e reseta o Guardião para uma nova tentativa. Usa-se o checkpoint já ativo (CP2 testado), com HP cheio conforme M2. Não há checkpoint específico do boss.

Queda viva conserva a regra M3: início original (48,156), sem recuperar HP e sem esquecer o checkpoint. O adaptador apenas encerra o modo arena/restaura a câmera. A entrada diferida também revalida se Aren está vivo, evitando iniciar uma intro após morte no mesmo intervalo do trigger.

## 5. Máquina de estados e ataque inicial

| Estado | Comportamento |
|---|---|
| IDLE | Dormência antes do encontro; breve idle após despertar. |
| INTRO | 0,90 s, apresentação e imunidade do boss. |
| WAKE | 0,35 s, ativação visível e imunidade. |
| PURSUIT | Aproximação a 34 px/s; limites locais 28–292; inicia aviso ao chegar a 80 px. |
| TELEGRAPH | 0,80 s; pose carregada e marca âmbar; direção fica comprometida, sem dano. |
| ATTACK | 0,18 s; espada pesada em segmento descendente, uma entrega de dano M2 por golpe. |
| PUNISH | 1,10 s sem ataque: janela para aproximação e espada de Aren. |
| HURT | 0,16 s quando atingido fora de um golpe comprometido; retoma o estado/tempo anterior. |
| DEFEATED | Zero HP, sem fonte ativa, portão liberado, retorno disponível. |
| RESET | Desativa fonte, restaura origem/vida/receiver e volta ao idle. |

HP exportado/configurável, padrão 10. Cada golpe M1 válido remove 1 HP. O boss fica imune apenas em intro/wake/reset/derrota; acertos durante aviso/ataque contam, mas não cancelam o movimento comprometido, evitando um loop de cancelamento por spam. O flash dá feedback mesmo nesses estados. Não há segunda fase em HP baixo.

A lâmina usa os mesmos pontos no desenho e na fonte física: hilt (15,−38), ponta (75,−12), espessura 10, comprimento aproximado 65,39. Retângulo físico rotacionado, espelhado pela direção, contra a hurtbox M2. O dano é 1; proteção de Aren é a original. Um contato protegido também consome a entrega do golpe; não há multi-hit no mesmo swing. Consulta de mundo impede dano através de paredes. A espada horizontal de Aren não foi alterada.

O salto original, iniciado nos últimos 0,30 s da antecipação, atravessou fisicamente toda a janela ativa sem dano no teste. Recuar também é favorecido pela antecipação de 0,8 s. Existe um ponto próximo ao corpo, sob a alavanca da espada, explorável neste protótipo; uma vitória real por golpes M1 consecutivos foi demonstrada ali, sem congelar o boss, curar ou reposicionar durante o duelo. Isso comprova a base jogável, não balanceamento final da luta. Não foi adicionado dano corporal ou outro padrão para compensar esse ponto.

## 6. Preservação e arquivos

Comparação SHA-256 com o início confirma todos os arquivos preexistentes iguais, exceto `scenes/main.tscn` e a seção nova de README. Inclui controle/física de Aren, vida, espada, IA, geometria/cena da fase, HUD, câmera, configuração DISPLAY01, imagens originais e testes anteriores. Cenas e parâmetros homologados não foram sobrescritos.

Novos arquivos: `scenes/boss/guardian.tscn`, `guardian_arena.tscn`; seis scripts em `scripts/boss/` e seus UIDs (guardian, guardian_attack, guardian_visual, encounter, arena_visual, boss_hud); PNG/sidecar/proveniência em `assets/art/m4a/`; `tests/boss_test.gd`/UID e este relatório. O corpo do boss usa layer 9 (256) com máscara World; receiver M1 usa layer 4 (8), fonte M2 layer 6 (32). Aren conserva suas máscaras. A instância fria observada no teste de coesão ficou em 163 nós, mantendo o limite anterior de menos de 200 durante exploração.

## 7. Testes executados

Importação e inicialização gráfica por 60 quadros retornaram 0. Suíte regressiva inteira reexecutada, sem remoção/enfraquecimento de testes:

| Suíte | Aprovadas | Falhas | Método |
|---|---:|---:|---|
| smoke | 14 | 0 | Headless/física |
| combat | 36 | 0 | Headless/física |
| survival | 59 | 0 | Headless/física |
| cemetery | 52 | 0 | Headless/física |
| reachability | 35 | 0 | Headless/física |
| skeleton | 49 | 0 | Headless/física |
| raven | 63 | 0 | Headless/física |
| distribution | 115 | 0 | Headless/física |
| mechanisms | 77 | 0 | Headless/física |
| art | 18 | 0 | Gráfico |
| presentation | 10 | 0 | Gráfico |
| raster_art | 8 | 0 | Gráfico |
| horizontal_attack | 46 | 0 | Gráfico |
| cohesion | 14 | 0 | Gráfico |
| display | 38 | 0 | Gráfico |
| integration | 101 | 0 | Headless/física |
| **Regressão anterior** | **735** | **0** | Reexecutada |
| M4-A — física | 59 | 0 | Headless; repetida em renderização |
| M4-A — salvamento das capturas | 9 | 0 | Gráfico 4K |
| **Total distinto** | **803** | **0** | Repetições não somadas |

A execução gráfica final passou 68/68 (59 físicas/funcionais repetidas + 9 de captura). Headless final passou 59/59. As nove capturas confirmam gravação de PNG, não qualidade estética. Resultados preliminares anteriores ao acabamento da sala não são somados. O teste gráfico foi repetido após corrigir a amostragem do piso e indicar o selo de saída.

Cobertura nova: carregamento sob demanda, chegada por entrada física, preservação do marcador M3, intro/wake/idle, perseguição real e limites, telegraph/attack/punish/hurt, gate físico, HUD ligada ao HP, salto de esquiva, dano único, acerto real M1, vitória com boss ativo, abertura e saída, restauro da câmera/HUD/processamento, CP2, morte/retry, queda viva e rejeição de entrada com Aren morto. Fixtures posicionam Aren para cada cenário; o salto, contatos, duelo e caminhada de entrada/saída usam a física real. Não se apresenta fixture como playtest humano completo desde o começo da fase.

A regressão mantém 120 tentativas físicas de salto, navegação ida/volta e 101 integrações M3-E. Fonte de verdade: `results.json`, logs por suíte e `boss_test.json` dos grupos finais, em `C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\m4a`. Os comandos completos estão no JSON; forma de repetição:

```powershell
# Usar o executável Godot 4.7.2 instalado; log e evidências devem apontar para pasta existente.
$env:CINZAS_M4A_EVIDENCE = '<pasta_externa>'
godot --headless --path . --fixed-fps 60 --script res://tests/boss_test.gd --log-file <log>
$env:CINZAS_M4A_4K = '1'
godot --path . --fixed-fps 60 --script res://tests/boss_test.gd --log-file <log>
```

`godot` representa `C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`. Sem variável de evidências, o teste usa `.godot/m4a`, ignorado. Os exemplos usam placeholders a substituir. As nove suítes físicas anteriores usam headless; art/presentation/raster/horizontal/cohesion/display usam GPU. `--fixed-fps 60` dá determinismo funcional, não mede 60 FPS reais; não houve benchmark prolongado do boss nesta entrega.

## 8. Inspeção e evidências

Capturas finais persistentes: `C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\m4a\native4k-complete`. Galeria `index.html`, nove PNGs nativos **3840×2160** com cabeçalhos conferidos: cathedral_portal, intro, idle, telegraph, attack_evaded, punish, hurt, duel e defeated. Não houve ampliação artificial nem foto/captura certificada da saída física da TCL. A imagem gerada foi usada como sprite, não como screenshot de jogo.

Inspecionadas vistas da antecipação e do ataque com Aren saltando. A composição conserva a Catedral e diferencia a silhueta maior do Guardião, arma e barra. A primeira textura de piso estava excessivamente esticada; foi substituída por repetição do material aprovado no cenário novo. O mesmo acabamento indicou a saída após vitória, e os testes gráficos foram repetidos. Nenhuma arte M3 foi refeita. Fluidez percebida, preferência estética e legibilidade na distância habitual da TCL continuam pendentes do responsável.

## 9. Diagnósticos e limitações

Persistem os diagnósticos de certificados Windows e escrita bloqueada de editor_settings no perfil durante importação. Importação, startup, regressões e testes finais encerraram 0, sem erros de script/parsing nos logs finais. Não foram modificados certificados, permissões, configurações Windows/TV ou drivers.

Este é um protótipo de um padrão: quatro poses base, sem ciclo final de caminhada, som/música exclusivos, segunda fase, recompensas, cinematic final ou persistência de vitória. O equilíbrio do ponto próximo ao corpo e o custo de repetir o percurso desde CP2 precisam de playtest; não se ajustaram os parâmetros de Aren para disfarçar problemas. O acesso por selo/vestíbulo é uma escolha explícita para preservar o mapa homologado; não há travessia contínua da parede direita original. Câmera dedicada e troca de sala precisam de avaliação humana além das asserções.

## 10. Como jogar e checklist manual

Pare a execução antiga (F8) e inicie com F5 na Godot 4.7.2. Percorra a primeira fase e continue à direita do marcador final até o **Selo do Guardião**, no Portão da Catedral. O contato inicia a sala. A/D ou setas movem; Espaço/W/cima saltam; J usa a mesma espada. Observe o aviso, salte/recue e aproveite a recuperação. Após vencer, caminhe ao selo esquerdo para voltar. Se morrer, use o checkpoint já ativado; F8/F5 reinicia a sessão para novo playtest completo.

Preencher PASSOU / FALHOU / NÃO TESTADO. Todos pendentes; homologações M3 anteriores continuam registradas, sem homologar M4-A por inferência.

| Nº | Verificação | Resultado |
|---|---|---|
| 1 | Acesso à arena pelo selo ao final da Catedral | NÃO TESTADO |
| 2 | Apresentação curta do chefe | NÃO TESTADO |
| 3 | Barra de vida visível e atualizada | NÃO TESTADO |
| 4 | Aparência original do Guardião | NÃO TESTADO |
| 5 | Movimentação/posicionamento do chefe | NÃO TESTADO |
| 6 | Telegrafia clara e direção comprometida | NÃO TESTADO |
| 7 | Ataque pesado legível | NÃO TESTADO |
| 8 | Esquiva possível com os movimentos originais | NÃO TESTADO |
| 9 | Dano no boss com J | NÃO TESTADO |
| 10 | Reação do boss ao dano | NÃO TESTADO |
| 11 | Derrota funcional e saída pelo selo esquerdo | NÃO TESTADO |
| 12 | Câmera da arena e retorno à câmera da fase | NÃO TESTADO |
| 13 | HUD base preservada | NÃO TESTADO |
| 14 | Física, salto, espada e vida de Aren preservados | NÃO TESTADO |
| 15 | Estabilidade em mortes e novas tentativas | NÃO TESTADO |
| 16 | Integração com a Catedral e percurso anterior | NÃO TESTADO |
| 17 | Qualidade visual e proporção em tela cheia | NÃO TESTADO |
| 18 | Ausência de bugs graves | NÃO TESTADO |

## 11. Git final e encerramento

Branch main, HEAD `35cc465308d884f826f91eb3586e652b73f2d19a`, índice vazio. Dois rastreados modificados (README/main), 20 novos arquivos M4-A e 14 arquivos locais preexistentes preservados (referências/sidecars históricos). Nenhum cache, captura ou log adicionado ao índice. `.gitignore` preservado; verificações de referências/UIDs e whitespace realizadas no encerramento.

**Sem git add, commit, push, tag, exportação ou publicação. M4-B não iniciado. Aguardar playtest e homologação manual do responsável.**
