# Auditoria técnica — resolução e apresentação PC

Data: 03/11/2026. Godot 4.7.2 stable oficial, Windows, Compatibility/OpenGL.
Escopo: diagnóstico, cópia experimental e recomendação. A aprovação visual/funcional de M3-D/FIX01/FIX02/FIX03 foi informada pelo responsável nesta solicitação; os relatórios históricos permanecem intactos.

## 1. Conclusão e natureza da evidência

**A resolução interna atual é 320×180. 960×540 é o tamanho inicial da janela (3×).** A ampliação para 4K aumenta cada pixel lógico para 12×12; não recupera o detalhe descartado na primeira rasterização. Isso explica a perda percebida mesmo com assets detalhados. Não foi identificado motivo para redesenhar a arte aprovada.

A recomendação para implementação futura é preservar o espaço lógico 320×180 e experimentar como configuração final `canvas_items`, mantendo enquadramento, física e HUD. Os readbacks nativos deste modo mostraram mais detalhe em Aren, fundos, inimigos e fontes. Nearest nos atores e Linear somente nos fundos/materiais é uma candidata, sujeita ao playtest na TCL. A recomendação NÃO foi aplicada ao projeto principal.

**Medido:** propriedades efetivas, sinal Windows, readbacks PNG, intervalos de frames e regressões. **Observado:** avaliação visual dos readbacks. **Simulado:** composição GPU da imagem 320×180 para comparar apresentação ampliada; arquivos `_output_sim` não são detalhe nativo 4K. **Não confirmado:** processamento interno da TCL, tearing, latência física e preferência visual humana durante movimento prolongado.

## 2. Git e preservação

Pasta confirmada: `C:\PROJETOS\CINZAS DO JURAMENTO`, branch `main`, HEAD `3af31c31da5f693dfef10db0f709d2e76a674c34`. Inicial: 13 rastreados modificados e 52 não rastreados acumulados; índice vazio. Um commit à frente da referência local origin/main; não houve consulta ou publicação remota. Nenhum AGENTS.md encontrado no projeto/pais na inspeção.

Cópia de 151 arquivos atuais, incluindo recursos não commitados, criada fora do repositório. Todos os 151 SHA-256 foram conferidos novamente e permaneceram iguais. `project.godot`, README, arte, física, câmera, combate, testes e documentos anteriores foram preservados. A única inclusão principal desta auditoria é este relatório: estado esperado final 13 modificados e 53 novos, índice vazio. Não houve add, commit, push, exportação, alteração de branch nem início de M3-E/M4.

## 3. Windows, tela e sinal

Consultas somente leitura via QueryDisplayConfig/DisplayConfigGetDeviceInfo, EnumDisplayMonitors, GetScaleFactorForMonitor e EDID no Registro. WMI/CIM não permitiu acesso; a medição alternativa funcionou.

| Item | Resultado |
|---|---|
| Tela ativa | Uma, `Smart TV Pro`, identificador EDID `XXX8000` |
| Modelo exato TCL/75 polegadas | Informado pelo responsável; identidade comercial exata não confirmada pela identificação genérica |
| Desktop físico e sinal ativo HDMI | **3840×2160, 60 Hz**, progressivo |
| EDID, primeiro timing detalhado | 3840×2160; clock 594 MHz |
| Cor informada pela API | RGB, 8 bits/canal; flags Advanced Color=1 (suporte presente, habilitação ausente) |
| Godot HDR solicitado | false; não equivale à leitura do menu da TV |
| Escala Windows | **200%**, consulta retornou sucesso |
| Chamador sem consciência de DPI | Métricas lógicas 1920×1080, área útil 1920×1040 |
| Godot consciente de DPI | Tela 3840×2160, área útil 3840×2080, DPI 192 |
| GPU realmente usada | NVIDIA GeForce RTX 2060 SUPER, OpenGL 3.3, driver informado 621.01 |

A diferença de métricas lógicas não significa que a TV receba Full HD. O sinal ativo foi confirmado em 4K. Não foi demonstrado redimensionamento adicional da imagem pela GPU/TV; source e target têm a mesma resolução. Escala Windows 200% não prova borramento no jogo: a Godot consultou dimensões físicas. Consultas inicial/final estão nas evidências. Nenhuma configuração Windows/TV/driver foi alterada.

Referências dos métodos: [QueryDisplayConfig](https://learn.microsoft.com/en-us/windows/desktop/api/winuser/nf-winuser-querydisplayconfig) e [escala por monitor](https://learn.microsoft.com/en-us/windows/win32/api/shellscalingapi/nf-shellscalingapi-getscalefactorformonitor).

## 4. Propriedades reais da Godot

| Propriedade ProjectSettings | Efetivo |
|---|---|
| display/window/size/viewport_width / viewport_height | 320 / 180 |
| display/window/size/window_width_override / window_height_override | 960 / 540 |
| display/window/size/mode | 0, janela |
| display/window/size/min_width / min_height | 320 / 180 |
| display/window/size/resizable / borderless | true / false |
| display/window/stretch/mode / aspect | viewport / keep |
| display/window/stretch/scale / scale_mode | 1.0 / integer |
| display/window/dpi/allow_hidpi | true |
| display/window/vsync/vsync_mode | 1, habilitado |
| display/window/hdr/request_hdr_output | false |
| rendering/textures/canvas_textures/default_texture_filter | 0, Nearest |
| rendering/2d/snap/snap_2d_transforms_to_pixel | true |
| rendering/2d/snap/snap_2d_vertices_to_pixel | false |

Alguns valores são defaults efetivos, ausentes do texto de project.godot; foram consultados na engine instalada. A janela inicial tem root.size=960×540, root.content_scale_size=320×180, root.content_scale_mode=2 (VIEWPORT), screen_transform=3×, stretch_transform identidade e readback de imagem **320×180**.

Experimentos usaram somente propriedades runtime da cópia: `Window.content_scale_mode` (CANVAS_ITEMS=1/VIEWPORT=2), `content_scale_size`, `content_scale_aspect` KEEP=1, `content_scale_factor`=1, `content_scale_stretch` INTEGER=1/FRACTIONAL=0, `Window.mode`, `size` e filtros por CanvasItem. Não persistiram ProjectSettings.

Câmera: `scripts/levels/forgotten_cemetery.gd`, `_update_presentation`, arredonda posição lógica, limita X 160–2208 e Y 90–154; zoom 1. Fundos calculam vista fixa 320×180. Não há SubViewport na produção; o diagnóstico criou um apenas para compor as simulações identificadas. HUD usa dois CanvasLayers e coordenadas lógicas, fontes desenhadas em tamanho 8. Oversampling de fontes habilitado. O mesmo retângulo visível 320×180 permaneceu nos dois modos.

**Cuidado de medição:** em canvas_items, `ViewportTexture.get_size()` relatou tamanhos multiplicados pelo oversampling (por exemplo 11520×6480 para a janela 1920×1080). O `get_image()` e o cabeçalho PNG mediram 1920×1080. O relatório usa a imagem efetiva, não interpreta esse retorno de textura como renderização 12K.

## 5. Editor incorporado e execução separada

A indicação 960×540 pode ser o tamanho solicitado do jogo mostrado pelo editor; não identifica o detalhe interno. O perfil local contém `run/window_placement/game_embed_mode=0`; isso é um override global e não prova sozinho o modo atualmente ativo. A janela de depuração disponível estava minimizada; a sessão original não foi manipulada.

O editor pode apresentar o jogo em tamanho fixo, ajustar proporção ou esticar a prévia. A documentação registra limitações de fullscreen no modo incorporado. Portanto a decisão deve ser validada em janela separada. Os experimentos abriram a cópia diretamente pela engine, sem o editor incorporado; não foi produzido executável exportado. `embed_subwindows=true` refere-se a subjanelas do jogo e não comprova embedding no editor. [Documentação oficial de embedding](https://docs.godotengine.org/en/4.7/tutorials/editor/game_embedding.html).

## 6. Comparação de resoluções e filtros

| Destino de renderização | Escala sobre 960×540 | Escala lógica real | A: readback | B: readback |
|---|---|---|---|---|
| 1280×720 | 1,333× | 4× | 320×180 | 1280×720 |
| 1920×1080 | 2× | 6× | 320×180 | 1920×1080 |
| 2560×1440 | 2,667× | 8× | 320×180 | 2560×1440 |
| 3840×2160 | 4× | 12× | 320×180 | 3840×2160 |

São ensaios de renderização no PC conectado à tela 4K, não medições de quatro monitores físicos. Todos são múltiplos inteiros da grade verdadeira e preservam 16:9. Nenhum aumento da área visível, mudança de tamanho relativo de Aren ou reposicionamento de HUD foi observado nos readbacks comparados.

A usa a imagem já rasterizada em baixa resolução; pixels regulares e custo menor, mas detalhes pequenos de fontes, armadura, caveiras, vitrais e alvenaria se perdem. B rasteriza os desenhos na resolução de destino, preservando mais informações dos arquivos atuais. O ganho é real nos PNGs; não aumenta a resolução original de cada asset. [Explicação oficial dos modos](https://docs.godotengine.org/en/4.7/tutorials/rendering/multiple_resolutions.html).

Fundos originais principais: 1774×887; materiais 1254×1254; atores/props 1448×1086; Aren e ataque 1774×887, com recortes. Importação lossless, mipmaps desligados, size_limit=0. Nenhuma compressão destrutiva nova foi introduzida. Mipmaps não foram ensaiados; não há evidência para recomendá-los globalmente.

| Critério | A viewport | B canvas_items |
|---|---|---|
| Fundo e materiais | Detalhe limitado pela grade | Mais detalhe e separação de planos |
| Aren/inimigos | Silhuetas legíveis; detalhes colapsam | Armadura, rosto e penas mais legíveis |
| Perigos | Colisões iguais; representação mais grosseira | Serra/espinhos com mais detalhe; exige avaliação humana de contraste |
| HUD | Posições corretas, fonte pixelizada | Mesmas posições, fonte mais definida |
| Nearest global | Grade consistente | Contornos nítidos; texels dos assets podem ter larguras distintas |
| Linear global | Suaviza antes de perder detalhe na grade | Suaviza também Aren; menos indicado para preservar contornos |
| Filtro misto | Não supera gargalo 320×180 | Fundos mais suaves, atores/HUD preservam Nearest |
| Movimento | Quantização lógica visível ampliada | Mesma câmera arredondada; não promete rolagem subpixel |
| Full HD/QHD/4K | Compatíveis; ganho apenas de tamanho | Compatíveis nos destinos ensaiados; custo de framebuffer cresce |

Teste adicional 1366×768: escala inteira 4×, conteúdo 1280×720 e margens geométricas 43 px horizontais/24 verticais. Fracionária produziu conteúdo 1365×768 e arredondamento de cerca de um pixel; pode gerar texels desiguais. Nos ensaios iniciais houve divergência entre Window/root e DisplayServer após transições de tamanho para 4K: o último reteve modo 4 e tamanho 3840×2160, embora o render target seguisse a resolução solicitada. Por isso esses dados são classificados como comparação de destinos de renderização, e os `_output_sim` dessa sequência não comprovam composição física correta em todos os tamanhos. Repetições em processos novos ficam identificadas `fresh_*`, sem substituir silenciosamente os logs iniciais.

## 7. Modos de janela

Os dois modos gráficos produziram os seguintes resultados de área cliente e escala inteira:

| Modo solicitado | Área cliente observada | Escala/conteúdo | Observação |
|---|---|---|---|
| Janela com moldura | 1894×1009 | 5×, 1600×900 | Moldura ativada depois do tamanho; não interpretar como janela Full HD exata |
| Maximizada | 3840×2035 | 11×, 3520×1980 | Área útil/moldura; margens |
| Fullscreen, modo 3 | 3840×2160 | 12×, tela toda | Sem redução de uma linha nesta execução |
| Exclusive Fullscreen, modo 4 | 3840×2160 | 12×, tela toda | Não melhorou detalhe nem FPS de forma relevante |

Em canvas_items o readback contém a área de conteúdo, podendo excluir margens da janela. Barras e uso total da tela acima foram derivados das dimensões/transforms; não são fotografia da TCL. Os FPS médios de cada grupo ficaram próximos de 60, com p95 máximo de 17,68 ms. Recomenda-se fullscreen comum como primeira opção futura, exclusivo opcional após validação de troca de foco e comportamento em outros PCs. Tearing e latência de entrada não foram medidos fisicamente; VSync habilitado não prova ausência deles.

## 8. Movimento, câmera e regressão

Ensaios reais acionaram movimento, salto, ataque horizontal e dano na cópia. Não existe comando separado de sprint para auditar. Readbacks de ataque e salto/dano foram guardados. A regressão percorreu os seis setores nos dois sentidos, incluiu 120 tentativas físicas de salto por perfil, inimigos, perigos, checkpoints, espada, estados visuais e câmera.

Diagnóstico de movimento: 36 amostras por modo com marcador magenta de um pixel lógico preso ao personagem. Centro raster observado constante: A (159,110), 1 pixel; B (1919,5;1331,5), 144 pixels (12×12). Isso sustenta estabilidade relativa nesse trecho, não certifica toda a arte. Readbacks custosos alteram o número de ticks entre amostras: as duas séries não representam a mesma duração nem servem para comparar velocidade/FPS. O fundo/câmera continuam quantizados em unidades lógicas; shimmering, partículas, rolagem longa e conforto na TV exigem observação humana. Nenhum sistema foi reescrito.

| Suíte | Baseline | B 4K misto |
|---|---:|---:|
| smoke | 14 | 14 |
| combat | 36 | 36 |
| survival | 59 | 59 |
| cemetery | 52 | 52 |
| reachability | 35 | 35 |
| skeleton | 49 | 49 |
| raven | 63 | 63 |
| distribution | 115 | 115 |
| mechanisms | 77 | 77 |
| art | 18 | 18 |
| presentation | 10 | 10 |
| raster_art | 8 | 8 |
| horizontal_attack | 46 | 46 |
| cohesion | 14 | 14 |
| **Total** | **596/596** | **596/596** |

Todas as 28 execuções retornaram código 0. Testes existentes não foram alterados nem enfraquecidos. Wrappers externos configuraram a janela antes de executar os mesmos métodos. Baseline: nove suítes headless e cinco gráficas. B: todas gráficas em canvas_items com destino 4K e fundos Linear. Verificações que leem ProjectSettings continuam verificando o arquivo preservado; não devem ser confundidas com prova isolada do filtro runtime. As regressões usam `--fixed-fps 60` para determinismo; seus tempos NÃO são benchmark de FPS. Rotas contínuas foram aprovadas funcionalmente, sem alegar uma medição de performance de longa duração nelas.

Importação inicial da cópia e inicializações completaram. Logs registram falha de leitura do repositório de certificados e bloqueio de escrita de editor_settings no perfil; não foram corrigidos por alteração de permissões ou certificados. Não houve falha de asserção associada a esses diagnósticos.

## 9. Desempenho disponível

Matriz inicial: 12 configurações, duas repetições de aproximadamente 2 s de caminhada cada, 30 frames de aquecimento, VSync e limite de 60 FPS, sem `--fixed-fps`, sem readbacks durante a amostragem. Uma GPU/processo por vez. Métricas são intervalos entre process_frame, não tempo exclusivo da GPU. Memória de textura é contador aproximado Godot, não VRAM total do processo. A sequência de transições teve a ressalva de modo nativo descrita acima; não atribuir causalidade a diferenças centesimais entre resoluções.

| Configuração | FPS médio | p95 pior (ms) | Máximo (ms) | Texturas máx. MiB |
|---|---:|---:|---:|---:|
| viewport_1280x720_nearest | 60.00 | 17.11 | 17.75 | 66.7 |
| viewport_1920x1080_nearest | 60.00 | 17.48 | 17.77 | 66.7 |
| viewport_2560x1440_nearest | 59.99 | 17.61 | 18.03 | 66.7 |
| viewport_3840x2160_nearest | 60.01 | 17.42 | 17.80 | 66.7 |
| canvas_items_1280x720_nearest | 59.99 | 17.29 | 17.72 | 73.5 |
| canvas_items_1920x1080_nearest | 60.00 | 17.48 | 18.52 | 83.1 |
| canvas_items_2560x1440_nearest | 60.00 | 17.51 | 18.59 | 95.4 |
| canvas_items_3840x2160_nearest | 60.02 | 17.58 | 18.62 | 133.5 |
| viewport_3840x2160_mixed | 59.98 | 17.66 | 18.35 | 66.7 |
| canvas_items_3840x2160_mixed | 59.99 | 17.48 | 18.16 | 133.5 |
| viewport_3840x2160_linear | 60.01 | 17.59 | 18.46 | 66.7 |
| canvas_items_3840x2160_linear | 60.00 | 17.32 | 17.59 | 133.5 |

Memória estática Godot: aproximadamente 35–39,4 MiB; não representa working set/RAM total. Instanciação inicial da cena na matriz: 862,899 ms, uma amostra com caches potencialmente aquecidos, sem comparação de carregamento frio entre modos. O teto de 60 FPS esconde margem máxima da GPU; não se conclui desempenho equivalente em hardware mais fraco. 4K B aumenta o contador de texturas de cerca de 66,7 para 133,5 MiB. Os trechos curtos não registraram engasgos longos, mas não certificam sessão prolongada, input lag ou fluidez física na TCL.

## 10. Evidências e reprodução

Diretório persistente fora de caches e do repositório:

`C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\auditoria_resolucao_pc\evidencias`

Arquivos centrais: `windows_display_inicial.json`, `windows_display_final.json`, `godot_probe.json`, `godot_probe_canvas.json`, `matrix.json`, `window_modes.json`, `motion.json`, `regression.json`, logs correspondentes e `fresh_*` das repetições isoladas. Scripts e comandos de diagnóstico estão na pasta irmã `projeto_experimental/diagnostics` e `ferramentas`; manifestos ficam na raiz da auditoria.

Capturas principais: prefixos `canvas_items_1920x1080_nearest` e `canvas_items_3840x2160_nearest`, sufixos `_garden_rt.png`, `_crypt_rt.png`, `_bridge_rt.png`, `_cathedral_rt.png`, `_attack_rt.png`. Incluem HUD e cenas aprovadas, sem modificar assets. Os correspondentes `viewport_*_rt.png` são 320×180; `_output_sim.png` são composição ampliada explicitamente simulada. Filtros: `*_3840x2160_mixed_*` e `*_linear_*`. Fullscreen: `windowmode_*_3_*` e exclusivo `*_4_*`. Dimensões efetivas constam nos JSON e cabeçalhos PNG.

As tentativas de captura da saída de janela retornaram imagens pretas (`probe_janela.png` e `probe_canvas_janela.png`); são falhas de captura, excluídas da avaliação visual. As evidências úteis são readbacks do render target da engine. Não são fotografia nem captura certificada da saída real da TV.

## 11. Recomendação para implementação futura

1. Manter **320×180 como espaço lógico** para preservar câmera, geometria, enquadramento e regras já aprovadas. 960×540 pode continuar como tamanho inicial da janela. Aumentar a base para 960×540 sem adaptar câmera/layout alteraria a área visível e é inadequado como ajuste isolado.
2. Preferir `canvas_items` com escala 1, aspecto keep e escala inteira como candidata principal. Usar destino nativo da área cliente: Full HD/6×, QHD/8× e 4K/12×. Não elevar artificialmente a resolução dos PNGs.
3. Manter Nearest em personagens, inimigos e elementos pixel art. Avaliar Linear nos fundos e materiais, separadamente, com foco em bordas e movimento. O filtro misto é recomendação visual provisória; requer escolha do responsável.
4. HUD permaneceu alinhada e legível; não precisa de escala independente para corrigir este problema. Acessibilidade/tamanho à distância pode justificar opção futura, sem mudar agora o layout aprovado.
5. Fullscreen comum primeiro, exclusivo opcional; janela/maximizada também disponíveis. Validar fora do editor. VSync habilitado inicialmente, sem prometer latência ideal.
6. Planejar futuramente menu simples com modo de janela, resolução de renderização/qualidade, VSync e escala de UI se necessária. Não foi implementado menu, sistema híbrido ou configuração C complexa: B mostrou ganho sem exigir arquitetura adicional.
7. Manter constantes entre monitores: física, câmera lógica, hitboxes, aspecto, tamanho relativo dos atores e regras. Variar somente apresentação, com fallback 1080p em máquinas que não sustentem 4K.

Implementação futura deve ocorrer somente após análise/autorização do responsável, repetir regressões e comparar movimento prolongado na TCL. Exportação standalone permanece uma validação futura; esta auditoria usou o binário da engine executando a cópia.

## 12. Checklist manual da TCL — pendente

- [ ] Confirmar no menu de informação da TV entrada 3840×2160/60 Hz e modelo exato.
- [ ] Conferir proporção 1:1/Just Scan e overscan, sem cortes nos cantos/HUD.
- [ ] Conferir Modo Jogo/entrada PC, nitidez artificial, redução de ruído e interpolação de movimento; registrar valores antes de qualquer ajuste humano.
- [ ] Conferir correspondência de HDR e formato de cor entre PC/TV. Não inferir estado do painel pelas flags Windows.
- [ ] Comparar A/B e filtros na distância habitual: Aren, fontes, folhas, grades, alvenaria, inimigos e sinais dos perigos.
- [ ] Caminhar/saltar/atacar/receber dano, percorrer seis setores ida/volta por pelo menos alguns minutos; observar cintilação, partículas e rolagem.
- [ ] Comparar fullscreen comum/exclusivo, troca de foco, margens, tearing percebido e resposta dos controles.
- [ ] Aprovar configuração e filtro antes de implementação definitiva.

Nenhum item deste checklist foi declarado homologado automaticamente. O projeto principal conserva integralmente a implementação artística aprovada. Esta entrega acrescenta somente documentação e mantém M3-E/M4 não iniciados.

## 13. Confirmação em processos independentes e encerramento

Repetidos os 16 casos em processos novos: oito combinações de resolução/modo Nearest, quatro combinações 4K com filtros misto/Linear e quatro controles 1366×768. Todos terminaram com código 0. As 12 configurações de desempenho tiveram duas amostras novas cada. Nos destinos 720p/1080p/QHD e 1366×768, root e DisplayServer concordaram com janela e tamanho pedidos. Ao dimensionar a janela sem bordas para cobrir 4K, ambos passaram a informar modo 4 nesta instalação; não se presume janela comum nesse caso. Assim a divergência residual da sequência inicial não invalida os novos ensaios independentes.

| Caso independente | FPS médio | p95 pior ms |
|---|---:|---:|
| fresh_canvas_items_1280x720_nearest_integer | 59.98 | 17.51 |
| fresh_canvas_items_1920x1080_nearest_integer | 60.00 | 17.65 |
| fresh_canvas_items_2560x1440_nearest_integer | 60.02 | 17.47 |
| fresh_canvas_items_3840x2160_linear_integer | 60.01 | 17.16 |
| fresh_canvas_items_3840x2160_mixed_integer | 59.99 | 17.25 |
| fresh_canvas_items_3840x2160_nearest_integer | 59.99 | 17.50 |
| fresh_viewport_1280x720_nearest_integer | 59.98 | 17.32 |
| fresh_viewport_1920x1080_nearest_integer | 60.00 | 17.49 |
| fresh_viewport_2560x1440_nearest_integer | 60.00 | 17.66 |
| fresh_viewport_3840x2160_linear_integer | 59.98 | 17.69 |
| fresh_viewport_3840x2160_mixed_integer | 59.99 | 17.46 |
| fresh_viewport_3840x2160_nearest_integer | 59.99 | 17.49 |

Comparador visual local: `C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\auditoria_resolucao_pc\evidencias\comparacao.html`. Contém links para os PNGs, rótulos de método e dimensões verificadas pelos cabeçalhos. A exibição ajustada pelo navegador não altera os arquivos.

Consulta final do Windows idêntica à inicial: sinal, escala, cor e áreas de tela preservados. Git final confirmado: main, mesmo HEAD, 13 rastreados modificados e 53 novos (o único novo desta tarefa é este relatório), índice vazio. `git diff --check` retornou 0; avisos de normalização LF/CRLF se referem a arquivos preexistentes preservados. As 151 assinaturas iniciais permaneceram iguais. Nenhum commit ou push foi criado.
