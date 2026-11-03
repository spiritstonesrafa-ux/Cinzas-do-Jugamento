# Cinzas do Juramento — Roadmap por marcos

**Versão:** 0.1  
**Regra geral:** cada marco exige relatório técnico, verificação automatizada compatível com o ambiente e avaliação jogável humana. O próximo marco só começa após aprovação explícita do responsável. Não fazer commit/push automaticamente.

| Marco | Entrega demonstrável | Critério de aceite principal | Dependência |
|---|---|---|---|
| **M0 — Fundação jogável** | Cavaleiro provisório se move, salta, colide, acompanha câmera e retorna após queda em cenário de teste | Abrir no Godot, jogar sem bloqueios e documentar validação | Nenhuma |
| **M1 — Combate com espada** | Ataque básico, hitbox temporal, inimigo estático/móvel simples, feedback de acerto | Golpe só causa dano em janela correta; sem acerto por trás ou fora de alcance | M0 homologado |
| **M2 — Sobrevivência** | HP, receber dano, invulnerabilidade, knockback, checkpoints, reinício | Dano não repete indevidamente; restauração previsível | M1 homologado |
| **M3 — Primeira fase** | Cenário gótico, inimigos variados, desafios, armadilhas, início/fim de fase | Percurso completo, sem softlock, ritmo de dificuldade validado | M2 homologado |
| **M4 — Chefe** | Chefe de fase, arena, padrões legíveis, vitória | Pode ser derrotado de forma justa, sem estado impossível | M3 homologado |
| **M5 — Vertical slice polido** | Demo 3–5 min, arte original consistente, som original, UX básica | Experiência coesa, performance e estabilidade aceitáveis no PC-alvo | M4 homologado |
| **M6 — Expansão de conteúdo** | Desenvolvimento incremental das demais fases e chefes | Cada fase concluída e testada isoladamente e em regressão | M5 homologado |
| **M7 — Publicação** | Build Windows, configuração, testes finais, distribuição | Empacotamento executável, licenças e documentação revisadas | M6 homologado |

## M0 — Backlog estrito

- **M0-01** Detectar estado da pasta/versão da Godot e registrar baseline.
- **M0-02** Criar `project.godot` e cena inicial, sem sobrescrever material pré-existente.
- **M0-03** Configurar resolução lógica 320×180 e escala visual pixel-perfect.
- **M0-04** Criar personagem `CharacterBody2D` com silhueta geométrica do cavaleiro (espada embainhada decorativa).
- **M0-05** Implementar movimento horizontal, gravidade, pulo, *coyote time* e *jump buffer*.
- **M0-06** Criar cenário de testes com piso, três plataformas de alturas diferentes, paredes e zona de queda.
- **M0-07** Configurar câmera horizontal limitada às bordas do cenário.
- **M0-08** Implementar retorno ao ponto de início quando o jogador cai.
- **M0-09** Escrever `README.md` com requisitos, execução, controles e decisões técnicas.
- **M0-10** Rodar validações disponíveis e entregar relatório honesto com testes manuais pendentes.

## Não entra no M0

Ataques, dano, inimigos, chefes, armadilhas com dano, efeitos de sangue, vida, menu, save, checkpoints, gamepad, fases finais, diálogos, cutscenes, trilha, asset packs, exportação release, publicação.

## Gatilho para avançar

Somente iniciar M1 depois que: (1) o projeto abrir e executar no computador do responsável; (2) o movimento e a câmera forem aprovados em jogo; (3) o relatório de M0 mostrar alterações e verificações; (4) houver autorização expressa para M1.

## Disciplina de entregas

- Um objetivo principal por marco.
- Cenas e scripts revisáveis e autocontidos.
- Mudanças pequenas, reversíveis e rastreáveis.
- Nunca declarar PASS se o comando não foi executado.
- Toda aprovação é do responsável, não do agente.
- Git: somente ações de leitura até instrução explícita para versionar.
