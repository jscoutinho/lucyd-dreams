extends Node2D

@onready var player = $Lucy
@onready var intro = $CanvasLayer/AnimationPlayer
@onready var DialogueBox: CanvasLayer = $DialogueBox


func _ready():

	var dialogo: Array[String] = [
	"...",
	"Que estranho...",
	"Por que eu dormi tanto?"]
	DialogueBox.show_dialogue(dialogo)
