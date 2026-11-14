extends CharacterBody3D
## Jogador em primeira pessoa: anda com WASD e olha com o mouse.
## Sem pulo e sem corrida por enquanto.

# @export faz a variável aparecer no Inspetor do Godot,
# então dá para ajustar os valores sem abrir o código.

## Velocidade de caminhada em metros por segundo (uma criança andando ~2,5 m/s).
@export var velocidade: float = 2.5
## Altura dos olhos em metros, medida a partir dos pés.
@export var altura_camera: float = 1.1
## Quanto a câmera gira (em radianos) para cada pixel que o mouse anda.
@export var sensibilidade_mouse: float = 0.002
## Ângulo máximo (em graus) para olhar para cima ou para baixo.
@export var angulo_max_olhar: float = 85.0

# @onready busca o nó só quando a cena já está pronta na árvore.
# "$Cabeca" é um atalho para get_node("Cabeca").
@onready var cabeca: Node3D = $Cabeca


func _ready() -> void:
	# Posiciona a cabeça (e a câmera dentro dela) na altura definida.
	cabeca.position.y = altura_camera
	# Prende e esconde o cursor no centro da janela.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# _unhandled_input recebe eventos que nenhuma interface (UI) consumiu antes.
# Assim, no futuro, um menu aberto pode "engolir" o clique sem girar a câmera.
func _unhandled_input(event: InputEvent) -> void:
	var mouse_preso: bool = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion and mouse_preso:
		var movimento := event as InputEventMouseMotion
		# screen_relative = quantos pixels o mouse andou desde o último evento,
		# sem ser afetado pela escala da janela.
		# Horizontal: gira o CORPO inteiro em volta do eixo Y.
		rotate_y(-movimento.screen_relative.x * sensibilidade_mouse)
		# Vertical: gira só a CABEÇA em volta do eixo X.
		cabeca.rotate_x(-movimento.screen_relative.y * sensibilidade_mouse)
		# Limita o ângulo para não dar "cambalhota" olhando para cima/baixo.
		var limite: float = deg_to_rad(angulo_max_olhar)
		cabeca.rotation.x = clampf(cabeca.rotation.x, -limite, limite)

	elif event.is_action_pressed("ui_cancel"):
		# "ui_cancel" já vem pronto no Godot e corresponde ao ESC.
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	elif event is InputEventMouseButton and event.is_pressed() and not mouse_preso:
		# Clicar na janela com o mouse solto prende ele de novo.
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# _physics_process roda em ritmo fixo (60x por segundo por padrão),
# sincronizado com a física. Movimento de corpos físicos vai sempre aqui.
func _physics_process(delta: float) -> void:
	# Gravidade: sem ela o personagem "flutuaria" ao sair de uma borda.
	# Multiplicar por delta transforma aceleração (m/s²) em mudança de velocidade.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# get_vector junta 4 ações num Vector2 (x = esquerda/direita, y = frente/trás).
	# O comprimento já vem limitado a 1, então andar na diagonal não fica mais rápido.
	var entrada: Vector2 = Input.get_vector(
		"mover_esquerda", "mover_direita", "mover_frente", "mover_tras"
	)

	# Converte a entrada (relativa ao jogador) para uma direção no mundo.
	# transform.basis contém a rotação do corpo; multiplicar "gira" o vetor
	# para apontar para onde o jogador está virado.
	var direcao: Vector3 = transform.basis * Vector3(entrada.x, 0.0, entrada.y)

	# Só mexemos em X e Z; o Y fica com a gravidade.
	velocity.x = direcao.x * velocidade
	velocity.z = direcao.z * velocidade

	# Move o corpo usando "velocity" e desliza ao encostar em paredes.
	move_and_slide()
