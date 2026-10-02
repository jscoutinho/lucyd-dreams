extends Node2D

@onready var player = $Lucy
@onready var intro = $CanvasLayer/AnimationPlayer
@onready var DialogueBox: CanvasLayer = $UI/DialogueBox
@onready var barulho: AudioStreamPlayer2D = $AudioStreamPlayer2D

var intro_step = 0

func _ready():
	if GameManager.came_from == "banheiro":
		intro.play("fade_out")
		var marker = $SpawnBanheiro
		$Lucy.global_position = marker.global_position

		GameManager.came_from = ""
	else:
		MusicManager.tocar_musica(load("res://assets/msc/wake_up.mp3"))
		barulho.play()
		intro.play("intro")

func dialogo():
	var dialogo0: Array[String] = [
	"...",
	"Que barulho foi esse lá fora?",
	"Se eu não conferir, não vou conseguir pregar os olhos"]
	DialogueBox.show_dialogue(dialogo0, "Lucy")
	player.go_to_dialogue_state()
	var lucy = get_tree().get_first_node_in_group("Player")
	lucy.get_node("./AnimatedSprite2D").stop()
	lucy.get_node("./AnimatedSprite2D").play("idle")


func _on_tutorial_finished():
	$Lucy.exit_dialogue()



func _on_dialogue_box_finished() -> void:

	if GameManager.tutorial1 == false:
			GameManager.tutorial1 = true

			var dialogo3: Array[String] = [
				"Use as setas do teclado para se mover para a (<--) esquerda e para a (-->) direita!"
			]

			DialogueBox.show_dialogue(dialogo3, "Tutorial")

	else:
			$Lucy.exit_dialogue()
