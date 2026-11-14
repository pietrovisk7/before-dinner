class_name Item
extends Interagivel
## Objeto que vai para o inventário ao ser pego e some do mapa.

## Chave de tradução do nome do item. Também serve de identificador no Inventario.
@export var chave_nome: String = ""


func _init() -> void:
	# Valor padrão diferente da base: o aviso vira "E — pegar".
	chave_aviso = "UI_PEGAR"


func interagir(jogador: Node3D) -> void:
	if chave_nome.is_empty():
		push_warning("Item '%s' está sem chave_nome." % name)
		return
	if not Inventario.adicionar(chave_nome):
		Jogo.mostrar_mensagem("UI_INVENTARIO_CHEIO")
		return
	super(jogador)
	queue_free()
