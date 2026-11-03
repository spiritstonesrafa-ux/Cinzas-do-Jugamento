# Registro de homologação e auditoria final M3-E

**M3-E — HOMOLOGADO FUNCIONALMENTE PELO RESPONSÁVEL.**

**Playtest manual: 20/20 PASSOU — Nenhuma observação.**

**Testes automatizados anteriores: 735/735 PASSOU.**

Registro: 03/11/2026. O responsável informou o playtest final da primeira fase
com os 20 itens abaixo aprovados, sem falhas ou observações. Trata-se da
homologação recebida do responsável, distinta dos testes automatizados e da
sessão gráfica anterior do agente. Não se afirma preenchimento dos 24 itens
do checklist histórico, que permanece intacto abaixo.

| Nº | Item efetivamente informado | Resultado do responsável |
|---|---|---|
| 1 | Movimentação | PASSOU |
| 2 | Salto | PASSOU |
| 3 | Espada horizontal | PASSOU |
| 4 | Dano e invulnerabilidade | PASSOU |
| 5 | Esqueletos | PASSOU |
| 6 | Corvos | PASSOU |
| 7 | Armadilhas | PASSOU |
| 8 | Combate final | PASSOU |
| 9 | Checkpoint 1 | PASSOU |
| 10 | Checkpoint 2 | PASSOU |
| 11 | Morte | PASSOU |
| 12 | Queda viva | PASSOU |
| 13 | Restauração | PASSOU |
| 14 | Percurso completo | PASSOU |
| 15 | Cenários | PASSOU |
| 16 | Câmera e HUD | PASSOU |
| 17 | Tela cheia 4K | PASSOU |
| 18 | Fluidez prolongada | PASSOU |
| 19 | Transições | PASSOU |
| 20 | Estabilidade geral | PASSOU |

## Auditoria documental e Git desta tarefa

Repositório confirmado exatamente em `C:\PROJETOS\CINZAS DO JURAMENTO`, main,
HEAD inicial `369de2168d798b8e27a92ce406f4cbe666b8207d`, commit M3-D de 77
arquivos, com histórico anterior preservado. Estado inicial: README modificado,
três novos arquivos M3-E (este relatório, integration_test.gd e seu UID), dez
sidecars de capturas e quatro arquivos preexistentes de referência. Índice vazio.
Estado real correspondeu ao baseline; nenhuma alteração inesperada foi encontrada.

Lidos README, relatório completo e teste de integração/UID; diff rastreado e
conteúdo dos novos arquivos examinados. Auditadas referências estáticas res://,
UIDs únicos dos scripts e existência dos recursos referidos. Teste e UID
`uid://dhuhycwdmnr66` preservados byte a byte. DISPLAY01, cenas, assets, scripts
de produção e testes anteriores permanecem inalterados. `.gitignore` preservado.
Nenhuma credencial identificada nos arquivos selecionados. `git fsck
--no-dangling` e verificações de whitespace concluíram sem falhas. Os avisos de
normalização LF/CRLF não representam falha de whitespace nem mudança funcional.

Esta etapa não reexecutou a engine ou a suíte: somente a documentação mudou.
Os 735 resultados, navegação, resets/checkpoints, diagnósticos de certificados e
escrita no perfil, medições e limitações anteriores foram preservados integralmente.
A sessão anterior de 231,087 segundos, seus JSONs e oito PNGs nativos 3840×2160
foram conferidos no diretório persistente externo indicado no histórico.
Não foram criadas métricas novas nem declarada captura física independente da TCL.

## Decisão por metadado gerado

Os dez arquivos abaixo são sidecars `.png.import` de capturas documentais M3-D,
não arquivos `.uid` de scripts e não caches `.ctex`. As imagens-fonte existem e
já são versionadas como evidência; nenhuma cena/script de produção referencia
seus caminhos ou UIDs. A engine pode regenerar os sidecars para importá-las,
mas esses UIDs não são necessários para reproduzir o jogo ou executar os testes.
Por isso todos ficam **fora do staging**, preservados no disco. Nenhuma opção de
importação foi alterada. A decisão não se aplica aos `.png.import` dos assets
runtime, já versionados e preservados.

| Caminho exato | Classificação / decisão |
|---|---|
| `tests/evidencias/m3d/fix03-after-sector1.png.import` | Sidecar de captura; sem dependência runtime; excluir do staging, preservar local. |
| `tests/evidencias/m3d/fix03-after-sector2.png.import` | Sidecar de captura; sem dependência runtime; excluir do staging, preservar local. |
| `tests/evidencias/m3d/fix03-after-sector3.png.import` | Sidecar de captura; sem dependência runtime; excluir do staging, preservar local. |
| `tests/evidencias/m3d/fix03-after-sector4.png.import` | Sidecar de captura; sem dependência runtime; excluir do staging, preservar local. |
| `tests/evidencias/m3d/fix03-after-sector5.png.import` | Sidecar de captura; sem dependência runtime; excluir do staging, preservar local. |
| `tests/evidencias/m3d/fix03-after-sector6.png.import` | Sidecar de captura; sem dependência runtime; excluir do staging, preservar local. |
| `tests/evidencias/m3d/fix03-attack--1-8.png.import` | Sidecar de captura; sem dependência runtime; excluir do staging, preservar local. |
| `tests/evidencias/m3d/fix03-attack-1-8.png.import` | Sidecar de captura; sem dependência runtime; excluir do staging, preservar local. |
| `tests/evidencias/m3d/fix03-detail-cp1-active.png.import` | Sidecar de captura; sem dependência runtime; excluir do staging, preservar local. |
| `tests/evidencias/m3d/fix03-detail-cp2-active.png.import` | Sidecar de captura; sem dependência runtime; excluir do staging, preservar local. |

Outros arquivos locais excluídos, preservados como referências fornecidas pelo
responsável, sem uso dos pixels pelo jogo:

- `The Art of the Pixel.jpg`
- `The Art of the Pixel.jpg.import`
- `The Siege and the Sandfox _ Le metroidvania en 2D de Cardboard Sword et PLAION sortira le 20 mai sur PC.jpg`
- `The Siege and the Sandfox _ Le metroidvania en 2D de Cardboard Sword et PLAION sortira le 20 mai sur PC.jpg.import`

`.godot/` permanece ignorado: caches de importação/editor e diagnósticos locais
históricos; nenhum conteúdo desse diretório integra o commit. Não houve exclusão
ou limpeza de arquivos. O arquivo-fonte do teste e seu `.gd.uid` são necessários
para a entrega e integram o staging.

## Seleção do único commit autorizado

Somente quatro arquivos: `README.md`, `tests/VALIDACAO_M3_E.md`,
`tests/integration_test.gd` e `tests/integration_test.gd.uid`.
Mensagem: `test(m3-e): homologa regressao final da primeira fase`.
Autor local Rafael <spiritstonesrafa@gmail.com>, main, sem alterar autoria/configuração.
O diff staged completo é revisado antes do commit. Após o registro, o índice
fica vazio; os 14 arquivos locais enumerados acima permanecem não rastreados.
Remoto/configuração não são alterados; não há push, tag, release ou exportação.
**M4 permanece não iniciado. Encerrar após o único commit local M3-E.**

## Histórico técnico anterior — conteúdo integral preservado

# M3-E — Regressão Final e Polimento da Primeira Fase

**M3-E — IMPLEMENTADO E VALIDADO TECNICAMENTE, PENDENTE DE PLAYTEST MANUAL E HOMOLOGAÇÃO.**

Data: 03/11/2026. Primeira fase: O Cemitério dos Esquecidos. Escopo encerrado sem M4.

## 1. Fase A concluída antes do M3-E

Homologação geral M3-D/FIX01/FIX02/FIX03/DISPLAY01 registrada em README e nos cinco relatórios. Aprovação expressa do responsável: “Agora sim, a imagem está boa. E tudo funcionando normal. Essa é a resolução que o jogo deve ter.” Não se presumiu preenchimento individual dos checklists anteriores.

Commit único: `369de2168d798b8e27a92ce406f4cbe666b8207d`. Mensagem: `feat(m3-d): homologa arte animacoes e renderizacao para pc`. Branch main. Autor e committer: Rafael <spiritstonesrafa@gmail.com>. Pai: `3af31c31da5f693dfef10db0f709d2e76a674c34`. Exatamente um commit desde o baseline. Inventário completo de **77 arquivos** no apêndice.

Auditoria A: repositório correto, diff acumulado e staged revisados; referências estáticas res:// resolvidas, UIDs de scripts únicos, PNGs/importações/proveniência preservados, DISPLAY01 mantido. Maior asset: 3.141.289 bytes, sem arquivo próximo ao limite do Git. Caches, credenciais, exportações e quatro arquivos de referência JPG/sidecars fora do staging. `.gitignore` preservado. Dez evidências históricas FIX03 copiadas sem edição de `.godot` para `tests/evidencias/m3d/` (320×180, anteriores ao DISPLAY01). Evidências nativas DISPLAY01 já estavam em diretório persistente externo, documentado no relatório respectivo.

Inicialização A por 60 quadros retornou 0. O resultado 634/634 citado no registro de homologação era histórico; a reexecução completa desta tarefa ocorreu na fase B, abaixo. Três linhas vazias finais em proveniência/ground_skin foram removidas para passar o diff staged sem mudar conteúdo funcional. `git fsck --no-dangling` retornou 0; a consulta inicial sem esse filtro listou árvores órfãs, sem erro de integridade. Commit validado, índice vazio e somente quatro referências locais não rastreadas antes de começar B. Sem push.

## 2. Auditoria estrutural e preservação

Revisados cena principal, 19 sólidos, seis setores, controlador, espada, sobrevivência, hurtbox, sinais de respawn, checkpoints progressivos, IA, perigos, câmera, apresentação e recursos. O nível continua ligando inimigos ao jogador, vida à HUD e restauração de inimigos/perigos à morte e à queda. Não há dependência de imagens do perfil do agente em runtime.

Todos os **162 arquivos rastreados** após A foram inventariados. Durante B, nenhum código/cena/asset/configuração de produção foi modificado. A única edição rastreada do M3-E é a seção documental nova no README. Scripts de teste anteriores e seus UIDs permaneceram byte a byte iguais. Não houve mudança mecânica, de dificuldade, física, câmera, arte ou balanceamento.

Configuração preservada: canvas_items, referência 320×180, janela inicial 960×540, aspecto keep, escala inteira, snapping de transforms, Nearest em atores/HUD e Linear no Backdrop/terreno. Full HD, QHD e 4K continuam sendo destinos de apresentação, não mudanças do mundo lógico. A janela inicial não foi trocada por fullscreen; a sessão gráfica do teste solicita fullscreen apenas no seu processo.

## 3. Revisão funcional

| Grupo | Verificação e evidência |
|---|---|
| Aren | M0/M2 e FIX03 cobrem os dois sentidos, salto, coyote time, jump buffer, queda, oito poses de ataque, dano, proteção, morte/respawn e controle após reaparecer. Parâmetros 100 / 680 / −230 preservados. |
| Espada | M1/FIX03 cobrem acerto único, ciclos consecutivos, chão/ar, paredes, alcance, direção travada, oito poses nos dois lados e acertos reais em Esqueleto/Corvo após mergulho. |
| Inimigos | B1/B2/B3 cobrem patrulha, alerta, ataque, esquiva, contra-ataque, mortes, restauração e o encontro combinado. Distribuição 0/1/1/1/1/2 por setor mantida. |
| Perigos | M3-C cobre dano 1, proteção, geometria, avisos/ciclos, ausência de duplicação, passagens físicas sem dano em ambos os sentidos e reset após morte/queda. |
| Checkpoints | Contato, progressão CP1→CP2 sem regressão, segurança, recuperação após morte, fallback de marcador inseguro e queda viva mantendo checkpoint/HP. |
| Navegação | M3-A, 120 tentativas físicas de saltos, B3 e cena M3-C mais oito percursos encadeados novos, sem teleportar no interior de cada percurso. Catacumbas/Ponte/Catedral e volta verificados. |
| Gráficos | Arte/FIX01/02/03/DISPLAY01 cobrem recursos, transparência, recortes, fontes/avisos/setores, registro da espada, invariância de colisões, câmera e dimensões nativas de HD a 4K. |

Essas verificações não certificam conforto humano ou ausência de dano em toda estratégia. B3 usa fixture histórica; mechanisms e a suíte nova usam a cena corrente com perigos.

## 4. Implementação de testes M3-E

Novos `tests/integration_test.gd` e `.uid`. A suíte herda os helpers de M3-C e usa um navegador de entrada adaptado para percursos parciais com sequência explícita de setores. **101 asserções**: configuração/FOV/estrutura; cinco mortes em cada checkpoint; HP, apoio, fonte de ataque, hitbox, HUD e segurança entre resets; exatamente dez mortes/dez respawns; queda viva sem cura e restauro dos perigos; oito percursos após CP1, CP2, queda e derrota de inimigos, incluindo sequências de setores, descida real e limites inteiros da câmera.

Reposicionamentos são usados somente para montar cenários de morte/queda/checkpoint. Dentro de cada perna, movimento, saltos, espada, dano e aterrissagens são físicos, via Input e controlador original, sem cura/reset/retry para esconder falha. A preparação de inimigos derrotados chama receive_hit diretamente; é fixture de estado, não prova de acerto de espada. Os acertos reais são comprovados nas suítes específicas já reexecutadas.

## 5. Defeitos e correções

**Nenhum defeito de produção comprovado exigiu alteração.** O polimento desta entrega consiste em ampliar a cobertura de integração e documentar estabilidade/pontos pendentes, sem refatorar sistemas funcionais.

Durante a construção da suíte nova ocorreram erros de indentação e atribuição de Array tipado, corrigidos no próprio teste. A primeira estratégia automática após CP1 podia ultrapassar o Esqueleto e continuar golpeando na direção original enquanto aguardava a lâmina, perdendo HP até morrer. Logs de posição/HP/direção demonstraram falha do navegador de teste, não alteração do combate. A estratégia final olha a posição real do inimigo antes de cada golpe e caminha pelos degraus descendentes do CP1, preservando os mesmos critérios de sobrevivência, sequência e aterrissagem. Nenhum teste antigo foi alterado ou enfraquecido. Logs preliminares permanecem externos, separados dos finais.

## 6. Regressão realmente reexecutada

| Suíte | Aprovadas | Falhas | Método |
|---|---:|---:|---|
| smoke | 14 | 0 | Físico/headless |
| combat | 36 | 0 | Físico/headless |
| survival | 59 | 0 | Físico/headless |
| cemetery | 52 | 0 | Físico/headless |
| reachability | 35 | 0 | Físico/headless |
| skeleton | 49 | 0 | Físico/headless |
| raven | 63 | 0 | Físico/headless |
| distribution | 115 | 0 | Físico/headless |
| mechanisms | 77 | 0 | Físico/headless |
| art | 18 | 0 | Gráfico |
| presentation | 10 | 0 | Gráfico |
| raster_art | 8 | 0 | Gráfico |
| horizontal_attack | 46 | 0 | Gráfico |
| cohesion | 14 | 0 | Gráfico |
| DISPLAY01 | 38 | 0 | Gráfico, destinos HD/Full HD/QHD/4K |
| Integração M3-E | 101 | 0 | Física headless; repetida em gráfico 4K |
| **Total distinto** | **735** | **0** | Repetições não somadas |

Todas as execuções finais retornaram 0. A repetição gráfica aprova novamente as 101 condições, sem contar 101 testes diferentes a mais. Importação da árvore principal retornou 0; a sessão gráfica inicializou a mesma cena e concluiu. Renderer Compatibility/OpenGL 3.3, Godot 4.7.2 stable oficial ed1daf0bf, NVIDIA RTX 2060 SUPER.

Comando por suíte (o executável completo e argumentos estão em `regression.json`):

```powershell
$engine = 'C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
# smoke, combat, survival, cemetery, reachability, skeleton, raven, distribution, mechanisms:
& $engine --headless --path . --fixed-fps 60 --script res://tests/<nome>_test.gd --log-file <log_externo>
# art, presentation, raster_art, horizontal_attack, cohesion, display:
& $engine --path . --fixed-fps 60 --script res://tests/<nome>_test.gd --log-file <log_externo>
# Nova integração física:
& $engine --headless --path . --fixed-fps 60 --script res://tests/integration_test.gd --log-file <log_externo>
# Sessão gráfica real, SEM --fixed-fps:
$env:CINZAS_M3E_NATIVE = '1'
$env:CINZAS_M3E_EVIDENCE = '<diretorio_externo>'
& $engine --path . --script res://tests/integration_test.gd --log-file <log_externo>
```

CINZAS_DISPLAY_EVIDENCE direciona os quatro PNGs de display_test a uma pasta externa. Sem essas variáveis, os testes usam subpastas ignoradas de `.godot`. Os placeholders devem ser substituídos ao repetir. Cadência fixed-fps é determinismo funcional, não benchmark gráfico.

## 7. Navegabilidade observada

Oito pernas: saída do CP1 após morte até a Catedral e retorno ao começo; saída do CP2 após morte até a Catedral e retorno; ida/volta após queda viva com 4 HP; ida/volta após fixture de derrota dos seis inimigos. As duas primeiras idas começam nos setores 4 e 5, respectivamente; não se afirma que tenham visitado seis setores desde o checkpoint. As voltas e idas completas verificam a sequência inteira.

Logs LIVE ROUTE preservam o HP real. Na integração headless: CP1 ida 5→3 e volta 3→2; CP2 ida 5→5 e volta 5→4; pós-queda ida 4→3 e volta 3→2; derrotados ida 5→5 e volta 5→4. Danos das armadilhas podem ocorrer mesmo sem inimigos; não se promete travessia automática sem dano. Os testes M3-C de passagem sem dano por cada perigo foram aprovados separadamente. A repetição gráfica tem seus próprios valores no log, sem substituir números reais por resultados esperados.

## 8. Sessão gráfica prolongada e métricas

Condições reproduzíveis: cena atual, canvas_items aprovado, fullscreen runtime, área da janela **(3840, 2160)**, campo lógico **[P: (0.0, 0.0), S: (320.0, 180.0)]**, VSync e teto 60 FPS, entradas automáticas descritas acima, sem fixed-fps. Nenhuma outra execução gráfica de teste em paralelo.

| Medição | Resultado |
|---|---:|
| Duração de parede da sessão medida | 231.087 s |
| Intervalos de process_frame amostrados | 11551 |
| Tempo acumulado dos intervalos | 192.383 s |
| FPS observado agregado | 60.042 |
| p95 dos intervalos | 17.342 ms |
| Maior intervalo registrado | 19.476 ms |
| Carregamento/instanciação da cena, uma amostra | 777.027 ms |
| Memória estática Godot mín./máx. | 39.62 / 40.12 MiB |
| Memória estática primeira/última amostra | 39.62 / 40.12 MiB |
| Texturas mín./máx. | 133.29 / 133.29 MiB |
| Nós mín./máx. | 160 / 160 |
| Nós órfãos mín./máx. | 0 / 0 |

Contadores são do processo Godot, não RAM/VRAM total nem utilização percentual da GPU. O coletor guarda arrays que também consomem memória; cache de fonte/texturas pode crescer no primeiro uso. Não se diagnostica vazamento somente pela diferença de bytes. O campo sampled_seconds exclui o readback/salvamento de oito capturas (coleta interrompida nesses pontos), portanto wall_s é maior. As capturas ainda podem perturbar a cadência da simulação; não representam um benchmark livre de instrumentação. Não há separação quantitativa por combate/setor nem medição física de tearing, input lag ou carga fria de disco. O intervalo máximo registrado deve ser considerado no playtest, sem prometer ausência de engasgos em outros PCs. A sessão completou os percursos e asserções sem travamento; horas de uso e fluidez percebida na TCL continuam pendentes.

## 9. Evidências e inspeção

Diretório estável externo: `C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\m3e`. Logs por suíte e comandos em regression.json; display.log e quatro PNGs em display/; integração headless em headless/; gráfico em native4k/, com integration_metrics.json e index.html. Oito PNGs nativos **3840×2160** conferidos pelos cabeçalhos: seis setores no decorrer da navegação e CP1/CP2 ativos. Não houve upscale nem geração de arte nova. São readbacks da engine, não fotografias/captura certificada da saída física TCL. Full HD/QHD foram verificados na suíte DISPLAY01 reexecutada.

Inspeção visual pelo agente incluiu Catacumbas/CP1 e o primeiro encontro terrestre; recursos, layout e contornos aprovados permaneceram. As imagens de fronteira podem mostrar dois ambientes sobrepostos conforme a composição homologada. As novas capturas não documentam todos os instantes de um combate combinado ou cada pose de espada; os registros anteriores DISPLAY01/FIX03 continuam disponíveis e as suítes de combate/ataque foram reexecutadas. Julgamento estético final e movimento humano são distintos de asserções automáticas.

## 10. Diagnósticos e limitações

Persistem os diagnósticos conhecidos de certificados e escrita de editor_settings no perfil durante importação, sem mudança de permissões/certificados/driver/Windows/TV. Não houve falha crítica de recurso/script nos logs finais. A importação gerou dez sidecars `.png.import` para as evidências históricas recém-versionadas; ficam locais e sem staging. Não são novos recursos da jogabilidade. Os quatro arquivos JPG/sidecars do responsável continuam locais e preservados.

## 11. Checklist manual do responsável

Preencher PASSOU / FALHOU / NÃO TESTADO, com setor/posição/modo de janela e observação em falhas. A aprovação anterior pertence ao M3-D; não preenche automaticamente este checklist do M3-E.

| Nº | Critério | Resultado |
|---|---|---|
| 1 | Início seguro | NÃO TESTADO |
| 2 | Movimentação para os dois lados | NÃO TESTADO |
| 3 | Salto, coyote time e jump buffer | NÃO TESTADO |
| 4 | Ataque horizontal direito/esquerdo | NÃO TESTADO |
| 5 | Dano e invulnerabilidade | NÃO TESTADO |
| 6 | Primeiro Esqueleto | NÃO TESTADO |
| 7 | Primeiro Corvo | NÃO TESTADO |
| 8 | Combate nas Catacumbas | NÃO TESTADO |
| 9 | Espinhos fixos | NÃO TESTADO |
| 10 | Lâmina oscilante | NÃO TESTADO |
| 11 | Espinhos temporizados | NÃO TESTADO |
| 12 | Checkpoint 1 | NÃO TESTADO |
| 13 | Checkpoint 2 | NÃO TESTADO |
| 14 | Morte e respawn | NÃO TESTADO |
| 15 | Queda viva sem recuperação de HP | NÃO TESTADO |
| 16 | Restauração dos inimigos | NÃO TESTADO |
| 17 | Ponte das Almas | NÃO TESTADO |
| 18 | Encontro combinado final | NÃO TESTADO |
| 19 | Percurso completo de ida | NÃO TESTADO |
| 20 | Percurso completo de volta | NÃO TESTADO |
| 21 | Qualidade visual dos seis setores | NÃO TESTADO |
| 22 | Nitidez em tela cheia | NÃO TESTADO |
| 23 | Fluidez prolongada na TCL | NÃO TESTADO |
| 24 | Ausência de bugs ou bloqueios | NÃO TESTADO |

## 12. Inventário e Git final

M3-E: README atualizado; novos `tests/integration_test.gd`, `.uid` e `tests/VALIDACAO_M3_E.md`. Dez sidecars de importação das evidências históricas foram gerados pela engine e continuam locais. Nenhum código de produção foi editado. Demais arquivos rastreados conferidos por SHA-256 com o baseline pós-commit.

Branch main, HEAD `369de2168d798b8e27a92ce406f4cbe666b8207d`, índice vazio. Exatamente um commit M3-D nesta tarefa, nenhum commit M3-E, nenhum staging M3-E e nenhum push. Árvore contém README modificado, três novos arquivos M3-E, dez sidecars gerados e quatro referências preexistentes. `git diff --check` e inventário final conferidos no encerramento. M4, chefe, novas fases, inimigos ou sistemas não foram iniciados.

## Apêndice — inventário do único commit M3-D (77 arquivos)

```text
README.md
assets/art/fix02/PROVENANCE.md
assets/art/fix02/aren_poses.png
assets/art/fix02/aren_poses.png.import
assets/art/fix02/crypt_background.png
assets/art/fix02/crypt_background.png.import
assets/art/fix02/garden_background.png
assets/art/fix02/garden_background.png.import
assets/art/fix02/surface_materials.png
assets/art/fix02/surface_materials.png.import
assets/art/fix03/PROVENANCE.md
assets/art/fix03/actors_props.png
assets/art/fix03/actors_props.png.import
assets/art/fix03/aren_attack.png
assets/art/fix03/aren_attack.png.import
assets/art/fix03/bridge_background.png
assets/art/fix03/bridge_background.png.import
assets/art/fix03/cathedral_background.png
assets/art/fix03/cathedral_background.png.import
assets/art/fix03/gate_background.png
assets/art/fix03/gate_background.png.import
assets/art/fix03/graves_background.png
assets/art/fix03/graves_background.png.import
project.godot
scenes/ui/health_hud.tscn
scripts/art/aren_attack_art.gd
scripts/art/aren_attack_art.gd.uid
scripts/art/cemetery_sprite_art.gd
scripts/art/cemetery_sprite_art.gd.uid
scripts/art/ground_skin.gd
scripts/art/ground_skin.gd.uid
scripts/art/health_frame.gd
scripts/art/health_frame.gd.uid
scripts/art/pixel_canvas.gd
scripts/art/pixel_canvas.gd.uid
scripts/enemies/raven_visual.gd
scripts/enemies/skeleton_visual.gd
scripts/levels/cemetery_visual.gd
scripts/player/knight_visual.gd
scripts/player/sword_attack.gd
scripts/props/cemetery_checkpoint.gd
scripts/props/damage_source.gd
scripts/props/oscillating_blade.gd
scripts/props/respawn_checkpoint.gd
scripts/props/timed_spikes.gd
scripts/ui/cemetery_interface.gd
scripts/ui/cemetery_interface.gd.uid
scripts/ui/health_hud.gd
tests/AUDITORIA_RESOLUCAO_PC.md
tests/VALIDACAO_M3_D.md
tests/VALIDACAO_M3_D_DISPLAY01.md
tests/VALIDACAO_M3_D_FIX01.md
tests/VALIDACAO_M3_D_FIX02.md
tests/VALIDACAO_M3_D_FIX03.md
tests/art_test.gd
tests/art_test.gd.uid
tests/cohesion_test.gd
tests/cohesion_test.gd.uid
tests/display_test.gd
tests/display_test.gd.uid
tests/evidencias/m3d/README.md
tests/evidencias/m3d/fix03-after-sector1.png
tests/evidencias/m3d/fix03-after-sector2.png
tests/evidencias/m3d/fix03-after-sector3.png
tests/evidencias/m3d/fix03-after-sector4.png
tests/evidencias/m3d/fix03-after-sector5.png
tests/evidencias/m3d/fix03-after-sector6.png
tests/evidencias/m3d/fix03-attack--1-8.png
tests/evidencias/m3d/fix03-attack-1-8.png
tests/evidencias/m3d/fix03-detail-cp1-active.png
tests/evidencias/m3d/fix03-detail-cp2-active.png
tests/horizontal_attack_test.gd
tests/horizontal_attack_test.gd.uid
tests/presentation_test.gd
tests/presentation_test.gd.uid
tests/raster_art_test.gd
tests/raster_art_test.gd.uid
```
