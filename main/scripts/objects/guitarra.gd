extends Node2D

@onready var interact: AnimatedSprite2D = $interact
@onready var guitarra: Label = $Guitarra

var player_near = false
var interacting = false

func _ready() -> void:
	interact.hide()
	guitarra.hide()

func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interact") and !interacting:
		interacting = true
		interact.play("press")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = true
		interact.show()
		interact.play("idle")
		guitarra.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = false
		interact.hide()
		guitarra.hide()
		interacting = false
		


func _on_interact_animation_finished() -> void:
	match interact.animation:
		"press":
			var dialogue = get_tree().current_scene.get_node("UI/DialogueBox")
			dialogue.show_dialogue(["Eu não deveria ter tocado nela hoje.", "Fazia tanto tempo que ela estava guardada...", "Desde que..."], "Lucy")
			interact.play("release")

		"release":
			interact.play("idle")
			interacting = false
