extends Node
## Autoload "Jogo": estado global e sinais que ligam o mundo 3D à interface.
##
## O mundo roda dentro de um SubViewport (para o visual PS1) e o HUD fica fora dele,
## então os dois conversam por aqui em vez de se referenciarem diretamente.

## A mira passou a apontar para outro objeto. Chave vazia = nada interagível na mira.
signal mira_mudou(chave_aviso: String)
## Um bilhete foi aberto; o HUD mostra o texto da chave de tradução.
signal bilhete_aberto(chave_texto: String)
signal bilhete_fechado
## Mensagem curta no topo da tela (ex.: inventário cheio).
signal mensagem(chave: String)

## Enquanto um bilhete está aberto, o jogador não anda nem olha.
var bilhete_esta_aberto: bool = false


func abrir_bilhete(chave_texto: String) -> void:
	bilhete_esta_aberto = true
	bilhete_aberto.emit(chave_texto)


func fechar_bilhete() -> void:
	bilhete_esta_aberto = false
	bilhete_fechado.emit()


func mostrar_mensagem(chave: String) -> void:
	mensagem.emit(chave)


func _unhandled_input(event: InputEvent) -> void:
	# F2 troca o idioma entre PT e EN. Só existe em builds de depuração
	# (rodando pelo editor); some no jogo exportado.
	if not OS.is_debug_build():
		return
	var tecla := event as InputEventKey
	if tecla and tecla.pressed and not tecla.echo and tecla.physical_keycode == KEY_F2:
		var novo: String = "en" if TranslationServer.get_locale().begins_with("pt") else "pt"
		TranslationServer.set_locale(novo)
		print("Idioma: ", novo)
