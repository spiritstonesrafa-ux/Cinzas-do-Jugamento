# Cinzas do Juramento — Arquitetura Técnica

**Versão:** 0.1 | **Alvo:** Godot 4.x estável + GDScript tipado | **Plataforma:** Windows PC

## 1. Princípios

1. **Game feel first**: mecânicas antes da arte final.
2. **Composição por cenas**: jogador, cenário e UI separáveis.
3. **Mínima estrutura necessária**: não criar managers/autoloads abstratos sem uso real.
4. **Parâmetros configuráveis**: constantes ou `@export` para tuning sem reescrever física.
5. **Estado local e sinais quando necessários**: evitar dependência circular entre jogador e fase.
6. **Sem plugins externos em M0**: projeto deve abrir com Godot padrão.
7. **Pipeline offline e rastreável**: assets provisórios originais, sem cópias de IP e sem downloads automáticos.

## 2. Configuração do projeto

- Godot 4.x estável detectada localmente; registrar versão exata no README.
- Renderer: Compatibility para protótipo 2D simples (se compatível com ambiente).
- Resolução interna: **320×180**, proporção 16:9.
- Janela inicial: **960×540** (ampliação 3×), ajustável.
- Stretch/content scale: viewport + aspecto keep + integer, conforme opções disponibilizadas pela versão instalada.
- Texturas com filtro nearest; evitar sprites com escala fracionária.
- Física padrão de 60 ticks/s, salvo incompatibilidade justificada.
- Coordenadas e gravidade em px e segundos; usar `delta` onde apropriado.

## 3. Estrutura recomendada

```text
cinzas-do-juramento/
├── project.godot
├── README.md
├── AGENTS.md                      # diretrizes do Codex (opcional mas recomendado)
├── docs/
│   ├── GDD.md
│   ├── ARQUITETURA.md
│   ├── ROADMAP.md
│   └── CODEX_PROMPT_M0.md
├── scenes/
│   ├── main.tscn
│   ├── player/
│   │   └── knight.tscn
│   └── levels/
│       └── prototype_stage.tscn
├── scripts/
│   ├── player/
│   │   └── knight_controller.gd
│   └── levels/
│       └── prototype_stage.gd     # apenas se realmente necessário
├── assets/
│   └── placeholders/              # opcional; preferir geometria simples no M0
└── tests/
    └── smoke_test.gd             # opcional e sem dependências externas
```

A árvore é **proposta**, não mandato de criar pastas vazias ou scripts sem função. Descrever diferenças justificadas no relatório.

## 4. Hierarquia de cenas para M0

```text
Main (Node2D)
└── PrototypeStage (Node2D, instância de prototype_stage.tscn)
    ├── WorldGeometry (Node2D)
    │   ├── Floor/Wall/Platform_* (StaticBody2D + CollisionShape2D + visual provisório)
    ├── Knight (instância de knight.tscn)
    ├── Camera2D (pode estar sob Knight se preferível)
    └── FallBoundary (Area2D) ou limite Y controlado

Knight (CharacterBody2D)
├── CollisionShape2D
└── Visual (Node2D com desenho geométrico original)
```

Não usar `TileMap` legado nem introduzir TileMapLayer sem necessidade na fundação. Quando o design dos níveis se estabilizar, poderá haver migração de geometria provisória para `TileMapLayer` em um marco específico.

## 5. Responsabilidades

| Componente | Faz | Não faz em M0 |
|---|---|---|
| Main | Define a cena inicial | Gerenciar saves, menus, progresso |
| Knight | Física, direções, estado de movimento, aparência provisória | Combate, vida, inventário, IA |
| PrototypeStage | Chão, plataformas, limites e ponto inicial | Progressão de fases ou chefes |
| Camera2D | Acompanhar cavaleiro sem sair dos limites | Cenas cinematográficas |
| Testes | Validar carregamento e invariantes simples | Fingir que há playtest visual |

## 6. Contrato da movimentação M0

**Inputs sugeridos:**

| Ação | Teclado |
|---|---|
| `move_left` | A / seta esquerda |
| `move_right` | D / seta direita |
| `jump` | Espaço / W / seta para cima |

`attack` e `pause` ficam reservados para marcos futuros e **não devem ter comportamento** no M0.

**Estados mínimos:** IDLE, RUN, JUMP, FALL; apresentação visual pode ser provisória.  
**Controles técnicos:** `@export` para velocidade, aceleração/desaceleração, velocidade inicial do salto e gravidade; implementar `move_and_slide()` em `_physics_process()`.  
**Qualidade desejada:** transição de direção rápida; salto sem multissalto; pequeno *coyote time* (~0,10 s) e *jump buffer* (~0,10 s), valores ajustáveis; nenhuma travessia de paredes ou solo.

**Valores apenas de partida** (ajustar após testes, não tratar como requisito absoluto): velocidade horizontal de 90–110 px/s, gravidade de 600–750 px/s², impulso de salto entre -210 e -250 px/s. Espaçamento de plataformas dimensionado à trajetória real, com alternativa segura de retorno.

**Queda:** atravessar limite inferior do cenário leva ao ponto inicial; não implementar sistema de mortes/vidas. Proteger contra respawn repetido no mesmo frame.

## 7. Colisões e visual provisório

- `CharacterBody2D` do jogador com cápsula/retângulo alinhado à figura.
- Chão, paredes e plataformas como `StaticBody2D`.
- Colisão separada da aparência para facilitar a troca de arte.
- Figura temporária reconhecível: capacete, armadura, capa e espada embainhada com formas geométricas. Não gerar nem baixar imagens externas nesta fase.
- O visual deve espelhar a direção sem modificar indevidamente a colisão.

## 8. Plano de validação

Antes de executar, detectar o binário `godot`, `godot4` ou o caminho configurado no Windows. Se não estiver disponível, registrar teste como **NÃO EXECUTADO**, sem afirmar sucesso.

Com o executável da Godot identificado, no diretório do projeto:

```bash
godot --version
godot --headless --path . --import
godot --headless --path . --quit-after 10
```

O comando `--import` valida importação de assets em modo editor e `--quit-after` testa a inicialização da cena. Esses passos **não substituem** o playtest interativo.

**Playtest manual:** andar para ambos os lados; mudar direção sem atraso excessivo; saltar de diferentes alturas; pousar; testar bordas e paredes; testar *coyote time* e *jump buffering*; caminhar até o limite da câmera; cair e reaparecer; iniciar 3 vezes sem erros no painel Debugger. Relatar resultados reais e problemas conhecidos.

Testes automatizados de invariantes são bem-vindos, mas devem ter código pequeno, sem plugin externo e sem dependência de renderização.

## 9. Governança do Codex

- Primeiro examinar a pasta e reportar a condição do projeto, sem sobrescrever arquivos existentes.
- Trabalhar **somente** no M0.
- Não executar `git init`, `git add`, `git commit`, `git push`, `git reset`, `git checkout`, `git rebase`, `git tag`, nem modificar remoto ou branches.
- Pode usar `git status` e `git diff` em modo leitura para o relatório.
- Sem deploy, release, upload, publicação nem chamadas de rede.
- Sem dependências/plugin/download externo sem autorização.
- Terminar com inventário de arquivos, comandos executados, testes, resultados, limitações e próximos passos **sem implementá-los**.

## 10. Referências oficiais

- Godot, movimentação 2D: https://docs.godotengine.org/en/stable/tutorials/2d/2d_movement.html
- Godot, CharacterBody2D: https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
- Godot, múltiplas resoluções/pixel art: https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
- Godot, linha de comando: https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
