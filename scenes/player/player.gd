extends CharacterBody3D
## Jogador em primeira pessoa: anda com WASD, olha com o mouse e examina com E.
## Sem pulo e sem corrida.

## Velocidade de caminhada em metros por segundo (uma criança andando ~2,5 m/s).
@export var velocidade: float = 2.5
## Altura dos olhos em metros, medida a partir dos pés.
@export var altura_camera: float = 1.1
## Quanto a câmera gira (em radianos) para cada pixel que o mouse anda.
@export var sensibilidade_mouse: float = 0.002
## Ângulo máximo (em graus) para olhar para cima ou para baixo.
@export var angulo_max_olhar: float = 85.0

@onready var cabeca: Node3D = $Cabeca
## Raio que sai do centro da tela; o alcance fica em target_position (no editor).
@onready var raio: RayCast3D = $Cabeca/Camera3D/RaioInteracao

## Objeto interagível na mira agora (null = nenhum).
var alvo_atual: Interagivel = null
## Última chave de aviso enviada ao HUD (evita emitir o sinal todo quadro).
var _aviso_mostrado: String = ""


func _ready() -> void:
	cabeca.position.y = altura_camera
	# O raio nasce dentro da cápsula do jogador; garante que ele não acerta o próprio corpo.
	raio.add_exception(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	# Com bilhete aberto, E ou ESC só fecham o bilhete; o resto é ignorado.
	# Tratar isso AQUI (e não no HUD) evita que o mesmo ESC também solte o mouse.
	if Jogo.bilhete_esta_aberto:
		if event.is_action_pressed("interagir") or event.is_action_pressed("ui_cancel"):
			Jogo.fechar_bilhete()
			get_viewport().set_input_as_handled()
		return

	var mouse_preso: bool = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion and mouse_preso:
		var movimento := event as InputEventMouseMotion
		# screen_relative não é afetado pela escala da janela nem do SubViewport.
		rotate_y(-movimento.screen_relative.x * sensibilidade_mouse)
		cabeca.rotate_x(-movimento.screen_relative.y * sensibilidade_mouse)
		var limite: float = deg_to_rad(angulo_max_olhar)
		cabeca.rotation.x = clampf(cabeca.rotation.x, -limite, limite)

	elif event.is_action_pressed("interagir"):
		if _alvo_valido():
			alvo_atual.interagir(self)
			# Atualiza na hora: se o item foi pego, o aviso some neste mesmo quadro.
			_atualizar_alvo()

	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	elif event is InputEventMouseButton and event.is_pressed() and not mouse_preso:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var entrada: Vector2 = Vector2.ZERO
	if not Jogo.bilhete_esta_aberto:
		entrada = Input.get_vector("mover_esquerda", "mover_direita", "mover_frente", "mover_tras")

	# Converte a entrada (relativa ao jogador) para uma direção no mundo.
	var direcao: Vector3 = transform.basis * Vector3(entrada.x, 0.0, entrada.y)
	velocity.x = direcao.x * velocidade
	velocity.z = direcao.z * velocidade
	move_and_slide()

	_atualizar_alvo()


## Vê o que o raio está acertando e avisa o HUD quando o aviso muda.
## O raio também enxerga paredes (camada 1), então não dá para examinar através delas.
func _atualizar_alvo() -> void:
	var novo: Interagivel = null
	if raio.is_colliding():
		novo = raio.get_collider() as Interagivel
	# Um item pego só é apagado no fim do quadro; até lá o raio ainda o enxerga.
	if not _eh_utilizavel(novo):
		novo = null
	alvo_atual = novo

	# Compara a CHAVE do aviso, não o objeto: comparar com um objeto já apagado
	# não é confiável no Godot 4 e deixava o aviso preso na tela.
	var chave: String = novo.chave_aviso if novo != null else ""
	if chave != _aviso_mostrado:
		_aviso_mostrado = chave
		Jogo.mira_mudou.emit(chave)


func _alvo_valido() -> bool:
	return _eh_utilizavel(alvo_atual)


func _eh_utilizavel(objeto: Interagivel) -> bool:
	return is_instance_valid(objeto) and not objeto.is_queued_for_deletion()
