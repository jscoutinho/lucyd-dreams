extends Node2D

@onready var interact: AnimatedSprite2D = $interact
@onready var guitarra: Label = $Vizinhos
@onready var baixo: AudioStreamPlayer2D = $Baixo

var player_near = false
var interacting = false

func _ready() -> void:
	interact.hide()
	guitarra.hide()

func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interact") and !interacting:
		interacting = true
		interact.play("press")
		baixo.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy_fora":
		player_near = true
		interact.show()
		interact.play("idle")
		guitarra.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Lucy_fora":
		player_near = false
		interact.hide()
		guitarra.hide()
		interacting = false
		


func _on_interact_animation_finished() -> void:
	match interact.animation:
		"press":
			var dialogue = get_tree().current_scene.get_node("UI/DialogueBox")
			dialogue.show_dialogue(["Estranho, parece que só eu ouvi esse barulho...", "Se não todo mundo já estaria aqui para saber o que aconteceu."], "Lucy")
			interact.play("release")

		"release":
			interact.play("idle")
			interacting = false
