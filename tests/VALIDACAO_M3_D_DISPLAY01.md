## Homologação registrada — 03/11/2026

**M3-D — HOMOLOGADO FUNCIONAL E VISUALMENTE PELO RESPONSÁVEL.**
Abrange M3-D, FIX01, FIX02, FIX03 e DISPLAY01. Aprovação expressamente informada:

> Agora sim, a imagem está boa. E tudo funcionando normal. Essa é a resolução que o jogo deve ter.

Foram aprovados Aren, movimentação/salto/dano, ataque horizontal e integração
corpo/espada, arte dos seis setores, fundos, HUD, nitidez, funcionamento na TCL
4K e preservação da jogabilidade. É homologação geral recebida do responsável;
não significa preenchimento individual de todos os checklists históricos.
Os resultados automatizados anteriores (último total: 634/634), diagnósticos e
limitações abaixo são preservados como histórico, sem alegar nova execução.

Baseline PC mantido: referência lógica 320×180, janela 960×540, canvas_items,
aspecto keep/16:9, escala inteira, Linear em fundos/terreno e Nearest em atores
/HUD. Adapta-se à janela/tela; não está fixado exclusivamente em 4K.

Referências JPG do usuário e seus sidecars continuam locais, sem staging, pois
não são recursos runtime. Originais gerados e proveniência são versionados.
Seleção das capturas históricas do cache preservada em `tests/evidencias/m3d/`;
evidências detalhadas de DISPLAY01 permanecem no diretório persistente indicado
no seu relatório. Nenhum cache inteiro é incluído.

Este registro antecede o único commit local M3-D. M3-E será iniciado somente
após sua validação. Nenhum push autorizado; M4 permanece não iniciado.

## Histórico técnico da implementação (preservado)

# M3-D-DISPLAY01 — Renderização nítida PC

**M3-D-DISPLAY01 — IMPLEMENTADO, PENDENTE DE PLAYTEST E HOMOLOGAÇÃO MANUAL.**

03/11/2026. **APTA PARA PLAYTEST MANUAL NA TCL 4K.** A homologação artística anterior foi informada pelo responsável; esta alteração de apresentação ainda precisa de avaliação humana.

## 1. Baseline e documentos

Pasta C:\PROJETOS\CINZAS DO JURAMENTO, main, HEAD `3af31c31da5f693dfef10db0f709d2e76a674c34`, mensagem `feat(m3-c): homologa armadilhas e checkpoints`. Inicial: 13 rastreados modificados, 53 novos acumulados, índice vazio. Arte local e auditoria preservadas. Não houve limpeza, troca de branch ou consulta/publicação remota.

Consultados README, auditoria de resolução, relatórios M3-D/FIX01/FIX02/FIX03, projeto, visuais, câmera e testes. Utilizadas as evidências anteriores sem repetir a investigação Windows. Na auditoria foram medidos sinal 4K/60 Hz, escala Windows 200% e RTX 2060 SUPER. Não se declara nova medição desses parâmetros nesta entrega.

## 2. Configuração efetivamente aplicada

| Item | Antes | DISPLAY01 |
|---|---|---|
| display/window/stretch/mode | viewport | canvas_items |
| display/window/stretch/aspect | keep default | keep explícito |
| Referência lógica | 320×180 | 320×180 |
| Janela inicial | 960×540 | 960×540 |
| Stretch scale / scale_mode | 1 / integer | 1 / integer |
| Modo inicial | Janela | Janela |
| Filtro padrão | Nearest | Nearest |
| Backdrop e GroundSkin | Nearest herdado | Linear no Backdrop, herdado pelo GroundSkin |
| Atores, props e HUD | Nearest | Nearest |
| Snap transforms / vertices | true / false | true / false |

Alterações de produção limitadas a `project.godot` e duas linhas no `_ready` de `scripts/levels/cemetery_visual.gd` (comentário e filtro). Os outros filhos do Backdrop são apenas composição visual; atores, perigos e HUD ficam em ramos separados. Nenhuma textura, importação, animação ou coordenada foi alterada. Não foram criados controle de fullscreen, menu ou sistema novo. Os modos da engine continuam disponíveis ao host/editor/sistema de janelas, com teste externo temporário. O modo de abertura permanece janela.

Linear evita amostragem excessivamente dura dos fundos detalhados; Nearest preserva os contornos dos sprites. Mipmaps e compressão permanecem como estavam, sem necessidade demonstrada de modificá-los. A referência lógica evita mudança involuntária de zoom, área visível ou proporções.

## 3. Preservação verificada

Manifesto SHA-256 anterior em `C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\display01\baseline.json`. Somente três arquivos preexistentes mudaram: project.godot, cemetery_visual.gd e README. Todos os demais hashes iniciais permaneceram iguais, incluindo física, câmera, combate, vida, seis inimigos, perigos, checkpoints, cenas, geometria, assets, testes e históricos.

Novos no projeto: `tests/display_test.gd`, seu `.uid` gerado pela Godot e este relatório. README recebeu seção nova, preservando integralmente o conteúdo antigo. Auditoria e relatórios anteriores não foram reescritos.

## 4. Resoluções, câmera e HUD

O novo teste executou a cena atual sem override de modo de renderização. Validou configuração efetiva, referência, janela inicial, filtros, carga dos seis fundos e isolamento do filtro em relação a atores/HUD.

| Destino | Raster nativo novo | Escala lógica | Campo lógico |
|---|---|---|---|
| HD | 1280×720 | 4× | 320×180 |
| Full HD | 1920×1080 | 6× | 320×180 |
| QHD | 2560×1440 | 8× | 320×180 |
| 4K | 3840×2160 | 12× | 320×180 |

Em cada tamanho: readback com dimensões corretas, escala uniforme X/Y, câmera/zoom preservados, snapshots de colisões/transforms idênticos e PNG salvo. Para comparar integridade estrutural, a cena foi pausada após estabilizar a posição; esses snapshots não são teste de animação. Animações, espada, dano, inimigos e HUD dinâmicos são cobertos separadamente pelas suítes existentes.

Nada mudou na lógica arredondada de câmera/parallax. O tamanho relativo de Aren, o alcance da espada, a área visível e o layout da HUD permanecem no mesmo espaço lógico. Os testes de apresentação verificam textos, setor, tutorial e avisos dos checkpoints; fontes renderizadas no destino ficaram mais definidas nas capturas.

## 5. Regressão executada

Executável Godot 4.7.2 stable oficial ed1daf0bf, Compatibility/OpenGL, RTX 2060 SUPER.

| Suíte | Aprovadas | Falhas |
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
| DISPLAY01 | 38 | 0 |
| **Total** | **634** | **0** |

As 596 verificações antigas foram reexecutadas sem alteração. Nove suítes funcionais usam headless; cinco visuais usam renderização gráfica. DISPLAY01 usa GPU real. Todos encerraram com código 0. Não confundir os testes headless com qualidade física de TV. `--fixed-fps 60` foi usado para determinismo nestes testes, não para medir FPS.

Cobertura herdada: acerto único, direita/esquerda, alcance/paredes, golpes reais em Esqueleto e Corvo após mergulho, oito poses de ataque, salto/dano, cancelamento, queda/morte/respawn, perigos, CP1/CP2 e ida/volta pelos seis setores. Navegabilidade mantém 120 tentativas físicas de salto. Distribuição usa fixture histórica B3; mechanisms cobre a cena corrente com perigos. Essas aprovações funcionais não equivalem a julgamento estético humano ou ausência de dano em toda abordagem.

Importação da cópia de comparação e inicialização por 60 quadros concluíram com código 0. Diagnósticos conhecidos: certificados Windows e gravação de editor_settings no perfil bloqueada durante importação; nenhuma mudança de certificado, permissões, Windows ou TV. Logs preservados. Não foram identificadas falhas de asserção ou parsing nas execuções finais.

## 6. Comparações e desempenho

Antes/depois foram executados na cópia do estado atual completo, incluindo arte não commitada. Antes: override runtime viewport e Nearest; depois: canvas_items com Linear no Backdrop e Nearest nos atores/HUD, reproduzindo a configuração aplicada. A cópia permanece fora da árvore principal. Cenários comparados no mesmo ponto lógico; inimigos/ambiente podem estar em fases diferentes. Não se declara identidade pixel a pixel entre capturas animadas.

Cada configuração de desempenho: duas caminhadas de cerca de 2 segundos, 30 frames de aquecimento, VSync e teto 60 FPS, sem fixed-fps nem readback durante a coleta. Processos novos por resolução evitam resíduos de transições observados na auditoria. Métricas de process_frame são intervalos de apresentação no PC, não tempo GPU puro.

| Caso | FPS médio | p95 pior ms | Texturas máx. MiB |
|---|---:|---:|---:|
| fresh_canvas_items_1280x720_nearest_integer | 59.99 | 17.61 | 73.3 |
| fresh_canvas_items_1920x1080_nearest_integer | 60.00 | 17.17 | 82.8 |
| fresh_canvas_items_2560x1440_nearest_integer | 60.00 | 17.27 | 95.1 |
| fresh_canvas_items_3840x2160_nearest_integer | 59.99 | 17.79 | 133.3 |
| fresh_viewport_1920x1080_nearest_integer | 59.99 | 17.62 | 66.7 |
| fresh_viewport_3840x2160_nearest_integer | 59.98 | 17.67 | 66.7 |

O contador de texturas Godot aproxima alocações do renderer; não é VRAM total nem utilização percentual da GPU. O teto de 60 FPS limita a inferência de margem de hardware. Não foi medida latência física ou carregamento frio comparativo. As travessias contínuas foram verificadas funcionalmente; não houve benchmark prolongado de sessão/streaming. Nenhum ganho universal de performance é alegado.

## 7. Tela cheia e movimento

Testados janela, maximizada, Fullscreen=3 e Exclusive Fullscreen=4 nos modos antigo/novo. Logs/JSON guardam área cliente e transform, sem alterar modo inicial do projeto. Em Windows a janela com moldura deste ensaio ficou 1894×1009 (moldura ativada após redimensionar); maximizada 3840×2035. Com escala inteira o conteúdo ocupa 1600×900 e 3520×1980, com margens. Ambos fullscreen chegaram a 3840×2160, escala 12×. Não se conclui superioridade universal do exclusivo. O driver/engine também pode informar modo 4 ao dimensionar janela sem bordas para ocupar a tela toda; não interpretar esse ensaio como janela normal 4K.

Movimento: séries de 36 amostras com marcador diagnóstico, mais readbacks reais de salto e dano; o overlay não entra na produção. Centro/tamanho do marcador constam em motion.json. Readbacks custosos afetam os ticks entre amostras e não medem suavidade física da tela. Mantido o arredondamento lógico da câmera; ausência perceptiva de jitter, shimmering/parallax e conforto em sessão longa continua pendente de playtest. Não houve tentativa de suavizar a física/câmera para mascarar quantização.

## 8. Evidência visual e avaliação

Diretório persistente, fora de `.godot` e do Git:

`C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\display01\evidencias`

Abrir `comparacao.html`: pares Full HD/4K com Jardim, Catacumbas, Ponte, Catedral e ataque; HD/QHD com Jardim; modos de janela; salto/dano; detalhes de Portões em repouso, CP1/CP2 e golpe à esquerda. Cada registro tem posição de câmera, campo lógico, resolução efetiva e método. `details.json` guarda os oito detalhes antes/depois. Há também quatro PNGs nativos do teste principal em `C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\display01`.

Antes: `_rt.png` nativo 320×180; `_output_sim.png` é composição GPU ampliada explicitamente simulada, não detalhe nativo 4K. Depois: `_rt.png` com pixels rasterizados diretamente no destino. Dimensões conferidas no cabeçalho PNG. Capturas são readbacks do framebuffer; não são fotografia nem captura certificada da saída física TCL. O comparador pode ajustar a exibição no navegador, sem modificar PNGs.

Observação visual: maior detalhe nos fundos, Aren e letras em Full HD e 4K; espada e plataformas mais definidas, sem deformação de enquadramento. Aren conserva Nearest e não recebeu borramento Linear. O fundo recebe suavização localizada; isso não certifica a preferência do responsável. Os assets usam recortes/escalas próprias e não se promete que cada texel de origem tenha largura inteira idêntica. A escala lógica permanece uniforme. Inimigos e perigos mantêm formas/contornos funcionais, sujeitos à avaliação de contraste em movimento. A melhora estática é convincente para disponibilizar playtest, sem antecipar homologação.

## 9. Checklist manual TCL

Preencher PASSOU / FALHOU / NÃO TESTADO. Todos os resultados abaixo estão pendentes do responsável. Testar fora da prévia incorporada do editor; fullscreen embutido pode ter limitações. Não alterar menus da TV automaticamente.

| Item | Verificação | Resultado |
|---|---|---|
| 1 | Windows/sinal 3840×2160/60 Hz | NÃO TESTADO |
| 2 | Inicialização correta | NÃO TESTADO |
| 3 | Janela normal | NÃO TESTADO |
| 4 | Fullscreen em execução separada | NÃO TESTADO |
| 5 | Ausência de deformações/cortes | NÃO TESTADO |
| 6 | Fundos mais nítidos | NÃO TESTADO |
| 7 | Aren bem definido | NÃO TESTADO |
| 8 | Ataque horizontal nos dois sentidos | NÃO TESTADO |
| 9 | HUD/HP/setor/tutorial legíveis | NÃO TESTADO |
| 10 | Plataformas legíveis | NÃO TESTADO |
| 11 | Seis inimigos visíveis | NÃO TESTADO |
| 12 | Três armadilhas visíveis | NÃO TESTADO |
| 13 | Câmera fluida nas transições | NÃO TESTADO |
| 14 | Ausência de jitter/shimmering perceptível | NÃO TESTADO |
| 15 | Ausência de engasgos em sessão prolongada | NÃO TESTADO |
| 16 | Movimentação e saltos preservados | NÃO TESTADO |
| 17 | Combate/acertos em Esqueleto e Corvo preservados | NÃO TESTADO |
| 18 | Dois checkpoints e morte/respawn preservados | NÃO TESTADO |
| 19 | Ida/volta, Catacumbas e Ponte navegáveis | NÃO TESTADO |
| 20 | Qualidade visual superior ao estado anterior | NÃO TESTADO |

Se houver falha, informar setor/posição, resolução, modo de janela e estado de Aren. Comparar distância habitual de uso, transições e sessão de alguns minutos; conferir overscan, nitidez artificial, interpolação e modo jogo manualmente antes de atribuir todo artefato à engine.

## 10. Git e encerramento

Branch main e HEAD preservados; índice vazio. Estado agregado: 14 rastreados modificados e 56 novos acumulados, incluindo trabalhos artísticos anteriores. Esta tarefa modificou somente os três arquivos preexistentes listados e acrescentou teste, UID e relatório. `git diff --check` verificado ao encerrar; avisos de normalização LF/CRLF são distinguíveis de falhas de whitespace.

**Sem git add, commit, push, publicação, exportação ou alteração de histórico. M3-E e M4 não iniciados. Aguardar playtest na TCL e autorização de versionamento.**
