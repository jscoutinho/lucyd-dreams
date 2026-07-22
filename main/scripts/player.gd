extends CharacterBody2D

enum PlayerState {
	IDLE,
	TRANSITION,
	WALK,
	STOP,
	JUMP,
	CUTSCENE
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -770.0
const GRAVITY_MULTIPLIER = 2.5

var status: PlayerState


func _ready() -> void:
	go_to_idle_state()
	
func play_wake_up():
	go_to_cutscene_state()


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MULTIPLIER * delta

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
		
		PlayerState.CUTSCENE:
			cutscene_state()
	move_and_slide()


#====================
# GO TO STATES
#====================

func go_to_idle_state():
	status = PlayerState.IDLE
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
	anim.play("jump")
	velocity.y = JUMP_VELOCITY

func go_to_cutscene_state():
	status = PlayerState.CUTSCENE
	anim.play("wake_up")

#====================
# STATES
#====================

func idle_state():
	move()

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		go_to_jump_state()
		return

	if velocity.x != 0:
		go_to_transition_state()
		return


func transition_state():
	move()

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		go_to_jump_state()
		return

	if velocity.x == 0:
		go_to_idle_state()


func walk_state():
	move()

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		go_to_jump_state()
		return

	# Jogador soltou a tecla
	if Input.get_axis("ui_left", "ui_right") == 0:
		go_to_stop_state()
		return


func stop_state():

	velocity.x = move_toward(velocity.x, 0, SPEED)

	# Permite pular durante a desaceleração
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		go_to_jump_state()
		return

	# Caso o jogador volte a andar antes da animação terminar
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		go_to_transition_state()
		return


func jump_state():
	move()

	if is_on_floor():
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
			

func cutscene_state():
	pass


#====================
# MOVIMENTO
#====================

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


#====================
# ANIMAÇÕES
#====================

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
			go_to_idle_state()
