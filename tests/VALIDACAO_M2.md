# Validação M2 — Sistema de sobrevivência

## Baseline e auditoria

Diretório confirmado por `git rev-parse --show-toplevel`:
`C:\PROJETOS\CINZAS DO JURAMENTO`.
Branch `main`, HEAD `c7a82dcd527ba7cf754878da6bad449f5f75e08d`.
Status inicial limpo; diff local e staged vazios. Não havia alterações inesperadas.
Nenhum AGENTS.md foi encontrado nas consultas ao projeto e aos diretórios pais.

Foram examinados estrutura real, README, arquitetura, roadmap, relatórios M0/M1,
controlador, visual, espada, cenas e testes. M0/M1 estão homologados pelo
responsável; essa homologação é histórica e não se estende automaticamente ao M2.
Os relatórios M0/M1 e os documentos de planejamento foram preservados.

Antes do M2, o jogador já era CharacterBody2D com movimento/salto, visual e um
nó SwordAttack independente. Camadas existentes: World=1, Player=2,
SwordAttack=3, TrainingTarget=4. O combate usava consultas de forma, sem sinais
customizados de vida ou morte. Não havia sistema de sobrevivência ou HUD.
Testes existentes: `smoke_test.gd` (M0) e `combat_test.gd` (M1).

Engine detectada sem instalação:
`C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`

Versão executada: **4.7.2.stable.official.ed1daf0bf**.

## Arquitetura e funcionalidades

- `KnightSurvival`, nó local de Aren: vida máxima configurável (5), vida atual
  somente para leitura, dano centralizado, rejeição de valores <= 0, clamp,
  sinais `health_changed(current, maximum)`, `died` e `respawn_requested`.
  Guarda de morte definida antes dos sinais impede dano/morte repetidos.
- `KnightHurtbox`: Area2D defensiva separada da espada. Consulta fontes de dano
  na física, incluindo contatos já sobrepostos. Camada 5/bit 16, máscara 6/bit 32.
- `DamageSource`: espinhos estáticos, não sólidos e sem IA; camada 6/bit 32,
  máscara 5/bit 16. Um contato aceito reduz exatamente um ponto. A permanência
  sobre a armadilha permite novo dano após expirar a invulnerabilidade.
- Proteção padrão de **0,80 s**, configurável. Visual de Aren recebe tintura
  vermelha intermitente; ao terminar, retorna a Color.WHITE. Pose e ciclo de
  espada M1 não são substituídos pelo feedback de dano.
- Estado **DEAD** adicionado ao enum existente. Vida zero cancela espada,
  desabilita sua forma, zera velocidade e temporizadores de movimento e bloqueia
  novos inputs de movimento/salto/ataque. Visual fica deitado e esmaecido.
- Intervalo de morte configurável, inicialmente **0,60 s**; apenas uma solicitação
  de respawn é emitida por morte. Não há Game Over ou continuação.
- `RespawnCheckpoint`: cena reutilizável com trigger e Marker2D `RespawnPoint`.
  Ativação por contato muda a bandeira de azul para âmbar, emite `activated`,
  substitui o anterior e evita ativação duplicada. O jogador conserva a referência
  ao checkpoint; não há lookup por nome/posição da fase para escolher o retorno.
- Segurança do retorno: forma do corpo com pequeno recuo evita confundir apoio
  no piso com penetração; verifica sólidos World, fontes de dano e chão até 3 px
  abaixo. Marcador inseguro não é ativado. Se o checkpoint ativo ficar inseguro,
  o respawn usa o início padrão, também validado.
- Respawn restaura vida máxima e controle, zera velocidade, buffer/coyote e
  temporizadores de morte/proteção, cancela espada e restaura apresentação normal.
  Não inicia uma proteção artificial adicional: os marcadores são seguros e o
  passo que executa o respawn termina sem aplicar novos inputs ou dano de contato.
- `HealthHUD`: CanvasLayer local com Label discreta `VIDA atual/máximo`, ligada
  ao sinal de vida pela fase. Nenhum autoload, save ou manager global.

### Cenário e compatibilidade explícita

Layout sólido, plataformas, paredes, vão e alvo M1 preservados. Adições:

| Elemento | Posição global |
|---|---|
| Armadilha de teste | (490,156) |
| Checkpoint ativável | (690,156) |
| RespawnPoint desse checkpoint | (666,156) |
| Início padrão já existente | (48,156) |

**Queda M0:** Aren vivo além de Y=224 continua voltando ao início original,
com velocidade zero e ataque cancelado. Não cura HP, não altera o checkpoint e
não reinicia proteção que já esteja em andamento. A mudança mínima necessária
é ignorar esse retorno enquanto DEAD, permitindo que a morte complete seu
intervalo e retorne ao checkpoint. A câmera mantém seu código de acompanhamento
e atualiza o retorno no mesmo passo de física.

O núcleo original de movimento vivo e todos os seus parâmetros permaneceram
idênticos ao baseline. `sword_attack.gd` e `knight_visual.gd` não foram alterados;
o controlador apenas integra sobrevivência e modifica propriedades visuais locais.

## Arquivos modificados e criados

Modificados (6):

- `README.md`.
- `project.godot` — nomes de três novas camadas.
- `scenes/player/knight.tscn` — Survival e Hurtbox.
- `scenes/levels/prototype_stage.tscn` — armadilha, checkpoint e HUD.
- `scripts/player/knight_controller.gd` — integração de dano/morte/retorno.
- `scripts/levels/prototype_stage.gd` — bindings e compatibilidade da queda.

Criados (16, incluindo UIDs):

- `scripts/player/knight_survival.gd` e `.gd.uid`.
- `scripts/player/knight_hurtbox.gd` e `.gd.uid`.
- `scripts/props/damage_source.gd` e `.gd.uid`.
- `scripts/props/respawn_checkpoint.gd` e `.gd.uid`.
- `scripts/ui/health_hud.gd` e `.gd.uid`.
- `scenes/props/damage_source.tscn`.
- `scenes/props/respawn_checkpoint.tscn`.
- `scenes/ui/health_hud.tscn`.
- `tests/survival_test.gd` e `.gd.uid`.
- `tests/VALIDACAO_M2.md`.

## Comandos executados e resultados reais

Comandos Godot executados no binário identificado acima, na raiz do projeto:

| Argumentos | Resultado |
|---|---|
| `--version` | Código 0, versão 4.7.2 confirmada |
| `--headless --path . --log-file .godot/m2-import.log --import` | Código 0, importação concluída; diagnósticos de ambiente abaixo |
| `--headless --path . --log-file .godot/m2-startup.log --quit-after 10` | Código 0, cena principal carregada, sem erros de script/recurso |
| `--headless --path . --log-file .godot/m2-regression-m0.log --script res://tests/smoke_test.gd` | Código 0: **14 verificações M0, zero falhas** |
| `--headless --path . --log-file .godot/m2-regression-m1.log --script res://tests/combat_test.gd` | Código 0: **36 verificações M1, zero falhas** |
| `--headless --path . --log-file .godot/m2-test.log --script res://tests/survival_test.gd` | Primeira execução: 54 verificações, zero falhas. Suíte ampliada final: código 0, **59 verificações M2, zero falhas** |
| `--headless --path . --log-file .godot/m2-import-final.log --import` | Código 0, importação final e UIDs gerados; diagnósticos de ambiente abaixo |

**Diagnósticos de ambiente observados:** a engine continua emitindo
`Failed to read the root certificate store` no Windows. A importação também
registra falha ao gravar `AppData/Roaming/Godot/editor_settings-4.7.tres`.
São os mesmos problemas documentados no M1; não impediram as suítes de concluir
com código 0 e não foram alteradas permissões, certificados ou configurações.
Não se afirma execução sem diagnósticos. Logs explícitos estão em `.godot/`,
ignorado pelo Git. Nenhum erro de script, referência ausente ou asserção falha
foi observado nas execuções desta etapa.

Verificações estáticas executadas com Python e Git em leitura:

- Comparação com HEAD de GDD, arquitetura, roadmap, relatórios M0/M1, testes
  M0/M1, espada, visual e alvo: preservados integralmente.
- Comparação do núcleo de movimento e de seus parâmetros: preservados.
- Existência dos recursos `res://` e IDs de recursos das cenas: válidos.
- `git diff --check`: sem erros de whitespace; somente avisos de normalização
  futura LF → CRLF. Nenhuma configuração Git alterada.
- Revisão de status, diff e índice; nenhum comando de staging ou escrita Git.

## Cobertura e regressões

59 verificações M2 cobrem vida inicial/configurada, clamp, dano inválido,
atualização dos sinais/HUD, contato físico real com a armadilha, duração e
rejeição de dano na proteção, expiração/limpeza visual, novo dano, morte única,
cancelamento de ataque ativo, bloqueio de controles, intervalo/pose de morte,
retorno padrão, ausência de inputs residuais, vida restaurada, checkpoint por
contato, ativação sem duplicação, múltiplas instâncias e troca do checkpoint,
rejeição de marcadores sem piso ou sobre dano, retorno ao último checkpoint,
segurança após retorno, espada/movimento/salto após respawn, queda M0 sem cura,
checkpoint conservado após queda, morte junto ao vão, câmera, coyote time,
jump buffer, morte natural por contato contínuo e fallback de marcador inválido.

As suítes M0/M1 foram executadas sem editar os testes homologados. Confirmaram
movimento, salto, colisões, extremos da câmera, retorno após queda, fases do
golpe, inputs, orientação fixa, acertos únicos/consecutivos e bloqueio por paredes.

## Homologação funcional manual — APROVADA PELO RESPONSÁVEL

O usuário informou os seguintes resultados do playtest M2:

- [x] Vida inicial: PASSOU.
- [x] Recebimento de dano: PASSOU.
- [x] Invulnerabilidade: PASSOU.
- [x] Feedback visual: PASSOU.
- [x] Novo dano: PASSOU.
- [x] Ativação do checkpoint: PASSOU.
- [x] Morte: PASSOU.
- [x] Respawn: PASSOU.
- [x] Controles após respawn: PASSOU.
- [x] Queda do cenário: PASSOU.
- [x] Regressão: PASSOU.

**Resultado informado: 11/11 PASSOU. Observações: nenhuma. M2 homologado
funcionalmente pelo responsável.** O agente registra a declaração do usuário;
não realizou o playtest manual nem atribui essa homologação a auditoria própria.
Os itens acima reproduzem as categorias efetivamente informadas, sem afirmar
execução individual de todos os passos do roteiro manual anterior.

Os testes headless da implementação e seus diagnósticos de ambiente permanecem
registrados acima. A engine não foi reexecutada na etapa de homologação e
versionamento; os resultados anteriores não são apresentados como novos testes.

## Riscos e limitações

Arte, fonte da HUD e feedback são provisórios. Não há saves: checkpoints duram
somente a sessão. Posições seguras precisam ser autoradas com espaço para o
corpo atual (12 × 24 px) e apoio de chão. A validação verifica o estado estático
no momento do retorno, sem prever perigos móveis futuros. Se tanto o checkpoint
como o início forem inseguros, o personagem permanece DEAD e há um aviso;
não se tenta adivinhar uma posição ou atravessar colisores.

As fases continuam em física discreta de 60 Hz. Não foram criados inimigos,
IA, knockback, inventário, equipamentos, menus ou novas fases. O M2 aqui segue
o escopo detalhado autorizado; não avança para sistemas de M3.

## Git ao final da implementação — registro histórico

Branch `main`, HEAD preservado em `c7a82dcd527ba7cf754878da6bad449f5f75e08d`.
Entrega local: seis arquivos rastreados modificados e dezesseis novos arquivos,
incluindo seis UIDs gerados pela engine. Índice sem alterações staged.
Históricos M0/M1 preservados, caches/logs ignorados.

Nenhum `git add`, commit, push, branch, operação de histórico, exportação,
deploy ou publicação foi executado. Nenhuma dependência foi instalada.
**Na entrega da implementação, o M2 aguardava playtest e homologação; M3 não iniciado.**

## Registro da homologação e versionamento local

Na retomada, foram confirmados branch `main`, HEAD M1
`c7a82dcd527ba7cf754878da6bad449f5f75e08d`, seis arquivos modificados e dezesseis
novos, com índice vazio. O inventário corresponde ao M2 descrito acima.
A homologação manual 11/11 foi informada pelo usuário, sem observações.

Nesta etapa, somente README e este relatório receberam ajustes de documentação;
a jogabilidade implementada foi preservada. Os logs locais consultados confirmam
os resultados registrados das suítes; não houve nova execução da engine.
Foram revisados status, diff, arquivos novos e padrões de credenciais; nenhum
segredo foi identificado nos arquivos candidatos. `.godot/` e seus logs estão
ignorados; caches e temporários não integram o inventário do commit.

O usuário autorizou um único commit semântico local do M2, na branch `main`,
com a autoria já configurada. O hash resultante e o estado final do Git serão
informados na entrega, evitando inserir neste relatório uma referência ao hash
do próprio commit. Não houve push, deploy, alteração de remoto ou publicação.
**M3 não iniciado.**
