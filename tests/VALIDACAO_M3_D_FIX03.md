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

# M3-D-FIX03 — Ataque horizontal e uniformização artística

Data: 03/11/2026. Godot 4.7.2 stable, Windows.

**M3-D-FIX03 — IMPLEMENTADO, PENDENTE DE PLAYTEST MANUAL E HOMOLOGAÇÃO.**

O responsável aprovou visualmente Aren em idle, movimento, salto e dano e
informou que os sistemas funcionais continuavam operantes; criticou o ataque
e a diferença de acabamento entre setores. Isso foi tratado como orientação
de refinamento, não como homologação integral de M3-D/FIX01/FIX02/FIX03.

## 1. Baseline, auditoria e preservação

Repositório confirmado em `C:\PROJETOS\CINZAS DO JURAMENTO`, branch `main`,
HEAD `3af31c31da5f693dfef10db0f709d2e76a674c34`, mensagem
`feat(m3-c): homologa armadilhas e checkpoints`.

Estado inicial: **13 rastreados modificados, 30 novos acumulados e índice vazio**,
incluindo dois JPGs de referência e seus metadados. Um commit local à frente
da referência `origin/main` em `3695eb2b350837cc7622e025e2d05c350b3e2ffc`.
Não foi feita consulta de rede nem alteração dessa referência.

Lidos README, relatórios M3-D/FIX01/FIX02, proveniência FIX02, cena/controlador
de Aren, espada, recebedores de acerto, visuais, materiais, configurações e testes.
Diff acumulado inspecionado e guardado em `.godot/fix03-initial.diff`.
Capturas FIX02 e folha de Aren abertas para comparar ataque e seis setores.
Sem AGENTS.md encontrado na busca do projeto/raiz/pais. Cópia dos arquivos
iniciais e hashes em `.godot/fix03-baseline/` e `fix03-baseline-manifest.json`.

Comparação final confirmou preservação integral de:

- Cenas, colisores, posições, 19 sólidos, seis inimigos, três perigos e dois CPs.
- Controlador, física, câmera, IA, vida, invulnerabilidade, morte, queda e respawn.
- `project.godot`, controles, resolução, filtros e `.gitignore`.
- Todos os testes, fixtures, relatórios e PNGs anteriores.
- Todas as funções preexistentes de M1 e props, exceto `_draw`.
- Seleção e renderização não relacionadas ao ataque em `knight_visual.gd`.

Não houve git init, troca de branch, descarte de trabalho ou reescrita de histórico.

## 2. Diagnóstico objetivo do ataque anterior

Aren usava poses raster, porém não selecionava pose de ataque: o corpo seguia
idle/corrida enquanto `SwordAttack._draw` desenhava a antiga espada por formas
geométricas, elevada na preparação e baixa na recuperação. A desconexão era
de apresentação e registro, não de regra de acerto.

O hitbox M1 **já é horizontal**, com centro `(17×direção,-14)` e tamanho
`22×14`: para direita X=6–28 e Y=−21–−7; para esquerda X=−28–−6.
Preparação 0,10 s, ativo 0,10 s e recuperação 0,20 s. O ciclo completo de
0,40 s restringe repetição; não há cooldown extra introduzido pelo FIX03.
Segurar J não repete e apertos durante o ciclo não formam fila/combos.

Cada `SwordReceiver` recebe um evento por golpe, com bloqueio por paredes
e direção. Esqueleto perde 1 de seus 3 HP; corvo perde 1 de seus 2 HP.
M1 somente inicia apoiado. Um ataque iniciado no chão pode continuar após um
salto; um novo comando no ar é rejeitado. Todos esses contratos foram mantidos.

## 3. Arquitetura da nova animação

Nova folha `assets/art/fix03/aren_attack.png`, gerada com a folha original de
Aren como referência de identidade, sem substituir `fix02/aren_poses.png`.
O helper sem nós `ArenAttackArt` contém recortes, registro da mão/lâmina e
seleção de pose. Ele somente lê `phase`, durações e `_remaining` do M1.
Não avança relógios nem escreve em estados de combate.

| Poses | Janela funcional | Corpo e espada |
|---|---|---|
| 0–1 | WINDUP, 0,10 s | Ombros carregam, braço recua e capa acompanha; lâmina à cintura. |
| 2–3 | ACTIVE, 0,10 s | Extensão horizontal, mão/guarda/lâmina conectadas; tronco participa. |
| 4–7 | RECOVERY, 0,20 s | Continuação, recolhimento do braço e retorno à guarda. |
| −1 | NEUTRAL | Volta às poses aprovadas do FIX02. |

As oito poses foram efetivamente alcançadas em ticks físicos, nos dois sentidos.
`KnightVisual` usa essa apresentação enquanto o ciclo está em andamento e
Aren está vivo. O controlador já mantém o espelhamento na direção inicial
durante o golpe; esse comportamento continua governando corpo, mão e espada.

O desenho antigo da espada foi removido de `_draw`; a função ficou sem desenho
para que a espada não apareça duplicada. **Nenhuma função de combate mudou.**
Não há nova mecânica, combo, trava de movimento ou sacudida de câmera.

## 4. Registro visual e área ativa

A folha nova contém corpo, braço, mão, guarda e espada juntos. Na integração,
somente os pixels da lâmina são recortados e registrados longitudinalmente:
quatro partes recompõem o restante da pose e o mesmo fragmento raster da
lâmina se junta à guarda. Isso permite adaptar a espada ao alcance M1 sem
comprimir todo o corpo ou aumentar a área de dano.

Nas poses ativas a lâmina começa em X=6 e termina em X=28, com altura contida
em Y=−21–−7. À esquerda o mesmo registro é espelhado. Altura visual de referência
36 px, pés registrados na base; as poses antigas, sua escala e metadados não
foram alterados. Mudanças de postura durante o golpe são cosméticas.

Os testes comparam o retângulo renderizado e seu centro global ao colisor real,
em ambos os sentidos. Essa é evidência geométrica; reconhecer semanticamente
a mão e julgar naturalidade/fluidez são inspeção visual e homologação humana.

Dois rastros horizontais curtos, dentro do corredor, aparecem somente no ACTIVE.
Faíscas breves dependem de a lista real de acertos do M1 estar preenchida.
Inimigos continuam reagindo a HURT/DEAD; não foram adicionados sinais de dano,
hitstop, luzes ou partículas pesadas. **Nenhuma adaptação funcional de hitbox,
dano, alcance, cooldown, física ou janela ativa foi necessária.**

## 5. Uniformização dos seis setores

| Setor | Entrega e comparação com FIX02 |
|---|---|
| 1 — Portões | Fundo raster original com portão aberto, grades, bustos, pylons desgastados, árvores e necrópole distante; substitui a entrada predominantemente geométrica. A área segura continua igual. |
| 2 — Lápides | Fundo original com túmulos variados, sarcófagos, arcadas, muros, raízes e vegetação; deixa de depender de silhuetas simples e faz a ligação com o Jardim. |
| 3 — Jardim | PNG original e composição FIX02 preservados; pisos, inimigos e perigos agora compartilham a família de materiais do restante da fase. |
| 4 — Catacumbas | PNG original e passagens preservados; atlas de inimigos/props substitui o acabamento esquemático, com lâmina e corrente ainda à frente do painel. |
| 5 — Ponte | Novo fundo com penhascos, arcos rompidos, ruínas e névoa inferior, profundidade abaixo do percurso; vãos, tamanhos e posições dos dois spans rigorosamente preservados. |
| 6 — Catedral | Novo fundo com grande portal, arquivoltas, vitrais, entalhes, colunas e contrafortes, como clímax arquitetônico; nenhum chefe ou transição nova. |

Os quatro novos fundos referenciam somente o trabalho original do FIX02 quanto
a paleta e materiais. Não são recortes das imagens de terceiros. Os seis
setores agora usam painéis raster com acabamento de pedra e vegetação próximo;
a equivalência artística final entre eles não é certificada automaticamente.

## 6. Camada jogável, inimigos e perigos

Todos os sólidos usam o atlas de materiais original do FIX02: pedra/terra
musgosa nos trechos externos e pedra fria em cripta, ponte e catedral. Os
patches são recortados nos retângulos físicos, com topo de contato claro e
contínuo. Nenhuma decoração criou apoio ou fechou um vão.

Novo `actors_props.png`, atlas transparente 4×3:

- Esqueleto: duas poses de marcha, preparação e ataque; recuperação retorna
  à postura baixa. HURT recebe destaque/faíscas e DEAD mantém rotação original.
- Corvo: quatro poses de asas/mergulho, olho vermelho, alerta `!`, recuperação
  e dano distintos, controlados exclusivamente pela IA existente.
- Espinhos fixos: sprite contido em 20×12; temporizados expõem sprite 24×12
  somente no ACTIVE e mantêm aviso/recolhimento do M3-C.
- Lâmina: disco raster de 20×20, preservando raio perigoso 10; corrente e
  suporte são decorativos e não perigosos.
- Checkpoints: pedestal raster, cristal turquesa, centro dourado ativo e marcas
  orbitais. Gatilho, progressão, morte/queda e respawn intactos.

Esses recursos compartilham marfim, aço azul, bronze corroído, tecido teal e
acentos contidos com os fundos e Aren. HUD do FIX02 foi preservada. Asas,
capas e ornamentos continuam decorativos, sem redefinir hurtboxes.

## 7. Transições, parallax e resolução

`PANELS` contém seis texturas com regiões sobrepostas. Deslocamentos relativos
de 0,035–0,08 consultam a câmera real; bandas de alpha de 8 px suavizam as
fronteiras. Há dez capturas, uma antes e outra depois de cada uma das cinco
transições. A cobertura de opacidade é testada geometricamente ao longo do
eixo X, sem alegar que isso prova composição ou continuidade artística.

Os planos de profundidade estão principalmente compostos nos painéis, com
deslocamento relativo e poucos pontos ambientais separados. Não se declara
um conjunto completo de planos raster independentes ou tileset modular final.

320×180, nearest, escala inteira e pixel snapping intactos. PNGs originais
em resolução maior são amostrados nessa grade; não se afirma pintura manual
pixel a pixel. Recortes dos dois novos atlases têm metadados fixos e foram
validados dentro dos limites e sem sobreposição de células.

## 8. Proveniência dos recursos

Seis PNGs novos em `assets/art/fix03/`, gerados com **image_gen integrado**:
`aren_attack`, `gate_background`, `graves_background`, `bridge_background`,
`cathedral_background` e `actors_props`. O primeiro usa a folha original
FIX02 como referência de identidade; os fundos usam o Jardim original como
referência de qualidade/material. O atlas de inimigos/props foi gerado por
descrição. Não houve CLI, chave de API ou pack externo.

Prompts integrais, método, referências próprias, condições conhecidas e
modificações de integração: `assets/art/fix03/PROVENANCE.md`.
Os recursos estão no projeto, carregados por `res://`, sem dependência do
perfil de geração. PNGs anteriores e referências JPG do usuário preservados.
Metadados `.png.import` reproduzíveis, compressão lossless e sem mipmaps;
UIDs existentes mantidos e novos gerados pela engine.

## 9. Regressão completa executada

Executável:
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
| FIX03 — horizontal_attack | 46 | 0 | 0 |
| FIX03 — cohesion | 14 | 0 | 0 |
| **Total** | **596** | **0** | **Todos 0** |

As 536 anteriores foram executadas sem alteração. Importação e inicialização
por 60 quadros concluíram com saída 0. Logs `.godot/fix03-<suíte>_test.log`,
`fix03-import-final.log`, `fix03-startup.log` e `fix03-regression-exits.json`.
As cinco suítes art/presentation/raster/horizontal/cohesion usam renderização
gráfica real Compatibility/OpenGL, RTX 2060 SUPER. Repetições não são somadas.

As 46 verificações novas de ataque incluem entradas e física reais: oito poses
nos dois sentidos, registro da lâmina dentro da área ativa, direção travada,
acerto único, nada atrás/fora de alcance, repetição/ciclo, movimento, virada,
salto, aterrissagem, dano, cancelamento e morte. Também houve contra-ataques
reais ao corvo depois do mergulho, nos dois lados, e acertos no Esqueleto.
Não houve teleporte do alvo para simular esses acertos no teste novo.

As 14 de coesão verificam recursos/UIDs, seis painéis, mipmaps, alpha, recortes,
orçamento de texels, cobertura geométrica e alinhamento da câmera nas cinco
transições, sólidos/inimigos e contagem de nós. Não medem beleza.

O FIX01 de navegabilidade mantém 120 ensaios físicos. Suítes B3 e M3-C continuam
cobrindo ida/volta, câmera, combate, checkpoints, restauração após morte/queda
e perigos; B3 usa sua fixture histórica e M3-C usa a cena corrente. Não se
afirma ausência de dano em qualquer abordagem humana.

## 10. Evidências e capturas

**103 novas capturas do viewport real**, ignoradas pelo Git em `.godot/`:

| Grupo | Quantidade |
|---|---:|
| `fix03-after-sector1.png` até `fix03-after-sector6.png` | 6 |
| `fix03-attack-1-0.png` até `fix03-attack-1-25.png` | 26 |
| `fix03-attack--1-0.png` até `fix03-attack--1-25.png` | 26 |
| `fix03-impact-{skeleton,raven}-{1,-1}.png` | 4 |
| `fix03-transition-0.png` até `fix03-transition-9.png` | 10 |
| `fix03-detail-{start,spikes,blade-high,blade-low,timed-safe,timed-1,timed-2,timed-3,cp1-active,cp2-active,final}.png` | 11 |
| `fix03-bird-{patrol,wing,alert,dive,recover,hurt,dead}.png` | 7 |
| `fix03-pose-aren-{idle,run,jump,fall,sword,damage,dead,respawn}.png` | 8 |
| `fix03-pose-skeleton-{windup,active,recover,hurt,dead}.png` | 5 |

Sequência de ataque: 26 ticks consecutivos por sentido, iniciados por J em
(240,156); inclui preparação, todos os oito quadros, ativo, recuperação e
retorno ao neutro. `fix03-attack-sequence.json` registra fase, pose e estado
real do hitbox por quadro. `fix03_attack_sequence.html` permite pausar,
avançar e ver os dois sentidos em tempo real ou lento, ampliando os mesmos PNGs.
Não é uma animação inventada de apresentação.

Setores usam os mesmos seis pontos de FIX02: (160,156), (710,140), (990,156),
(1348,220), (1788,144), (2212,156), permitindo comparar os pares
`fix02-after-sectorN.png` e `fix03-after-sectorN.png`. A sequência nova do ataque
usa posição diferente das poses antigas do FIX02; não se declara câmera idêntica
nessa comparação específica. Evidências anteriores não foram sobrescritas.

Capturas e principais estados foram abertas pelo agente: seis setores, cinco
fronteiras, dois sentidos do ataque, impacto em ambos os inimigos, perigos e
poses. Fixtures/reposicionamentos de inspeção não equivalem a um playtest
humano contínuo. A navegação física é demonstrada separadamente pelas suítes.

Logs gráficos: `fix03-sectors.log`, `fix03-attack-sequence.log`,
`fix03-details.log`, `fix03-bird.log`, `fix03-poses.log` e as duas novas suítes;
todas as execuções finais encerraram com código 0.

## 11. Avaliação crítica e limites

| Pergunta | Evidência observada / limite |
|---|---|
| Ataque realmente novo e horizontal? | Sim nas capturas: poses de corpo novas, lâmina à cintura, sem o desenho vertical antigo. |
| Espada acompanha mão/corpo e mantém identidade? | Registro e inspeção mostram junta contínua; equipamento/capa seguem o Aren original. Naturalidade final é pendente. |
| Há antecipação, impacto e recuperação? | Oito poses e estados reais registrados, com faíscas em acerto; sensação de peso e fluidez requer playtest. |
| Seis setores próximos no acabamento? | Todos usam arte raster, pedra texturizada e atlas compartilhado; é uma melhora observável frente ao FIX02, não uma certificação de qualidade final. |
| Entrada, Ponte e Catedral melhoraram? | Portão/ornamentos, ruínas/abismo e fachada esculpida substituem desenhos simples; impacto estético é do responsável. |
| Fundos e camada jogável combinam? | Materiais/paleta são compartilhados e contornos de piso mantidos; leitura em movimento ainda precisa de avaliação humana. |
| Jogo artisticamente coeso e fluido? | Capturas e regressão sustentam integração técnica; julgamento final e sessão prolongada continuam pendentes. |

Limitações específicas: painéis têm profundidade composta, não múltiplas
camadas raster recortadas independentes; a resolução continua 320×180 e não
comporta todo detalhe dos PNGs maiores. Recuperação usa quatro poses discretas
no tempo M1 original, sem prolongar o golpe para obter mais quadros. Leitura
de perigo, comparação com as referências, estilo, ritmo e conforto visual não
são homologados por testes. Nenhum marco seguinte foi iniciado.

## 12. Desempenho e diagnósticos

Cena permanece em **160 nós**, abaixo do limite de 200, sem novos corpos.
Helpers são RefCounted e texturas reutilizadas; não há novos emissores físicos,
luzes ou pós-processamento. Fundo conserva cache de comandos em repouso,
passos ambientais de 7 Hz e atualização a cada pixel real de câmera. Terreno
conserva culling/cache por célula de 32 px com margem de 48 px.

Seis PNGs novos: **14.540.960 bytes** em disco. O monitor gráfico na passagem
de transições informou **69.938.297 bytes de texturas** (~66,7 MiB), incluindo
recursos do renderer, não apenas os novos PNGs. As dimensões dos seis fundos
e dois atlases novos ficam abaixo do orçamento testado de 24 milhões de texels.
Nenhum recurso depende de caminho absoluto em runtime.

Amostra curta em Portões, 120 quadros após 30 de aquecimento, cadência fixa 60:
`TIME_PROCESS` médio **46,27795 ms**, pico **70,261 ms**, parede **1999,796 ms**;
160 nós e **20 chamadas de desenho**. Outra coleta preliminar marcou média
30,7285 ms e pico 50,789 ms. FIX02 histórico: média 27,82895 ms e pico 43,381 ms,
202 chamadas. O monitor variou e não representa CPU pura nem benchmark de
deslocamento completo; menos chamadas não prova melhor tempo de quadro.
**Não se garante 60 FPS ou desempenho prolongado. Esse critério fica pendente
de playtest na máquina de destino.** Capturas nas dez transições e travessias
físicas concluíram, sem certificar conforto humano de movimento.

Persistem os diagnósticos conhecidos de certificados e gravação de
`C:/Users/ovohe/AppData/Roaming/Godot/editor_settings-4.7.tres` na importação.
Sem alteração de certificados, permissões ou configurações globais. Logs finais
sem erros de script, parsing, referências ou triangulação identificados.

## 13. Checklist manual — aguardando o responsável

Preencher **PASSOU / FALHOU / NÃO TESTADO**, informando posição/estado e
observação quando falhar. Todos pendentes de playtest do FIX03:

| Nº | Critério | Resultado |
|---|---|---|
| 1 | Aren continua bonito. | NÃO TESTADO |
| 2 | Movimentação preservada. | NÃO TESTADO |
| 3 | Salto preservado. | NÃO TESTADO |
| 4 | Animação de dano preservada. | NÃO TESTADO |
| 5 | Novo ataque horizontal. | NÃO TESTADO |
| 6 | Espada integrada ao corpo. | NÃO TESTADO |
| 7 | Golpe fluido e convincente. | NÃO TESTADO |
| 8 | Ataque para direita e esquerda. | NÃO TESTADO |
| 9 | Impacto visual satisfatório. | NÃO TESTADO |
| 10 | Dano e alcance corretos. | NÃO TESTADO |
| 11 | Primeiro setor com arte aprimorada. | NÃO TESTADO |
| 12 | Segundo setor com arte aprimorada. | NÃO TESTADO |
| 13 | Jardim preservado ou melhorado. | NÃO TESTADO |
| 14 | Catacumbas preservadas ou melhoradas. | NÃO TESTADO |
| 15 | Ponte visualmente aprimorada. | NÃO TESTADO |
| 16 | Catedral visualmente aprimorada. | NÃO TESTADO |
| 17 | Coerência entre os seis setores. | NÃO TESTADO |
| 18 | Pisos e plataformas com bom acabamento. | NÃO TESTADO |
| 19 | Fundos e sprites visualmente compatíveis. | NÃO TESTADO |
| 20 | Inimigos legíveis. | NÃO TESTADO |
| 21 | Armadilhas legíveis. | NÃO TESTADO |
| 22 | Checkpoints funcionais. | NÃO TESTADO |
| 23 | HUD funcional. | NÃO TESTADO |
| 24 | Câmera preservada. | NÃO TESTADO |
| 25 | Ida e volta pela fase. | NÃO TESTADO |
| 26 | Desempenho adequado. | NÃO TESTADO |
| 27 | Ausência de bugs visuais graves. | NÃO TESTADO |
| 28 | Qualidade artística final satisfatória. | NÃO TESTADO |

Incluir parado/em movimento, ambos os lados, ataque após dano, iniciado no chão
e seguido de salto, novo comando no ar rejeitado, acerto em Esqueleto e Corvo
após mergulho, paredes, recuperação, queda/morte e os dois checkpoints. Observar
as aterrissagens da Ponte e os sinais das três armadilhas durante ida/volta.

## 14. Inventário e Git final

**11 arquivos existentes alterados em relação ao FIX02 local:**

```text
README.md
scripts/art/ground_skin.gd
scripts/levels/cemetery_visual.gd
scripts/player/knight_visual.gd
scripts/player/sword_attack.gd
scripts/enemies/skeleton_visual.gd
scripts/enemies/raven_visual.gd
scripts/props/damage_source.gd
scripts/props/oscillating_blade.gd
scripts/props/timed_spikes.gd
scripts/props/respawn_checkpoint.gd
```

**22 novos arquivos do FIX03:**

```text
assets/art/fix03/PROVENANCE.md
assets/art/fix03/aren_attack.png
assets/art/fix03/aren_attack.png.import
assets/art/fix03/actors_props.png
assets/art/fix03/actors_props.png.import
assets/art/fix03/gate_background.png
assets/art/fix03/gate_background.png.import
assets/art/fix03/graves_background.png
assets/art/fix03/graves_background.png.import
assets/art/fix03/bridge_background.png
assets/art/fix03/bridge_background.png.import
assets/art/fix03/cathedral_background.png
assets/art/fix03/cathedral_background.png.import
scripts/art/aren_attack_art.gd
scripts/art/aren_attack_art.gd.uid
scripts/art/cemetery_sprite_art.gd
scripts/art/cemetery_sprite_art.gd.uid
tests/horizontal_attack_test.gd
tests/horizontal_attack_test.gd.uid
tests/cohesion_test.gd
tests/cohesion_test.gd.uid
tests/VALIDACAO_M3_D_FIX03.md
```

Estado agregado: **13 rastreados modificados e 52 novos**, índice vazio, branch
`main`, HEAD inalterado. Os 52 incluem os trabalhos anteriores e as referências
do usuário; não são 52 arquivos criados somente neste fix. `.png.import` são
metadados de fonte Godot, não caches `.ctex`. Quatro UIDs novos de GDScript
gerados pela engine; UIDs anteriores preservados. Referências e UIDs verificados,
`git diff --check` sem erro de whitespace e nenhum segredo identificado nos fontes.

README preserva todo o conteúdo anterior como histórico; relatórios anteriores
intactos. Capturas, logs, viewer HTML e backups ficam somente em `.godot/`,
ignorados pelo Git. Nada foi adicionado ao índice.

**Não houve git add, commit, push, exportação ou publicação.**
**M3-E e M4 não iniciados. Aguardar playtest e homologação do responsável.**
