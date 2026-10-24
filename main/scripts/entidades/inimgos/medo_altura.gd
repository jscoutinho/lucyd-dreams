extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var vida_maxima: int = 3
@export var velocidade: float = 100.0
@export var gravidade: float = 980.0
@onready var sensor_chao: RayCast2D = $SensorChao

@export var dano_contato: int = 1
@export var intervalo_dano: float = 1.0

var pode_causar_dano: bool = true

@onready var area_deteccao: Area2D = $AreaDeteccao

var alvo: CharacterBody2D = null
var perseguindo: bool = false

@export var velocidade_perseguicao: float = 160.0

var recebendo_dano: bool = false
var morrendo: bool = false
var vida_atual: int
var direcao: int = 1
var patrulhando: bool = true

func _physics_process(delta: float) -> void:
	if morrendo or recebendo_dano:
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y += gravidade * delta
	else:
		velocity.y = 0.0

	if perseguindo and is_instance_valid(alvo):
		var diferenca_x: float = alvo.global_position.x - global_position.x

		if abs(diferenca_x) > 10.0:
			var nova_direcao: int = 1 if diferenca_x > 0 else -1

			if nova_direcao != direcao:
				direcao = nova_direcao
				anim.flip_h = direcao < 0
				sensor_chao.position.x = abs(sensor_chao.position.x) * direcao
				sensor_chao.force_raycast_update()

			if is_on_floor() and not sensor_chao.is_colliding():
				velocity.x = 0.0
			else:
				velocity.x = direcao * velocidade_perseguicao
		else:
			velocity.x = 0.0

	elif patrulhando:
		if is_on_floor() and not sensor_chao.is_colliding():
			virar()
		else:
			velocity.x = direcao * velocidade

	move_and_slide()
	verificar_contato()


func virar() -> void:
	direcao *= -1
	velocity.x = 0.0

	# Espelha o sensor para o outro lado.
	sensor_chao.position.x = abs(sensor_chao.position.x) * direcao

	# Espelha o sprite, se a animação estiver orientada para a direita.
	anim.flip_h = direcao < 0

func _ready() -> void:
	vida_atual = vida_maxima


func receber_dano(quantidade: int = 1) -> void:
	if vida_atual <= 0 or recebendo_dano or morrendo:
		return

	vida_atual = max(vida_atual - quantidade, 0)
	print("Vida do monstro: ", vida_atual)

	if vida_atual <= 0:
		morrer()
	else:
		recebendo_dano = true
		velocity.x = 0.0
		anim.play("dano")
		
func morrer() -> void:
	morrendo = true
	patrulhando = false
	velocity = Vector2.ZERO

	# Impede que o monstro receba novos ataques.
	$CollisionShape2D.set_deferred("disabled", true)
	anim.play("morrendo")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	match anim.animation:
		"dano":
			recebendo_dano = false

			if patrulhando:
				anim.play("andando")

		"morrendo":
			queue_free()


func _on_area_deteccao_body_entered(body: Node2D) -> void:
	if body.name == "Lucy_fora" and body is CharacterBody2D:
		alvo = body
		perseguindo = true


func _on_area_deteccao_body_exited(body: Node2D) -> void:
	if body == alvo:
		alvo = null
		perseguindo = false
		
func verificar_contato() -> void:
	if morrendo:
		return

	for i in get_slide_collision_count():
		var colisao := get_slide_collision(i)
		var corpo := colisao.get_collider()

		if corpo.name == "Lucy_fora":
			var health_component = corpo.get_node_or_null("HealthComponent")

			if health_component:
				var direcao_recuo: float = sign(
	corpo.global_position.x - global_position.x
)

				health_component.receber_dano(
					dano_contato,
					direcao_recuo
				)
