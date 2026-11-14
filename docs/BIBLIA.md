# Antes do Jantar (Before Dinner) — Bíblia do jogo

Versão de 14/11/2026. Fonte original: documento de design no Claude.

## Premissa

Ao anoitecer, uma menina entra na floresta atrás de casa para achar o amigo que sumiu durante uma brincadeira. O jogo inteiro sustenta uma dúvida: quem chama por ela é o amigo ou o monstro?

- **Personagens:** Maria e Cesar, crianças. Ele veio visitá-la, os dois foram brincar na floresta e a brincadeira demorou demais.
- **Cenário:** a casa dela fica na entrada da floresta. Ela conhece o lugar, e cada canto guarda uma memória dos dois.
- **Tempo:** começa no anoitecer e termina em noite fechada. O céu escurece a cada enigma resolvido.
- **Dúvida central:** voz chamando de longe, silhuetas que somem e pistas que se contradizem.
- **Finais:** dois, um em que é o amigo e outro em que é o monstro.
- **Formato:** de 30 a 45 minutos, em português e inglês. PC, publicado no itch.io. Godot 4, com código no GitHub.

Título: Antes do Jantar (PT) / Before Dinner (EN). A criatura se chama Charlote em português e Charlotte em inglês.

## História

Um monstro solitário entrou no esconde-esconde dos dois e escondeu o menino. O jogo termina com uma pergunta que só o amigo verdadeiro sabe responder.

### O que aconteceu de verdade

Antes do anoitecer, enquanto esperavam o jantar, os dois brincavam de esconde-esconde na floresta. Naquele dia, ele ia dormir na casa dela. Um monstro com poderes misteriosos quis entrar na brincadeira e a levou a outro nível: escondeu o menino.

### Abertura

- A mãe de Maria leva os dois de carro para casa. A conversa planta a pista final: a macarronada com carne e pimenta é a comida favorita de Maria.
- A cena do carro não é jogável. O formato (tela preta com texto e som, ou imagem parada) ainda está em aberto.
- O jogo fica jogável quando eles chegam em casa. Maria explora a casa por um tempo antes do esconde-esconde começar.
- A casa fica numa fazenda, mas só a casa existe no jogo. Outros lugares da fazenda podem ser citados.
- O prato do jantar daquela noite aparece numa cena posterior.

### O monstro

- **Origem:** Charlote foi criada por magia de uma bruxa que morreu há décadas, numa cabana no fundo da floresta.
- **O que quer:** é solitária e só quer fazer amigos.
- **Aparência:** meio zumbi, meio floresta. Tamanho de criança, cabelo de folhas e galhos, olhos fundos e escuros, corpo de madeira e casca.
- **Poder:** imita aparência, voz, ações e sinais.
- **Regra:** só imita o que viu.
- **Progressão:** imita cada vez melhor ao longo do jogo. A escrita dela começa simples e cheia de erros e melhora a cada bilhete.

### Como a história chega ao jogador

- **Bilhetes e riscos nas árvores** contam quem é o monstro e o que ele faz.
- **Lembranças:** quando a menina tenta se acalmar, ela se lembra de coisas que fez com o amigo. As lembranças são as pistas.
- **Sinais:** o amigo tenta dar sinais para ajudá-la, e o monstro imita esses sinais.
- **A cabana** só confirma uma peça-chave. O resto o jogador já descobriu pelo caminho.

### Personagens

| Personagem | Como é |
| --- | --- |
| Maria | Morena, cabelo cacheado, magrelinha, sorridente. Adora brincar e se esconder. Fala muito. |
| Cesar | Cabelo liso, óculos. Lê livros e HQs, escreve com português refinado e cheio de referências. Fala pouco e gosta de ouvir a amiga. |
| Charlote | Tamanho de criança, cabelo de folhas e galhos, olhos fundos e escuros, corpo fino de madeira. |

### Finais

Na cabana, a menina abre uma porta e encontra dois meninos idênticos, cada um tentando convencê-la de que é o verdadeiro. Ela pergunta: "Qual é a minha comida favorita?". Os dois respondem, e o jogador escolhe.

- **Acertou (final bom):** ela reencontra o amigo e os dois jantam.
- **Errou (final ruim):** os dois ficam presos na floresta, forçados a ser amigos do monstro.

### Regras de escrita

- Toda pista necessária para acertar fica no caminho obrigatório, nunca num canto opcional.
- Os textos com erros do monstro são reescritos em inglês, com erros e gírias próprios do inglês.

Comida favorita de Maria: macarrão apimentado com carne. Em aberto: em qual lembrança, de antes daquele dia, ela aparece.

## Mapa

```
            [Riacho]                 [Poço velho] ---chave---+
           (enigma 3)            (enigma 4, dá a chave)      |
                 \                    /                      v
 [Casa na árvore] --- [   Clareira   ] --- [ Cabana (final, trancada) ]
    (enigma 2)        (hub, liga tudo)
                             |
                       [ Casa dela ]
                    (início, enigma 1)

 Bordas do mapa fechadas por mato denso.
```

A clareira liga as quatro trilhas, e cada trilha termina num lugar com um enigma. A cabana fica trancada até o poço entregar a chave, e é lá que o jogo termina.

## Mecânica principal

Explorar, examinar e usar objetos. Não existe combate nem morte: o medo vem de luz, som e dúvida.

- **Câmera:** primeira pessoa, na altura de uma criança. Tudo parece maior, sem precisar de modelo nem animação da protagonista.
- **Examinar:** um raio sai do centro da tela; quando acerta um objeto interativo, aparece um aviso ("E — examinar").
- **Itens:** inventário simples, com no máximo 5 itens e sem combinações. Um item só é usado no lugar certo.
- **Bilhetes:** aparecem por cima da tela. O texto vem do arquivo de tradução, nunca da imagem.
- **Lanterna:** liga e desliga. É a principal fonte de luz quando a noite fecha.
- **Clima:** shader PS1 (vértices tremidos, texturas sem filtro, resolução baixa), névoa e luz amarrada ao progresso.
- **Sustos:** só momentos com roteiro fixo, disparados por áreas invisíveis no mapa. O amigo e o monstro nunca andam pelo mapa com IA.

### Memórias

As memórias são feitas de texto, efeito de tela e som, sem arte desenhada. O objeto no mapa já serve de imagem.

1. Maria examina um objeto ligado a uma lembrança (o balanço, um gibi, a casa na árvore).
2. A tela perde a cor e desfoca levemente, e os sons da floresta abafam.
3. Toca um som suave, como uma caixinha de música.
4. Aparecem poucas linhas: a lembrança contada por Maria, com uma fala de Cesar.
5. A tela volta ao normal.

Algumas memórias e pistas usam desenhos de Maria, feitos à mão com giz de cera, de propósito tortos, como os de uma criança.

## Enigmas (proposta)

São quatro enigmas e uma cena final, cada um num lugar do mapa.

| # | Lugar | O que o jogador faz | Recompensa |
| --- | --- | --- | --- |
| 1 | Casa dela | Acha pilhas numa gaveta e liga a lanterna. Serve de tutorial de examinar, pegar e usar. | Lanterna |
| 2 | Casa na árvore | Abre o baú com a "senha secreta" dos dois, escondida num desenho no quarto dela. | Mapa dos esconderijos, desenhado por ele |
| 3 | Riacho | A ponte está quebrada. Empurra um tronco para atravessar. | Boné dele, num lugar onde ele não poderia estar |
| 4 | Poço velho | Gira a manivela e puxa o balde do fundo. | Chave da cabana |
| Final | Cabana | Abre a porta e encontra a resposta. | Um dos dois finais |

Cada enigma resolvido escurece o céu e deixa a voz mais perto.

## Entra / fica de fora

Qualquer ideia nova vai para a lista "Versão 2.0" e não para esta versão. Se atrasar, corte um enigma em vez de esticar o prazo.

| Entra | Fica de fora |
| --- | --- |
| 1 mapa: casa, clareira e 4 trilhas | Mundo aberto ou áreas extras |
| 4 enigmas e 1 cena final | Mais de 5 enigmas |
| 2 finais | Terceiro final |
| Sustos com roteiro fixo | Monstro com IA que persegue |
| Sem morte, sem game over | Combate, vida, checkpoints |
| Jogo de uma sentada (30 a 45 min) | Sistema de save |
| Português e inglês | Outros idiomas antes de lançar |
| Bilhetes e falas curtas em texto | Dublagem e cutscenes animadas |
| Amigo e monstro como silhueta ou modelo parado | Personagens animados andando |

### Versão 2.0

- (anote aqui as ideias que surgirem)

## Arte e som

Tudo gratuito ou feito por Pietro. Anote a licença de cada arquivo (arquivo, autor, fonte, licença) no momento em que baixar: os créditos saem dela. Assets pagos ficam em `assets/paid/`, que não vai para o GitHub.

### Arte

| Item | Onde procurar |
| --- | --- |
| Árvores, arbustos, pedras, mato | Kenney (Nature Kit), Quaternius |
| Casa dela (fachada e um cômodo) | Kenney, KayKit, Poly Pizza |
| Casa na árvore, ponte, poço, cabana | Poly Pizza, Quaternius, ou montar com caixas no Godot |
| Objetos: lanterna, pilhas, baú, balde, boné, chave, desenho | Kenney, Poly Pizza |
| Silhueta do amigo e do monstro | Personagem low poly parado (Quaternius) |
| Texturas pixeladas | Reduzir as texturas dos pacotes para 64 ou 128 px |
| Céu e névoa | Ambiente do próprio Godot, sem asset |

Desenhos de Maria: feitos à mão com giz de cera, fotografados com o celular e usados como textura.

### Som

| Item | Como conseguir |
| --- | --- |
| Passos em folha e terra | Gravar com o celular e limpar no Audacity |
| Ambiente noturno (vento, grilos, coruja) | Freesound (filtrar por CC0) |
| Voz do amigo chamando | Gravar e mudar o tom no Audacity |
| Sussurros e respiração | Gravar |
| Água do riacho, madeira rangendo, corda, porta | Freesound, Kenney, ou gravar em casa |
| Sons de interface (pegar item, abrir bilhete) | sfxr, Kenney (UI Audio) |
| Música: 1 ou 2 drones de ambiente e o tema dos finais | BeepBox |

## Cronograma

São 8 semanas guiadas por marcos. Só avance quando o marco da semana funcionar. No fim da semana 3, compare o ritmo real com o plano e ajuste o resto.

Modo de trabalho: o foco é terminar o jogo. O Claude Code faz o código direto, sem etapas de ensino. Pietro escreve a história e os textos, testa e decide.

- [x] **Semana 1: base.** Repositório no GitHub e personagem em primeira pessoa. Marco: andar e olhar num cenário de cubos, com o primeiro commit no GitHub.
- [ ] **Semana 2: interação e visual.** Examinar e pegar objetos, bilhete na tela, shader PS1, névoa, tradução por CSV. Pietro escreve o roteiro em tópicos. Marco: pegar um objeto e ler um bilhete em PT e EN, já com cara de PS1.
- [ ] **Semana 3: mapa em blocos.** Casa, clareira e as 4 trilhas feitas com cubos, sem arte. Marco: atravessar o mapa inteiro em cerca de 5 minutos. Revisão do ritmo.
- [ ] **Semana 4: enigmas.** Os 4 enigmas e a cena final funcionando, com a luz amarrada ao progresso. Marco: jogar do início a um dos finais, ainda feio.
- [ ] **Semana 5: arte.** Trocar cubos por assets, aplicar texturas pixeladas, ajustar iluminação. Pietro fecha os textos em português. Marco: um screenshot que já parece o jogo final.
- [ ] **Semana 6: som e clima.** Ambiente, passos, voz do amigo, sustos com roteiro, música e os dois finais. Marco: jogo completo com som. Primeiro teste com 2 ou 3 pessoas.
- [ ] **Semana 7: polimento.** Corrigir o que o teste mostrou. Menu, opções (idioma, volume, sensibilidade), tradução para o inglês, créditos com licenças. Marco: versão candidata e segundo teste.
- [ ] **Semana 8: publicação.** Exportar para Windows (e web, se possível). Página no itch.io com capa, screenshots, GIF, descrição em PT e EN e duração honesta. README no GitHub. Marco: jogo publicado e link no currículo.
