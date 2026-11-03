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

# M3-D-FIX01 — Refinamento Visual Avançado

Data: 03/11/2026. Godot 4.7.2 stable, Windows.

**M3-D-FIX01 — IMPLEMENTADO, PENDENTE DE PLAYTEST MANUAL E HOMOLOGAÇÃO.**

Este relatório registra trabalho do agente. Não houve homologação manual do
M3-D nem deste fix. A avaliação recebida solicitou refinamento; não equivale
a aprovação. O relatório anterior `VALIDACAO_M3_D.md` permanece integralmente
preservado, com seus resultados e evidências históricos.

## 1. Baseline real e auditoria

Projeto/repositório confirmado em `C:\PROJETOS\CINZAS DO JURAMENTO`, branch
`main`, HEAD `3af31c31da5f693dfef10db0f709d2e76a674c34`, mensagem
`feat(m3-c): homologa armadilhas e checkpoints`.

No início: **13 arquivos rastreados modificados, nove novos e índice vazio**,
correspondendo ao M3-D local. Não houve inicialização do Git, mudança de branch,
descarte de alterações ou reescrita de histórico. A referência local de
`origin/main` permanece `3695eb2b350837cc7622e025e2d05c350b3e2ffc`, um commit
atrás da `main`. Não foi consultado ou atualizado o remoto nesta tarefa.

Lidos README e relatório M3-D; inspecionados cena completa, Aren, inimigos,
perigos, checkpoints, HUD, scripts, filtros, escala e testes. Não encontradas
instruções AGENTS.md na raiz ou nos diretórios pais. As **37 capturas anteriores**
estavam disponíveis e foram abertas para inspeção antes das alterações.
Uma cópia local ignorada dos arquivos do baseline M3-D e seus hashes foi
guardada em `.godot/fix01-baseline/` e `fix01-baseline-manifest.json`.

Diagnóstico confirmado nas imagens: fundo de torres e árvores semelhante em
vários setores; alvenaria muito uniforme; poucos elementos no Jardim;
Catacumbas com arcos rasos e aparência de parede exterior; textos empilhados
no topo esquerdo; silhueta de Aren ainda sem um detalhe dominante.

## 2. Direção de arte e profundidade

Mantida a paleta gótica original do M3-D: contorno azul quase preto, pedra fria,
osso, vinho, ouro e pequenos acentos turquesa. Foram acrescentadas variações
de verdes dessaturados no Jardim, terra nas Lápides, verde mineral nas
Catacumbas, azul no abismo e tons vinho na arquitetura da Catedral.

O horizonte passou a variar por região: terraços funerários nas Lápides,
ciprestes no Jardim e penhascos na Ponte. Um plano médio, com deslocamento
relativo de 0,60, acrescenta árvores, capelas, túmulos, pilares ou arcadas.
As camadas anteriores de lua, ruínas e árvores foram mantidas onde apropriadas,
com menor repetição de torres. Os fundos têm contraste inferior ao dos atores.

Catacumbas usam aberturas sem travessas, câmaras encaixadas em perspectiva,
degraus apenas desenhados ao fundo, abóbadas com aduelas e pedras-chave,
colunas, depósitos minerais, raízes e focos quentes de velas. O interior
escuro cobre o céu na faixa subterrânea; não há filtro escurecendo Aren ou HUD.

Não foram importadas imagens, fontes, marcas ou assets comerciais. A solução
continua em primitivas Godot sobre grade lógica, sem blur, shaders pesados ou
novas luzes físicas. O personagem e os ornamentos são originais.

## 3. Resultado por setor

| Setor | Refinamento |
|---|---|
| 1 — Portões | Pináculos, coroamento do arco, medalhão do juramento, travamentos, desgaste dos pilares e base mais robusta. Instruções deixam o topo do cenário livre. |
| 2 — Lápides | Horizonte em terraços de sepulturas, cruzes distantes, árvores secas no plano médio, desgaste/vegetação nos túmulos e solo de terra com pedras e raízes. |
| 3 — Jardim | Ciprestes em várias profundidades, duas capelas ancestrais, gradil ornamental, flores fúnebres, musgo, coroas vegetais e pontos votivos junto ao mausoléu e à estátua existente. |
| 4 — Catacumbas | Túneis recuados, abóbadas, aduelas, colunas, ossos, raízes, minerais e iluminação local de velas. Superfícies maiores de alvenaria úmida. |
| 5 — Ponte | Horizonte de penhascos, bancos de nuvens, pilares quebrados que descem no abismo, bruma inferior, reflexos distantes e detalhe de juntas/fixações nos vãos. |
| 6 — Catedral | Traceria, vitrais, estandartes, juntas de pedra, contrafortes, lanternas processionais e faixas muito discretas de luz atrás dos atores. |

## 4. Superfícies e personagens

Os materiais deixaram de compartilhar somente tijolos de 16×10: a entrada tem
blocos maiores e friso, as Lápides usam terra com ilhas irregulares e pedrinhas,
o Jardim usa pedra verde com desgaste e musgo, a cripta tem alvenaria maior
com depósitos minerais, a Ponte tem juntas estreitas e fixações e a Catedral
tem blocos largos com gravações. Variações são determinísticas.

Os detalhes do revestimento são recortados no retângulo do sólido existente.
A linha superior continua coincidindo com o topo real, sem modificar dimensões
ou posições. Apoios ornamentais e arquitetura de fundo não têm colisão.

- **Aren:** crista partida de ouro e brasa no elmo, ombreira assimétrica,
  juramento gravado no peitoral e manto dividido com forro e borda bordada.
  Poses e ritmo visual do M3-D foram preservados; nenhuma mudança funcional.
- **Esqueleto:** arcada/queixo mais definidos, dente ausente, diadema corroído,
  ossos realçados, tecido rasgado e pontos de ferrugem na arma.
- **Corvo:** segunda asa, pontas de penas, crista, bico e garras mais definidos.
  Alerta, investida, recuperação, dano e morte continuam ligados à IA original.
- **Espinhos:** rebites e encaixe no piso. **Lâmina:** suporte ornamental e
  marcas no metal, mantendo raio perigoso 10 px. **Temporizados:** ranhuras,
  pequenas marcas de estado e linha de aviso, preservando o `!` e os dentes
  somente no estado ativo.
- **Checkpoints:** auréola aberta, órbita interrompida e acabamento do pedestal,
  com turquesa inativo e ouro ativo; gatilho e respawn permanecem iguais.

As silhuetas decorativas continuam maiores que alguns corpos físicos, como
já ocorria com asas/capa no M3-D. Elas não redefinem alcance ou área de dano.

## 5. HUD, textos e adaptação técnica

A moldura da vida passou de 119×15 para 106×12 px, conservando o brasão,
cinco ícones, pulso e texto `VIDA n/5`. O texto usa a mesma fonte e tamanho 8.
O setor é apresentado em tamanho 8, no topo direito; instruções e avisos de
checkpoint/fim ficam centralizados numa faixa inferior, quando existem.

O novo `cemetery_interface.gd` é um adaptador de apresentação, acrescentado
como um Node2D ao `StageHUD`. Oculta somente os dois Labels visuais anteriores,
lê seus textos e desenha a nova disposição. Os Labels continuam recebendo os
mesmos valores do script homologado. Nenhuma mudança em câmera, progressão
ou detecção de setores. O tutorial conserva mover, saltar e espada; o aviso
de fim continua explicitamente provisório e dependente de playtest.

Não há Control novo capturando entrada. A cena funcional não foi editada.
A única cena alterada nesta entrega continua sendo a HUD, para reposicionar
o texto da vida. Os testes conferem que títulos e instruções cabem em 320 px.

## 6. Auditoria de preservação

Comparação com a cópia do M3-D local confirmou:

- `project.godot`, controles, física, vida, hurtbox, IA, câmera e script da
  fase intactos.
- Cenas de nível, player, inimigos e props, incluindo colisores, posições,
  recursos físicos, seis inimigos, três perigos e dois checkpoints intactos.
- Todas as funções preexistentes de espada e props, exceto `_draw`, idênticas.
  O processamento cosmético de checkpoint introduzido no M3-D também intacto.
- Suítes, fixtures e relatório anteriores preservados, sem remoção de asserções.
- Referências `res://` existentes, UIDs válidos e únicos e ausência de padrões
  de credenciais na inspeção dos fontes.

O teste gráfico M3-D também compara todos os transformes, camadas, máscaras,
dimensões e recursos de colisão antes/depois de oito redesenhos, além de dano,
HUD, morte, respawn, checkpoint e leitura da câmera.

## 7. Testes executados

Executável: `C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`.
Regressão completa executada; verificações gráficas e de interface usam o
renderer Compatibility/OpenGL real, NVIDIA RTX 2060 SUPER.

| Suíte | Passaram | Falhas | Código de saída |
|---|---:|---:|---:|
| M0 — smoke | 14 | 0 | 0 |
| M1 — combat | 36 | 0 | 0 |
| M2 — survival | 59 | 0 | 0 |
| M3-A — cemetery | 52 | 0 | 0 |
| FIX01 navegabilidade — reachability | 35 | 0 | 0 |
| M3-B1 — skeleton | 49 | 0 | 0 |
| M3-B2 — raven | 63 | 0 | 0 |
| M3-B3 — distribution | 115 | 0 | 0 |
| M3-C — mechanisms | 77 | 0 | 0 |
| M3-D — art | 18 | 0 | 0 |
| M3-D-FIX01 — presentation | 10 | 0 | 0 |
| **Total** | **528** | **0** | **Todos 0** |

Logs finais `.godot/fix01-<suíte>_test.log`. Importação e inicialização por
60 quadros concluídas com código 0, em `fix01-import-final.log` e
`fix01-startup.log`. Resultados das nove suítes headless também em
`fix01-regression-exits.json`. As execuções finais ocorreram após os ajustes
visuais e de cache. Repetições de uma suíte não são somadas como novas asserções.

O FIX01 de navegabilidade mantém 120 ensaios físicos. Os testes B3 usam sua
fixture histórica preservada; M3-C carrega a fase atual, com perigos e relíquias.
Ida e volta físicas, combate, câmera, quedas, restauração e conclusão continuam
passando. Os percursos não certificam imunidade a dano em qualquer abordagem.

A nova suíte `presentation_test.gd` verifica dez condições: apresentação sem
texto duplicado, três controles essenciais, instruções dentro da tela, seis
setores corretos, títulos sem sobrepor a vida, avisos CP1 e CP2, sentido do
fim provisório, largura do aviso final e ausência de aviso em travessia comum.
Esses testes verificam conteúdo e encaixe; não avaliam beleza.

Exemplos para repetir após a importação, com `godot` apontando ao executável:

```powershell
godot --headless --path . --import
godot --headless --path . --quit-after 60
godot --headless --path . --fixed-fps 60 --script res://tests/mechanisms_test.gd
godot --path . --fixed-fps 60 --script res://tests/art_test.gd
godot --path . --fixed-fps 60 --script res://tests/presentation_test.gd
```

## 8. Capturas e inspeção

**37 novas capturas do viewport real**, sem montagem; preservadas separadamente
das 37 capturas anteriores. Todas sob `.godot/`, ignoradas pelo Git:

| Prefixo/arquivos | Quantidade |
|---|---:|
| `fix01-after-sector1.png` até `fix01-after-sector6.png` | 6 |
| `fix01-detail-{start,spikes,blade-high,blade-low,timed-safe,timed-1,timed-2,timed-3,cp1-active,cp2-active,final}.png` | 11 |
| `fix01-bird-{patrol,wing,alert,dive,recover,hurt,dead}.png` | 7 |
| `fix01-pose-aren-{idle,run,jump,fall,sword,damage,dead,respawn}.png` | 8 |
| `fix01-pose-skeleton-{windup,active,recover,hurt,dead}.png` | 5 |

Fixtures gráficas locais: `fix01_capture.gd`, `fix01_details.gd`,
`fix01_bird.gd`, `fix01_poses.gd`. Logs `fix01-sectors.log`,
`fix01-details.log`, `fix01-bird.log`, `fix01-poses.log`, todos com saída 0.
São ensaios de posições/estados controlados, com entradas reais de ataque
nas poses; não representam uma sessão humana contínua.

As imagens anteriores e novas foram abertas pelo agente. A comparação mostra
mudança do horizonte entre setores, mais camadas no Jardim, interior recuado
nas Catacumbas, ornamentação da Catedral, variações de chão, nova silhueta de
Aren e menos texto sobre a área jogável. Também foram observados os quatro
estados temporizados, extremos da lâmina, checkpoints ativos e poses dos
atores. A apreciação final da qualidade e legibilidade em movimento depende
do responsável; não foi declarada homologação.

## 9. Desempenho e organização

Cena atual: **160 nós**, contra 159 no M3-D, sem novos colisores. O único nó
adicional do fix é o adaptador da interface. O terreno conserva cache por
células de câmera de 32 px e margem de 48 px; detalhes são descartados fora
da vista. Fundo redesenha quando muda um pixel da câmera ou o passo ambiente
de 7 Hz; os textos somente quando seu conteúdo muda. Não há atraso deliberado
de câmera nem alteração da simulação física.

Amostra final de 120 quadros, após 30 de aquecimento, com cadência fixa de 60:

| Monitor | M3-D histórico | FIX01 final |
|---|---:|---:|
| `Performance.TIME_PROCESS`, média | 19,4866 ms | 19,4634 ms |
| Pico na amostra | 24,520 ms | 25,132 ms |
| Tempo de parede | 1999,679 ms | 2000,041 ms |
| Nós | 159 | 160 |
| Chamadas de desenho observadas | 197 | 234 |

O aumento de chamadas é real. As amostras curtas variaram: uma coleta antes
do cache final registrou média 29,6530 ms e pico 45,853 ms. Não se atribui essa
diferença inteira ao cache: agendamento, cadência fixa e ambiente também
influenciam o monitor. A tabela não mede CPU pura da arte, não é benchmark
prolongado e não garante 60 FPS em outra máquina. Desempenho em sessão longa
continua item obrigatório de playtest.

## 10. Diagnósticos e limitações

- Durante o refinamento, aberturas decorativas muito pequenas e uma pose
  da asa produziram erros de triangulação. Foram corrigidas as proporções
  das aberturas e a topologia da asa. Suítes afetadas foram repetidas e a
  regressão final foi executada novamente; logs finais não repetem esses erros.
- Persistem o diagnóstico de certificados `Failed to read the root certificate
  store` e, na importação, a impossibilidade de gravar
  `C:/Users/ovohe/AppData/Roaming/Godot/editor_settings-4.7.tres`.
- Não foram alterados certificados, permissões ou configurações globais.
  Nenhum erro de script, parsing ou recurso ausente nos logs finais.
- Arte continua procedural e composta em execução. O editor pode exibir
  placeholders antes do F5. Não há atlas pintado ou pipeline raster novo.
- Beleza, legibilidade em movimento, conforto visual, contraste em outros
  monitores e desempenho prolongado não são homologados por testes automáticos.
- Capturas/logs são evidência local ignorada, não artefatos publicados.

## 11. Checklist manual — aguardando o responsável

Registrar **PASSOU / FALHOU / NÃO TESTADO**; se falhar, informar setor, estado e
observação. Todos permanecem NÃO TESTADO pelo responsável nesta entrega.

| Nº | Critério | Resultado |
|---|---|---|
| 1 | O jogo ficou mais bonito que no M3-D anterior. | NÃO TESTADO |
| 2 | Há mais profundidade visual. | NÃO TESTADO |
| 3 | Os setores estão mais distintos entre si. | NÃO TESTADO |
| 4 | O Setor 1 ficou mais marcante. | NÃO TESTADO |
| 5 | O Jardim dos Mortos ficou mais rico visualmente. | NÃO TESTADO |
| 6 | As Catacumbas parecem mais subterrâneas. | NÃO TESTADO |
| 7 | A Ponte das Almas ficou mais dramática. | NÃO TESTADO |
| 8 | O Portão da Catedral ficou mais impactante. | NÃO TESTADO |
| 9 | Aren ficou mais marcante. | NÃO TESTADO |
| 10 | Esqueleto ficou mais bonito. | NÃO TESTADO |
| 11 | Corvo ficou mais bonito. | NÃO TESTADO |
| 12 | Armadilhas ficaram mais bonitas e claras. | NÃO TESTADO |
| 13 | Checkpoints ficaram melhores. | NÃO TESTADO |
| 14 | HUD ficou melhor. | NÃO TESTADO |
| 15 | Textos ficaram mais elegantes. | NÃO TESTADO |
| 16 | Plataformas continuam legíveis. | NÃO TESTADO |
| 17 | Inimigos continuam legíveis. | NÃO TESTADO |
| 18 | Armadilhas continuam legíveis. | NÃO TESTADO |
| 19 | Jogabilidade foi preservada. | NÃO TESTADO |
| 20 | Câmera foi preservada. | NÃO TESTADO |
| 21 | Desempenho continua aceitável. | NÃO TESTADO |
| 22 | O jogo agora parece mais profissional. | NÃO TESTADO |
| 23 | Não foram percebidos bugs visuais graves. | NÃO TESTADO |
| 24 | A fase está no nível visual esperado. | NÃO TESTADO |

Executar ida e volta, saltos, queda viva, morte/respawn em ambos os checkpoints,
combate nos dois sentidos, avisos de ataques, quatro estados da grade e
extremos da lâmina. Conferir transições de cenário e textos durante movimento,
aterrissagens, contornos, tutorial, indicação de setor, fim e sessão prolongada.

## 12. Arquivos e estado final do Git

Em relação ao M3-D local, o fix modifica **12 arquivos existentes**:

```text
README.md
scenes/ui/health_hud.tscn
scripts/art/ground_skin.gd
scripts/art/health_frame.gd
scripts/levels/cemetery_visual.gd
scripts/player/knight_visual.gd
scripts/enemies/skeleton_visual.gd
scripts/enemies/raven_visual.gd
scripts/props/damage_source.gd
scripts/props/oscillating_blade.gd
scripts/props/timed_spikes.gd
scripts/props/respawn_checkpoint.gd
```

E cria **cinco arquivos**:

```text
scripts/ui/cemetery_interface.gd
scripts/ui/cemetery_interface.gd.uid
tests/presentation_test.gd
tests/presentation_test.gd.uid
tests/VALIDACAO_M3_D_FIX01.md
```

As mudanças já presentes do M3-D em espada, numeral do checkpoint, ligação
da HUD, biblioteca PixelCanvas, teste de arte e relatório anterior foram
preservadas. Os UIDs existentes permanecem; dois novos foram gerados pela Godot.

Estado agregado em relação ao commit M3-C: **13 rastreados modificados e 14
novos**, nada staged. Branch `main`, HEAD igual ao baseline. `git diff --check`
sem erro de whitespace; referências e UIDs válidos. `.gitignore` intacto,
mantendo caches, temporários, exportações e credenciais fora do versionamento.
Histórico de documentação preservado e diff revisado.

**Não houve git add, commit, push, exportação ou publicação.**
**M3-E e M4 não iniciados. Encerrar e aguardar playtest/homologação manual.**
