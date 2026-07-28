extends Node2D

@onready var interact: AnimatedSprite2D = $interact
@onready var banheiro: Label = $Banheiro
@onready var abrindo: AudioStreamPlayer2D = $abrindo

var player_near = false
var interacting = false

func _ready() -> void:
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
			abrindo.play()
			
		"release":
			interact.play("idle")
			interacting = false


func _on_abrindo_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/casa.tscn")
