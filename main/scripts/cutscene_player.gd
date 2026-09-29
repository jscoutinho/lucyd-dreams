extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y = min(velocity.y, 1100.0)
	move_and_slide()
	
func _ready() -> void:
	anim.play("acelerando")
	

func _on_animated_sprite_2d_animation_finished() -> void:
	anim.play("caindo")
