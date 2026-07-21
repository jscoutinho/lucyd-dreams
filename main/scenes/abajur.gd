extends Node2D

@onready var prompt = $Prompt

func _ready():
	prompt.hide()

func _on_area_2d_body_entered(body):
	if body.name == "Lucy":
		prompt.show()

func _on_area_2d_body_exited(body):
	if body.name == "Lucy":
		prompt.hide()
