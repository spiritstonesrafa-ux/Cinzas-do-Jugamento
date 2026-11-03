# Relatório M0 — 02/11/2026

## Estado inicial

A pasta continha somente `ARQUITETURA.md`, `GDD.md` e `ROADMAP.md`, todos na
raiz. Foram lidos e preservados; não existiam projeto Godot ou código a integrar.
Nenhum `AGENTS.md` foi encontrado nas consultas ao projeto e diretórios pais.
`git status --short --branch` retornou `fatal: not a git repository`.

Godot: versão **não detectada**. `Get-Command godot*,git` não localizou a engine;
`godot --version` terminou com código 1, comando não reconhecido. Foram feitas
consultas a locais usuais do Windows. Uma busca recursiva ampla nesses locais
foi interrompida sem resultado; portanto não se afirma que a engine não esteja
instalada em algum outro caminho. Não houve instalação ou acesso à rede.

## Inventário da entrega

Arquivos criados:

1. `project.godot`
2. `README.md`
3. `scenes/main.tscn`
4. `scenes/player/knight.tscn`
5. `scenes/levels/prototype_stage.tscn`
6. `scripts/player/knight_controller.gd`
7. `scripts/player/knight_visual.gd`
8. `scripts/levels/prototype_stage.gd`
9. `scripts/levels/stage_visual.gd`
10. `tests/smoke_test.gd`
11. `tests/VALIDACAO_M0.md`

Arquivos preexistentes modificados: **nenhum**.

## Implementação

Projeto para Godot 4.3+, Compatibility, sem dependências externas. Resolução
320 × 180, janela 960 × 540, escala inteira, aspecto preservado e filtro nearest.
Personagem CharacterBody2D com movimento acelerado, desaceleração, salto,
gravidade, limite de queda, direção visual independente do colisor e quatro
estados de movimento. Coyote time e buffer ajustáveis de 0,10 s.

Capacete, armadura, capa e espada embainhada desenhados com geometria original.
Fase de 960 px com dois pisos, quatro plataformas, paredes laterais, vão e
ponto inicial seguro. Câmera horizontal limitada e fixa em Y; reposição após
Y > 224 zera velocidade e temporizadores e atualiza câmera no mesmo passo.
Nenhum combate ou sistema posterior ao M0 foi criado.

## Comandos e resultados

| Comando ou consulta | Resultado observado |
|---|---|
| `Get-ChildItem -Force`, `rg --files` e consultas por `AGENTS.md`/`project.godot` | Inventário inicial sem projeto ou instruções locais adicionais |
| `Get-Content ARQUITETURA.md,GDD.md,ROADMAP.md` | Documentos lidos integralmente |
| `Get-Command godot*,git` e buscas por `*godot*.exe` | Nenhum executável identificado; busca recursiva ampla interrompida sem resultado |
| `godot --version` | Falhou, código 1: comando não reconhecido |
| `godot --headless --path . --import` | NÃO EXECUTADO: executável não identificado |
| `godot --headless --path . --quit-after 10` | NÃO EXECUTADO: executável não identificado |
| `godot --headless --path . --script res://tests/smoke_test.gd` | NÃO EXECUTADO: executável não identificado |
| Script Python de geração da cena | Primeira tentativa falhou pela pasta `scenes/levels` ausente; corrigida com criação da pasta, segunda execução concluiu |
| Script Python de revisão estática | PASS: referências `res://` existentes, IDs de recursos, oito corpos e oito formas de colisão, colisor do jogador, resolução, aspecto, escala e códigos das setas |
| `git status --short --branch`, ao início e ao final | Código 128: pasta não é um repositório Git |

O PASS estático verifica texto e existência dos arquivos; **não valida o parser
da Godot, física em execução ou renderização**. O código de saída 1 da consulta
PowerShell final decorre do comando Git; as asserções Python anteriores passaram.

## Playtest e pendências

**PENDENTE PLAYTEST**: seguir o checklist completo no README: abrir três vezes,
testar todas as teclas, mudar direção, saltar e aterrissar, plataformas e paredes,
coyote time, buffer, ausência de multissalto, vão, retorno, extremos da câmera,
legibilidade e redimensionamento.

Não foi possível executar ou controlar o jogo visualmente. Nenhum teste da engine
foi declarado aprovado. A principal pendência é importar na Godot, executar os
três comandos de validação e o smoke test, e então avaliar o controle em jogo.
Possíveis erros de parser ou incompatibilidades só podem ser descartados depois
dessas execuções. Arte é provisória, câmera usa passos inteiros sem suavização e
o ajuste de movimento ainda requer homologação.

## Git e próximo marco

Não há repositório Git nesta pasta. Nenhum init, staging, commit, push, alteração
de branch/remoto, exportação ou publicação foi executado.

M1 — combate básico com espada — é apenas o próximo marco sugerido pelo roadmap.
**A execução encerra no M0; M1 depende de homologação e autorização expressa.**
