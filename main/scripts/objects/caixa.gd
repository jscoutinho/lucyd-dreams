extends Node2D

@onready var interact: AnimatedSprite2D = $interact
@onready var caixa: Label = $CaixaN

var player_near = false
var interacting = false

func _ready() -> void:
	interact.hide()
	caixa.hide()

func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interact") and !interacting:
		interacting = true
		interact.play("press")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = true
		interact.show()
		interact.play("idle")
		caixa.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = false
		interact.hide()
		caixa.hide()
		interacting = false
		


func _on_interact_animation_finished() -> void:
	match interact.animation:
		"press":
			if !GameManager.has_key:
				GameManager.has_key = true
				var dialogue = get_tree().current_scene.get_node("UI/DialogueBox")
				dialogue.show_dialogue(["Isso, sabia que você estava por aqui."], "Lucy")
				interact.play("release")
			else:
				var dialogue = get_tree().current_scene.get_node("UI/DialogueBox")
				dialogue.show_dialogue(["Tenho que abrir a porta agora."], "Lucy")
				interact.play("release")
		"release":
			interact.play("idle")
			interacting = false
