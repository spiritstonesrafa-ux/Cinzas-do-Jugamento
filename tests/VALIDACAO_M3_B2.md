# M3-B2 — Validação do Corvo Amaldiçoado

**M3-B2 — HOMOLOGADO FUNCIONALMENTE PELO RESPONSÁVEL.**

**Playtest manual: 14/14 PASSOU — Nenhuma observação.**

Registro da implementação anterior e da homologação recebida em 03/11/2026.
A homologação funcional foi realizada e informada pelo responsável; não é uma
auditoria independente do agente. Os testes abaixo são execuções da etapa de
implementação. A engine não foi reexecutada nesta etapa de documentação e
versionamento. M0, M1, M2, M3-A/FIX01 e M3-B1 permanecem
homologados historicamente; seus relatórios foram preservados.

## 1. Auditoria e baseline

Repositório existente confirmado em `C:\PROJETOS\CINZAS DO JURAMENTO`.
Branch `main`; HEAD `3d3bf96e57f4c619684152e5a93da9c88ad3a039`, mensagem
`feat(m3-b1): homologa esqueleto patrulheiro`. Árvore e índice inicialmente
limpos. Nenhuma inicialização, troca de branch ou alteração de histórico.
Não foram encontradas instruções AGENTS.md aplicáveis nos diretórios consultados.

Foram inspecionados a estrutura, README, arquitetura, roadmap, relatórios
anteriores, seis setores, controlador de Aren, espada, sobrevivência,
DamageSource/SwordReceiver, esqueleto, restauração do cenário e testes.
Godot disponível: `4.7.2.stable.official.ed1daf0bf` (Windows).

Antes de implementar, a suíte física de navegabilidade mediu subida máxima
40,834 px com corrida e 40,907 px partindo parado; deslocamentos de centro
respectivos de aproximadamente 70,001 e 66,673 px. Foram 35 verificações,
120 ensaios físicos, zero falhas. Isso não representa alcance com margem de
aterrissagem em qualquer geometria. Nenhum parâmetro de Aren foi alterado.

## 2. Inventário

Modificados:

- `README.md`: instruções atuais e resultados; conteúdo histórico mantido.
- `scenes/levels/forgotten_cemetery.tscn`: uma referência e uma instância do corvo.
- `scripts/levels/forgotten_cemetery.gd`: atribuição de alvo e restauração dos
  dois tipos de inimigo nos dois laços existentes.

Criados:

- `scenes/enemies/cursed_raven.tscn`.
- `scripts/enemies/cursed_raven.gd` e seu `.uid`.
- `scripts/enemies/raven_attack_source.gd` e seu `.uid`.
- `scripts/enemies/raven_visual.gd` e seu `.uid`.
- `tests/raven_test.gd` e seu `.uid`.
- `tests/VALIDACAO_M3_B2.md` (este relatório).

Total: três arquivos rastreados modificados e dez novos arquivos. Logs,
instrumentação gráfica e capturas estão em `.godot/`, ignorada. Não são
recursos necessários ao jogo. Nenhuma dependência ou arte externa adicionada.

## 3. Arquitetura e estados

`CursedRaven` é um CharacterBody2D flutuante, com máquina de estados própria;
não herda a IA terrestre do esqueleto. Apresentação separada em RavenVisual,
com desenhos nativos de corpo, cabeça, bico, asas e olho sobrenatural.

| Estado | Comportamento |
|---|---|
| IDLE | Pausa inicial de 0,3 s, voo visual, pode detectar Aren. |
| PATROL | Movimento horizontal determinístico, limites e colisões com sólidos. |
| ALERT | Para, mostra !, fixa direção e destino, aguarda 0,45 s. |
| DIVE | Move fisicamente com velocidade limitada e fonte ofensiva ativa. |
| RECOVER | Desliga ataque, pausa baixa de 0,55 s, retorna fisicamente à origem. |
| HURT | Feedback claro por 0,18 s, cancela ataque e depois recupera. |
| DEAD | Corpo visual inclinado e inerte; sem movimento, recepção ou ataque. |

RECOVER inclui **pausa mais viagem**, podendo durar mais de 0,55 s. A pausa
baixa permite o contra-ataque com espada horizontal antes da subida. O retorno
usa 24 px/s e colisões, sem teleporte. O corpo derrotado permanece até a
restauração do cenário. Durante DEAD de Aren, inimigo vivo cancela o ataque e
fica parado em IDLE até o ciclo existente de restauração.

## 4. Parâmetros no Inspector

| Parâmetro | Padrão |
|---|---:|
| HP máximo | 2 |
| Dano | 1 |
| Patrulha | 24 px/s |
| Investida | 85 px/s |
| Detecção | 110 px |
| Preparação | 0,45 s |
| Intervalo mínimo entre inícios de ALERT | 1,8 s |
| Pausa de recuperação | 0,55 s |
| Meia largura da patrulha | 20 px |
| Distância máxima da investida | 96 px |
| Diferença vertical máxima para aquisição | 48 px |
| Pausa inicial / reação ao dano | 0,3 s / 0,18 s |

Aquisição exige Aren vivo, apoiado no chão, sem parede na linha de visão e
corvo inteiramente visível no retângulo da câmera, com margem de 8 px. A
visibilidade é verificada novamente antes de entrar em DIVE; sair da tela
no aviso cancela a investida. O alvo fica fixo no início do aviso, na posição
de Aren menos 14 px em Y; não acompanha esquivas. O comprimento é limitado a
96 px. Colisão ou chegada ao destino encerram a investida. O cooldown começa
no aviso; não há novo ataque durante recuperação/retorno.

## 5. Integração preservada

SwordReceiver reutiliza o contrato M1; cada sinal válido retira exatamente
1 HP. A deduplicação de um mesmo golpe permanece na SwordAttack original.
Duas oportunidades com J derrotam o corvo. HURT e DEAD desativam imediatamente
a fonte ofensiva; DEAD também desativa formas corporal e receptora.

RavenAttackSource estende DamageSource. Somente DIVE ativa a área, que usa a
consulta original de KnightHurtbox e o sistema M2. Cada investida consome no
máximo um contato válido, inclusive se o M2 rejeitar dano por proteção já ativa;
assim não espera a proteção expirar para acertar novamente. A linha até Aren
também é bloqueada por sólidos. A regra de invulnerabilidade de 0,8 s é a do M2.

Corpo 14×10 na camada 128, máscara 1; receptor camada 8/máscara 4; fonte camada
32/máscara 16. O corpo não bloqueia Aren. Não há segundo sistema global de
vida, combate ou respawn. Os laços do cenário apenas reconhecem CursedRaven
além de SkeletonPatrol, reutilizando os eventos e reset_enemy existentes.
Morte e queda viva restauram ambos; queda viva continua sem curar Aren.

## 6. Posicionamento e alcance

Uma única instância em **(1050,112)**, Jardim dos Mortos (3/6), patrulha
X=1030–1070. Piso GardenRest X=976–1152, superfície Y=156; área plana segura,
sem buraco obrigatório no encontro. Esqueleto original em (744,140) preservado.
A câmera existente mostra aviso e encontro; sua lógica não foi alterada.

Espada M1 original: alcance horizontal 6–28 px na direção de Aren e faixa
vertical dos pés menos 21 até menos 7. Aren no piso Y=156 tem golpe Y=135–149.
Destino próximo de Y=142 deixa receptor do corvo Y=137–147, dentro dessa faixa.
Isso oferece contra-ataque no chão, sem ataque vertical, salto obrigatório ou
ampliação artificial do golpe. Pontas mais distantes podem ser limitadas pela
investida máxima; os ensaios de contra-ataque usam aproximação real adequada.
O jogador pode atravessar o encontro sem precisar derrotar o inimigo.

## 7. Execuções e resultados

Executável console utilizado em
`C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`.
Importação, inicialização headless e todas as suítes abaixo concluíram com
código 0. Importação final também concluída após geração dos UIDs.

| Suíte executada | Verificações | Falhas |
|---|---:|---:|
| smoke_test.gd — M0 | 14 | 0 |
| combat_test.gd — M1 | 36 | 0 |
| survival_test.gd — M2 | 59 | 0 |
| cemetery_test.gd — M3-A | 52 | 0 |
| reachability_test.gd — FIX01 | 35 | 0 |
| skeleton_test.gd — M3-B1 | 49 | 0 |
| raven_test.gd — M3-B2 | 63 | 0 |
| **Total da regressão final** | **308** | **0** |

A medição inicial de salto foi uma execução adicional de reachability_test,
não somada novamente ao total final. A suíte de navegabilidade final realizou
120 ensaios físicos. As suítes anteriores não foram editadas. Cemetery e
reachability já isolam o processamento dos inimigos para validar a estrutura;
as suítes de inimigos cobrem os encontros ativos. Nenhum resultado equivale à
aprovação humana da dificuldade ou à travessia manual completa dos seis setores.

Comandos de reprodução (usando o executável acima no lugar de `godot`):

```powershell
godot --headless --path . --log-file .godot/b2-import.log --import
godot --headless --path . --log-file .godot/b2-startup.log --quit-after 60
# Executar para cada suíte da tabela:
godot --headless --path . --fixed-fps 60 --log-file .godot/b2-raven_test.log --script res://tests/raven_test.gd
```

Logs locais: `.godot/b2-<nome_da_suíte>.log`, `b2-audit-reachability.log`,
`b2-import.log`, `b2-import-final.log`, `b2-startup.log`, `b2-visual.log`.

## 8. Verificações físicas M3-B2

Os 63 checks incluem estado/HP/defaults, coexistência, patrulha aérea e limites,
obstáculo de patrulha, visibilidade, aviso estacionário de 0,45 s, trajetória
fixa, velocidade, limite de distância, fonte somente em DIVE, recuperação baixa,
retorno físico à patrulha, dano único de 1 HP, proteção preexistente e cooldown.

Em ambos os sentidos, testes carregam a cena real, aproximam Aren, aguardam
ALERT, aplicam entradas reais de movimento para esquivar, deixam a investida
chegar ao destino baixo e executam J pela espada original. Aren mantém 5 HP;
primeiro golpe causa HURT/1 HP, o mesmo golpe não duplica dano, segundo golpe
causa DEAD/0 HP. As formas e a fonte ficam desligadas, sem derrota duplicada.
Não foi colocado o corvo artificialmente dentro da espada nesses contra-ataques.

Outros ensaios físicos verificam parede interrompendo investida e retorno,
HURT cancelando DIVE, morte de Aren durante ALERT e DIVE, restauração de ambos
os inimigos e queda viva sem cura. Caminhar pelo encontro ativo nos dois
sentidos alcança o outro lado sem combate obrigatório; esse teste admite perder
até 1 HP e não afirma travessia inteira sem dano. O ensaio específico de esquiva
e contra-ataque, por sua vez, exige zero dano.

Fixtures reposicionam Aren e restauram o cenário entre casos. Paredes temporárias,
proteção de 0,01 s (para estressar dano repetido), limite de investida de 8 px
(para observar cooldown isolado) e câmera temporariamente afastada são sondagens
exclusivas do teste; parâmetros são restaurados e paredes removidas. Não são
alterações do conteúdo jogável. A câmera fora de visão bloqueia aquisição e
cancela lançamento iniciado com aviso ainda em andamento.

## 9. Preservação e regressão estática

Comparação com HEAD confirmou todos os blocos de nós e sub-recursos existentes
na cena do cemitério idênticos. Apenas a nova referência, instância e contagem
de recursos foram acrescidas. Geometria, plataformas, colisores, marcadores e
câmera dos seis setores preservados. A função de apresentação/câmera do cenário
permaneceu idêntica; apenas os dois laços de inimigos receberam adaptação.

Scripts de jogador, props, combate, alvos e esqueleto, project.godot, testes
anteriores e relatórios históricos permaneceram iguais ao baseline. Conteúdo
histórico completo do README preservado abaixo do registro atual.

## 10. Inspeção visual executada

Execução gráfica nativa, renderizador Compatibility, NVIDIA RTX 2060 SUPER,
código 0. Instrumentação temporária em `.godot/b2_visual.gd` carregou a cena,
produziu capturas do viewport e encerrou. Foram abertas e inspecionadas:

- `.godot/b2-visual-patrol.png`: patrulha e silhueta.
- `.godot/b2-visual-wing.png`: segunda pose de asas.
- `.godot/b2-visual-alert.png`: aviso !.
- `.godot/b2-visual-dive.png`: asas recolhidas/investida.
- `.godot/b2-visual-recover.png`: pausa baixa e inofensiva.
- `.godot/b2-visual-hurt.png`: feedback claro e espada real.
- `.godot/b2-visual-dead.png`: corpo inclinado e inerte após segundo golpe.

As capturas confirmam legibilidade provisória no viewport interno 320×180.
Elas vieram de cenários controlados por script e não de playtest humano contínuo.
Não constituem homologação manual; arquivos permanecem locais e ignorados.

## 11. Diagnósticos e limitações

Persistem `Failed to read the root certificate store` e, nas importações,
falha ao salvar `C:/Users/ovohe/AppData/Roaming/Godot/editor_settings-4.7.tres`.
São diagnósticos de ambiente/perfil já presentes; processos concluíram e as
suítes reportaram zero falhas. Não houve alteração de certificados ou permissões.
Não foram observados erros de script/recurso nesta validação.

Retorno é direto para a origem com colisão, sem busca de caminho para labirintos.
A área atual é livre e os ensaios de obstáculos locais retornaram; isso não
garante recuperação em qualquer futura disposição de paredes. A aquisição
somente com Aren no chão e limite vertical são escolhas deste encontro.
Detecção não substitui balanceamento humano. Os padrões do Inspector são
provisórios; novas configurações exigem validação. A morte usa pose estática,
sem física de cadáver. Não há arte definitiva ou novo sistema de animação.

## 12. Homologação manual informada pelo responsável — 03/11/2026

**M3-B2 — HOMOLOGADO FUNCIONALMENTE PELO RESPONSÁVEL.**

**Playtest manual: 14/14 PASSOU — Nenhuma observação.**

Funcionalidades aprovadas no playtest do responsável:

1. Aparência.
2. Patrulhamento aéreo.
3. Detecção.
4. Aviso do ataque.
5. Investida.
6. Esquiva.
7. Dano causado.
8. Invulnerabilidade.
9. Contra-ataque.
10. Morte do Corvo.
11. Recuperação.
12. Restauração.
13. Integração com sistemas anteriores.
14. Progressão pelo cenário.

A aprovação foi realizada e informada pelo responsável; não é uma auditoria
independente do agente. Preservados os resultados automatizados anteriores,
os testes físicos nos dois sentidos, as sete capturas, os diagnósticos e as
limitações técnicas. Código, IA, parâmetros, cenas e posicionamento não foram
alterados nesta etapa. M3-B3 permanece não iniciado.

## 13. Git ao encerrar a implementação — registro histórico

HEAD/branch preservados. Índice vazio, três arquivos rastreados modificados e
dez novos arquivos locais relacionados ao M3-B2. `.gitignore` preservado e
verificado: caches Godot, temporários, exportações e credenciais continuam
excluídos; os quatro UIDs de scripts novos são mantidos como fonte.
Revisão de diff e `git diff --check` sem problemas de whitespace.

Não executados git add, commit ou push; nenhum remoto, exportação, deploy ou
publicação. M3-B3 e marcos posteriores não iniciados. Encerrado no M3-B2;
pendência então existente: playtest e homologação manual do responsável,
posteriormente recebidos conforme seção 12.


## 14. Auditoria de homologação e versionamento — 03/11/2026

Estado inicial desta tarefa: repositório correto, branch `main`, HEAD
`3d3bf96e57f4c619684152e5a93da9c88ad3a039`, três arquivos modificados,
dez novos e índice vazio. Inventário igual ao registrado na seção 2.
Autoria local existente: Rafael <spiritstonesrafa@gmail.com>, sem alteração
de configuração. Não há alterações inesperadas no inventário da entrega.

Somente README e este relatório receberam alterações nesta etapa. A
implementação homologada, cenas, parâmetros, posicionamento e testes foram
preservados. Resultados anteriores: 308 verificações, 63 específicas do corvo,
testes físicos nos dois sentidos, importação/inicialização e sete capturas;
nenhuma nova execução da engine foi atribuída a esta tarefa.

Auditoria estática: referências de recursos e UIDs, inventário, preservação dos
sistemas anteriores, geometria/câmera, histórico documental e `.gitignore`.
Verificações Git incluem whitespace, integridade do repositório e revisão
integral do diff selecionado antes do commit. `git fsck --full` concluiu sem
erros de integridade; informou cinco árvores soltas, preservadas sem limpeza.
Caches, logs, instrumentação,
exportações e credenciais permanecem fora da seleção; quatro UIDs preservados.

Entrega autorizada para exatamente um commit local com a mensagem
`feat(m3-b2): homologa corvo amaldicoado`, reunindo os 13 arquivos da seção 2.
A identificação final e o estado após o commit são conferidos no Git e
informados ao responsável ao encerrar. Sem push, deploy, exportação ou
publicação. M3-B3 e demais marcos posteriores não iniciados.
