extends Node2D

@onready var interact: AnimatedSprite2D = $interact
@onready var papeln: Label = $PapelN
@onready var paper: AudioStreamPlayer2D = $paper

const FOTO := preload("res://assets/intro/img-2.png")

var player_near = false
var interacting = false

func _ready() -> void:
	interact.hide()
	papeln.hide()

func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interact") and !interacting:
		interacting = true
		interact.play("press")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = true
		interact.show()
		interact.play("idle")
		papeln.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = false
		interact.hide()
		papeln.hide()
		interacting = false
		


func _on_interact_animation_finished() -> void:
	match interact.animation:
		"press":
			paper.play()
			var dialogue = get_tree().current_scene.get_node("UI/ImageBox")
			dialogue.show_dialogue(["Parece que alguém deixou esse papel no sofá.","'Senhor Moon, é com grande prazer que venho recomendar por meio dessa carta que Lucy faça parte do show de talentos de hoje...'", "'Sabemos que ela passou por muita coisa e esperamos que essa experiência ajude o quadro dela.'", "Ajudar o quadro dela? Será que é por isso que ele concordou em me levar hoje?"], "Lucy", "res://assets/jogo/casa/documento.png")
			interact.play("release")

		"release":
			interact.play("idle")
			interacting = false
