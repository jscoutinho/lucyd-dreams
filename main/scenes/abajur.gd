extends Node2D

@onready var prompt = $Prompt
@onready var label: Label = $Label

func _ready():
	prompt.hide()
	label.hide()

func _on_area_2d_body_entered(body):
	if body.name == "Lucy":
		prompt.show()
		label.show()
func _on_area_2d_body_exited(body):
	if body.name == "Lucy":
		prompt.hide()
		label.show()
