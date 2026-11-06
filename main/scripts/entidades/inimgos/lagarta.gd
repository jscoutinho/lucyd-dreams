
extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sensor_chao: RayCast2D = $SensorChao
@export var dano_contato: int = 1
@export var intervalo_dano: float = 1.0
@export var vida_maxima: int = 3

@export var forca_knockback_x: float = 250.0
@export var forca_knockback_y: float = -80.0

var vida_atual: int
var recebendo_dano: bool = false
var morrendo: bool = false
var tempo_ate_dano: float = 0.0



enum Estado {
	PARADA,
	CONTRAINDO,
	AVANCANDO
}

var estado: Estado = Estado.PARADA

@export var gravidade: float = 980.0
@export var velocidade_avanco: float = 180.0

@export var intervalo_minimo: float = 0.5
@export var intervalo_maximo: float = 1

@export var tempo_contracao: float = 0.5
@export var tempo_avanco: float = 0.45

var tempo_estado: float = 0.0
var direcao: int = -1


func _ready() -> void:
	vida_atual = vida_maxima
	anim.play("parada")
	aguardar_proximo_movimento()


func _physics_process(delta: float) -> void:
	tempo_ate_dano = maxf(tempo_ate_dano - delta, 0.0)
	
	if morrendo:
		return

	if recebendo_dano:
		if not is_on_floor():
			velocity.y += gravidade * delta
		else:
			velocity.x = move_toward(velocity.x, 0.0, 500.0 * delta)

		move_and_slide()
		return
	
	
	# Gravidade
	if not is_on_floor():
		velocity.y += gravidade * delta
	else:
		velocity.y = 0.0

	match estado:

		Estado.PARADA:
			velocity.x = 0.0

			tempo_estado -= delta

			if tempo_estado <= 0:
				iniciar_contracao()

		Estado.CONTRAINDO:
			velocity.x = 0.0

			tempo_estado -= delta

			if tempo_estado <= 0:
				iniciar_avanco()

		Estado.AVANCANDO:
			velocity.x = direcao * velocidade_avanco

			tempo_estado -= delta

			if tempo_estado <= 0:
				finalizar_avanco()

	move_and_slide()

	# Verifica se encostou na Lucy
	#verificar_contato()

	# Verifica se encontrou uma parede de verdade
	if estado == Estado.AVANCANDO:
		var encontrou_parede := false

		for i in get_slide_collision_count():
			var colisao := get_slide_collision(i)

			# Só considera colisões laterais como parede.
			if absf(colisao.get_normal().x) > 0.8:
				encontrou_parede = true
				break

		if encontrou_parede:
			direcao *= -1
			finalizar_avanco()

		elif is_on_floor() and not sensor_chao.is_colliding():
			direcao *= -1
			finalizar_avanco()


func aguardar_proximo_movimento() -> void:
	estado = Estado.PARADA
	velocity.x = 0.0

	tempo_estado = randf_range(
		intervalo_minimo,
		intervalo_maximo
	)

	anim.play("parada")


func iniciar_contracao() -> void:
	estado = Estado.CONTRAINDO
	velocity.x = 0.0

	tempo_estado = tempo_contracao
	anim.play("contraindo")


func iniciar_avanco() -> void:
	estado = Estado.AVANCANDO

	tempo_estado = tempo_avanco
	anim.play("avancando")

	anim.flip_h = direcao < 0

	# Atualiza a direção do sensor
	sensor_chao.position.x = abs(sensor_chao.position.x) * direcao
	sensor_chao.force_raycast_update()


func finalizar_avanco() -> void:
	aguardar_proximo_movimento()
	
func verificar_contato() -> void:
	if tempo_ate_dano > 0:
		return

	for i in get_slide_collision_count():
		var colisao := get_slide_collision(i)
		var corpo := colisao.get_collider() as Node2D

		if corpo == null:
			continue

		var health_component: Node = corpo.get_node_or_null("HealthComponent") as Node

		if health_component:
			var direcao_recuo: float = sign(
				corpo.global_position.x - global_position.x
			)

			health_component.receber_dano(
				dano_contato,
				direcao_recuo
			)

			tempo_ate_dano = intervalo_dano
			return


func _on_area_dano_body_entered(corpo: Node2D) -> void:
	if corpo == self:
		return
	if morrendo:
		return
	var health_component: Node = corpo.get_node_or_null("HealthComponent")

	if health_component != null and health_component.has_method("receber_dano"):
		var direcao_recuo: float = signf(corpo.global_position.x - global_position.x)
		health_component.call("receber_dano", dano_contato, direcao_recuo)




func receber_dano(quantidade: int = 1) -> void:
	if vida_atual <= 0 or recebendo_dano or morrendo:
		return

	vida_atual = max(vida_atual - quantidade, 0)
	print("Vida da lagarta: ", vida_atual)

	if vida_atual <= 0:
		morrer()
	else:
		recebendo_dano = true

		var player = get_tree().get_first_node_in_group("Player")

		if player:
			var direcao_knockback = sign(global_position.x - player.global_position.x)
			velocity.x = direcao_knockback * forca_knockback_x

		velocity.y = forca_knockback_y
		anim.play("dano")



func morrer() -> void:
	morrendo = true
	recebendo_dano = false
	velocity = Vector2.ZERO

	# Desativa a colisão física.
	$CollisionShape2D.set_deferred("disabled", true)

	# Impede que a lagarta continue causando dano.
	$AreaDano.set_deferred("monitoring", false)
	$AreaDano.set_deferred("monitorable", false)

	anim.play("morrendo")

func _on_animated_sprite_2d_animation_finished() -> void:
	match anim.animation:
		"dano":
			recebendo_dano = false

			match estado:
				Estado.PARADA:
					anim.play("parada")
				Estado.CONTRAINDO:
					anim.play("contraindo")
				Estado.AVANCANDO:
					anim.play("avancando")

		"morrendo":
			queue_free()
