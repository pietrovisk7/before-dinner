class_name Bilhete
extends Interagivel
## Bilhete (ou risco na árvore, desenho...) que abre um texto por cima da tela.
## O texto vem sempre do arquivo de tradução, nunca de imagem.

## Chave de tradução com o texto do bilhete.
@export var chave_texto: String = ""


func _init() -> void:
	chave_aviso = "UI_LER"


func interagir(jogador: Node3D) -> void:
	super(jogador)
	Jogo.abrir_bilhete(chave_texto)
