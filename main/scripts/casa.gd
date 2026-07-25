extends Node2D

@onready var player = $Lucy
@onready var intro = $CanvasLayer/AnimationPlayer
@onready var DialogueBox: CanvasLayer = $UI/DialogueBox

var intro_step = 0

func _ready():
	pass

func dialogo():
	var dialogo0: Array[String] = [
	"...",
	"Que barulho foi esse lá fora?",
	"Se eu não conferir, não vou conseguir pregar os olhos"]
	DialogueBox.show_dialogue(dialogo0, "Lucy")
	player.go_to_dialogue_state()

func _on_tutorial_finished():
	$Lucy.exit_dialogue()

func tutorial():
	var dialogo2: Array[String] = [
	"Use as setas do teclado para se mover para frente e para trás!"]
	DialogueBox.show_dialogue(dialogo2, "Tutorial")


func _on_dialogue_box_finished() -> void:

	match intro_step:

		0:
			intro_step = 1

			var dialogo3: Array[String] = [
				"Use as setas do teclado para se mover para a (<--) esquerda e para a (-->) direita!"
			]

			DialogueBox.show_dialogue(dialogo3, "Tutorial")

		1:
			intro_step = 2
			$Lucy.exit_dialogue()
