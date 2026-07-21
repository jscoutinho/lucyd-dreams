extends CharacterBody2D

enum PlayerState {
	IDLE,
	TRANSITION,
	WALK,
	JUMP
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -760.0
const GRAVITY_MULTIPLIER = 1.5

var status: PlayerState


func _ready() -> void:
	go_to_idle_state()


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity += get_gravity() * GRAVITY_MULTIPLIER * delta

	match status:
		PlayerState.IDLE:
			idle_state()

		PlayerState.TRANSITION:
			transition_state()

		PlayerState.WALK:
			walk_state()

		PlayerState.JUMP:
			jump_state()

	move_and_slide()


# go_to 


func go_to_idle_state():
	status = PlayerState.IDLE
	anim.play("idle")


func go_to_transition_state():
	status = PlayerState.TRANSITION
	anim.play("transitioning")


func go_to_walk_state():
	status = PlayerState.WALK
	anim.play("walking")


func go_to_jump_state():
	status = PlayerState.JUMP
	anim.play("jump")
	velocity.y = JUMP_VELOCITY



# states

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

	# Espera a animação terminar
	if velocity.x == 0:
		go_to_idle_state()


func walk_state():
	move()

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		go_to_jump_state()
		return

	if velocity.x == 0:
		go_to_idle_state()
		return


func jump_state():
	move()

	if is_on_floor():
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()



# MOVIMENTO


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


# ANIMAÇÕES

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "transitioning":
		if status == PlayerState.TRANSITION:
			if velocity.x != 0:
				go_to_walk_state()
			else:
				go_to_idle_state()
