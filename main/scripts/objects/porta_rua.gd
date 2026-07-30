extends Node2D

@onready var interact: AnimatedSprite2D = $interact
@onready var rua: Label = $Rua
@onready var trancada: AudioStreamPlayer2D = $trancada

var player_near = false
var interacting = false
var waiting_tutorial = false

func _ready() -> void:
	interact.hide()
	rua.hide()

func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interact") and !interacting:
		interacting = true
		interact.play("press")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = true
		interact.show()
		interact.play("idle")
		rua.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = false
		interact.hide()
		rua.hide()
		interacting = false

func _on_interact_animation_finished() -> void:
	match interact.animation:
		"press":

			if GameManager.has_key:
				get_tree().change_scene_to_file("res://scenes/maps/rua_casa.tscn")
			else:
				trancada.play()
				var dialogue = get_tree().current_scene.get_node("UI/DialogueBox")

			
				if !dialogue.finished.is_connected(_on_dialogue_finished):
					dialogue.finished.connect(_on_dialogue_finished)

				waiting_tutorial = true

				dialogue.show_dialogue(
					[
						"A porta está trancada.",
						"Acho que deixei uma cópia da chave na caixa em cima do guarda-roupas."
					],
					"Lucy"
				)

				interact.play("release")

		"release":
			interact.play("idle")
			interacting = false


func _on_dialogue_finished():

	if !waiting_tutorial:
		return

	waiting_tutorial = false

	var dialogue = get_tree().current_scene.get_node("UI/DialogueBox")

	if dialogue.finished.is_connected(_on_dialogue_finished):
		dialogue.finished.disconnect(_on_dialogue_finished)

	dialogue.show_dialogue(
		[
			"Pressione Z para saltar sobre objetos."
		],
		"Tutorial"
	)
