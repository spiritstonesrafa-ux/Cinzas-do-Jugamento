# M3-A — Greybox estrutural de O Cemitério dos Esquecidos

Status: **M3-A e M3-A-FIX01 homologados funcionalmente pelo responsável em
03/11/2026**, com registro local autorizado. Nenhuma implementação posterior iniciada.
Autorização restrita ao M3-A. O nome desta fase segue a solicitação atual;
o nome antigo no GDD é um conceito histórico, preservado para rastreabilidade.

## Composição

`scenes/main.tscn` instancia `scenes/levels/forgotten_cemetery.tscn`.
A fase contém 19 StaticBody2D com retângulos sólidos e polígonos provisórios,
Knight e HealthHUD existentes, Spawn, Finish, dois Marker2D de checkpoints
futuros, Camera2D, fundo geométrico e duas linhas de identificação/instrução.
Todos os sólidos estão explicitamente na cena e são editáveis no editor.
O fundo tem `@tool` para inspeção no editor e nunca cria colisores.

O script da fase só integra retorno, HUD, câmera e identificação de setores.
Não há manager, autoload, dependência, plugin, recurso externo ou troca de fase.
O fim é uma faixa e um texto, sem vitória, chefe ou transição.

## Planta linear (coordenadas em pixels)

| Setor | Faixa X | Percurso e intenção |
|---|---|---|
| 1 Portões do Cemitério | 0–384 | Piso Y=156; início (48,156); área segura para testar comandos |
| 2 Caminho das Lápides | 384–768 | Vãos 448–480, 544–576, 640–672; pisos Y=144/156/140 |
| 3 Jardim dos Mortos | 768–1152 | Subida Y=140→116, descida 140→156; CP1 futuro (1040,156) |
| 4 Catacumbas | 1152–1536 | Entrada Y=180→204→220; saída Y=196→172→156; teto X=1248–1408, Y=64–120 |
| 5 Ponte das Almas | 1536–1984 | Lábios em X=1600/1632, 1712/1752, 1848/1888; pisos Y=156/148/144/156; CP2 futuro (1936,156) |
| 6 Portão da Catedral | 1984–2368 | Área final plana Y=156; faixa central (2288,156); parede direita em X=2368 |

As fronteiras dos setores são faixas verticais de fundo e nomes na tela.
Bordas claras delimitam sólidos; marcas âmbar indicam lábios de vãos.
Contornos tracejados e textos CP1/CP2 FUTURO distinguem reservas sem trigger.
Paredes fecham X=0 e X=2368; as plataformas são sólidas em todos os lados.

## Dimensionamento e recuperação

Jogador original: corpo 12×24, velocidade 100 px/s, impulso -230 px/s,
gravidade 680 px/s², física 60 Hz. Medição na engine em FIX01: salto de
40,83–40,91 px e deslocamento de 70,00 px correndo, ou 66,67 px iniciando parado,
entre decolagem e aterrissagem na mesma altura. Nenhum parâmetro foi ajustado.
Degraus obrigatórios sobem até 24 px; os vãos atuais da ponte medem 32/40/40 px,
com subidas de 8/4 px na ida e no máximo 12 px na volta. O alcance horizontal
em piso nivelado não deve ser usado sozinho para aprovar saltos com subida.

`CryptRoof` é teto (X=1248–1408, Y=64–120), não uma plataforma obrigatória.
Fica 156 px acima do piso Y=220; o vão inferior de 100 px comporta corpo físico
de 24 px e salto de cerca de 41 px. A aparência FIX01 diferencia o teto dos
pisos claros e identifica a passagem inferior. Os degraus da cripta não mudaram.

A suíte nova testa quatro aproximações nominais (decolagem 8/12/16/20 px antes
da borda) por transição e sentido, sem coyote ou física modificada. São 84 saltos
e 36 descidas adjacentes caminhando, com corpo inteiro apoiado no destino.
Ela usa resets entre ensaios; `cemetery_test.gd` prova separadamente a travessia
contínua nos dois sentidos. Isso amplia a evidência, sem homologar conforto humano.

Câmera: X entre 160 e 2208; Y entre 90 e 154; coordenadas arredondadas,
sem suavização. Limites World 0–2368 × 0–244. Acompanha uma faixa vertical
de 64 px para revelar o piso subterrâneo, mantendo a vista lateral. No FIX01,
o alvo vertical usa offset 54 px nas Catacumbas em vez de 66 px, com transições
gradativas de 32 px nas faixas X=1056–1088 e X=1568–1600. Assim o próximo
degrau já aparece com margem de 8 px antes da descida, em ambos os sentidos.
Viewport 320×180, integer scale, nearest e pixel snap permanecem intactos.

Queda viva além de Y=288 retorna ao Spawn, zera movimento e cancela espada,
sem curar HP. O limite é próprio deste layout para acomodar o piso Y=220.
O protótipo continua usando Y=224. Enquanto DEAD, o retorno por queda é
ignorado para que o sistema M2 conclua seu intervalo e respawn normalmente.
Não há checkpoints ativáveis no greybox; respawn usa o início seguro existente.
Não foi adicionado dano por queda nem corredor oculto de recuperação.

## Escopo encerrado

M3-A contém apenas layout, comunicação provisória e integração dos componentes
homologados. Não inclui arte final, esqueleto, corvo, IA, armadilhas novas,
novos sistemas de checkpoints, chefe, áudio, polimento, saves, menus ou deploy.
M3-B/C/D e M4 exigem autorização própria; a homologação atual não inicia essas etapas.

## Auditoria FIX01

Resultados completos, roteiro de playtest e homologação funcional em `tests/VALIDACAO_M3_A_FIX01.md`.
A validação original de 160 verificações não testava margem de decolagem nem
a visualização antecipada dos degraus. A regressão FIX01 passou 195 verificações
(incluindo 35 novas), sem homologação automática do M3-A. M3-B não iniciado.

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
