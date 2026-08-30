extends Node2D

@onready var interact: AnimatedSprite2D = $interact
@onready var banheiro: Label = $Banheiro
@onready var abrindo: AudioStreamPlayer2D = $abrindo

var player_near = false
var interacting = false


func _ready() -> void:
	MusicManager.get_node("AudioStreamPlayer").volume_db = -15
	
	interact.hide()
	banheiro.hide()

func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interact") and !interacting:
		interacting = true
		interact.play("press")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = true
		interact.show()
		interact.play("idle")
		banheiro.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = false
		interact.hide()
		banheiro.hide()
		interacting = false
		


func _on_interact_animation_finished() -> void:
	match interact.animation:
		"press":
			var animation_player = get_tree().current_scene.get_node("CanvasLayer/AnimationPlayer")
			animation_player.play("porta_cozinha")

			await animation_player.animation_finished


			get_tree().change_scene_to_file("res://scenes/maps/casa.tscn")

		"release":
			interact.play("idle")
			interacting = false
