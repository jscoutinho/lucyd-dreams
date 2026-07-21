extends Node2D

@onready var prompt: Sprite2D = $Prompt
@onready var guitarra: Label = $Guitarra

func _ready() -> void:
	prompt.hide()
	guitarra.hide()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy":
		prompt.show()
		guitarra.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Lucy":
		prompt.hide()
		guitarra.hide()
