# M3-C — Armadilhas e Checkpoints

03/11/2026. **M3-C — HOMOLOGADO FUNCIONALMENTE PELO RESPONSÁVEL.**

**Playtest manual: 22/22 PASSOU — Nenhuma observação.**
Homologação realizada e informada pelo responsável. Os resultados automatizados
abaixo são execuções anteriores do agente, distintas da aprovação humana.
A engine não foi reexecutada nesta etapa de documentação, auditoria e Git.

## Parte A — Publicação inicial no GitHub

Repositório exato autorizado:
https://github.com/spiritstonesrafa-ux/Cinzas-do-Jugamento.git
O nome remoto foi mantido, embora o jogo se chame Cinzas do Juramento.

Baseline inicial conferido: `main`, HEAD
`e79b4cd498049b4adea878ebca9053300dff74a1`, árvore e índice limpos, sem remotos.
Auditoria de sete commits locais e 114 blobs históricos: somente fontes e textos
Godot/documentais, sem padrões de credenciais encontrados, sem submódulos,
ponteiros LFS, caches, backups ou binários para publicar. O único e-mail nos
textos examinados era o do próprio responsável. Recursos visuais nativos e
originais; nenhum asset externo de terceiros incluído. `.gitignore` preserva
UIDs e exclui `.godot/`, temporários, exportações, ambientes e credenciais.
`git fsck --full` não encontrou erro de integridade; árvores soltas foram
informadas e preservadas, sem limpeza ou publicação como histórico acessível.
A verificação por padrões não garante detectar toda forma possível de segredo.

A consulta remota encontrou o commit raiz
`2aed34d4883d6ff98659a60506df9478a17df2bc`, “Initial commit”, contendo somente
LICENSE MIT de Rafael Alves. A publicação foi interrompida e o responsável
**autorizou explicitamente unir os dois históricos**, preservando a licença.
Foi configurado `origin` com a URL fornecida. A união sem conflitos acrescentou
apenas LICENSE à árvore do projeto e gerou um único commit adicional autorizado:

- Hash: **3695eb2b350837cc7622e025e2d05c350b3e2ffc**.
- Mensagem: `chore: une historicos e preserva licenca MIT`.
- Pais: M3-B3 `e79b4cd498049b4adea878ebca9053300dff74a1` e raiz remota
  `2aed34d4883d6ff98659a60506df9478a17df2bc`.
- Autoria local preservada: Rafael <spiritstonesrafa@gmail.com>.

A primeira tentativa foi rejeitada por GH007 (proteção do e-mail privado), sem
alterar a branch remota. O responsável ajustou a configuração do GitHub e
informou “ajustei”. O push seguinte concluiu, **sem força**, com upstream
`main → origin/main`. `git ls-remote` confirmou hash remoto igual ao local:
**3695eb2b350837cc7622e025e2d05c350b3e2ffc**. Nesse momento o índice e a árvore
estavam limpos. Foram publicados os nove commits acessíveis dos dois históricos,
a licença e a versão homologada; nenhum arquivo M3-C existia ainda.

Não houve tag, release, Actions, exportação executável ou deploy. Após confirmar
a publicação, começou a Parte B. Até encerrar aquela implementação, nenhum
commit ou push adicional foi feito. A autorização posterior de commit local
do M3-C está registrada na seção 13.

## Parte B — Implementação local

### 1. Baseline e auditoria

Baseline após publicação: `main`, rastreando `origin/main`, HEAD
`3695eb2b350837cc7622e025e2d05c350b3e2ffc`, árvore e índice limpos.
Foram consultados o pedido, README, GDD, arquitetura, roadmap, relatórios
anteriores, cena completa, seis setores, seis inimigos, contratos M1/M2,
checkpoint original, dano, invulnerabilidade, morte/queda e câmera.
Não há AGENTS.md aplicável nos diretórios consultados do projeto e pais.

O cenário tem 19 sólidos, vãos e degraus já homologados. A câmera usa 320×180,
limites existentes e antecipação subterrânea. Não foi alterada sua lógica.
Controles, movimento, espada, HP, proteção e IA dos inimigos permaneceram intactos.

### 2. Arquitetura

- **Espinhos fixos:** instância direta de `scenes/props/damage_source.tscn` do M2.
  Sem novo sistema de dano, código ou cena duplicada para esse tipo.
- **OscillatingBlade:** Area2D que estende DamageSource. Movimento cosenoidal
  limitado, tempo local e fonte circular de raio 10. Desenho circular coincide
  com o raio perigoso; corrente e fixação não têm colisão. Não persegue Aren.
- **TimedSpikes:** DamageSource com SAFE/WARNING/ACTIVE/RECOVER. Retrai forma e
  retorna dano zero fora de ACTIVE. `!` e hastes precedem a ativação; cores e
  dentes estendidos distinguem perigo e repouso. Física de prioridade -2 antes
  da consulta M2 evita divergência entre estado, forma e dano no mesmo tick.
- **CemeteryCheckpoint:** estende RespawnCheckpoint e delega ao M2 por `super`.
  Acrescenta somente ordem local 1/2 para recusar regressão ao checkpoint anterior.
  Cena pequena com o mesmo trigger 18×32 e RespawnPoint na própria bandeira.
  Não muda KnightController, validação de segurança, HP, morte ou queda.
- **Integração do nível:** o callback de restauração já existente também chama
  reset_hazard nos dois perigos com fase. O reset de inimigos foi mantido.
  Espinhos fixos não têm fase a reiniciar. Checkpoints mantêm sua progressão.
- **Apresentação:** substituídos avisos “CP FUTURO” por instruções de retorno.
  Um export do fundo oculta os contornos provisórios antigos somente na cena
  atual; seu padrão mantém a aparência da fixture histórica B3.

Camadas: perigos 32/máscara 16, sem monitoring; a hurtbox M2 consulta essas áreas.
Checkpoints 64/máscara 2, por contato de corpo. Nenhuma vida paralela, autoload,
gerenciador global, dependência ou asset externo novo.

### 3. Distribuição, parâmetros e justificativas

| Elemento | Coordenadas | Setor/piso | Parâmetros |
|---|---|---|---|
| GardenSpikes | (824,140) | 3, final do GraveSlabC, antes do desnível | Forma 20×12, visual base 24×12, dano 1 M2 |
| CryptBlade | origem (1384,176), X fixo, Y=148–204 | 4, piso CryptFloor Y=220 | Curso ±28, período 2,8 s, raio 10, âncora (1384,120) |
| CathedralTimed | (2016,156) | 6, CathedralFloor | SAFE 1,5 s; WARNING 0,6; ACTIVE 0,8; RECOVER 0,4; forma 24×12 |
| Checkpoint1 | (1176,180), respawn igual | Primeiro degrau após Jardim, setor 4 | Ordem 1, trigger 18×32 |
| Checkpoint2 | (1936,156), respawn igual | 5, piso firme após Ponte | Ordem 2, trigger 18×32 |

**Espinhos:** o setor 3 começa em X=768, mesmo antes do fim de GraveSlabC.
A posição 824 ensina o perigo antes dos patamares do Jardim, distante do corvo
em 1050. Pode-se saltar da área plana para o patamar ou no sentido inverso, sem
colocar espinhos em uma aterrissagem sobre vão. Há proximidade com o limite
oriental do encontro terrestre anterior: convém resolvê-lo antes de avançar.
Não se afirma que os alcances dos dois encontros nunca se aproximem; os ensaios
locais e o percurso real verificam uma solução, e o ritmo requer playtest.

**Lâmina:** ao fim do piso central, fora das escadas e sem modificar o teto.
Aren pode resolver o esqueleto pela esquerda e observar a lâmina; na volta,
pode aguardar no degrau à direita antes de descer. O corpo perigoso fica entre
X=1374–1394; há pontos de espera físicos em X=1354 e 1402, além do degrau em 1420.
A janela alta permite caminhar; não exige novas ações. Velocidade máxima no
padrão vertical é aproximadamente 62,8 px/s. Não há dano pela corrente.

**Grade temporizada:** X=2016, antes da região de ataque terrestre final.
O esqueleto tem limite mínimo X=2092 e alcance 24; a faixa perigosa termina
em X=2028. O jogador pode observar, esperar ou saltar a grade, e depois abordar
o encontro combinado. A posição não exige esquivar da grade e das duas fontes
ofensivas ao mesmo tempo. Foi testado combate final real enquanto o ciclo continua.

**Sem perigos novos nos setores 1, 2 ou 5.** A Ponte mantém todos os vãos e
aterrissagens livres, com seu corvo homologado no acesso firme. Total contido:
três armadilhas; nenhuma nova instância de inimigo no conteúdo jogável.

**CP1:** o antigo marcador (1040,156) fica no encontro do corvo. Todo o trecho
final plano do Jardim continua dentro de sua detecção potencial. Preferiu-se
segurança ao rótulo de setor: a bandeira fica 24 px após a fronteira nominal
1152, no primeiro degrau das Catacumbas, depois do encontro aéreo. No respawn,
o alvo do corvo teria Y≈166, diferença ≈54 para sua origem 112, fora do limite
vertical de aquisição 48. O esqueleto subterrâneo está separado em altura e
distância. O marcador de referência FutureCheckpoint1 acompanha a nova posição;
seu nome histórico foi mantido. Não foi alterado nenhum sólido.

**CP2:** aproveita o marcador (1936,156) em CathedralFloor, depois dos vãos,
ainda no setor 5 (fronteira 1984). Está longe do corvo da Ponte, do esqueleto
final e da grade. Não foi colocado no piso estreito antes dos saltos.
Ambos os respawns têm apoio físico, estão livres de formas perigosas e foram
observados por três segundos após retorno, com todos os sistemas ativos.

### 4. Checkpoints, morte e queda

Ativação somente ao contato, sem botão; azul inativo, âmbar ativo e marcas I/II.
CP2 desativa CP1. Passar novamente por CP1 mantém CP2 como destino. Não há save.
O protótipo M2 continua usando RespawnCheckpoint original sem essa especialização.

**Morte:** M2 valida o destino e retorna ao checkpoint ativo seguro, cura para 5,
limpa movimento/ataque e restaura o mundo pelo sinal já existente. Fallback de
segurança M2 permanece. **Queda viva:** retorna ao início (48,156), não cura,
não muda o checkpoint e reinicializa inimigos e fases das armadilhas. Não virou
morte nem retorno ao último checkpoint.

Lâmina começa alta após reset, tempo zero. Grade recomeça SAFE por 1,5 s.
Durante DEAD, o controlador não consulta dano; perigos podem continuar seu ciclo
até o reset. A proteção de 0,8 s permanece do M2. Contato contínuo com perigo
pode tirar outro HP depois dessa proteção, conforme contrato homologado; não é
um golpe infinito no mesmo frame. Armadilhas não afetam inimigos.

### 5. Inventário completo

Modificados (9):

- `README.md`.
- `scenes/levels/forgotten_cemetery.tscn`.
- `scripts/levels/forgotten_cemetery.gd`.
- `scripts/levels/cemetery_visual.gd`.
- `tests/cemetery_test.gd`.
- `tests/reachability_test.gd`.
- `tests/skeleton_test.gd`.
- `tests/raven_test.gd`.
- `tests/distribution_test.gd`.

Criados (16, incluindo cinco UIDs):

- `scenes/props/oscillating_blade.tscn`.
- `scenes/props/timed_spikes.tscn`.
- `scenes/props/cemetery_checkpoint.tscn`.
- `scripts/props/oscillating_blade.gd` e `.uid`.
- `scripts/props/timed_spikes.gd` e `.uid`.
- `scripts/props/cemetery_checkpoint.gd` e `.uid`.
- `tests/fixtures/m3_b3_main.tscn`.
- `tests/fixtures/m3_b3_cemetery.tscn`.
- `tests/fixtures/m3_b3_stage.gd` e `.uid`.
- `tests/mechanisms_test.gd` e `.uid`.
- `tests/VALIDACAO_M3_C.md`.

As cinco suítes B3/terreno/inimigos alteradas mudaram **somente o caminho de cena**
para a fixture B3. A fixture de nível é o snapshot do HEAD publicado com o script
histórico também preservado; o main carrega esse snapshot. Todas as asserções e
quantidades dos testes anteriores foram mantidas. Assim, expectativas históricas
como “CP futuro não ativa” e “travessia sem armadilhas” continuam medindo seu marco.
A suíte M3-C carrega `scenes/main.tscn` real e valida os novos contratos/integrados.
Não se apresenta a regressão isolada como prova de integração com os perigos novos.
M0/M1/M2, scripts de Aren, espada, HP, contratos base de dano/checkpoint, scripts
ou cenas reutilizáveis dos inimigos e relatórios homologados não foram alterados.

### 6. Resultados reais da implementação anterior

Godot **4.7.2.stable.official.ed1daf0bf**, executável console:
`C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`.

| Execução | Verificações | Falhas | Código |
|---|---:|---:|---:|
| Importação inicial e final | — | — | 0 |
| Inicialização headless, 60 ticks | — | — | 0 |
| M0 — smoke_test | 14 | 0 | 0 |
| M1 — combat_test | 36 | 0 | 0 |
| M2 — survival_test | 59 | 0 | 0 |
| M3-A — cemetery_test | 52 | 0 | 0 |
| FIX01 — reachability_test | 35 | 0 | 0 |
| M3-B1 — skeleton_test | 49 | 0 | 0 |
| M3-B2 — raven_test | 63 | 0 | 0 |
| M3-B3 — distribution_test | 115 | 0 | 0 |
| M3-C — mechanisms_test | 77 | 0 | 0 |
| **Total final** | **500** | **0** | **0** |
| Execução gráfica/captura | 11 imagens | — | 0 |

FIX01 inclui 120 ensaios físicos agregados nos 35 checks. Nenhuma contagem foi
somada duas vezes. As suítes antigas continuam cobrindo seus snapshots; o teste
M3-C herda helpers de input/combate B3, mas sobrescreve _run para o cenário real.

As 77 verificações incluem:

- Coordenadas dos seis inimigos preservadas e contagem exata 3 perigos/2 CPs.
- Início seguro, respawns fisicamente apoiados e checkpoints sem ativação precoce.
- Dano estático, proteção de 0,8 s, novo dano após proteção, HUD e salto nos dois lados.
- Duas voltas completas de movimento da lâmina dentro dos limites, repetição
  determinística após reset, dano de 1, proteção e ausência de contato fora do raio.
- Passagem física da lâmina nos dois sentidos após observar a janela alta.
- Grade SAFE/WARNING/ACTIVE/RECOVER, aviso ≥0,5 s observado antes de ativar,
  forma/contrato ativo somente no perigo, duração configurável e saltos nos dois lados.
- Três esqueletos de teste temporários, um por perigo, com IA processando e
  patrulha de largura zero: sobreposição ambiental real sem perda dos 3 HP.
  Removidos antes da integração; não fazem parte dos seis inimigos da fase.
- Morte realmente causada por contato contínuo com espinhos, um respawn seguro,
  cura e ciclo restaurado, sem loop de morte.
- Ativação e sinal único CP1, passagem CP2, não regressão na volta, três mortes
  consecutivas em CP2 e retorno/cura corretos. Morte em CP1 e espera de três
  segundos segura em cada checkpoint; câmera alinhada após respawn em CP2.
- Queda viva preserva 4 HP, retorna ao início, mantém CP2 e restaura todos os
  inimigos, lâmina alta e grade SAFE.
- Combate final com as duas espécies e grade processando: ambos derrotados pela
  espada M1 real, sem reposição entre adversários e com 5 HP ao terminar.

Unidades dos perigos desativam explicitamente o processamento dos seis inimigos
originais, com fontes restauradas/inativas. Mantêm física real de Aren e contratos
M1/M2. Integrações de checkpoints, restauração, combate e percurso reativam os seis.
Fixtures posicionam Aren e resetam o mundo **entre** cenários, não durante o percurso
ou entre participantes do combate final. Sondagem de tempos da grade usa valores
curtos temporariamente e restaura os padrões antes das integrações.

### 7. Navegabilidade e justiça

Cenário real M3-C: percurso contínuo até (2288,156) e volta ao início, com
inimigos e mecanismos ativos. **Ida 5→4 HP; volta 4→3 HP**, sem morte, cura,
teleporte, reinício de fase ou retorno ao início durante os percursos.
CP1 e CP2 são ativados pelo contato real na ida e CP2 permanece na volta.
Foram atravessados os seis setores, degraus, passagens inferiores e Ponte;
câmera inteira e dentro dos limites, marcadores de fim acessíveis.

Os ensaios específicos demonstram soluções sem dano para cada perigo e para o
combate final com a grade funcionando. O percurso completo não foi certificado
sem dano, nem foram varridas todas as fases possíveis de patrulha e armadilhas.
Dano observado no bot não prova dano inevitável. A ausência universal de dano
obrigatório não foi provada para todas as condições possíveis pela automação.
O responsável posteriormente homologou a dificuldade e o percurso, conforme
seção 12; os limites das simulações permanecem.
As esperas e saltos usam inputs e colisões reais, não apenas posições geométricas.

### 8. Diagnóstico de desenvolvimento e inspeção visual

Primeira suíte C: 69 checks, uma falha na volta. O bot não retomava a caminhada
após aguardar a lâmina. Foi corrigida a política de teste para aguardar antes
de descer o degrau, considerar a frenagem, limpar o contador de bloqueio durante
espera deliberada e retomar o input. Nenhuma correção na física ou geometria foi
necessária. Log inicial preservado em `.godot/c-mechanisms-initial.log`.
Versão intermediária: 72 checks sem falhas; depois foram acrescidos cinco checks
de contatos ambientais em inimigos e morte por espinhos. Resultado final: 77/0.

Execução gráfica nativa, Compatibility, NVIDIA GeForce RTX 2060 SUPER. Onze
capturas do viewport 320×180 foram abertas e inspecionadas:

- `.godot/c-visual-start.png`: região inicial segura.
- `.godot/c-visual-spikes.png`: dentes visíveis antes do patamar.
- `.godot/c-visual-blade-high.png` e `blade-low.png`: curso e corrente legíveis.
- `.godot/c-visual-timed-safe.png`: placa retraída.
- `.godot/c-visual-timed-1.png`: WARNING com ! e hastes.
- `.godot/c-visual-timed-2.png`: dentes ACTIVE.
- `.godot/c-visual-timed-3.png`: RECOVER retraído.
- `.godot/c-visual-cp1-active.png` e `cp2-active.png`: bandeiras âmbar I/II.
- `.godot/c-visual-final.png`: espaço entre a grade e o combate combinado.

Instrumentação `.godot/c_visual.gd` usa cenários reposicionados entre capturas,
IA ativa e encerra automaticamente. Não é playtest humano contínuo. Não foram
medidos FPS/latência. As formas provisórias são originais, sem arte definitiva.
A câmera permitiu enxergar os perigos, bandeiras e pontos de espera nas capturas.
Não foi criada uma exportação de produção.

Persistem `Failed to read the root certificate store` e, nas importações, falha
ao salvar `C:/Users/ovohe/AppData/Roaming/Godot/editor_settings-4.7.tres`.
São diagnósticos de ambiente Windows/perfil já conhecidos; os processos finais
concluíram com código 0, sem erro observado de script ou recurso. Nenhuma mudança
de certificados/permissões foi realizada. Avisos Git LF/CRLF referem-se à política
existente de final de linha, sem corrupção ou erro de whitespace.

### 9. Verificação estática e limitações

Comparação contra o HEAD publicado verifica os seis blocos de inimigos e todos
os sólidos/sub-recursos físicos preservados. Alterações de blocos existentes
limitadas a Backdrop (ocultar contornos antigos) e marcador FutureCheckpoint1.
Câmera e controlador de Aren não foram alterados. As fixtures preservam o código
e as cenas B3 do baseline, com apenas os caminhos de referência adaptados.
UIDs novos foram gerados/importados pela Godot e mantidos como fontes.

Cenários novos são configuráveis, mas novos valores/posições exigem testes.
A trajetória da lâmina atual é livre de sólidos e pontos de respawn, não foi
criado sistema de colisão mecânica com paredes ou pathfinding para trajetórias
arbitrárias. Checkpoints são só para esta fase/sessão; não há persistência.
CP1 fica no começo do setor 4 por segurança, não no antigo ponto do Jardim.
A identidade greybox e a dificuldade receberam a homologação manual informada
pelo responsável, conforme seção 12; isso não substitui as limitações técnicas.

### 10. Roteiro manual original — registro histórico

Roteiro preparado na implementação, preservado sem preencher retroativamente
as linhas originais. O resultado recebido é 22/22 nas categorias informadas
pelo responsável, listadas na seção 12. As marcações NÃO TESTADO abaixo são
o estado histórico do roteiro, não uma pendência atual de homologação.
Instrução original: preencher PASSOU, FALHOU ou NÃO TESTADO e observações.

| # | Verificação | Resultado |
|---|---|---|
| 1 | Setor inicial permanece seguro. | NÃO TESTADO |
| 2 | Espinhos visíveis e evitáveis nos dois sentidos. | NÃO TESTADO |
| 3 | Espinhos causam dano corretamente. | NÃO TESTADO |
| 4 | Lâmina oscilante previsível e corrente inofensiva. | NÃO TESTADO |
| 5 | Lâmina permite passagem sem dano, inclusive na volta. | NÃO TESTADO |
| 6 | Armadilha temporizada possui aviso legível. | NÃO TESTADO |
| 7 | Grade alterna estados visualmente coerentes. | NÃO TESTADO |
| 8 | Invulnerabilidade funciona com os três perigos. | NÃO TESTADO |
| 9 | CP1 ativa e muda a bandeira para âmbar. | NÃO TESTADO |
| 10 | CP2 ativa e não regride ao passar por CP1. | NÃO TESTADO |
| 11 | Morte retorna ao checkpoint ativo correto. | NÃO TESTADO |
| 12 | HP é restaurado após morte. | NÃO TESTADO |
| 13 | Queda viva retorna ao início, sem curar HP. | NÃO TESTADO |
| 14 | Inimigos e fases das armadilhas são restaurados. | NÃO TESTADO |
| 15 | Respawn não causa dano imediato. | NÃO TESTADO |
| 16 | Travessia completa de ida. | NÃO TESTADO |
| 17 | Travessia completa de volta. | NÃO TESTADO |
| 18 | Ponte continua navegável e sem armadilhas novas. | NÃO TESTADO |
| 19 | Encontro final permanece justo após a grade. | NÃO TESTADO |
| 20 | Câmera, movimentação e espada permanecem funcionais. | NÃO TESTADO |
| 21 | Dificuldade geral e ritmo continuam equilibrados. | NÃO TESTADO |
| 22 | Ausência de travamentos/bloqueios e desempenho adequado. | NÃO TESTADO |

### 11. Git ao encerrar a implementação — registro histórico

M3-C local: nove arquivos rastreados modificados e 16 novos, conforme inventário.
Índice vazio; HEAD/branch permanecem no commit publicado de união, sem commit
adicional durante ou após esta implementação. `.gitignore` intacto, caches,
capturas, logs e instrumentação em `.godot/`, excluídos do versionamento.
Nenhum token ou credencial acrescentado. Licença MIT preservada.

**Estado histórico: M3-C não commitado, não publicado e pendente de playtest.**
Posteriormente recebeu homologação e autorização de commit local conforme
seções 12 e 13. M3-D não iniciado.
M3-E/M4 também não iniciados. Não houve novo push, deploy, release, tag ou
exportação executável. Encerrar e aguardar o responsável antes de qualquer
novo commit, publicação ou avanço de marco, conforme condição daquela entrega.

### 12. Homologação manual informada pelo responsável — 03/11/2026

**M3-C — HOMOLOGADO FUNCIONALMENTE PELO RESPONSÁVEL.**

**Playtest manual: 22/22 PASSOU — Nenhuma observação.**

O responsável realizou o playtest completo no Godot e aprovou:

1. Espinhos visíveis.
2. Dano dos espinhos.
3. Salto sobre espinhos.
4. Lâmina oscilante.
5. Esquiva da lâmina.
6. Armadilha temporizada.
7. Ciclo de ativação.
8. Invulnerabilidade.
9. Checkpoint 1.
10. Checkpoint 2.
11. Morte no CP1.
12. Morte no CP2.
13. Queda com vida.
14. Restauração dos inimigos.
15. Respawn seguro.
16. Percurso de ida.
17. Percurso de volta.
18. Ponte das Almas.
19. Encontro final.
20. Controles e câmera.
21. Dificuldade geral.
22. Estabilidade.

Decisão do responsável: M3-C homologado funcionalmente, sem correção obrigatória
identificada. A homologação foi realizada e informada pelo responsável; não é
uma auditoria independente nem um playtest executado pelo agente nesta tarefa.

Preservados os resultados automatizados anteriores: 500/500 verificações,
incluindo 423 dos marcos anteriores e 77 do M3-C, importação/inicialização,
11 capturas, ida 5→4 HP, volta 4→3 HP, travessias locais e combate final sem dano.
Diagnósticos Windows, falhas históricas de desenvolvimento e limitações técnicas
permanecem documentados. A homologação humana não amplia a cobertura dos testes.

Nesta etapa somente README e relatório receberam alterações documentais.
Engine e suítes não foram reexecutadas. Implementação, cenas, parâmetros,
coordenadas e regras homologadas foram preservados. M3-D não iniciado.

### 13. Auditoria final e versionamento local

Estado inicial conferido nesta tarefa: repositório exato do projeto, branch
`main`, HEAD `3695eb2b350837cc7622e025e2d05c350b3e2ffc`, nove arquivos
modificados, 16 novos e índice vazio. Inventário igual ao da seção 5, sem
alterações inesperadas. Autoria local existente preservada: Rafael
<spiritstonesrafa@gmail.com>. Remoto e autenticação não alterados.

Somente README e este relatório foram editados nesta etapa. As armadilhas,
checkpoints, regras de morte/queda, testes, fixtures e cinco UIDs foram
preservados. Conferências estáticas abrangem integridade de cenas, referências
res://, IDs de recursos, UIDs únicos, ausência de dependências detectavelmente
quebradas, preservação dos sistemas anteriores, histórico documental, padrões
de credenciais, arquivos indevidos, `.gitignore`, whitespace e integridade Git.
`git diff --check` passou. `git fsck --full` concluiu sem erros de integridade;
sete árvores soltas foram informadas e preservadas sem limpeza. A consulta
remota confirmou `3695eb2b350837cc7622e025e2d05c350b3e2ffc` antes do commit.
A revisão integral do diff staged antecede o commit.

Entrega autorizada para exatamente um commit local:
`feat(m3-c): homologa armadilhas e checkpoints`, com os 25 arquivos da seção 5.
Hash, autoria, quantidade e inventário são conferidos após o commit; limpeza da
árvore/índice e HEAD remoto também são verificados e informados ao responsável.
Caches, temporários, capturas e logs ficam fora do commit; UIDs necessários
permanecem como fontes. Nenhuma nova execução de engine/testes foi declarada.

O M3-C deve permanecer exclusivamente local. **Sem push, deploy, exportação,
release ou tag. M3-D, M3-E e M4 não iniciados.** Encerrar após o único commit
verificado e aguardar a próxima autorização.
