# Validação M1 — 02/11/2026

## Baseline e autorização

Projeto: `C:\PROJETOS\CINZAS DO JURAMENTO`.
Inspeção inicial confirmou branch `main`, HEAD
`c9cd1f558dc02e83cb81438efa56c7a8fbbff622`, sem diferenças locais ou staged.
Foram lidos os documentos de planejamento, README, cenas, scripts e testes.
Nenhum AGENTS.md foi encontrado no projeto ou nas consultas aos diretórios pais.

O responsável informou que **M0 foi homologado manualmente, sem observações**:
movimento, salto/aterrissagem, paredes, coyote time, jump buffer, câmera e retorno.
Essa informação não representa playtest realizado pelo agente. O relatório
histórico `VALIDACAO_M0.md` foi preservado integralmente.

## Implementação

- Ação `attack` na tecla física J, sem mudar os inputs existentes.
- Ciclo local NEUTRAL → WINDUP → ACTIVE → RECOVERY → NEUTRAL, com durações
  exportadas de 0,10 / 0,10 / 0,20 s. Somente novo pressionamento no chão inicia
  o golpe. Pressionamentos durante o ciclo ou no ar são descartados, sem fila.
- Movimento, salto e seus parâmetros preservados. Golpe iniciado no chão pode
  terminar no ar; não há ataque aéreo próprio. Direção da espada, hitbox e pose
  fixada no início, independente das mudanças de direção do movimento.
- Area2D ofensiva separada, retângulo 22 × 14 px, centrado em (±17,-14),
  desabilitado fora da fase ativa. Camada SwordAttack=3/bit 4, máscara
  TrainingTarget=4/bit 8; alvo com camada 4/bit 8 e máscara 3/bit 4.
- Consultas diretas à física durante a janela ativa detectam tanto alvos já
  sobrepostos na abertura como alvos que entram depois. IDs recebidos são
  registrados por golpe para impedir múltiplos acertos no mesmo alvo.
- Consulta adicional ao corredor da lâmina usa somente World=1 e bloqueia
  acertos por sólidos, inclusive obstáculos na borda vertical da hitbox.
- Retorno após queda cancela qualquer fase, limpa os registros/temporizador,
  desabilita a forma e restaura orientação neutra, posição e velocidade.
- Um único alvo reutilizável em (112,156), não sólido, com contador `hit_count`
  e clarão reiniciado em cada acerto. Não tem vida, IA, ataque ou morte.
- Espada geométrica erguida, horizontal clara e abaixada distingue as três fases.

## Arquivos

Modificados:

- `project.godot`: input J e nomes das camadas de ataque/alvo.
- `scenes/player/knight.tscn`: nó SwordAttack e sua Area2D/forma.
- `scripts/player/knight_controller.gd`: integração do ciclo e cancelamento,
  sem reescrever a movimentação.
- `scenes/levels/prototype_stage.tscn`: instância do alvo, sem mudar a geometria M0.
- `README.md`: uso do M1, engine localizada e contexto atualizado de homologação.

Criados:

- `scripts/player/sword_attack.gd` e `.gd.uid`.
- `scripts/targets/training_target.gd` e `.gd.uid`.
- `scenes/targets/training_target.tscn`.
- `tests/combat_test.gd` e `.gd.uid`.
- `tests/VALIDACAO_M1.md`.

Caches e logs de execução ficaram em `.godot/`, já ignorado pelo Git.
Nenhum plugin, download, asset externo ou dependência foi adicionado.

## Engine e comandos executados

Executável localizado sem instalação:

`C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`

Na etapa de implementação, todos os comandos abaixo foram executados nesse
binário, na pasta do projeto. Não foram repetidos na etapa de versionamento:

| Argumentos | Resultado real |
|---|---|
| `--version` | Código 0: `4.7.2.stable.official.ed1daf0bf` |
| `--headless --path . --import` | Código 0, classes/recursos importados; diagnósticos de ambiente descritos abaixo |
| `--headless --path . --quit-after 10` | Código 0, cena principal carregada sem erro de script/recurso; diagnósticos de ambiente |
| `--headless --path . --log-file .godot/m0-test.log --script res://tests/smoke_test.gd` | Código 0: **14 verificações, zero falhas** |
| `--headless --path . --log-file .godot/m1-test.log --script res://tests/combat_test.gd` | Primeira execução: 34 verificações, zero falhas. Suíte final ampliada: código 0, **36 verificações, zero falhas** |
| `--headless --path . --log-file .godot/import.log --import` | Código 0 na reimportação final, com os mesmos diagnósticos de ambiente |

**Diagnósticos observados, não omitidos:** a engine emite `Failed to read the
root certificate store` neste ambiente. A importação também registra falha ao
salvar `AppData/Roaming/Godot/editor_settings-4.7.tres`; a inicialização sem log
explícito registrou falhas de escrita/rotação em `user://logs`. Os logs explícitos
das suítes foram gravados em `.godot/`. Essas mensagens não impediram a execução
nem causaram falhas nas asserções; não se declara uma execução sem diagnósticos.
Nenhum ajuste de certificados, permissões ou perfil foi realizado.

Verificações adicionais executadas:

- Python comparou GDD, ARQUITETURA, ROADMAP, relatório/smoke M0, lógica da fase
  e visual do cavaleiro com `git show HEAD:...`: todos preservados.
- Comparação do controlador, removendo somente os pontos de integração M1 e
  comentário atualizado: movimentação original idêntica.
- Revisão estática dos caminhos `res://`: todos os recursos referenciados existem.
- Git somente em leitura: branch, HEAD, status, diff local/staged e revisão final.
- `git diff --check`: código 0, sem erros de whitespace. Git emitiu avisos de
  normalização futura LF → CRLF para três arquivos; nenhuma configuração foi alterada.
- Status ao encerrar a implementação: cinco arquivos rastreados modificados, oito novos arquivos
  (incluindo três `.uid`), nada staged; branch e HEAD preservados no baseline.

## Cobertura automatizada

Smoke M0: ponto inicial/chão, corpos sólidos, movimento/orientação, salto e
aterrissagem, paredes esquerda/direita, extremos da câmera, vão, retorno com
velocidade zerada e câmera reposicionada.

M1: forma inativa fora da janela; preparação sem acerto; acerto na primeira
consulta ativa com alvo já sobreposto; um acerto por alvo por ciclo; novo acerto
e reinício do feedback no ciclo seguinte; tecla mantida sem repetição; novo
pressionamento após soltar; bloqueio de reinício/fila em preparação, fase ativa
e recuperação; golpe à esquerda e à direita; alvo atrás e fora do alcance;
direção/pose fixa ao inverter movimento; parede fina e obstáculo fora do raio
central bloqueiam; remoção da parede permite acertar; alvo entrando durante
recuperação não é atingido, enquanto entrada na janela ativa é detectada;
início no ar bloqueado sem fila ao pousar; salto livre durante golpe iniciado
no chão; retorno após queda em cada uma das três fases limpa a hitbox e não
produz acertos residuais.

## Homologação manual do M1 e regressão M0 — APROVADAS

O responsável concluiu o playtest manual, informou **“tudo passou”** e
**homologou o M1, sem falhas relatadas**. Aprovações informadas pelo responsável:

- [x] Ataque e recuperação.
- [x] Acerto único por golpe e golpes consecutivos.
- [x] Direção, alcance e bloqueio por paredes.
- [x] Visual da espada e feedback do alvo.
- [x] Cancelamento após queda.
- [x] Regressão das funcionalidades homologadas do M0.

Esse resultado foi informado pelo responsável; o agente não realizou o playtest
manual. Os resultados automatizados anteriores (14 verificações M0 e 36 M1,
sem falhas) e os diagnósticos de ambiente foram preservados. A engine não foi
reexecutada nesta etapa de documentação e versionamento.

## Limitações e encerramento

Testes headless verificam física/input, não certificam aparência, clareza das
poses ou sensação de controle. Nenhum playtest manual desta etapa foi declarado
realizado pelo agente. A homologação do M1 foi informada pelo responsável,
conforme o registro acima, sem falhas relatadas.

Física e fases são discretizadas a 60 Hz. O bloqueio pelo corredor é conservador:
uma quina sólida em qualquer parte desse corredor impede o acerto. A espada
geométrica é uma pose de feedback e não resolve sua própria colisão visual contra
a parede; o evento de acerto é bloqueado pela geometria World.

Não foram implementados HP, dano ao jogador, invulnerabilidade, knockback,
checkpoints, morte, IA, combos, ataque aéreo próprio ou sistemas posteriores.
Ao encerrar a implementação não houve staging, commit, push, mudança de
branch/HEAD/configuração/remotos, exportação ou publicação; a entrega foi deixada
localmente para revisão. Esse é o registro histórico da implementação.

## Registro da entrega homologada

Após a homologação, o responsável autorizou um único commit local com a mensagem
`feat(m1): adiciona combate basico com espada homologado`, usando a autoria já
configurada: Rafael `<spiritstonesrafa@gmail.com>`.

A inspeção para versionamento confirmou a raiz exata do repositório, branch
`main`, HEAD no baseline M0 e somente os cinco arquivos modificados e oito novos
arquivos esperados do M1. Não foram encontrados arquivos sensíveis ou mudanças
fora do escopo nos arquivos selecionados. O `.gitignore` foi conferido com
`git check-ignore`: caches Godot, temporários, logs, exportações e credenciais
permanecem excluídos; os três `.uid` novos são preservados.

Nesta etapa foram atualizados apenas README e este relatório, sem alterar código,
cenas, parâmetros ou comportamento. O relatório histórico do M0 foi preservado.
As verificações de versionamento incluem comparação do conteúdo preservado,
`git diff --check`, seleção explícita dos 13 arquivos da entrega e revisão do
diff staged completo antes do commit. Não foram declaradas novas execuções da
engine. Não há autorização para push, publicação ou nova implementação.
**M2 permanece não iniciado.**
