extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var spawn_be: Marker2D = $Spawns/SpawnBE
@onready var spawn_bd: Marker2D = $Spawns/SpawnBD
@onready var lucy: CharacterBody2D = $Lucy_fora
@onready var health_component: Control = $Lucy_fora/HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_agua_body_entered(body: Node2D) -> void:
	anim.play("fade_in_agua")

func esq_ou_dir():
		if lucy.position.x >= 0 :
			health_component.receber_dano(1,-1)
			lucy.global_position = spawn_bd.global_position

		else:
			health_component.receber_dano(1,-1) 
			lucy.global_position = spawn_be.global_position



func _on_area_2d_body_entered(body: Node2D) -> void:
	anim.play("fade_in")
	if body.is_in_group("Player"):
		
		GameManager.came_from = "conexao2"
		get_tree().call_deferred("change_scene_to_file", "res://scenes/maps/conexao1.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in_agua":
		anim.play("fade_out")
