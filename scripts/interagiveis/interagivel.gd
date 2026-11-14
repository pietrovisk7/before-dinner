class_name Interagivel
extends StaticBody3D
## Base de todo objeto que o jogador pode examinar com E.
##
## Uso: coloque este script (ou um filho dele, como Item e Bilhete) num StaticBody3D
## com malha e colisão. Para reagir no próprio nível sem criar script novo,
## conecte o sinal "interagido" no editor.

## Chave de tradução do aviso que aparece ao mirar no objeto.
@export var chave_aviso: String = "UI_EXAMINAR"

signal interagido(jogador: Node3D)

## Camada de física 2 ("interagivel"): o raio do jogador procura nela.
const CAMADA_INTERAGIVEL: int = 2


func _ready() -> void:
	# Mantém a camada 1 (o jogador colide) e liga a 2 (o raio enxerga).
	set_collision_layer_value(CAMADA_INTERAGIVEL, true)


## Chamado pelo jogador ao apertar E mirando neste objeto.
## Filhos sobrescrevem e chamam super(jogador) para manter o sinal.
func interagir(jogador: Node3D) -> void:
	interagido.emit(jogador)
