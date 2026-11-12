
extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_contato: Area2D = $Area2D
@onready var timer_dano: Timer = $TimerDano

@export var vida_maxima: int = 3
@export var velocidade: float = 80.0

@export var distancia_minima: float = 80.0
@export var distancia_maxima: float = 250.0

@export var dano_contato: int = 1
@export var intervalo_dano: float = 1.0

var vida_atual: int

var recebendo_dano: bool = false
var morrendo: bool = false
var descendo: bool = true

var alvo: CharacterBody2D = null


func _ready() -> void:
	vida_atual = vida_maxima

	# Configura o intervalo de dano.
	timer_dano.wait_time = intervalo_dano
	timer_dano.one_shot = true

	# Conecta os sinais automaticamente.
	if not area_contato.body_entered.is_connected(_on_area_2d_body_entered):
		area_contato.body_entered.connect(_on_area_2d_body_entered)

	if not area_contato.body_exited.is_connected(_on_area_2d_body_exited):
		area_contato.body_exited.connect(_on_area_2d_body_exited)

	if not timer_dano.timeout.is_connected(_on_timer_dano_timeout):
		timer_dano.timeout.connect(_on_timer_dano_timeout)


func _physics_process(delta: float) -> void:
	if morrendo or recebendo_dano:
		return

	if descendo:
		position.y = move_toward(
			position.y,
			distancia_maxima,
			velocidade * delta
		)

		anim.play("descer")

		if position.y >= distancia_maxima:
			descendo = false

	else:
		position.y = move_toward(
			position.y,
			distancia_minima,
			velocidade * delta
		)

		anim.play("subir")

		if position.y <= distancia_minima:
			descendo = true


# =====================================
# SISTEMA DE DANO RECEBIDO
# =====================================

func receber_dano(quantidade: int = 1) -> void:
	if vida_atual <= 0 or recebendo_dano or morrendo:
		return

	vida_atual = max(vida_atual - quantidade, 0)
	print("Vida da aranha: ", vida_atual)

	if vida_atual <= 0:
		morrer()
	else:
		recebendo_dano = true
		anim.play("dano")


func morrer() -> void:
	morrendo = true
	recebendo_dano = false

	timer_dano.stop()
	alvo = null

	area_contato.set_deferred("monitoring", false)
	$CollisionShape2D.set_deferred("disabled", true)

	anim.stop()
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "dano":
		recebendo_dano = false


# =====================================
# SISTEMA DE DANO POR CONTATO
# =====================================

func _on_area_2d_body_entered(body: Node2D) -> void:
	if morrendo:
		return

	if body.name == "Lucy_fora" and body is CharacterBody2D:
		alvo = body
		causar_dano()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == alvo:
		alvo = null
		timer_dano.stop()


func causar_dano() -> void:
	if morrendo or not is_instance_valid(alvo):
		return

	var health_component = alvo.get_node_or_null("HealthComponent")

	if health_component:
		var direcao_recuo: float = sign(
			alvo.global_position.x - global_position.x
		)

		if direcao_recuo == 0:
			direcao_recuo = 1

		health_component.receber_dano(
			dano_contato,
			direcao_recuo
		)

	timer_dano.start()


func _on_timer_dano_timeout() -> void:
	if morrendo or not is_instance_valid(alvo):
		return

	if area_contato.overlaps_body(alvo):
		causar_dano()


# =====================================
# TESTE DE DANO
# =====================================

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("testar_dano"):
		receber_dano()
