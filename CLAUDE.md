# Before Dinner — instruções para o Claude Code

Jogo de terror curto (30 a 45 min) em primeira pessoa, estilo PS1, feito no Godot 4.7 com GDScript e o renderizador Compatibilidade. Publicação no itch.io (Windows e, se possível, web).

**A bíblia completa do jogo está em `docs/BIBLIA.md`.** Leia antes de qualquer tarefa de jogabilidade, mapa, enigma ou texto.

## Modo de trabalho

- O foco é terminar o jogo. Faça o código direto, sem etapas de ensino.
- Ao terminar uma tarefa, diga em poucas linhas como testar e onde ajustar os valores principais.
- Pietro escreve a história e todos os textos do jogo. **Não invente falas, bilhetes ou lembranças.** Onde faltar texto, use uma chave de tradução com texto provisório marcado como `[TODO]`.
- Faça commits pequenos, com mensagens claras, ao fim de cada etapa que funcione.

## Regras técnicas

- GDScript com tipos estáticos (`var velocidade: float`). Comentários em português.
- Textos do jogo sempre via tradução (CSV com colunas `keys,pt,en`, usando `tr()`). Nunca escreva texto dentro de imagens ou texturas.
- Renderizador Compatibilidade: use apenas recursos suportados por ele (névoa simples sim, névoa volumétrica não).
- Assets pagos ficam em `assets/paid/`, que está no `.gitignore` e nunca vai para o GitHub.
- Anote a licença de todo asset de terceiros que entrar no projeto (arquivo, autor, fonte, licença), para montar os créditos.

## Escopo (não ultrapassar sem aprovação do Pietro)

- Um mapa: casa, clareira e 4 trilhas (casa na árvore, riacho, poço, cabana), com bordas fechadas.
- 4 enigmas e 1 cena final. 2 finais.
- Sem combate, sem morte, sem save, sem IA que persegue. Charlote (o monstro) e Cesar aparecem só em momentos com roteiro fixo, como silhueta ou modelo parado.
- Inventário de no máximo 5 itens, sem combinações.
- Se uma tarefa parecer exigir algo fora desta lista, pergunte antes.

## Nomes

- Título: Antes do Jantar (PT) / Before Dinner (EN).
- Protagonista: Maria. Amigo: Cesar. Monstro: Charlote (PT) / Charlotte (EN).
