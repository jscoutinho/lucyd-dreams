extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/Label


var index := 0
var active := false
var texts: Array = []

func show_dialogue(dialogue: Array):
	texts = dialogue
	index = 0
	active = true

	label.text = texts[index]
	show()

func _ready():
	hide()


func _process(_delta):

	if !active:
		return

	if Input.is_action_just_pressed("ui_accept"):

		index += 1

		if index >= texts.size():
			hide()
			active = false
		else:
			label.text = texts[index]
