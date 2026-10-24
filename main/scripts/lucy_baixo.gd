
extends CharacterBody2D
signal animation_finished_custom(animation_name: String)

@export var forca_knockback_x: float = 600.0
@export var forca_knockback_y: float = -300.0
@export var coyote_time :float = 0.15
var coyote_timer : float = 0

@onready var health_component: Control = $HealthComponent

var attack_area_posicao_inicial: Vector2

enum PlayerState {
	IDLE,
	TRANSITION,
	WALK,
	STOP,
	JUMP,
	WAKE_UP,
	DIALOGUE,
	ATTACK,
	DAMAGE,
	DEAD
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea


var alvos_atingidos: Array[Node2D] = []

const SPEED = 400.0
const JUMP_VELOCITY = -900.0
const GRAVITY_MULTIPLIER = 2.7

var status: PlayerState

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("testar_dano"):
		$HealthComponent.receber_dano(1)

func _ready() -> void:
	attack_area_posicao_inicial = attack_area.position

	attack_area.monitoring = false
	health_component.dano_recebido.connect(_on_dano_recebido)
	health_component.morreu.connect(_on_morreu)

	go_to_idle_state()


func _physics_process(delta: float) -> void:
	if status == PlayerState.DEAD:
		return

	if status == PlayerState.DAMAGE:
		if not is_on_floor():
			velocity.y += get_gravity().y * GRAVITY_MULTIPLIER * delta

		velocity.x = move_toward(
			velocity.x,
			0.0,
			1000.0 * delta
		)

		move_and_slide()
		return

	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer = maxf(coyote_timer - delta, 0.0)

		if status != PlayerState.WAKE_UP \
		and status != PlayerState.DIALOGUE:
			velocity += get_gravity() * GRAVITY_MULTIPLIER * delta

	if Input.is_action_just_pressed("atacar") \
	and status in [
		PlayerState.IDLE,
		PlayerState.TRANSITION,
		PlayerState.WALK,
		PlayerState.STOP,
		PlayerState.JUMP
	]:
		print("Estado atual: ", PlayerState.keys()[status])
		go_to_attack_state()

	match status:

		PlayerState.IDLE:
			idle_state()

		PlayerState.TRANSITION:
			transition_state()

		PlayerState.WALK:
			walk_state()

		PlayerState.STOP:
			stop_state()

		PlayerState.JUMP:
			jump_state()

		PlayerState.WAKE_UP:
			wake_up_state()

		PlayerState.DIALOGUE:
			dialogue_state()

		PlayerState.ATTACK:
			attack_state()

	
	move_and_slide()


# ==========================================
# ESTADOS
# ==========================================


func go_to_idle_state():
	status = PlayerState.IDLE
	velocity.x = 0
	anim.play("idle")


func go_to_transition_state():
	status = PlayerState.TRANSITION
	anim.play("transitioning")


func go_to_walk_state():
	status = PlayerState.WALK
	anim.play("walking")


func go_to_stop_state():
	status = PlayerState.STOP
	anim.play("stop")


func go_to_jump_state():
	status = PlayerState.JUMP
	coyote_timer = 0.0
	anim.play("jump")
	velocity.y = JUMP_VELOCITY


func go_to_wake_up_state():
	status = PlayerState.WAKE_UP
	velocity = Vector2.ZERO
	anim.play("wake_up")


func go_to_dialogue_state():
	status = PlayerState.DIALOGUE
	velocity = Vector2.ZERO
	anim.play("idle")
	
func go_to_attack_state():
	status = PlayerState.ATTACK
	alvos_atingidos.clear()

	atualizar_direcao_ataque()
	attack_area.monitoring = true

	anim.play("ataque")

func go_to_damage_state() -> void:
	if status == PlayerState.DEAD:
		return

	status = PlayerState.DAMAGE
	velocity.x = 0
	anim.play("dano")


func go_to_dead_state() -> void:
	status = PlayerState.DEAD
	velocity = Vector2.ZERO
	attack_area.monitoring = false
	$CollisionShape2D.set_deferred("disabled", true)
	anim.play("die")

# ==========================================
# IDLE
# ==========================================

func idle_state():

	move()

	if Input.is_action_just_pressed("ui_accept") && coyote_timer>0:
		go_to_jump_state()
		return

	if velocity.x != 0:
		go_to_transition_state()
		return


# ==========================================
# ATTACK
# ==========================================
func attack_state():
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED

		if direction > 0:
			anim.flip_h = false
		else:
			anim.flip_h = true

		atualizar_direcao_ataque()
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED * 0.5)
# ==========================================
# TRANSITION
# ==========================================

func transition_state():

	move()

	if Input.is_action_just_pressed("ui_accept") && coyote_timer>0:	
		go_to_jump_state()
		return

	if velocity.x == 0:
		go_to_idle_state()


# ==========================================
# WALK
# ==========================================

func walk_state():

	move()

	if Input.is_action_just_pressed("ui_accept") && coyote_timer>0:
		go_to_jump_state()
		return

	# Jogador soltou a tecla
	if Input.get_axis("ui_left", "ui_right") == 0:
		go_to_stop_state()
		return


# ==========================================
# STOP
# ==========================================

func stop_state():

	velocity.x = move_toward(velocity.x, 0, SPEED)

	# Permite pular durante a desaceleração
	if Input.is_action_just_pressed("ui_accept") && coyote_timer>0:
		go_to_jump_state()
		return

	# Caso o jogador volte a andar antes da animação terminar
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		go_to_transition_state()
		return


# ==========================================
# JUMP
# ==========================================

func jump_state():

	move()

	if is_on_floor():

		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()


# ==========================================
# WAKE UP
# ==========================================

func wake_up_state():

	# Enquanto acorda, não pode andar
	velocity = Vector2.ZERO


# ==========================================
# DIALOGUE
# ==========================================

func dialogue_state():
	velocity = Vector2.ZERO


func exit_dialogue():

	go_to_idle_state()


# ==========================================
# MOVIMENTO
# ==========================================

func move():

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction > 0:
		anim.flip_h = false

	elif direction < 0:
		anim.flip_h = true
		
	atualizar_direcao_ataque()


# ==========================================
# WAKE UP
# ==========================================

func play_wake_up() -> void:

	go_to_wake_up_state()


# ==========================================
# ANIMAÇÃO TERMINOU
# ==========================================

func _on_animated_sprite_2d_animation_finished() -> void:
	match anim.animation:
		"transitioning":
			if status == PlayerState.TRANSITION:
				if velocity.x != 0:
					go_to_walk_state()
				else:
					go_to_idle_state()

		"stop":
			if status == PlayerState.STOP:
				go_to_idle_state()

		"wake_up":
			if status == PlayerState.WAKE_UP:
				go_to_idle_state()

		"ataque":
			if status == PlayerState.ATTACK:
				attack_area.monitoring = false

				if not is_on_floor():
					status = PlayerState.JUMP
					anim.play("jump")
				else:
					var direction := Input.get_axis(
						"ui_left", "ui_right"
					)

					if direction != 0:
						go_to_transition_state()
					else:
						go_to_idle_state()
		"dano":
			if status == PlayerState.DAMAGE:
				go_to_idle_state()

		"die":
			if status == PlayerState.DEAD:
				get_tree().call_deferred("change_scene_to_file", "res://scenes/UI/morte.tscn")

	animation_finished_custom.emit(anim.animation)

func _on_dano_recebido(direcao_impacto: float = 0.0) -> void:
	go_to_damage_state()

	var direcao := direcao_impacto

	# Se o dano não informar a direção, usa a orientação da Lucy.
	if direcao == 0.0:
		direcao = 1.0 if anim.flip_h else -1.0

	velocity.x = direcao * forca_knockback_x
	velocity.y = forca_knockback_y

		
func _on_morreu() -> void:
	go_to_dead_state()


func _on_attack_area_body_entered(body: Node2D) -> void:
	print("Área de ataque detectou: ", body.name)
	if status != PlayerState.ATTACK:
		return

	if body in alvos_atingidos:
		return

	if body.has_method("receber_dano"):
		alvos_atingidos.append(body)
		body.receber_dano(1)
		
func atualizar_direcao_ataque() -> void:
	if anim.flip_h:
		attack_area.position.x = -abs(attack_area_posicao_inicial.x)
	else:
		attack_area.position.x = abs(attack_area_posicao_inicial.x)
