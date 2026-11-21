extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_deteccao: Area2D = $AreaDeteccao

@export var velocidade_patrulha: float = 40.0
@export var velocidade_perseguicao: float = 100.0

@export var distancia_patrulha: float = 30.0

var perseguindo: bool = false
var player: CharacterBody2D = null

var posicao_inicial: Vector2
var direcao_patrulha: float = 1.0

@export var velocidade_ataque: float = 300.0
@export var distancia_ataque: float = 300.0
@export var duracao_ataque: float = 0.4
@export var intervalo_ataque: float = 1.5

var atacando: bool = false
var direcao_ataque: Vector2 = Vector2.ZERO

var tempo_ataque: float = 0.0
var tempo_intervalo: float = 0.0

func _ready() -> void:
	posicao_inicial = global_position

	area_deteccao.body_entered.connect(_on_area_deteccao_body_entered)
	area_deteccao.body_exited.connect(_on_area_deteccao_body_exited)


func _physics_process(delta: float) -> void:
	if atacando:
		executar_ataque(delta)
	elif perseguindo and is_instance_valid(player):
		perseguir_player(delta)
	else:
		patrulhar(delta)

	move_and_slide()

func perseguir_player(delta: float) -> void:
	if not is_instance_valid(player):
		return

	tempo_intervalo = max(tempo_intervalo - delta, 0.0)

	var distancia = global_position.distance_to(player.global_position)

	if distancia <= distancia_ataque and tempo_intervalo <= 0.0:
		iniciar_ataque()
		return

	var direcao = global_position.direction_to(player.global_position)

	velocity = direcao * velocidade_perseguicao

	if direcao.x > 0:
		anim.flip_h = true
	elif direcao.x < 0:
		anim.flip_h = false

	anim.play("voando")

func patrulhar(delta: float) -> void:
	var distancia_x = global_position.x - posicao_inicial.x

	if abs(distancia_x) >= distancia_patrulha:
		direcao_patrulha *= -1

	velocity.x = direcao_patrulha * velocidade_patrulha

	# Pequena movimentação vertical
	var distancia_y = global_position.y - posicao_inicial.y

	if abs(distancia_y) >= distancia_patrulha:
		velocity.y = -sign(distancia_y) * velocidade_patrulha
	else:
		velocity.y = sin(Time.get_ticks_msec() / 400.0) * velocidade_patrulha

	anim.play("voando")
	

func iniciar_ataque() -> void:
	atacando = true
	tempo_ataque = duracao_ataque

	# Guarda a direção da Lucy no momento do ataque
	direcao_ataque = global_position.direction_to(player.global_position)

	if direcao_ataque.x > 0:
		anim.flip_h = true
	elif direcao_ataque.x < 0:
		anim.flip_h = false

	anim.play("voando_atacando")

func executar_ataque(delta: float) -> void:
	tempo_ataque -= delta

	velocity = direcao_ataque * velocidade_ataque

	if tempo_ataque <= 0.0:
		atacando = false
		tempo_intervalo = intervalo_ataque

func _on_area_deteccao_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		perseguindo = true


func _on_area_deteccao_body_exited(body: Node2D) -> void:
	if body == player:
		perseguindo = false
		player = null
