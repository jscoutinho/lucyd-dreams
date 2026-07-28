extends Node2D

@onready var interact: AnimatedSprite2D = $interact
@onready var retrato: Label = $Retrato
@onready var som_papel: AudioStreamPlayer2D = $SomPapel

const FOTO := preload("res://assets/intro/img-2.png")

var player_near = false
var interacting = false

func _ready() -> void:
	interact.hide()
	retrato.hide()

func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interact") and !interacting:
		interacting = true
		interact.play("press")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = true
		interact.show()
		interact.play("idle")
		retrato.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = false
		interact.hide()
		retrato.hide()
		interacting = false
		


func _on_interact_animation_finished() -> void:
	match interact.animation:
		"press":
			som_papel.play()
			var dialogue = get_tree().current_scene.get_node("UI/ImageBox")
			dialogue.show_dialogue(["'Para MINHA Lucy lembrar de onde veio - SUA Mamãe c:'","Ah... Esse dia no parque. Me lembro como se fosse ontem.", "Nessa época, eu não sabia o quão sortuda era. Queria tantas coisas, mas não enxerguei que já tinha tudo o que eu precisava.", "Obrigada por me obrigar a tirar essa foto."], "Lucy", "res://assets/jogo/casa/quadro.png")
			interact.play("release")

		"release":
			interact.play("idle")
			interacting = false
