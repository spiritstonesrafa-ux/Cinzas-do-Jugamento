# Validação M3-A — O Cemitério dos Esquecidos

Data: 03/11/2026. **M3-A e M3-A-FIX01 homologados funcionalmente pelo
responsável.** As seções abaixo preservam o histórico de implementação e de
testes; a homologação posterior está registrada ao final, sem novas execuções.

## Baseline inspecionado e escopo

Projeto real: `C:\PROJETOS\CINZAS DO JURAMENTO`.
Branch `main`; HEAD `c58690bbb3dfe122bb8e1ff8de05b966f17dd772`.
Árvore e índice inicialmente limpos, conforme informado e confirmado por Git.
M0/M1/M2 homologados historicamente; nenhuma autorização presumida para M3-B/C/D
ou M4. Nenhum AGENTS.md encontrado no projeto e nas consultas aos pais.

Foram examinados arquivos reais, project.godot, README, GDD, ARQUITETURA,
ROADMAP, relatórios anteriores, cenas, controlador, visual, espada,
sobrevivência, hurtbox, props, HUD e suítes M0/M1/M2. O projeto já tinha
CharacterBody2D, componentes locais, geometria sólida e integração de retorno.

Foi criada uma fase original de greybox com seis setores em ordem. O F5 abre
essa fase; o protótipo de testes permanece intacto e acessível por F6.
O layout e as coordenadas completas estão em `docs/M3_A.md`.

## Alterações e preservação

- Nova cena com 19 sólidos explícitos/editáveis, incluindo piso, degraus,
  plataformas, teto subterrâneo e paredes nas extremidades.
- Seis setores nomeados, início seguro, setas de progressão, bordas dos vãos,
  dois espaços tracejados de checkpoints futuros e fim provisório seguro.
- Knight e HealthHUD existentes instanciados, sem alterar scripts, parâmetros,
  cenas ou camadas físicas dos sistemas M0/M1/M2.
- A câmera da nova fase acompanha lateralmente e admite 64 px de deslocamento
  vertical para mostrar as catacumbas, com posições inteiras e limites.
- Queda viva retorna ao início sem cura; somente o limite espacial da nova fase
  usa Y=288 para acomodar o piso subterrâneo Y=220. O protótipo mantém Y=224.
- Morte/respawn usam os sinais e métodos existentes. Nenhum checkpoint ativável
  foi colocado na nova fase; CP1/CP2 são exclusivamente Marker2D e desenho.
- As suítes antigas mudaram somente o caminho de carregamento da entrada para
  `tests/fixtures/baseline_main.tscn`, cópia do main original M2. Todas as
  asserções, inputs, tempos e coordenadas dessas suítes foram preservados.
- Configuração 320×180, integer scale, nearest e pixel snap intacta.

Não foram criados arte final, inimigos (esqueleto/corvo), IA, armadilhas,
novos sistemas de checkpoint, chefe, áudio, menus, saves ou transição de fase.
O antigo alvo, espinhos e checkpoint continuam apenas no protótipo preservado.

## Execuções e resultados reais

Engine já instalada, sem instalação/download:
`C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`.
Versão executada: **4.7.2.stable.official.ed1daf0bf**.

Nos comandos abaixo, `godot` representa esse executável e `--path .` representa
a raiz do projeto. As execuções reais usaram o caminho absoluto da raiz.

| Comando/argumentos | Resultado observado |
|---|---|
| `godot --version` | 4.7.2 confirmada |
| `godot --headless --path . --log-file .godot/m3a-import.log --import` | Código 0, importação concluída |
| `godot --headless --path . --log-file .godot/m3a-startup.log --quit-after 60` | Cena real de F5 iniciou e encerrou, sem erro de script/recurso |
| `godot --headless --path . --fixed-fps 60 --log-file .godot/m3a-regression-m0.log --script res://tests/smoke_test.gd` | **14 verificações M0, zero falhas** |
| `godot --headless --path . --fixed-fps 60 --log-file .godot/m3a-regression-m1.log --script res://tests/combat_test.gd` | **36 verificações M1, zero falhas** |
| `godot --headless --path . --fixed-fps 60 --log-file .godot/m3a-regression-m2.log --script res://tests/survival_test.gd` | **59 verificações M2, zero falhas** |
| `godot --headless --path . --fixed-fps 60 --log-file .godot/m3a-test.log --script res://tests/cemetery_test.gd` | Código 0, **51 verificações M3-A, zero falhas** |
| `godot --headless --path . --log-file .godot/m3a-import-final.log --import` | Código 0, importação final e três UIDs presentes |
| Captura temporária via Godot gráfica, carregando main real | Código 0; seis PNGs de 320×180 inspecionados, um por setor |
| Comparação de arquivos rastreados contra HEAD | Somente os cinco arquivos previstos modificados; demais arquivos preservados |
| Comparação das suítes antigas e fixture | Somente caminho mudou; fixture equivale ao main original, normalizando CRLF |
| Inspeção de recursos | 28 referências `res://` em scripts/cenas apontam para arquivos existentes |
| `git diff --check` | Sem erros de whitespace |
| `git diff --cached --stat` | Vazio; nenhuma alteração staged |

**Total: 160 verificações automatizadas, zero falhas.** O uso de `--fixed-fps 60`
permite execução determinística dos testes, mantendo os passos de física a 60 Hz.
As suítes antigas verificam seu cenário histórico; a suíte nova carrega a cena
real de F5, testando a integração da fase nova de forma independente.

### Cobertura específica do M3-A

O teste automatizado percorreu a fase inteira nos dois sentidos, por inputs de
movimento/salto e colisões reais. Durante esses percursos não usou teleporte,
mudança de física, reinício, checkpoint ou repetição após falha. O controlador
de teste usa raios próximos aos pés para decidir saltos, registrando os seis
setores em ordem, a descida subterrânea e a câmera inteira dentro dos limites.

Também verificou início apoiado, HUD, escala interna, ausência de props de
checkpoint/dano/alvo na raiz da nova cena, segurança dos marcadores futuros,
texto de fim, ausência de ativação dos checkpoints e paredes esquerda/direita.
Seis sondagens de queda separadas colocam o jogador em cada vão para testar
ausência de piso invisível, retorno, velocidade/câmera zeradas e HP sem cura.
O teste ainda provoca morte nas catacumbas, verifica retorno M2 ao início e
acionamento de espada após respawn. Essas sondagens usam reposicionamento
explícito; não fazem parte da prova de percurso contínuo.

As regressões M0/M1/M2 incluem coyote time, jump buffer, bloqueio por paredes,
espada, dano, invulnerabilidade, checkpoints ativos no protótipo e respawn.

### Diagnósticos e limites da validação

Os logs `.godot/m3a*.log` destas execuções headless não apresentaram ERROR,
WARNING, SCRIPT ERROR ou FAIL. As importações não reproduziram a falha histórica
de gravação de editor_settings. Não se afirma que o problema foi corrigido.

A captura gráfica com OpenGL Compatibility/NVIDIA RTX 2060 SUPER registrou
`Failed to read the root certificate store`, diagnóstico do Windows já presente
no histórico. A renderização e as seis capturas concluíram; nenhuma alteração
de certificados, permissões do Windows ou configuração da engine foi feita.
Capturas/script temporários ficaram fora do repositório, no workspace de trabalho.

Uma primeira auditoria Python de leitura do Git foi bloqueada por diferença de
proprietário do processo. A auditoria foi repetida como proprietário do projeto
e passou, sem alterar `safe.directory` nem qualquer configuração Git.

Inspeção de capturas valida enquadramento e textos estáticos, não a experiência
interativa. O teste automático demonstra uma rota viável, mas não garante todos
os tempos de salto humanos. A ponte é mais exigente e exige avaliação manual.
Nenhum playtest humano ou homologação foi declarado pelo agente.

## Checklist de playtest — preencher pelo responsável

Abra o projeto e pressione **F5**. Use A/D ou setas, Espaço/W/cima e J.
Reinicie com F8 e F5 quando necessário. Roteiro preservado da entrega original,
quando os itens estavam pendentes. A homologação funcional global foi informada
posteriormente pelo responsável; o agente não preenche resultados individuais:

- [ ] Iniciar três vezes e verificar ausência de erros de script no Debugger.
- [ ] Portões: início seguro, andar nas duas direções, frear, saltar e atacar;
      conferir se as instruções são legíveis e não cobrem o personagem.
- [ ] Lápides: atravessar os três vãos, pousar nas superfícies claras e retornar;
      avaliar se os saltos iniciais são fáceis e as bordas ficam visíveis.
- [ ] Jardim: subir o bloco, descer e reconhecer CP1 como futuro; confirmar
      que passar na marca não cura, não ativa bandeira e não muda retorno.
- [ ] Catacumbas: descer, ver o piso subterrâneo, passar sob o teto e subir
      os degraus; voltar pelo mesmo caminho sem ficar preso.
- [ ] Ponte: atravessar os três vãos sem salto de precisão excessiva;
      observar antecipação dos pousos, câmera e marca CP2 FUTURO.
- [ ] Catedral: alcançar a faixa final, ler FIM PROVISÓRIO e confirmar
      que não há chefe, transição nem avanço para outro submarco.
- [ ] Caminhar contra as duas paredes externas e verificar bloqueio/câmera.
- [ ] Cair de cada um dos seis vãos; confirmar retorno ao início, controle
      restaurado, ataque cancelado e ausência de retorno repetido/travamento.
- [ ] Avaliar coyote time e jump buffer em bordas/pousos; confirmar ausência
      de multissalto, travessia de sólidos ou mudança do controle homologado.
- [ ] Redimensionar a janela e conferir pixels nítidos/escala inteira, nomes
      de setores, HUD e ausência de exposição além dos limites da fase.
- [ ] Para regressão manual de combate/sobrevivência: abrir
      `scenes/levels/prototype_stage.tscn`, pressionar F6 e testar alvo,
      espinhos, invulnerabilidade, morte, bandeira e retorno ao checkpoint.

Registrar PASSOU/FALHOU por item e observações, especialmente sobre a ponte e
a câmera na entrada/saída das catacumbas. Aguardar homologação expressa antes
de qualquer etapa posterior.

## Inventário final

Cinco arquivos rastreados modificados:

1. `README.md` — instruções M3-A, resultados e separação do histórico.
2. `scenes/main.tscn` — entrada F5 para a fase nova.
3. `tests/smoke_test.gd` — somente caminho da fixture de regressão.
4. `tests/combat_test.gd` — somente caminho da fixture de regressão.
5. `tests/survival_test.gd` — somente caminho da fixture de regressão.

Dez arquivos novos, incluindo três UIDs:

1. `docs/M3_A.md`.
2. `scenes/levels/forgotten_cemetery.tscn`.
3. `scripts/levels/forgotten_cemetery.gd`.
4. `scripts/levels/forgotten_cemetery.gd.uid`.
5. `scripts/levels/cemetery_visual.gd`.
6. `scripts/levels/cemetery_visual.gd.uid`.
7. `tests/cemetery_test.gd`.
8. `tests/cemetery_test.gd.uid`.
9. `tests/fixtures/baseline_main.tscn`.
10. `tests/VALIDACAO_M3_A.md` — este relatório.

## Git, riscos e encerramento da implementação original

Branch `main` e HEAD M2 preservados. Cinco modificados e dez novos; índice vazio.
`.godot/` e logs permanecem ignorados. GDD, arquitetura, roadmap, relatórios
históricos, configuração do projeto, cenário antigo e sistemas de jogo intactos.
Não houve git add/commit/push, alteração de branch/remoto, publicação ou deploy.

Pendências ao encerrar a implementação original: playtest humano, avaliação da dificuldade da ponte e da câmera
subterrânea, e homologação do responsável. As marcas futuras não oferecem
retorno intermediário: toda queda viva reinicia no começo, conforme a regra
preservada. A sensação desse custo precisa ser avaliada no playtest.
Fonte, cores, portas e lápides são apenas comunicação temporária do greybox.

**Ao encerrar a implementação original, aguardava-se playtest e homologação.** Nenhum outro
submarco será iniciado com base nesta entrega.

## Adendo M3-A-FIX01 — 03/11/2026

O playtest do responsável apontou dificuldade nas Catacumbas e solicitou
verificação da ponte. Este documento preserva o registro original da entrega;
coordenadas e resultados atuais estão em `tests/VALIDACAO_M3_A_FIX01.md`.
A auditoria ampliada confirmou o teto fora da rota, ambiguidade de apresentação,
margem insuficiente em dois saltos da ponte e degraus fora da imagem antes da
descida. Foram corrigidos apenas geometria/comunicação/câmera da fase nova.
A descrição original de salto de aproximadamente 37 px foi substituída na
especificação atual por medição física de aproximadamente 40,9 px.

Regressão atual: 14 M0 + 36 M1 + 59 M2 + 51 M3-A + 35 de navegabilidade,
zero falhas. O teste contínuo original foi preservado. Os 35 testes agregam
120 ensaios físicos locais com diferentes aproximações; não são playtest humano.
Os diagnósticos de certificados e escrita de editor_settings ocorreram na
execução FIX01 e estão registrados no relatório próprio. **Aguardando nova
homologação manual ao encerrar o FIX01; a aprovação posterior consta abaixo.
M3-B não iniciado.**

## Homologação funcional registrada — 03/11/2026

O responsável informou a **homologação funcional do M3-A e da correção
M3-A-FIX01** e autorizou registrar a implementação homologada em um único
commit local. Esta aprovação é atribuída ao responsável, não a um playtest
realizado pelo agente nesta etapa.

Foram preservados os resultados anteriores: 160 verificações na entrega
original e 195 na regressão final do FIX01, incluindo 35 verificações de
navegabilidade com 120 ensaios físicos agregados. Falhas de diagnóstico antes
da correção, limites dos testes e mensagens de ambiente continuam documentados.
Nenhum teste da engine foi repetido nesta etapa; foram feitas somente revisões
de documentação e versionamento. Não houve alteração de jogabilidade.

A homologação é funcional e restrita ao M3-A com FIX01. **M3-B não iniciado**;
qualquer etapa posterior exige autorização própria. Não há push ou publicação
no escopo deste registro.
