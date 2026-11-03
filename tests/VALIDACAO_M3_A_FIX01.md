# M3-A-FIX01 — Auditoria e correção de navegabilidade

Data: 03/11/2026. **M3-A e M3-A-FIX01 homologados funcionalmente pelo
responsável.** Diagnóstico e testes abaixo preservam o registro da correção;
a homologação posterior está documentada ao final.

## Baseline e limites da intervenção

Raiz: `C:\PROJETOS\CINZAS DO JURAMENTO`; branch `main`, HEAD M2
`c58690bbb3dfe122bb8e1ff8de05b966f17dd772`. M3-A já tinha cinco arquivos
rastreados modificados e dez novos, sem staging/commit. Essas alterações foram
preservadas. Não foram encontrados AGENTS.md no inventário do projeto.

Foram lidos README, especificação M3-A, relatório original, cena da fase, script
de integração/câmera, desenho provisório, controlador homologado e teste de
percurso. Nenhum screenshot estava disponível como arquivo anexado nesta
execução: a identificação abaixo usa os elementos reais da cena e sua intenção
documentada, sem afirmar correspondência visual com uma imagem não acessível.

Não foi alterado nenhum arquivo de movimento, combate, vida, checkpoint,
hurtbox, HUD ou configuração física. Não há novos inimigos ou sistemas.

## Diagnóstico antes de modificar a fase

### Capacidades reais de Aren

Godot: **4.7.2.stable.official.ed1daf0bf**, física de 60 Hz. Corpo físico 12×24 px,
velocidade 100 px/s, aceleração 1200 px/s², gravidade 680 px/s², impulso -230 px/s.
Nenhum valor foi modificado. Sondagens usam Input.action_press/release, o
CharacterBody2D original e colisões reais, sem atribuir velocidade nem usar coyote.

| Sondagem física em piso nivelado | Altura máxima dos pés | Deslocamento horizontal entre decolagem e pouso |
|---|---:|---:|
| Correndo antes de saltar | 40,83 px | 70,00 px |
| Partindo parado, andar e saltar juntos | 40,91 px | 66,67 px |

As diferenças de centésimos vêm do contato/posição inicial da física. A fórmula
contínua v²/(2g) dá 38,90 px, mas não reproduz exatamente a ordem e a integração
discreta do controlador. Por isso a medição real, aproximadamente **40,9 px**,
substitui a estimativa anterior de 37 px na especificação atual. Os 70 px não são
uma promessa de vão atravessável com subida: a janela de aterrissagem diminui
para destinos elevados e depende do ponto de decolagem e do corpo físico.

### Catacumbas: teto confundido com plataforma e descida sem antecipação

Cena: `scenes/levels/forgotten_cemetery.tscn`, `WorldGeometry/CryptRoof`.
Retângulo X=1248–1408, Y=64–120; piso subterrâneo em Y=220. O topo está **156 px
acima do piso**, muito além dos 40,9 px de salto. `docs/M3_A.md` já definia a
peça como teto, com percurso obrigatório por baixo e degraus laterais. Subir no
teto não faz parte da travessia. O vão livre inferior de 100 px comporta o corpo
de 24 px e o salto completo, deixando aproximadamente 35 px de folga adicional.

O problema de comunicação era comprovável na cena: o teto usava o mesmo bloco
cinza e a mesma borda superior clara dos pisos obrigatórios. Ele agora tem tom
escuro, borda inferior discreta e a indicação `TETO - PASSAGEM ABAIXO`. Sua
colisão e posição foram preservadas. Nenhuma escada foi criada para um destino
que não faz parte da rota; a identidade subterrânea foi mantida.

Outra falha confirmada: nas descidas de 24 px, a câmera centrada em Y=pés-66
deixava a superfície seguinte exatamente no limite inferior exclusivo do
viewport. Os pés/pouso não estavam visíveis antes de sair do degrau, tanto na
entrada quanto na saída percorrida ao contrário. A câmera local da fase agora
antecipa essas descidas com margem, sem mudar a câmera do protótipo homologado.

### Ponte: rota possível, mas margem insuficiente

O teste contínuo anterior encontrava uma rota possível; não media tolerância à
decolagem. No layout original, quatro decolagens nominais (8/12/16/20 px antes
da borda, já correndo e ainda no chão) produziram:

- BridgeSpanA → BridgeSpanB: vão 56 px/subida 12 px, **2/4** pousos válidos.
- CathedralFloor → BridgeSpanB: vão 56 px/subida 20 px, **1/4** pousos válidos.
- BridgeApproach → BridgeSpanA: vão 48 px/subida 8 px, **4/4**, mas foi encurtado
  junto com o alargamento necessário do tablado A.

Não se conclui que todo salto da ponte era impossível. A falha comprovada era
uma margem pequena demais em duas transições para uma introdução, sobretudo
na volta. Após as mudanças, todas as quatro aproximações passaram nos dois
sentidos, com apoio do corpo inteiro no tablado de destino.

## Coordenadas e correções

Posições dos nós são o canto superior esquerdo do sólido. Dimensões em pixels.

| Elemento | Antes: posição / tamanho | Depois: posição / tamanho |
|---|---|---|
| BridgeSpanA | (1648,148) / 64×12 | **(1632,148) / 80×12** |
| BridgeSpanB | (1768,136) / 64×12 | **(1752,144) / 96×12** |
| CryptRoof | (1248,64) / 160×56 | **mesma posição, tamanho e colisão**; apenas apresentação |
| Escadas/piso das Catacumbas | Y=180,204,220,196,172 | **inalterados** |

Colisores, centros das formas, blocos, bordas e marcas âmbar da ponte foram
atualizados em conjunto. A passagem preserva seus três vãos reais e o piso final.

| Travessia da ponte | Antes: vão / subida na ida | Depois: vão / subida na ida |
|---|---:|---:|
| Aproximação → A | 48 / 8 | **32 / 8** |
| A → B | 56 / 12 | **40 / 4** |
| B → Catedral | 56 / -20 | **40 / -12** |

Na volta, Catedral → B passa a subir 12 px em vez de 20, com vão de 40 px.
Demais subidas obrigatórias da fase permanecem em no máximo **24 px**, abaixo
dos 40,9 px medidos. Essa comparação geométrica é apenas triagem; os pousos
foram também testados com a física real.

Câmera: mesmo limite X=160–2208 e Y=90–154, escala e posições inteiras. O offset
vertical passa gradualmente de 66 para 54 px na região das Catacumbas. Faixas
de transição X=1056–1088 e X=1568–1600 evitam um salto abrupto de 12 px. O teste
verifica o corpo do destino e 8 px abaixo da borda visíveis antes da travessia.

## Auditoria dos seis setores

| Setor | Risco auditado | Resultado físico atual |
|---|---|---|
| 1 Portões | Piso inicial, partida, conexão com Lápides | Percurso contínuo, sondagem de salto e ligação em ambos os sentidos aprovados |
| 2 Lápides | Três vãos de 32 px, subidas de até 16 px | Quatro aproximações por ligação/sentido aprovadas |
| 3 Jardim | Subida/descida de 24 px, superfícies adjacentes | Quatro aproximações aprovadas; descidas caminhando, sem exigir pulo que ultrapasse o degrau |
| 4 Catacumbas | Teto, folga, degraus 16/24 px, câmera | Piso inferior e escadas percorridos nos dois sentidos; teto excluído da rota pela intenção documentada |
| 5 Ponte | Margem nos vãos elevados e travessia reversa | Todos os vãos corrigidos aprovados nas quatro decolagens/sentido |
| 6 Catedral | Pouso final, conexão reversa com a ponte e parede | Pousos locais e rota contínua de volta aprovados |

`reachability_test.gd` testa as 16 superfícies consecutivas do percurso: 15
ligações nos dois sentidos, quatro aproximações por ligação, **120 ensaios
físicos locais**. Desses, 84 são saltos e 36 são descidas adjacentes caminhando.
O corpo precisa estar integralmente apoiado no destino para o ensaio passar.
As posições nominais de decolagem têm discretização de um passo (até 1,67 px).
São quatro amostras, não prova de uma janela contínua nem de todo input humano.

Esses ensaios reposicionam Aren entre tentativas para isolar cada ligação;
nunca modificam a física. `cemetery_test.gd` foi preservado e continua verificando
independentemente o percurso inteiro de ida e volta sem teleporte, reinício ou
nova tentativa. Paredes e teto não são classificados como destinos obrigatórios.

## Execuções reais

Executável instalado:
`C:\Users\ovohe\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`.
Nos comandos, `godot` representa esse binário; diretório de trabalho é a raiz.

| Comando / argumentos | Resultado |
|---|---|
| `--version` | Código 0, 4.7.2 confirmada |
| `--headless --path . --fixed-fps 60 --log-file .godot/fix01-before.log --script res://tests/reachability_test.gd -- --layout=res://.godot/fix01-before.tscn` | Diagnóstico antes de corrigir a fase: 35 verificações, **3 falhas esperadas** — duas margens de salto e antecipação da câmera |
| `--headless --path . --log-file .godot/fix01-import.log --import` | Código 0, importação concluída e UID do teste gerado |
| `--headless --path . --log-file .godot/fix01-startup.log --quit-after 60` | Código 0, cena real inicia sem erro de script/recurso |
| `--headless --path . --fixed-fps 60 --log-file .godot/fix01-smoke_test.log --script res://tests/smoke_test.gd` | Código 0, **14 M0**, zero falhas |
| `--headless --path . --fixed-fps 60 --log-file .godot/fix01-combat_test.log --script res://tests/combat_test.gd` | Código 0, **36 M1**, zero falhas |
| `--headless --path . --fixed-fps 60 --log-file .godot/fix01-survival_test.log --script res://tests/survival_test.gd` | Código 0, **59 M2**, zero falhas |
| `--headless --path . --fixed-fps 60 --log-file .godot/fix01-cemetery_test.log --script res://tests/cemetery_test.gd` | Código 0, **51 M3-A**, zero falhas, ida/volta contínuas |
| `--headless --path . --fixed-fps 60 --log-file .godot/fix01-reachability_test.log --script res://tests/reachability_test.gd` | Código 0, **35 novas verificações**, zero falhas; 120 ensaios físicos |

**Regressão final: 195 verificações, zero falhas.** Os 120 ensaios estão
agregados nas 35 verificações novas, não são somados outra vez ao total.

Durante o desenvolvimento da suíte, a primeira sondagem obrigava pular também
nas descidas adjacentes, ultrapassando seis degraus estreitos. Isso não provava
falha do cenário: a suíte foi corrigida para caminhar nessas descidas, e o layout
original foi testado novamente antes de qualquer edição na fase. Restaram as
três falhas documentadas. Depois da correção da câmera, a asserção de visibilidade
foi ampliada para exigir também 8 px de margem abaixo do destino.

Diagnósticos reais: `Failed to read the root certificate store` ocorreu nestas
execuções. A importação também registrou falha ao salvar
`AppData/Roaming/Godot/editor_settings-4.7.tres`. Não impediram códigos 0 dos
testes finais; não houve erro de script, recurso ausente ou asserção falha na
regressão final. Certificados e permissões não foram alterados.

Snapshot anterior, hashes e logs estão em `.godot/`, ignorado pelo Git. O teste
novo padrão não depende do snapshot: o argumento `--layout=` é opcional, apenas
para reproduzir o diagnóstico contra a cópia anterior local.

## Roteiro do novo playtest — registro histórico

- [ ] Iniciar F5 e chegar às Catacumbas com os controles originais.
- [ ] Reconhecer a peça escura como teto e seguir por baixo, sem tentar subir nela.
- [ ] Descer e subir as duas escadas; ver os degraus antes de sair da borda.
- [ ] Saltar sob o teto e confirmar folga, enquadramento e identidade da cripta.
- [ ] Cruzar os três vãos da ponte de ida e volta, variando a antecedência do salto.
- [ ] Confirmar que os pousos da ponte são claros e não exigem precisão extrema.
- [ ] Percorrer todos os seis setores de ida e volta sem atalhos ou reset.
- [ ] Cair nos seis vãos e conferir retorno ao início, sem cura ou ataque residual.
- [ ] Verificar a câmera nas transições entre Jardim, Catacumbas e Ponte.
- [ ] Confirmar que CP1/CP2 continuam apenas marcações futuras.
- [ ] Avaliar legibilidade de `TETO - PASSAGEM ABAIXO` em 960×540 e ao redimensionar.

Na implementação do FIX01, o agente não realizou novo playtest humano.
A homologação funcional posterior foi informada pelo responsável, conforme
o registro ao final. As verificações automatizadas de câmera usam o
retângulo visível e coordenadas da física; não são inspeção de uma imagem
renderizada nem certificação de conforto/clareza visual. A arte continua provisória.

## Arquivos e Git ao encerrar a correção

Nesta correção foram alterados somente:

- `scenes/levels/forgotten_cemetery.tscn`: ponte e apresentação do teto.
- `scripts/levels/forgotten_cemetery.gd`: antecipação da câmera da nova fase.
- `scripts/levels/cemetery_visual.gd`: marcas das novas bordas da ponte.
- `README.md` e `docs/M3_A.md`: instruções e dimensionamento atuais.
- `tests/VALIDACAO_M3_A.md`: adendo, preservando o registro original.

Criados: `tests/reachability_test.gd`, seu `.gd.uid` e este relatório.
Nenhum teste preexistente foi alterado nesta correção. Arquivos da implementação
M3-A anterior, incluindo fixture e entrada F5, foram preservados.

Git permanece em `main`, HEAD `c58690bbb3dfe122bb8e1ff8de05b966f17dd772`.
Estado final esperado da entrega conjunta: cinco rastreados modificados e treze
arquivos novos, incluindo os já existentes antes do FIX01. Nada staged; nenhum
git add/commit/push, branch, alteração de histórico ou publicação foi executado.

**Ao encerrar o FIX01, aguardava-se homologação; a aprovação funcional posterior
está registrada abaixo. M3-B não iniciado.**

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
