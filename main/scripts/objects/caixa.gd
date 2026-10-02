
extends Node2D

@onready var interact: AnimatedSprite2D = $interact
@onready var caixa: Label = $CaixaN

var player_near = false
var interacting = false
var waiting_for_taking = false


func _ready() -> void:
	interact.hide()
	caixa.hide()

	var lucy = get_tree().get_first_node_in_group("Player")

	if lucy:
		lucy.animation_finished_custom.connect(_on_lucy_animation_finished)


func _process(_delta: float) -> void:

	if player_near and Input.is_action_just_pressed("interact") and !interacting:

		interacting = true
		interact.play("press")

		var lucy = get_tree().get_first_node_in_group("Player")

		# Se ainda não pegou a chave,
		# Lucy começa a animação de pegar.
		if !GameManager.has_key:

			waiting_for_taking = true

			var lucy_anim: AnimatedSprite2D = lucy.get_node("./AnimatedSprite2D")

			lucy_anim.stop()
			lucy_anim.play("taking")

		else:

			# Já possui a chave
			show_dialogue()


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

			# Se estamos esperando a Lucy terminar de pegar,
			# não fazemos nada aqui.
			if waiting_for_taking:
				return

			interact.play("release")


		"release":

			interact.play("idle")
			interacting = false


func _on_lucy_animation_finished(animation_name: String) -> void:

	if animation_name == "taking" and waiting_for_taking:

		waiting_for_taking = false

		GameManager.has_key = true

		show_dialogue()


func show_dialogue() -> void:

	var dialogue = get_tree().current_scene.get_node("UI/DialogueBox")

	dialogue.show_dialogue(
		["Isso, sabia que você estava por aqui."],
		"Lucy"
	)

	interact.play("release")
