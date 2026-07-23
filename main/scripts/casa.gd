extends Node2D

@onready var player = $Lucy
@onready var intro = $CanvasLayer/AnimationPlayer
@onready var DialogueBox: CanvasLayer = $UI/DialogueBox


func _ready():

	var dialogo: Array[String] = [
	"...",
	"Que estranho...",
	"Por que eu dormi tanto?"]
	DialogueBox.show_dialogue(dialogo)
	
	var player = get_tree().current_scene.get_node("Lucy")
	player.go_to_dialogue_state()
