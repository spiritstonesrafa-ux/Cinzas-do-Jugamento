# M4-C — Conclusão do Guardião do Juramento

**M4-C — HOMOLOGADO FUNCIONAL E VISUALMENTE PELO RESPONSÁVEL.**

## Homologação final informada pelo responsável — 04/11/2026

**M4-C — HOMOLOGADO FUNCIONAL E VISUALMENTE PELO RESPONSÁVEL.**

**Playtest manual: 13/13 PASSOU — Nenhuma observação.**

**Validação automatizada anterior: 1013/1013 PASSOU.**

O responsável realizou o playtest humano e aprovou os itens abaixo. O agente
registra essa aprovação; não afirma ter realizado o playtest humano nem infere
aprovação individual dos 30 itens do checklist técnico histórico.

| Nº | Item informado pelo responsável | Resultado |
|---|---|---|
| 1 | Golpe final | PASSOU |
| 2 | Animação de derrota | PASSOU |
| 3 | Dissipação da maldição | PASSOU |
| 4 | Armadura persistente | PASSOU |
| 5 | Barra de vida | PASSOU |
| 6 | Texto narrativo | PASSOU |
| 7 | Controle de Aren | PASSOU |
| 8 | Saída e retorno | PASSOU |
| 9 | Reentrada após vencer | PASSOU |
| 10 | Morte após vencer | PASSOU |
| 11 | Morte antes de vencer | PASSOU |
| 12 | Imagem e fluidez | PASSOU |
| 13 | Sensação de conclusão | PASSOU |

**O primeiro chefe e a conclusão da primeira fase estão homologados.**
Guardião mantido como chefe introdutório: HP, dano, velocidades, quatro padrões,
tempos, cooldowns, recuperações e transformação aos 50% preservados. Nenhum
rebalanceamento, próxima região, segundo chefe ou novo marco foi iniciado.
A próxima região permanece pendente do roadmap; o jogo inteiro não está concluído.

Resultados anteriores preservados: 946 herdados + 59 funcionais + oito de
resolução; execução gráfica 67/67, importação/inicialização aprovadas,
17 capturas em quatro resoluções, sessão de 45,001 s, média 59,999 FPS,
p95 17,048 ms, máximo 17,378 ms e 182 nós estáveis. Suítes, importação,
startup e benchmark não foram repetidos nesta etapa. Houve apenas consulta
auxiliar de integridade da configuração e do PNG na Godot 4.7.2, sem carregar
a cena jogável, sem novos resultados de combate ou desempenho.

Autorizado exatamente um commit local M4-C. Sem push, tag, release ou
sincronização automática. Próximo marco depende de nova autorização.

## Auditoria documental e de versionamento — 04/11/2026

Diretório confirmado: C:\PROJETOS\CINZAS DO JURAMENTO. Branch main,
HEAD inicial `0cd1285f47987477f4ec620978ae9f6d6ec64ea2`, índice vazio.
M4-B confirmado no histórico, autoria local Rafael <spiritstonesrafa@gmail.com>.
Referência local origin/main: `ab003475e4a39bc5d0b40d33292b54fd5c745404`;
um commit local à frente inicialmente. Sem fetch, pull ou push nesta tarefa.

Estado real: **oito** rastreados modificados, não sete: os sete da entrega e
`project.godot`, alterado depois do inventário anterior. Dez novos M4-C e
14 não rastreados anteriores. Os 17 arquivos da entrega coincidiram por
SHA-256 com final_inventory.json; os 14 anteriores também coincidiram com o
manifesto histórico. Sem arquivo desconhecido incluído por suposição.

### Diferença local de project.godot — fora do commit

Diff restrito à omissão de window/stretch/aspect="keep", expansão do evento
InputEventKey da tecla J e uma linha vazia. Consulta auxiliar na Godot 4.7.2
confirmou aspecto efetivo "keep", modo "canvas_items", tecla física 74 e
device 16 tanto no baseline carregado por ConfigFile quanto no estado atual.
O evento de auditoria device 16 correspondeu a attack; device 0 não correspondeu
na configuração atual. Não se alterou o input nem se apresenta essa consulta
como teste manual de teclado. Nenhuma divergência funcional demonstrada.
A diferença é compatível com serialização do editor e não pertence ao M4-C;
**arquivo preservado integralmente, sem staging**, SHA-256 63fddfb499d59cd3ae9b5b70d7d4a8816ccfd8586486c6cfcc3023733bcdcec9.
Não foi restaurado, sobrescrito ou normalizado para limpar a pasta de trabalho.

A consulta auxiliar verificou atlas 1265x1244 e alpha blend (2), exit 0.
Uma tentativa inicial usava API de valor inicial indisponível e foi corrigida
somente no script de auditoria ignorado; logs preservados. Diagnóstico de
certificados e aviso de carregar PNG diretamente referem-se à consulta local,
não a uma exportação: runtime mantém preload de textura importada homologado.
Nenhuma suíte ou benchmark foi novamente executado.

### Classificação individual dos 14 arquivos anteriores

Nenhum pertence ao M4-C ou é necessário ao runtime do jogo. Os dez PNGs de
capturas M3-D já estão rastreados; seus sidecars locais não são dependências
runtime. Referências locais não são assets usados pelas cenas/scripts.
Decisão por arquivo:

| Caminho | Finalidade | M4-C? | Execução necessária? | Versionar nesta entrega? |
|---|---|---|---|---|
| `The Art of the Pixel.jpg` | Imagem de referência visual fornecida pelo responsável; não é asset runtime. | Não | Não | Não; preservar local |
| `The Art of the Pixel.jpg.import` | Metadados Godot da imagem de referência local correspondente. | Não | Não | Não; preservar local |
| `The Siege and the Sandfox _ Le metroidvania en 2D de Cardboard Sword et PLAION sortira le 20 mai sur PC.jpg` | Imagem de referência visual fornecida pelo responsável; não é asset runtime. | Não | Não | Não; preservar local |
| `The Siege and the Sandfox _ Le metroidvania en 2D de Cardboard Sword et PLAION sortira le 20 mai sur PC.jpg.import` | Metadados Godot da imagem de referência local correspondente. | Não | Não | Não; preservar local |
| `tests/evidencias/m3d/fix03-after-sector1.png.import` | Sidecar Godot da captura histórica M3-D do setor 1. | Não | Não | Não; preservar local |
| `tests/evidencias/m3d/fix03-after-sector2.png.import` | Sidecar Godot da captura histórica M3-D do setor 2. | Não | Não | Não; preservar local |
| `tests/evidencias/m3d/fix03-after-sector3.png.import` | Sidecar Godot da captura histórica M3-D do setor 3. | Não | Não | Não; preservar local |
| `tests/evidencias/m3d/fix03-after-sector4.png.import` | Sidecar Godot da captura histórica M3-D do setor 4. | Não | Não | Não; preservar local |
| `tests/evidencias/m3d/fix03-after-sector5.png.import` | Sidecar Godot da captura histórica M3-D do setor 5. | Não | Não | Não; preservar local |
| `tests/evidencias/m3d/fix03-after-sector6.png.import` | Sidecar Godot da captura histórica M3-D do setor 6. | Não | Não | Não; preservar local |
| `tests/evidencias/m3d/fix03-attack--1-8.png.import` | Sidecar Godot da captura histórica de ataque horizontal M3-D. | Não | Não | Não; preservar local |
| `tests/evidencias/m3d/fix03-attack-1-8.png.import` | Sidecar Godot da captura histórica de ataque horizontal M3-D. | Não | Não | Não; preservar local |
| `tests/evidencias/m3d/fix03-detail-cp1-active.png.import` | Sidecar Godot da captura histórica de checkpoint ativo M3-D. | Não | Não | Não; preservar local |
| `tests/evidencias/m3d/fix03-detail-cp2-active.png.import` | Sidecar Godot da captura histórica de checkpoint ativo M3-D. | Não | Não | Não; preservar local |

Todos permanecem no disco, inalterados e fora do índice. Os arquivos .uid e
.import que pertencem a scripts/texturas runtime M4-C são incluídos; não são
confundidos com sidecars documentais acima.

### Recursos, segurança e seleção

PNG inspecionado visualmente: quatro poses, alpha preservado, dimensões reais
1265x1244, sem edição do original. Proveniência e prompt lidos. Recortes,
âncoras, animação 2,6 s, guardas de estados, limpeza de perigos, controle de
Aren, HUD, retorno e persistência conferidos nos scripts/cena e comparados
com a implementação homologada. UIDs/referências locais auditados; todas as
dependências runtime estão rastreadas ou na seleção M4-C. Nenhum código,
cena, parâmetro ou recurso gráfico foi alterado nesta etapa.

.gitignore preservado: .godot/, temporários, logs, exports/build/dist,
ambiente, credenciais e chaves ficam fora do commit. Padrões de segredos
verificados nos arquivos selecionados; nenhum encontrado. Verificações Git,
whitespace e diff final/staged devem encerrar a preparação do commit.

A seleção contém **17 arquivos**: sete modificados e dez novos. ROADMAP.md
é incluído como documentação do próprio M4-C já presente na entrega e para
sincronizar a homologação sem anunciar outro marco; justificativa restrita
à coerência documental. project.godot e os 14 anteriores ficam de fora.
Relatórios/evidências históricos abaixo são preservados, inclusive limitações,
diagnósticos e checklist original. O novo quadro oficial de 13 itens acima
é a homologação recebida, sem converter o antigo checklist de 30 por inferência.

## Histórico técnico da implementação — preservado

Data: 04/11/2026 (conclusão; trabalho iniciado em 03/11/2026). Windows, Godot 4.7.2 ed1daf0bf, Compatibility/OpenGL,
RTX 2060 SUPER. Validação técnica do agente não constitui homologação humana.

## 1. Etapa A concluída: homologação e único commit M4-B

Pasta C:\PROJETOS\CINZAS DO JURAMENTO, branch main. Baseline conferido:
ab003475e4a39bc5d0b40d33292b54fd5c745404, M4-A publicado. Seis modificados,
13 novos M4-B, índice vazio e 14 arquivos locais anteriores preservados.
README, relatório, roadmap, GDD/lore, scripts/cenas, PNGs, proveniências,
UIDs, referências, .gitignore, diff staged integral e padrões de segredos
foram auditados. Sem AGENTS.md aplicável encontrado no projeto/pais consultados.

O responsável homologou funcionalmente o M4-B: ataques, transformação, segunda
fase, efeitos, morte de Aren, reinício e estabilidade normais; nenhum bug
relatado. Confirmação: “Sim, tudo funcionando normal.” Aprovação geral,
**sem inferir 29/29 respostas individuais**. Resultados anteriores 946/946,
29 capturas 4K, duelos e métricas preservados como histórico, sem alegar
reexecução na etapa documental A. O checklist histórico não foi falsamente
preenchido. Apenas uma linha vazia extra no EOF de um teste foi normalizada
para passar git diff --check; nenhuma asserção ou comportamento foi alterado.

**Decisão oficial: Guardião mantido como chefe introdutório.** Ser fácil não
é defeito. ROADMAP registra ensino de leitura, esquiva/posicionamento,
contra-ataques e recuperação; próximo chefe deverá elevar domínio/padrões com
justiça, não apenas HP/dano. Nenhum próximo chefe foi desenvolvido.

Único commit local criado: **0cd1285f47987477f4ec620978ae9f6d6ec64ea2**.
Mensagem: `feat(m4-b): homologa combate avancado do guardiao`.
Branch main. Rafael <spiritstonesrafa@gmail.com>. Objeto commit e arquivos
validados, parent ab003475, índice vazio após criação. **Nenhum push nesta tarefa.**
O desenvolvimento M4-C começou somente depois da validação desse commit.

Arquivos incluídos (20):

```text
README.md
ROADMAP.md
assets/art/m4a/M4_B_ANIMATION.md
assets/art/m4b/PROVENANCE.md
assets/art/m4b/oath_flame.png
assets/art/m4b/oath_flame.png.import
scripts/boss/boss_hud.gd
scripts/boss/encounter.gd
scripts/boss/guardian.gd
scripts/boss/guardian_attack.gd
scripts/boss/guardian_visual.gd
scripts/boss/oath_wave.gd
scripts/boss/oath_wave.gd.uid
tests/VALIDACAO_M4_B.md
tests/boss_advanced_test.gd
tests/boss_advanced_test.gd.uid
tests/boss_performance_test.gd
tests/boss_performance_test.gd.uid
tests/boss_visual_test.gd
tests/boss_visual_test.gd.uid
```

## 2. Escopo M4-C e preservação

Um Node2D Conclusion dentro da cena do Guardião apresenta a derrota; não há
novo manager global, save, IA ou sistema cinematográfico genérico. A máquina
de combate, quatro padrões, HP 10, dano 1, velocidade de perseguição 34,
investida 144/72, telegrafias, cooldowns, recuperações e fase 2 aos 50% foram
preservados byte a byte nos scripts guardian.gd/guardian_attack.gd/oath_wave.gd.
Aren, espada, vida, checkpoints, geometria/câmera da fase, arte M3, sprites de
combate do boss, project.godot e DISPLAY01 permanecem iguais ao commit M4-B.

A cena guardian.tscn apenas acrescenta o recurso/filho Conclusion. Renderers
existentes delegam apresentação somente após derrota; durante a luta seus
ramos/recursos homologados continuam os mesmos. Arena não foi reconstruída.
Não há segunda fase do jogo, região/chefe novo, item, habilidade ou recompensa.

## 3. Sequência de derrota e reação do mundo

| Tempo após HP zero | Apresentação |
|---|---|
| imediato | M4-B já cancela IA, hitboxes, receiver e onda; sinal local inicia apresentação uma vez |
| 0–0,40 s | pose específica de impacto/recuo, deslocamento máximo de 2 px; barra zero some em 0,55 s |
| 0,40–1,10 s | joelho ao chão, armadura cede e espada baixa |
| 1,10–1,90 s | colapso e energia desprendendo-se das juntas; três fragmentos raster, sem fontes de dano |
| 1,90–2,60 s | armadura vazia, elmo e espada ao chão; energia dissipa |
| após 2,60 s | casco final permanece; iluminação da Catedral ligeiramente mais calma |

O sprite não desaparece instantaneamente. As quatro poses são exclusivas da
derrota; efeitos são ancorados ao corpo/armadura e reutilizam a chama M4-B.
Nenhuma explosão genérica, hitbox decorativa ou debug geometry nova foi usada.

Aren conserva movimento, salto e espada: não há pausa da árvore, slow motion,
input bloqueado, shake, zoom ou mudança de posição da câmera. O portão abre
**imediatamente ao HP zero**, como homologado no M4-A/B; não se atrasa a saída
para obrigar a assistir. Caminhar para fora cedo conclui a apresentação com
segurança e conserva o casco final para reentrada.

## 4. Narrativa, HUD e continuidade

README, GDD e ROADMAP foram lidos antes dos textos. Aren é o cavaleiro
amaldiçoado ligado a um juramento quebrado; o Guardião é o antigo protetor da
Catedral. O plano macro do GDD v0.1 tem nomes provisórios anteriores; ROADMAP
agora explicita o cânone implementado: O Cemitério dos Esquecidos/Guardião.
Não se usa o plano provisório para anunciar uma região jogável inexistente.

Textos breves, em português brasileiro:

- “JURAMENTO ROMPIDO”
- “O Cemitério dos Esquecidos — concluído”
- “Um elo da maldição se rompe.”
- “A jornada de Aren continua.”
- “Retorne pelo selo à esquerda.”

Um elo, não a maldição inteira, é rompido. Nenhum acontecimento futuro
confirmado, item ou habilidade é inventado. Não há diálogo longo ou voz nova.
O painel ocupa a faixa superior lógica, acima dos personagens no chão. A
barra do boss cede ao texto; após nove segundos fica uma indicação compacta.
Vida original de Aren permanece visível e ligada ao M2. Não há pixels físicos
fixos na HUD: tudo usa referência 320x180 e escalonamento homologado.

A saída continua no selo esquerdo e retorna ao cemitério em (2296,156), com
câmera, ordem visual, HUD e processamento dos inimigos/perigos restaurados.
Na área do fim, o adaptador substitui somente o aviso provisório antigo por
“CEMITÉRIO CONCLUÍDO · exploração livre”, incluindo atualização do renderer
em cache. HUD M3 e mapa não foram reescritos. Fora dessa faixa, as mensagens
normais do estágio voltam a valer. O jogador pode continuar explorando a
versão atual e revisitar a sala vazia; não há acesso funcional à próxima fase.

## 5. Estado, concorrência e persistência

`played/running/settled` guardam execução única, andamento e casco final.
Contadores locais verificam que sinais duplicados não repetem conclusão.
A apresentação escuta defeated/state_changed e died; sinais têm guardas,
sem tweens, corrotinas soltas ou temporizadores que sobrevivam a um reset.

- Vitória e reentrada: estado apenas em RAM nesta sessão; sem replay da luta
  ou cinematic. Portão aberto, chefe inerte e armadura persistente.
- Saída precoce: settle imediato, texto longo dispensado, retorno liberado.
- Morte de Aren na luta/transformação: M2 e checkpoints homologados fazem reset.
- Morte durante a derrota: apresentação cancela imediatamente; respawn normal
  reseta HP/fase/conclusão e permite nova tentativa. Vitória ainda não mantida
  fora da sala não ganha uma persistência nova.
- Queda viva/abandono pela regra existente: sem cura, encontro reinicializado.
- Morte no cemitério depois de sair: conserva a regra da sessão M4-A/B; não
  apaga a vitória da sala já concluída. F8/F5 abre sessão nova.
- Último golpe e contato no mesmo tick: fonte fica inativa antes da consulta
  defensiva, mesmo se o shape físico aguardar atualização diferida.
- Morte concorrente antes do sinal de derrota: o guard de vida impede iniciar
  a apresentação; o respawn limpa o completed transitório do adaptador.

Sem dano invisível pós-HP-zero, bloqueio corporal novo, câmera presa ou espera
obrigatória. Vitória natural em fase 1 não ocorre com dano 1, HP 10 e limiar
50%; um fixture de HP 1/fase 1 exercita esse ramo defensivamente, sem alterar
parâmetros de produção ou alegar que ele ocorreu no duelo natural.

## 6. Arte, proveniência e áudio

Novo `assets/art/m4c/guardian_defeat.png`: **1265x1244 RGBA**, quatro células,
alpha verificado, escala 0,125. Atlas aprovado do M4-A foi fornecido ao
image_gen integrado como referência de identidade, preservando elmo,
relicário, aço, bronze, manto vinho e espada. O resultado foi copiado sem
edição para o projeto; nenhum sprite de combate foi sobrescrito.
Prompt integral, método e origem em `assets/art/m4c/PROVENANCE.md`.
Âncoras/recortes no script local, sem paths runtime fora do projeto.
A borda transparente extra de 1 px à direita não altera recortes/células.

Inspeção visual de quadros consecutivos incluiu impacto, colapso, dissipação,
armadura final, texto, saída e retorno. Não se afirma animação raster de alta
contagem de frames ou pintura manual pixel a pixel; são quatro poses com
movimento/efeitos locais. Qualidade artística final depende da homologação.

Não foram encontrados AudioStream/sistema sonoro ou WAV/OGG/MP3 apropriados
no projeto. **Sem áudio nesta entrega**, sem instalar dependência ou usar som
comercial. Ausência de áudio não bloqueia vitória ou retorno.

## 7. Verificações realmente executadas

**1013 verificações distintas aprovadas:** 946 herdadas, 59 novas físicas/
funcionais e oito novas de resolução/referência lógica. As 59 foram repetidas
na execução gráfica (67/67 com os oito checks gráficos); não são somadas duas
vezes. Verificação auxiliar de gravação M4-B passou 1/1, separada do total.

| Suíte herdada reexecutada | PASSOU | Falhas |
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
| boss_advanced | 152 | 0 |

M4-C headless final: **59/59**. Gráfico final: **67/67**. Zero script/parsing
errors. Importação e inicialização aprovadas, exit 0. Nenhum teste antigo foi
removido ou enfraquecido. Após corrigir o aviso em cache, repetidos os 59/67
novos e os 59 M4-A/152 M4-B, além de startup e medição gráfica final. Os demais
735 já haviam passado nesta tarefa; seus arquivos permanecem idênticos.

Cobertura nova inclui: entrada real, intro e combate preservados; duelo de
**dez golpes reais J**, 28,15 s, 5/5 HP ao vencer, sem cura/teleporte/freeze
ou mutação de dano dentro do duelo; progressão temporal das quatro poses;
fontes e projétil limpos; single-shot; movimento/salto durante sequência;
HUD/textos/câmera; quatro resoluções nativas; retorno e reentrada; golpes
finais durante ataque/recuperação/onda; sweep sobreposto no mesmo tick;
callback letal concorrente; morte durante derrota/transformação; queda viva,
saída real precoce, novo reset e integridade do atlas/alpha.

Cenários de borda usam fixtures explícitos de posição, HP e estado entre
ensaios, não são apresentados como playtest humano. O último golpe normal,
a caminhada de saída e a navegação da reentrada exercitam física/fluxo real.
Checks de largura de texto/recursos e resolução são estruturais/gráficos,
não prova de compreensão, estética ou conforto visual na TCL.

Diagnóstico preliminar preservado: o atlas tinha 1265 px, não os 1264 presumidos
pelo primeiro teste. O teste foi corrigido para o cabeçalho real, sem editar
imagem. Uma leitura de Label antes de _process também era prematura; passou
a observar o estágio de apresentação. A inspeção posterior do PNG mostrou
que isso ainda não bastava: o custom renderer da HUD mantinha comandos antigos.
Foi acrescentado queue_redraw somente no aviso pós-vitória; capturas e testes
afetados foram reexecutados. Arquivos originais da HUD M3 continuam idênticos.
Falhas/iterações anteriores não entram na contagem final; permanecem nos logs.

Diagnósticos ambientais de certificados Windows/editor_settings no perfil
persistem documentados; nenhum certificado, permissão, driver, Windows ou
TCL foi modificado. Todos os processos finais encerraram 0.

## 8. Gráfico em movimento, resoluções e desempenho

Fonte de resultados e comandos: `C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\m4c` — results.json, post-results.json,
logs por job e native-complete/victory.json. Baseline/códigos SHA em baseline.json.

**17 capturas finais:** 14 em 3840x2160 e três em 1280x720, 1920x1080 e
2560x1440, dimensões dos cabeçalhos conferidas. Sem ampliação artificial.
A galeria native-complete/index.html apresenta os PNGs e uma sequência temporal
com controles; é reprodução dos quadros capturados, não vídeo contínuo.
O teste Godot executou a sequência completa animada sob física e renderização
real; a medição abaixo também repete derrotas completas em movimento.

Capturas: combat, final_blow, sequence_2/4/7/11/15/19/23/28, arena_complete,
display_1280/1920/2560/3840, cemetery_return e reentry. native/ e native-final/ conservam a
iteração diagnóstica do aviso antigo; **native-complete/** é a fonte final.
Referência M4-B em `C:\Users\ovohe\.codex\visualizations\2026\11\03\01a19f0a-ee96-7412-bd99-7c6152fadd40\m4b\native4k-complete\index.html`.

Medição gráfica final real (sem --fixed-fps): **45.001 s,
2700 quadros, 59.999 FPS médios, p95 17.048 ms,
máximo 17.378 ms**, viewport (3840, 2160).
**13 sequências**, nós estáveis 182–182.
Warmup 120 quadros; sem PNG dentro da medição. Fixtures reiniciam entre ciclos,
último golpe usa J real; medição não representa dificuldade/duelo humano ou
latência/saída física certificada da TV. Não se promete 60 FPS travados nem
estabilidade prolongada além da janela medida. Valores M4-B preservados no
seu relatório; não misturados com esta amostra.

## 9. Como testar e checklist manual

F8/F5 na Godot 4.7.2 reinicia a sessão. Complete o cemitério, entre pelo Selo
do Guardião e vença a luta intacta. Observe a derrota; Aren continua livre.
Use selo esquerdo para retornar e reentre para verificar o casco final.
A/D/setas, Espaço/W/cima e J permanecem os controles originais.

Repetição automatizada: --headless --fixed-fps 60 --script
res://tests/boss_victory_test.gd; retirar --headless para capturas e checks de
resolução. CINZAS_M4C_EVIDENCE seleciona pasta de saída; sem ela usa .godot/m4c.
Para medição: boss_victory_performance_test.gd sem --fixed-fps. Comandos exatos
nos JSONs. Executável Godot é o mesmo 4.7.2 console instalado e documentado.

Todos os itens M4-C abaixo **NÃO TESTADOS pelo responsável**. Preencher
PASSOU / FALHOU / NÃO TESTADO; homologações anteriores não são transferidas.

| Nº | Item | Resultado |
|---|---|---|
| 1 | Entrada na arena | NÃO TESTADO |
| 2 | Introdução do Guardião | NÃO TESTADO |
| 3 | Funcionamento dos ataques | NÃO TESTADO |
| 4 | Transformação aos 50% | NÃO TESTADO |
| 5 | Efeitos da segunda fase | NÃO TESTADO |
| 6 | Combate preservado | NÃO TESTADO |
| 7 | Golpe final | NÃO TESTADO |
| 8 | Início da derrota | NÃO TESTADO |
| 9 | Animação de colapso | NÃO TESTADO |
| 10 | Efeitos da maldição | NÃO TESTADO |
| 11 | Sincronização visual | NÃO TESTADO |
| 12 | Ausência de dano após HP zero | NÃO TESTADO |
| 13 | Barra de vida desaparecendo corretamente | NÃO TESTADO |
| 14 | Conclusão narrativa | NÃO TESTADO |
| 15 | Texto legível | NÃO TESTADO |
| 16 | Indicação de vitória | NÃO TESTADO |
| 17 | Arena destravada | NÃO TESTADO |
| 18 | Aren com controle durante e após a sequência | NÃO TESTADO |
| 19 | Saída disponível | NÃO TESTADO |
| 20 | Retorno ao Cemitério | NÃO TESTADO |
| 21 | Morte durante a luta | NÃO TESTADO |
| 22 | Reset após morte | NÃO TESTADO |
| 23 | Reentrada após vitória | NÃO TESTADO |
| 24 | Câmera | NÃO TESTADO |
| 25 | HUD | NÃO TESTADO |
| 26 | Qualidade artística | NÃO TESTADO |
| 27 | Nitidez 4K | NÃO TESTADO |
| 28 | Fluidez | NÃO TESTADO |
| 29 | Ausência de bugs graves | NÃO TESTADO |
| 30 | Sensação de conclusão da primeira fase | NÃO TESTADO |

## 10. Arquivos, Git e encerramento

Modificados M4-C: README.md, ROADMAP.md, scenes/boss/guardian.tscn,
scripts/boss/guardian_visual.gd, arena_visual.gd, boss_hud.gd e encounter.gd.
Novos: guardian_conclusion.gd/UID, boss_victory_test.gd/UID,
boss_victory_performance_test.gd/UID, este relatório e assets/art/m4c
(guardian_defeat.png, .import, PROVENANCE.md). Lista literal/hashes/status:
final_inventory.json na pasta de evidências.

Branch main, HEAD **0cd1285f47987477f4ec620978ae9f6d6ec64ea2**. Referência local
origin/main permanece ab003475e4a39bc5d0b40d33292b54fd5c745404; main um commit
à frente. **Nenhum push nesta tarefa.** Índice vazio; sete rastreados modificados,
dez novos M4-C e 14 arquivos locais anteriores preservados por SHA-256.
Caches, logs, exportações e credenciais fora do índice; .uid/.import necessários
preservados. Referências, whitespace e padrões de segredos auditados.

**M4-C sem staging, commit ou push. Segunda fase do jogo e próximo chefe não
iniciados. Encerrar e aguardar playtest manual e homologação do responsável.**
