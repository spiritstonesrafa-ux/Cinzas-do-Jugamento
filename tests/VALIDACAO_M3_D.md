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

# M3-D — Arte e Ambientação: validação e entrega local

Data: 03/11/2026. Engine: Godot 4.7.2 stable.

**M3-D — IMPLEMENTADO, PENDENTE DE PLAYTEST MANUAL E HOMOLOGAÇÃO.**

As execuções e a inspeção abaixo foram realizadas pelo agente. Nenhuma
homologação manual do M3-D foi recebida. Os marcos M0 até M3-C continuam
homologados; seus relatórios históricos foram preservados.

## 1. Baseline e auditoria

- Diretório confirmado: `C:\PROJETOS\CINZAS DO JURAMENTO`; repositório existente,
  sem inicialização ou troca de branch.
- Branch `main`, HEAD `3af31c31da5f693dfef10db0f709d2e76a674c34`,
  `feat(m3-c): homologa armadilhas e checkpoints`.
- Árvore e índice limpos no início. Um commit à frente de `origin/main`.
- Referência local de `origin/main`: `3695eb2b350837cc7622e025e2d05c350b3e2ffc`.
  Não foi feita consulta de rede nem atualização dessa referência nesta etapa.
- Não foram encontradas instruções AGENTS.md na raiz e nos diretórios pais.
- Inspecionados README, relatórios anteriores, cena completa da fase, cenas de
  Aren, inimigos, armadilhas, checkpoints, HUD, scripts visuais e testes.
- O baseline usava desenho geométrico provisório, 19 sólidos, seis inimigos,
  três armadilhas e dois checkpoints. Resolução 320×180, nearest, escala inteira
  e snapping de transformações já eram adequados e foram mantidos.

## 2. Direção de arte e técnica

Composição original de fantasia gótica em grade de pixels, desenhada por
primitivas Godot sem antialiasing, com contornos escuros, volumes em poucos
tons e pequenos acentos luminosos. Não houve importação de recursos externos,
uso de marcas ou cópia de personagens de outras obras. Não há atlas raster
novo: o revestimento das superfícies e os personagens são arte por código.

Paleta central em `scripts/art/pixel_canvas.gd`:

| Uso | Cores hexadecimais |
|---|---|
| Contornos e profundidade | `10111f`, `191b2d`, `282b40` |
| Pedra e metal | `444957`, `737d86`, `b6c7cb` |
| Luz e osso | `e5e3cc` |
| Ouro e chama | `ba9865`, `f3ce8e` |
| Tecido e dano | `733b51`, `c96c72` |
| Magia e umidade | `72b9b3` |

O chão recebe juntas, rachaduras, lascas e musgo. O topo claro coincide com a
superfície física existente; laterais e teto têm tratamento distinto. O antigo
aviso textual de teto foi substituído pela leitura arquitetônica. Os polígonos
provisórios ficam ocultos em execução, mantendo os corpos e colisores originais.

| Setor | Composição entregue |
|---|---|
| 1 — Portões do Cemitério | Portão de ferro, arco, contrafortes, grades, árvore seca e velas. |
| 2 — Caminho das Lápides | Cruzes, lápides tortas, pedra desgastada e vegetação baixa. |
| 3 — Jardim dos Mortos | Estátua funerária com manto, mausoléus, colunas e hera. |
| 4 — Catacumbas | Alvenaria úmida, arcos, pilastras, nichos de ossário, goteiras e velas. |
| 5 — Ponte das Almas | Aqueduto arruinado, arcos profundos, pilares partidos, correntes, abismo e névoa inferior. |
| 6 — Portão da Catedral | Torres, contrafortes, grande portão gradeado, rosácea e vitrais quebrados sugeridos. |

Lua, arquitetura distante e árvores usam deslocamentos relativos à câmera
de 0,08, 0,18 e 0,42. A câmera homologada apenas é consultada. Coordenadas de
desenho são ajustadas à grade; nuvens, névoa baixa, nove pontos de cinza e
chamas acrescentam movimento discreto, atrás dos atores. Não há pós-processamento,
shader pesado, Light2D ou novo emissor de partículas físicas.

## 3. Atores, perigos, relíquias e HUD

- **Aren:** armadura de aço, visor âmbar, selo dourado, malha, bainha e capa
  vinho. Quatro poses de corrida, capa animada, salto recolhido e queda com
  pernas estendidas; espada com arco luminoso, faíscas de dano e brilho breve
  no respawn. A morte continua acompanhando o estado e a rotação originais.
- **Esqueleto:** caveira, mandíbula, costelas e membros definidos, armadura
  corroída e tecido rasgado. Espada e postura distinguem preparação, ataque
  e recuperação; dano e morte acompanham a máquina de estados original.
- **Corvo:** quatro poses de asas, contorno de penas claro, olho vermelho,
  sinal de alerta e asas recolhidas na investida. Recuperação, dano e morte
  continuam visualmente distintos, sem escrita na IA.
- **Espinhos fixos:** dentes de aço e suporte enferrujado, com altura perigosa
  preservada. **Lâmina:** disco serrilhado com raio de 10 px e corrente decorativa.
  **Temporizados:** base recolhida segura, aviso âmbar com `!`, dentes expostos
  no ACTIVE e recuperação violeta. Nenhum tempo ou regra de dano mudou.
- **Checkpoints:** pedestal, relíquia flutuante turquesa que muda para dourado,
  numeral I/II e breve pulso de ativação. O desenho da relíquia fica 8 px à
  direita do centro para aparecer ao lado de Aren; o gatilho permanece intacto.
- **HUD:** moldura, brasão e cinco ícones de vida com pulso ao receber dano.
  O texto `VIDA n/5` e o sinal do M2 continuam sendo a fonte da informação.

As asas, capa, correntes e ornamentos são decorativos; não ampliam hitboxes.
Os sinais de preparação e recuperação foram observados em capturas reais.
A preferência estética e a leitura durante uma sessão humana continuam
dependentes do checklist do responsável.

## 4. Preservação funcional e adaptações mínimas

Comparação com o HEAD confirmou ausência de alteração em `project.godot`,
geometria/cenas da fase, cenas de atores e props, controlador de Aren,
sobrevivência, hurtbox, câmera, máquinas de estados, fontes de ataque dos
inimigos e distribuição. Todas as suítes e fixtures anteriores ficaram intactas.

Em `sword_attack.gd`, `damage_source.gd`, `oscillating_blade.gd`,
`timed_spikes.gd`, `respawn_checkpoint.gd` e `cemetery_checkpoint.gd`, todas
as funções preexistentes, exceto `_draw`, foram comparadas e permanecem iguais.
O checkpoint recebeu somente campos e processamento cosméticos que observam
`active`. O HUD preserva a ligação e o texto originais, acrescentando a
atualização da moldura visual. Os scripts visuais dos atores apenas leem seus
estados; não atribuem posição, velocidade, vida, direção ou estado à entidade.

A única cena alterada é a HUD: acrescenta um Node2D de moldura e reposiciona
o texto. O cenário cria um único Node2D de revestimento. Nenhum colisor novo.
O teste gráfico compara transformações, máscaras, camadas, dimensões e recursos
de todos os colisores antes e depois de oito redesenhos, com simulação congelada.
Isso demonstra que o desenho não modifica física; os ensaios físicos de
regressão, separadamente, validam o movimento e os percursos.

## 5. Execuções reais e regressão

Executável utilizado:
`C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`.
Execuções finais realizadas após os últimos ajustes de pose de queda e relíquia.

| Suíte | Verificações aprovadas | Falhas | Saída |
|---|---:|---:|---:|
| M0 — `smoke_test.gd` | 14 | 0 | 0 |
| M1 — `combat_test.gd` | 36 | 0 | 0 |
| M2 — `survival_test.gd` | 59 | 0 | 0 |
| M3-A — `cemetery_test.gd` | 52 | 0 | 0 |
| FIX01 — `reachability_test.gd` | 35 | 0 | 0 |
| M3-B1 — `skeleton_test.gd` | 49 | 0 | 0 |
| M3-B2 — `raven_test.gd` | 63 | 0 | 0 |
| M3-B3 — `distribution_test.gd` | 115 | 0 | 0 |
| M3-C — `mechanisms_test.gd` | 77 | 0 | 0 |
| M3-D — `art_test.gd` | 18 | 0 | 0 |
| **Total** | **518** | **0** | **Todos 0** |

Importação final: código 0, `.godot/d-import-final.log`.
Inicialização por 60 quadros: código 0, `.godot/d-startup.log`.
Regressões headless com cadência de 60; logs `.godot/d-<nome_da_suíte>.log`.
A suíte de arte foi executada com renderização gráfica Compatibility/OpenGL
na RTX 2060 SUPER, também com código 0, `.godot/d-art_test.log`.

O FIX01 inclui 120 tentativas físicas de salto. Os percursos das suítes
anteriores continuam passando: B3 na fixture preservada, ida 5→5 HP, retorno
contínuo 5→4 e retorno independente 5→5; M3-C na fase atual com armadilhas e
checkpoints, ida 5→4 e retorno contínuo 4→3, sem morte, cura ou reset no percurso.
Esses resultados não garantem ausência de dano em toda abordagem humana.

As 18 verificações novas cobrem configuração de pixels, contagem de sólidos e
inimigos, dimensões de Aren/espada/corvo/lâmina, revestimento sem colisores,
ocultação apenas dos placeholders, menos de 200 nós, invariância física durante
redesenhos, HP intacto, HUD após dano real, pulso de checkpoint, morte, respawn
com brilho e uso da posição real da câmera pelo parallax. Não medem beleza.

Para repetir, após importar o projeto:

```powershell
godot --headless --path . --import
godot --headless --path . --quit-after 60
godot --headless --path . --fixed-fps 60 --script res://tests/mechanisms_test.gd
godot --path . --fixed-fps 60 --script res://tests/art_test.gd
```

`godot` nesses exemplos representa o executável 4.7.2 acima. As outras nove
suítes usam a mesma forma de execução headless, substituindo o nome do script;
`art_test.gd` deve usar renderização gráfica.

## 6. Inspeção gráfica e evidências

Capturas do viewport real de 320×180, sem montagem, produzidas por fixtures
gráficas locais. Os posicionamentos controlados das fixtures servem à inspeção
de poses e composição; não equivalem a um percurso manual contínuo.

**Seis antes + 37 depois = 43 imagens**, em `.godot/`, excluídas do Git:

| Arquivos | Quantidade | Conteúdo |
|---|---:|---|
| `d-before-sector1.png` até `d-before-sector6.png` | 6 | Baseline M3-C, antes de alterar a arte. |
| `d-after-sector1.png` até `d-after-sector6.png` | 6 | Composição final dos seis setores. |
| `d-detail-{start,spikes,blade-high,blade-low,timed-safe,timed-1,timed-2,timed-3,cp1-active,cp2-active,final}.png` | 11 | Perigos, quatro estados temporizados e relíquias ativas. |
| `d-bird-{patrol,wing,alert,dive,recover,hurt,dead}.png` | 7 | Asas, estados e dano/morte do corvo. |
| `d-pose-aren-{idle,run,jump,fall,sword,damage,dead,respawn}.png` | 8 | Poses e feedbacks de Aren. |
| `d-pose-skeleton-{windup,active,recover,hurt,dead}.png` | 5 | Janela de ataque, recuperação e reações do esqueleto. |

Fixtures ignoradas: `d_capture.gd`, `d_details.gd`, `d_bird.gd`, `d_poses.gd`,
todas sob `.godot/`. As quatro execuções finais encerraram com código 0;
logs `d-after.log`, `d-details.log`, `d-bird.log`, `d-poses.log`. A coleta anterior
ao trabalho está em `d-before.log`. As rotinas de poses usam ataques reais
para obter dano e morte; não alteram o código de gameplay do projeto.

Inspeção pelo agente: seis setores, pisos, teto das catacumbas, chegada da ponte,
portão final, estados dos perigos, relíquias, HUD e poses dos atores. A ponte
recebeu mais estrutura arquitetônica após a primeira inspeção; a queda de Aren
e a relíquia foram refinadas e recapturadas. Nas capturas, o fundo permanece
recuado, as bordas de piso claras e os perigos contrastantes. O julgamento
final de beleza, fluidez e legibilidade durante o jogo é do responsável.

As imagens são evidência local descartável: permanecem fora do versionamento,
conforme a política de caches. Não há publicação dessas imagens ou do marco.

## 7. Desempenho observado

Mesmo cenário de coleta, renderer Compatibility, cadência fixa de 60, após
30 quadros de aquecimento; 120 amostras, aproximadamente dois segundos:

| Monitor | Antes | Depois final |
|---|---:|---:|
| `Performance.TIME_PROCESS`, média | 18,3035 ms | 19,4866 ms |
| `Performance.TIME_PROCESS`, pico amostrado | 21,012 ms | 24,520 ms |
| Tempo de parede da amostra | 2000,011 ms | 1999,679 ms |
| Nós da cena | 157 | 159 |
| Chamadas de desenho observadas | 24 | 197 |

Esses valores incluem o comportamento do monitor, da cadência fixa e do
ambiente; não representam custo puro de CPU da arte, benchmark prolongado ou
garantia de 60 FPS em outras máquinas. O aumento das chamadas é uma limitação
mensurada. O teste em sessão longa e na máquina de destino permanece manual.

Para conter custo: apenas dois nós adicionais, geometria decorativa sem
colisão, descarte de desenhos fora da vista, revestimento de terreno com
comandos em cache atualizados por célula de câmera de 32 px e margem de 48 px,
poucos pontos ambientais e ausência de iluminação ou pós-processamento pesado.

## 8. Diagnósticos e limitações

- Persistiu `Failed to read the root certificate store` nas execuções.
- A importação também informou impossibilidade de gravar
  `C:/Users/ovohe/AppData/Roaming/Godot/editor_settings-4.7.tres`.
- Não foram alterados certificados, permissões ou configurações globais.
  Importação, inicialização, testes e capturas encerraram com código 0; não
  foram identificados erros de parsing, scripts ou referências nesses logs.
- A arte ambiental é composta em runtime: a visualização do editor pode
  manter os polígonos provisórios até executar a cena. Não há atlas externo
  nem pipeline de pintura raster nesta entrega.
- Os testes gráficos verificam integridade e capturam estados. Não certificam
  gosto estético, conforto em movimento, desempenho prolongado ou homologação.
- Nenhuma mudança em física, combate, IA, dificuldade, distribuição, vida,
  checkpoint ou geometria funcional foi necessária para a arte.

## 9. Checklist manual do responsável — pendente

Preencher com **PASSOU / FALHOU / NÃO TESTADO**. Se falhar, informar setor,
posição/estado e observação. Todos os itens permanecem NÃO TESTADO pelo
responsável nesta entrega; a inspeção do agente é separada.

| Nº | Critério | Resultado do responsável |
|---|---|---|
| 1 | Aren ficou visualmente melhor. | NÃO TESTADO |
| 2 | Esqueleto ficou visualmente melhor. | NÃO TESTADO |
| 3 | Corvo ficou visualmente melhor. | NÃO TESTADO |
| 4 | Fase parece um jogo bonito. | NÃO TESTADO |
| 5 | Setor 1 tem boa introdução visual. | NÃO TESTADO |
| 6 | Setor 2 ficou bonito e legível. | NÃO TESTADO |
| 7 | Setor 3 ficou bonito e legível. | NÃO TESTADO |
| 8 | Catacumbas ficaram bonitas e legíveis. | NÃO TESTADO |
| 9 | Ponte das Almas ficou bonita e legível. | NÃO TESTADO |
| 10 | Portão da Catedral tem impacto visual. | NÃO TESTADO |
| 11 | Fundo/parallax melhoraram a fase. | NÃO TESTADO |
| 12 | Plataformas continuam legíveis. | NÃO TESTADO |
| 13 | Inimigos continuam legíveis. | NÃO TESTADO |
| 14 | Armadilhas continuam legíveis. | NÃO TESTADO |
| 15 | Checkpoints ficaram visualmente claros. | NÃO TESTADO |
| 16 | HUD ficou melhor. | NÃO TESTADO |
| 17 | Feedback de combate ficou melhor. | NÃO TESTADO |
| 18 | Câmera continua boa. | NÃO TESTADO |
| 19 | Controles continuam bons. | NÃO TESTADO |
| 20 | Não houve perda de jogabilidade. | NÃO TESTADO |
| 21 | Desempenho continua aceitável. | NÃO TESTADO |
| 22 | Dificuldade geral continua adequada. | NÃO TESTADO |
| 23 | A fase parece mais profissional. | NÃO TESTADO |
| 24 | Não foram notados bugs visuais graves. | NÃO TESTADO |

Testar ida e volta dos seis setores, queda viva, morte em ambos os checkpoints,
combate nos dois sentidos e quatro estados da grade. Observar parallax durante
movimento e transições, aterrissagens, ataques, recuperação, brilho e HUD em
sessão prolongada. Não iniciar outro marco antes da decisão do responsável.

## 10. Inventário e Git final

**13 arquivos rastreados modificados:**

```text
README.md
scenes/ui/health_hud.tscn
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
scripts/ui/health_hud.gd
```

**Nove arquivos novos, sem staging:**

```text
scripts/art/pixel_canvas.gd
scripts/art/pixel_canvas.gd.uid
scripts/art/ground_skin.gd
scripts/art/ground_skin.gd.uid
scripts/art/health_frame.gd
scripts/art/health_frame.gd.uid
tests/art_test.gd
tests/art_test.gd.uid
tests/VALIDACAO_M3_D.md
```

Verificações de versionamento: diff completo revisado, `git diff --check`,
referências `res://` válidas, quatro UIDs novos válidos e sem duplicação,
índice vazio, relatórios anteriores preservados e `.gitignore` inalterado.
Caches, logs, temporários, exportações e credenciais continuam excluídos.
Nenhum segredo identificado nos arquivos modificados/novos do projeto.

Estado final esperado e conferido na entrega: `main`, HEAD igual ao baseline,
13 modificados e nove novos; nada staged. A referência remota local permanece
igual e a branch continua um commit à frente dela, referente ao M3-C anterior.
**Não houve git add, commit, push, exportação ou publicação do M3-D.**
**M3-E e M4 não iniciados. Aguardar playtest e homologação manual.**
