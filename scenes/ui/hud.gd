extends CanvasLayer
## HUD: mira, aviso de interação, inventário, mensagens e painel de bilhete.
##
## Fica FORA do SubViewport do mundo, então é desenhado em resolução cheia
## (texto nítido) enquanto o 3D fica pixelado.
## Os Labels recebem CHAVES de tradução no "text"; o Godot traduz sozinho
## e atualiza quando o idioma muda (auto_translate).

## Quanto tempo a mensagem do topo fica na tela, em segundos.
@export var duracao_mensagem: float = 2.0

@onready var mira: ColorRect = $Mira
@onready var aviso: Label = $Aviso
@onready var faixa_inventario: HBoxContainer = $Inventario
@onready var rotulo_mensagem: Label = $Mensagem
@onready var timer_mensagem: Timer = $TimerMensagem
@onready var painel_bilhete: Control = $Bilhete
@onready var texto_bilhete: Label = $Bilhete/Papel/Margem/Coluna/Texto

var espacos: Array[Label] = []


func _ready() -> void:
	aviso.visible = false
	rotulo_mensagem.visible = false
	painel_bilhete.visible = false
	_criar_espacos_inventario()

	Jogo.mira_mudou.connect(_ao_mudar_mira)
	Jogo.bilhete_aberto.connect(_ao_abrir_bilhete)
	Jogo.bilhete_fechado.connect(_ao_fechar_bilhete)
	Jogo.mensagem.connect(_ao_receber_mensagem)
	Inventario.mudou.connect(_atualizar_inventario)
	timer_mensagem.timeout.connect(func() -> void: rotulo_mensagem.visible = false)

	_atualizar_inventario()


func _criar_espacos_inventario() -> void:
	# Um quadro por espaço do inventário (5). Ícones entram na semana de arte.
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color(0, 0, 0, 0.5)
	estilo.border_color = Color(1, 1, 1, 0.25)
	estilo.set_border_width_all(1)
	estilo.set_content_margin_all(6)
	for i: int in Inventario.LIMITE:
		var espaco := Label.new()
		espaco.custom_minimum_size = Vector2(110, 32)
		espaco.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		espaco.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		espaco.clip_text = true
		espaco.add_theme_stylebox_override("normal", estilo)
		espaco.add_theme_font_size_override("font_size", 12)
		faixa_inventario.add_child(espaco)
		espacos.append(espaco)


func _atualizar_inventario() -> void:
	for i: int in espacos.size():
		espacos[i].text = Inventario.itens[i] if i < Inventario.itens.size() else ""


func _ao_mudar_mira(chave_aviso: String) -> void:
	aviso.text = chave_aviso
	aviso.visible = not chave_aviso.is_empty() and not Jogo.bilhete_esta_aberto


func _ao_abrir_bilhete(chave_texto: String) -> void:
	texto_bilhete.text = chave_texto
	painel_bilhete.visible = true
	mira.visible = false
	aviso.visible = false


func _ao_fechar_bilhete() -> void:
	painel_bilhete.visible = false
	mira.visible = true
	aviso.visible = not aviso.text.is_empty()


func _ao_receber_mensagem(chave: String) -> void:
	rotulo_mensagem.text = chave
	rotulo_mensagem.visible = true
	timer_mensagem.start(duracao_mensagem)
