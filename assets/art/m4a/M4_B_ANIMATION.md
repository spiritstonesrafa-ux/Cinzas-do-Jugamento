# M4-B — animação e efeitos originais em código

PNG e import guardian_poses preservados byte a byte. O Guardião não foi redesenhado nem seu PNG editado. Identidade, proporção, arena e filtros preservados.
Novas ações reutilizam corpo estendido e recorte da própria espada homologada,
articulado ao segmento físico: investida baixa, varredura e arma erguida para
impacto no solo. Pontos e ângulos vêm de guardian_attack.gd. Investida move o
corpo inteiro pela física. Fase 2 acrescenta fissuras e filamentos à armadura.
Os efeitos iniciais em código foram substituídos por chama raster original
gerada com image_gen integrado, em assets/art/m4b/oath_flame.png. Prompt e
proveniência completos em assets/art/m4b/PROVENANCE.md. O núcleo físico 18x18
permanece ancorado ao chão e segue o mesmo nó; cauda não causa dano.
Braços usam fragmentos raster da própria armadura para conectar mão e espada.
Limite: animação articulada sobre quatro poses, não ciclos raster extensos.
Aceitação estética final depende de playtest humano.
