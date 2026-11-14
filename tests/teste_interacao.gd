extends Node
## Teste automático da semana 2: tradução, examinar, pegar item, bilhete e inventário.
##
## Carrega a cena principal de verdade, posiciona o jogador, simula teclas
## e confere o resultado. Sai com código 0 se tudo passar e 1 se algo falhar.
##
## Rodar (na pasta do projeto):
##   godot --headless --path . res://tests/teste_interacao.tscn
##
## Limites: em headless não há renderização (erros de shader não aparecem)
## nem mouse real (o olhar com o mouse não é testado).

const CENA_PRINCIPAL: PackedScene = preload("res://scenes/main/main.tscn")
const CAMINHO_MUNDO: String = "Tela3D/SubViewport/Mundo"
## Se algo travar, encerra com erro em vez de ficar rodando para sempre.
const TEMPO_LIMITE: float = 30.0

var falhas: int = 0
var principal: Node
# Sem tipo de classe própria: o script do jogador não tem class_name, então
# lemos as variáveis dele com get() para o teste não depender do cache do editor.
var jogador: CharacterBody3D
var hud: CanvasLayer


func _ready() -> void:
	get_tree().create_timer(TEMPO_LIMITE).timeout.connect(_estourou_tempo)

	principal = CENA_PRINCIPAL.instantiate()
	add_child(principal)
	jogador = principal.get_node(CAMINHO_MUNDO + "/Player")
	hud = principal.get_node("HUD")
	await _quadros(5)

	_testar_traducao()
	await _testar_item()
	await _testar_bilhete()
	_testar_limite_inventario()

	if falhas == 0:
		print("\nTODOS OS TESTES PASSARAM")
	else:
		printerr("\n%d TESTE(S) FALHARAM" % falhas)
	get_tree().quit(1 if falhas > 0 else 0)


func _testar_traducao() -> void:
	print("Tradução:")
	var original: String = TranslationServer.get_locale()
	TranslationServer.set_locale("pt")
	_checar(tr("UI_PEGAR") == "E — pegar", "PT: UI_PEGAR")
	TranslationServer.set_locale("en")
	_checar(tr("UI_PEGAR") == "E — pick up", "EN: UI_PEGAR")
	_checar(tr("BILHETE_TESTE") != "BILHETE_TESTE", "chave de bilhete existe no CSV")
	TranslationServer.set_locale(original)


func _testar_item() -> void:
	print("Item:")
	var item: Item = principal.get_node(CAMINHO_MUNDO + "/ObjetosTeste/ItemTeste")
	var aviso: Label = hud.get_node("Aviso")
	await _mirar_em(item)
	_checar(jogador.get("alvo_atual") == item, "mira detecta o item")
	_checar(aviso.visible and aviso.text == "UI_PEGAR", "HUD mostra o aviso de pegar")

	await _apertar("interagir")
	_checar(Inventario.tem("ITEM_TESTE"), "item entrou no inventário")
	_checar(not is_instance_valid(item), "item sumiu do mapa")
	_checar(not aviso.visible, "aviso some depois de pegar")


func _testar_bilhete() -> void:
	print("Bilhete:")
	var bilhete: Bilhete = principal.get_node(CAMINHO_MUNDO + "/ObjetosTeste/BilheteTeste")
	var painel: Control = hud.get_node("Bilhete")
	var texto: Label = hud.get_node("Bilhete/Papel/Margem/Coluna/Texto")
	await _mirar_em(bilhete)
	_checar(jogador.get("alvo_atual") == bilhete, "mira detecta o bilhete")

	await _apertar("interagir")
	_checar(Jogo.bilhete_esta_aberto, "E abre o bilhete")
	_checar(painel.visible and texto.text == "BILHETE_TESTE", "painel mostra o texto certo")

	var antes: Vector3 = jogador.global_position
	await _segurar("mover_frente", 10)
	_checar(jogador.global_position.distance_to(antes) < 0.01, "jogador fica parado lendo")

	await _apertar("ui_cancel")
	_checar(not Jogo.bilhete_esta_aberto and not painel.visible, "ESC fecha o bilhete")

	antes = jogador.global_position
	await _segurar("mover_tras", 10)
	_checar(jogador.global_position.distance_to(antes) > 0.1, "jogador volta a andar")


func _testar_limite_inventario() -> void:
	print("Inventário:")
	Inventario.itens.clear()
	for i: int in Inventario.LIMITE:
		Inventario.adicionar("TESTE_%d" % i)
	_checar(Inventario.esta_cheio(), "fica cheio com %d itens" % Inventario.LIMITE)
	_checar(not Inventario.adicionar("TESTE_EXTRA"), "recusa o item a mais")
	_checar(Inventario.remover("TESTE_0") and not Inventario.tem("TESTE_0"), "remove item")
	Inventario.itens.clear()


# --- Ajudantes ---

func _checar(condicao: bool, descricao: String) -> void:
	if condicao:
		print("  OK     ", descricao)
	else:
		falhas += 1
		printerr("  FALHA  ", descricao)


func _quadros(quantidade: int) -> void:
	for i: int in quantidade:
		await get_tree().physics_frame


## Põe o jogador 1,2 m à frente do alvo (lado +Z) e aponta a câmera para ele.
func _mirar_em(alvo: Node3D) -> void:
	var pos_alvo: Vector3 = alvo.global_position
	jogador.global_position = Vector3(pos_alvo.x, 0.0, pos_alvo.z + 1.2)
	jogador.velocity = Vector3.ZERO
	var olho: Vector3 = jogador.global_position + Vector3.UP * float(jogador.get("altura_camera"))
	var direcao: Vector3 = pos_alvo - olho
	# Corpo gira no Y (frente padrão do Godot é -Z); cabeça inclina no X.
	jogador.rotation.y = atan2(-direcao.x, -direcao.z)
	var cabeca: Node3D = jogador.get_node("Cabeca")
	cabeca.rotation.x = atan2(direcao.y, Vector2(direcao.x, direcao.z).length())
	await _quadros(3)


## Simula um toque rápido numa ação (aperta e solta), passando pelo sistema de input real.
func _apertar(acao: String) -> void:
	var evento := InputEventAction.new()
	evento.action = acao
	evento.pressed = true
	Input.parse_input_event(evento)
	await _quadros(1)
	var solto := InputEventAction.new()
	solto.action = acao
	solto.pressed = false
	Input.parse_input_event(solto)
	await _quadros(2)


## Segura uma ação por alguns quadros de física (ex.: andar).
func _segurar(acao: String, quadros: int) -> void:
	Input.action_press(acao)
	await _quadros(quadros)
	Input.action_release(acao)
	await _quadros(1)


func _estourou_tempo() -> void:
	printerr("TEMPO ESGOTADO: o teste travou em algum passo.")
	get_tree().quit(2)
