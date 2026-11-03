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

# M3-D-FIX02 — Reorientação artística com referências

Data: 03/11/2026. Windows, Godot 4.7.2 stable.

**M3-D-FIX02 — IMPLEMENTADO, PENDENTE DE PLAYTEST MANUAL E HOMOLOGAÇÃO.**

Esta é uma amostra artística integrada ao jogo, concentrada no Jardim dos
Mortos, nas Catacumbas, em Aren e na HUD. Não foi recebida homologação manual
do M3-D, FIX01 ou FIX02. Testes e inspeção do agente são apresentados
separadamente do checklist do responsável. Relatórios históricos preservados.

## 1. Baseline e auditoria

- Repositório existente confirmado exatamente em
  `C:\PROJETOS\CINZAS DO JURAMENTO`; branch `main`.
- HEAD `3af31c31da5f693dfef10db0f709d2e76a674c34`, mensagem
  `feat(m3-c): homologa armadilhas e checkpoints`.
- No início: **13 rastreados modificados e 18 novos**, índice vazio. Os 18
  novos são os 14 do FIX01 e quatro arquivos das referências recém-fornecidas
  (dois JPGs e seus sidecars `.import`). Alterações locais preservadas.
- Referência local `origin/main` em
  `3695eb2b350837cc7622e025e2d05c350b3e2ffc`; `main` um commit à frente.
  Sem consulta de rede ou atualização do remoto nesta tarefa.
- Lidos README, `VALIDACAO_M3_D.md` e `VALIDACAO_M3_D_FIX01.md`; inspecionadas
  as referências e capturas disponíveis do jogo. Scripts visuais, HUD,
  materiais, cenas e contratos físicos revisados. Sem AGENTS.md encontrado
  na raiz/diretórios pais ou na busca do projeto.
- Cópia de segurança e hashes do estado inicial em
  `.godot/fix02-baseline/` e `fix02-baseline-manifest.json`, ignorados.

Não houve git init, troca de branch, descarte, rebase ou reescrita de histórico.

## 2. Referências e comparação crítica

Imagens fornecidas pelo usuário na raiz do projeto:

1. `The Art of the Pixel.jpg`.
2. `The Siege and the Sandfox _ Le metroidvania en 2D de Cardboard Sword et PLAION sortira le 20 mai sur PC.jpg`.

Ambas foram abertas e examinadas. São referências de qualidade/atmosfera,
sem extração, recorte ou carregamento dos seus pixels em cenas do jogo.
Arquivos e sidecars foram preservados, não apagados nem adicionados ao índice.

| Referências desejadas | FIX01 observado | Decisão do FIX02 |
|---|---|---|
| Árvores de contorno orgânico e massas de vegetação | Árvores/ciprestes definidos por poucas linhas e polígonos | Fundo original com troncos retorcidos, raízes e folhas agrupadas. |
| Pedra com erosão, planos e iluminação | Arcos e blocos repetidos com cores quase uniformes | Texturas de pedra/terra, juntas irregulares, relevos e desgaste. |
| Profundidade atmosférica por valores e sobreposição | Silhuetas sucessivas, mas pouco volume/material | Necrópole entre névoa e túneis com arcos recuados e luz localizada. |
| Personagem integrado e com silhueta própria | Armadura feita de retângulos, leitura muito esquemática | Folha original de oito poses, visor/capa e metal facetado. |
| Composição focal e contraste controlado | Muitos detalhes de peso semelhante | Monumento de luto/mausoléus no Jardim; abóbada/túnel e braseiro na cripta. |

Não se considera que acrescentar detalhes seja prova de atingir a qualidade
das referências. A mudança de técnica foi examinada em capturas comparáveis;
a equivalência estética e o nível esperado ainda são decisão do responsável.

## 3. Abordagem artística e produção dos recursos

O FIX01 era inteiramente desenhado por código. O FIX02 adota uma combinação:
**quatro PNGs originais gerados com a ferramenta integrada image_gen**, desenho
Godot para HUD/efeitos e a mesma estrutura funcional. Não houve CLI, chamada
de API com chave, download de assets comerciais ou cópia das referências.

Os prompts descrevem tema, paleta, materiais, composição, transparência e
restrições de originalidade; não fornecem as imagens anexadas como alvos de
edição. Prompts integrais e origem estão em `assets/art/fix02/PROVENANCE.md`.
Os originais gerados foram copiados para o projeto, sem dependência de arquivos
do perfil do agente em runtime.

| Arquivo em `assets/art/fix02/` | Uso |
|---|---|
| `garden_background.png` | Jardim: árvore orgânica, monumento sentado de luto, capelas abobadadas, grades e cidade funerária distante. |
| `crypt_background.png` | Interior: abóbadas maciças, colunas, ossários, túneis, raízes e pedra iluminada por braseiro. |
| `aren_poses.png` | Oito poses com alpha real, em folha 4×2. |
| `surface_materials.png` | Atlas 2×2 de terra/pedra musgosa e alvenaria úmida, com duas variações de cada material. |

Cada PNG possui `.png.import` próprio: compressão lossless, sem mipmaps.
Filtro nearest, snapping, resolução 320×180 e escala inteira do projeto
permanecem iguais. Os prompts pediram linguagem de pixel art; os PNGs foram
gerados em resolução maior e são amostrados na grade lógica pela Godot.
Não se afirma que sejam sprites pintados manualmente pixel a pixel.

## 4. Jardim dos Mortos

O painel substitui a composição geométrica no recorte: massas de árvores e
folhas cobre, monumento de luto, arquitetura com erosão/musgo, grades curvas,
mausoléus, horizonte de necrópole e névoa. O centro inferior é menos contrastado
que os atores; cinzas discretas continuam animadas em camada separada.

As plataformas do Jardim recebem textura de rocha/terra com raízes, recortada
estritamente nos sólidos anteriores. Topos claros continuam indicando contato
físico exato. Não foram adicionadas plataformas, paredes ou decoração sólida.
Há capturas tanto da área de combate quanto da vista do monumento em (876,116).

## 5. Catacumbas

O painel apresenta um interior sem céu: abóbadas, pedra irregular, colunas
esculpidas, nichos com ossos e túneis sucessivos. Luz âmbar lateral contrasta
com sombra azul/violeta, sem modulação sobre Aren ou inimigos. O revestimento
de teto/degraus/piso usa o atlas de pedra, respeitando todos os retângulos.

A lâmina e sua corrente continuam desenhadas sobre o fundo, mantendo raio,
curso e período; seus extremos foram capturados e examinados. O checkpoint
da descida permanece na posição homologada. Câmera e passagem sob o teto
não foram alteradas para acomodar a pintura.

## 6. Aren, HUD e props

- Aren usa oito regiões medidas no alpha da folha: repouso, três poses de
  corrida, salto, queda, reação a dano e variação de repouso/capa.
- Animação observa os mesmos estados e a direção homologada. Corrida conserva
  o ciclo visual de 11 Hz. Dano, morte por rotação e modulação continuam
  governados pelo M2; brilho de respawn preservado.
- O sprite tem altura visual de referência 36 px e ajuste horizontal cosmético
  para leitura. Corpo continua 12×24 e espada continua 22×14. Capa, crista e
  cabeça decorativas ultrapassam o corpo, como já ocorria no FIX01.
- O contraste do sprite foi aumentado após a primeira inspeção. Não se
  alteraram velocidade, salto, posição do jogador ou regras de dano.
- A espada é desenhada separadamente pelas mesmas fases do M1. Nenhuma
  alteração neste fix em alcance, hitbox, temporização ou código da espada.
- HUD recebe retrato derivado da nova folha, moldura de metal e cinco segmentos
  de rubi, preservando `VIDA n/5`, sinal de saúde, posição e tamanho do texto.
  O adaptador de setor/tutorial do FIX01 permanece intacto.
- Checkpoints recebem órbita de pequenas marcas/runas e arco luminoso somente
  em `_draw`. Gatilhos, ativação, progressão e respawn são idênticos.
- Inimigos e perigos mantêm seus visuais do FIX01: não houve tentativa de
  refazer todos os elementos ou os seis setores superficialmente.

## 7. Camadas e integração

Painéis são desenhados pelo Backdrop, atrás de sólidos, atores e props. Há
deslocamento relativo sutil de 0,08 e 0,035, consultando a câmera real, sem
escrita nela. Perspectiva interna e atmosferização dos painéis fornecem a
separação visual entre massas próximas e fundos distantes; a pintura não é
um conjunto completo de planos raster independentes.

A amostra do Jardim ocupa a região visual X=736–1184 e a cripta X=1120–1536,
com sobreposição e bandas de alpha nas bordas para suavizar a transição.
Esses limites são **visuais**, não mudam limites dos setores, física ou rota.
Os outros setores conservam a arte do FIX01; Aren/HUD/ornamento do checkpoint
se propagam por serem componentes compartilhados.

## 8. Preservação e testes

Comparação de hashes com o baseline local confirmou cenas, controle, física,
vida, espada, hurtbox, IA, distribuição, câmera, `project.godot`, testes,
fixtures e relatórios anteriores intactos. No checkpoint, todas as funções
exceto `_draw` permanecem iguais. Não foram removidas/enfraquecidas asserções.

Godot executada por:
`C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`.

| Suíte | Aprovadas | Falhas | Saída |
|---|---:|---:|---:|
| M0 — smoke | 14 | 0 | 0 |
| M1 — combat | 36 | 0 | 0 |
| M2 — survival | 59 | 0 | 0 |
| M3-A — cemetery | 52 | 0 | 0 |
| Navegabilidade — reachability | 35 | 0 | 0 |
| M3-B1 — skeleton | 49 | 0 | 0 |
| M3-B2 — raven | 63 | 0 | 0 |
| M3-B3 — distribution | 115 | 0 | 0 |
| M3-C — mechanisms | 77 | 0 | 0 |
| M3-D — art | 18 | 0 | 0 |
| FIX01 — presentation | 10 | 0 | 0 |
| FIX02 — raster_art | 8 | 0 | 0 |
| **Total** | **536** | **0** | **Todos 0** |

Logs `.godot/fix02-<suíte>_test.log`; saídas headless também em
`fix02-regression-exits.json`. Importação e inicialização por 60 quadros:
saída 0, `fix02-import-final.log` e `fix02-startup.log`. Art/presentation/raster
executadas com renderização Compatibility/OpenGL, NVIDIA RTX 2060 SUPER.
Execuções finais repetidas após o ajuste das transições; repetições não são
somadas como novas verificações.

Os ensaios de navegabilidade mantêm 120 tentativas físicas. Regressões cobrem
ida/volta, câmera, combate, morte, queda, checkpoints e armadilhas; B3 utiliza
sua fixture histórica, M3-C utiliza a fase corrente. O teste gráfico compara
colisores antes/depois de redesenhos e mantém dano/HUD/respawn funcionando.

A nova suíte verifica: quatro recursos carregados, ausência de mipmaps, alpha
real, orçamento de menos de oito milhões de texels, oito recortes válidos,
recortes sem sobreposição, fundos originais ligados ao nível real e folha
nova efetivamente ligada a Aren. Não mede beleza nem homologa arte.

## 9. Capturas e comparação

**41 novas imagens do viewport real**, em `.godot/`, sem montagem:

| Arquivos | Quantidade |
|---|---:|
| `fix02-after-sector1.png` até `fix02-after-sector6.png` | 6 |
| `fix02-focus-{garden-statue,garden-arena,crypt-checkpoint,crypt-vault}.png` | 4 |
| `fix02-detail-{start,spikes,blade-high,blade-low,timed-safe,timed-1,timed-2,timed-3,cp1-active,cp2-active,final}.png` | 11 |
| `fix02-bird-{patrol,wing,alert,dive,recover,hurt,dead}.png` | 7 |
| `fix02-pose-aren-{idle,run,jump,fall,sword,damage,dead,respawn}.png` | 8 |
| `fix02-pose-skeleton-{windup,active,recover,hurt,dead}.png` | 5 |

Os seis setores usam os mesmos pontos do FIX01: (160,156), (710,140),
(990,156), (1348,220), (1788,144), (2212,156). Assim os pares
`fix01-after-sector3/4.png` e `fix02-after-sector3/4.png` são comparáveis.
Ponte e Catedral também foram capturadas para verificar Aren/HUD compartilhados.

Fixtures ignoradas `fix02_capture.gd`, `fix02_focus.gd`, `fix02_details.gd`,
`fix02_bird.gd`, `fix02_poses.gd`; logs `fix02-sectors.log`, `fix02-focus.log`,
`fix02-details.log`, `fix02-bird.log`, `fix02-poses.log`, todos com saída 0.
Posicionamentos são controlados para inspeção, sem alegar playtest humano ou
percurso contínuo. Ataques das fixtures de poses continuam reais.

As capturas foram abertas pelo agente, incluindo estados de perigo e poses.
Foi observada mudança clara de material, arquitetura, volume e profundidade
nos dois recortes; o primeiro sprite escuro foi clareado e os cortes de
painel foram suavizados. A qualidade final e a leitura durante uma sessão
humana aguardam o checklist. Evidências do FIX01/M3-D foram preservadas.

## 10. Desempenho, diagnósticos e limites

- Cena continua com **160 nós**, sem novos corpos ou colisores. Quatro PNGs
  somam aproximadamente 9,7 MB em disco; dimensões somam menos de oito milhões
  de texels (não equivale ao consumo total de RAM/VRAM da aplicação).
- Terreno conserva cache por célula de câmera e recorte de comandos fora da
  vista. Regiões da folha de Aren são metadados fixos medidos pelo alpha,
  evitando ler a textura da GPU a cada quadro ou instância.
- Amostra final no início da fase: 120 quadros após 30 de aquecimento,
  cadência fixa 60, `TIME_PROCESS` médio 27,82895 ms, pico 43,381 ms, parede
  2001,088 ms e 202 chamadas de desenho observadas. FIX01 histórico: média
  19,4634 ms, pico 25,132 ms, 234 chamadas. Outras coletas FIX02 variaram.
  Não são custo puro de CPU nem benchmark prolongado; o ponto inicial não
  mede sozinho o pior caso dos painéis. Não se garante 60 FPS ou estabilidade
  em outra máquina. Sessão prolongada e conforto visual são itens manuais.
- Primeira importação identificou argumentos invertidos de uma chamada de
  desenho de textura. Corrigidos antes dos testes; logs finais sem erros de
  script/parsing/recurso/polígono identificados.
- Persistem `Failed to read the root certificate store` e o diagnóstico de
  gravação de `C:/Users/ovohe/AppData/Roaming/Godot/editor_settings-4.7.tres`.
  A medição auxiliar de recortes também encontrou restrição de log `user://`;
  as execuções de validação usam logs locais explícitos. Sem alteração de
  certificados, permissões ou configurações globais.
- São painéis raster compostos, não um tileset modular completo. Texturas são
  reduzidas à resolução homologada; detalhe das referências maiores não cabe
  integralmente em 320×180. Arte de outros setores ainda é o FIX01.
- Aren tem oito poses e espada separada, não uma produção final de dezenas
  de animações. Decoração não redefine tamanho físico ou dano.
- A amostra visual ainda precisa ser aprovada; não foi declarada equivalência
  às referências nem qualidade final certificada.

## 11. Checklist do responsável — pendente

Usar **PASSOU / FALHOU / NÃO TESTADO**, anotando setor, posição e motivo nas
falhas. Todos os itens permanecem NÃO TESTADO pelo responsável.

| Nº | Critério | Resultado |
|---|---|---|
| 1 | Há um salto visual perceptível em relação ao FIX01. | NÃO TESTADO |
| 2 | O Jardim se aproxima da qualidade/atmosfera desejadas. | NÃO TESTADO |
| 3 | Árvores, raízes e vegetação parecem orgânicas. | NÃO TESTADO |
| 4 | Monumento e mausoléus do Jardim são marcantes. | NÃO TESTADO |
| 5 | Os planos do Jardim têm profundidade e boa hierarquia. | NÃO TESTADO |
| 6 | Materiais do piso são mais ricos e menos repetitivos. | NÃO TESTADO |
| 7 | Catacumbas parecem realmente subterrâneas. | NÃO TESTADO |
| 8 | Abóbadas, túneis, pedra e luz têm acabamento adequado. | NÃO TESTADO |
| 9 | As transições de fundo são aceitáveis em movimento. | NÃO TESTADO |
| 10 | Aren tem presença e silhueta de protagonista. | NÃO TESTADO |
| 11 | Corrida, salto e queda de Aren são legíveis. | NÃO TESTADO |
| 12 | Espada, dano, morte e respawn continuam claros. | NÃO TESTADO |
| 13 | Aren se destaca dos fundos claros e escuros. | NÃO TESTADO |
| 14 | HUD é elegante, integrada e legível. | NÃO TESTADO |
| 15 | Vida, setor e avisos essenciais continuam claros. | NÃO TESTADO |
| 16 | Checkpoints parecem importantes e ativação é clara. | NÃO TESTADO |
| 17 | Lâmina e demais perigos continuam legíveis. | NÃO TESTADO |
| 18 | Inimigos e janelas de ataque permanecem legíveis. | NÃO TESTADO |
| 19 | Pisos, tetos e pontos de aterrissagem são inequívocos. | NÃO TESTADO |
| 20 | Controles, combate e dificuldade foram preservados. | NÃO TESTADO |
| 21 | Câmera, ida e volta continuam confortáveis. | NÃO TESTADO |
| 22 | Queda viva, morte e ambos os checkpoints funcionam. | NÃO TESTADO |
| 23 | Desempenho é aceitável em sessão prolongada. | NÃO TESTADO |
| 24 | A amostra alcança a direção artística esperada. | NÃO TESTADO |

Testar os dois sentidos, lâmina alta/baixa, quatro estados dos espinhos,
combate próximo a relevos/luz, morte/respawn nos dois checkpoints e transições
entre amostra/arte anterior. Não confundir cenário pintado com novo apoio físico.

## 12. Arquivos e Git final

Em relação ao FIX01 local, seis arquivos existentes foram alterados:

```text
README.md
scripts/levels/cemetery_visual.gd
scripts/art/ground_skin.gd
scripts/art/health_frame.gd
scripts/player/knight_visual.gd
scripts/props/respawn_checkpoint.gd
```

Doze novos arquivos do FIX02:

```text
assets/art/fix02/garden_background.png
assets/art/fix02/garden_background.png.import
assets/art/fix02/crypt_background.png
assets/art/fix02/crypt_background.png.import
assets/art/fix02/aren_poses.png
assets/art/fix02/aren_poses.png.import
assets/art/fix02/surface_materials.png
assets/art/fix02/surface_materials.png.import
assets/art/fix02/PROVENANCE.md
tests/raster_art_test.gd
tests/raster_art_test.gd.uid
tests/VALIDACAO_M3_D_FIX02.md
```

Os `.png.import` são metadados de fonte Godot com UIDs, não os caches `.ctex`.
Nenhum cache foi incluído. UIDs prévios preservados e UID do teste gerado pela
engine. As referências JPG e seus `.import` continuam locais como material
fornecido pelo usuário; não são assets runtime e precisam ser distinguidas
de arte original numa eventual revisão de versionamento futura.

Estado agregado: **13 rastreados modificados e 30 novos**, índice vazio,
branch `main`, HEAD igual ao baseline. `git diff --check`, referências,
UIDs, hashes de arquivos protegidos e inspeção dos fontes verificados.
README mantém todo o histórico anterior como sufixo; relatórios prévios intactos.
`.gitignore` permanece excluindo caches, logs, temporários, exportações e segredos.

**Não houve git add, commit, push ou publicação. M3-E e M4 não iniciados.**
**Aguardar playtest e homologação manual do responsável.**
