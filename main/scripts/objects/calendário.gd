extends Node2D

@onready var interact: AnimatedSprite2D = $interact
@onready var calendario: Label = $CalendarioN

var player_near = false
var interacting = false

func _ready() -> void:
	interact.hide()
	calendario.hide()

func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interact") and !interacting:
		interacting = true
		interact.play("press")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = true
		interact.show()
		interact.play("idle")
		calendario.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = false
		interact.hide()
		calendario.hide()
		interacting = false
		


func _on_interact_animation_finished() -> void:
	match interact.animation:
		"press":
			var dialogue = get_tree().current_scene.get_node("UI/ImageBox")
			dialogue.show_dialogue(["Dia 8 de dezembro...", "Ou será 7? Nunca fui boa com tempo, mas parece que ainda não amanheceu"], "Lucy", "res://assets/jogo/casa/calendario.png")
			interact.play("release")

		"release":
			interact.play("idle")
			interacting = false
