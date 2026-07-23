extends Node2D

@onready var prompt: Sprite2D = $Prompt
@onready var retrato: Label = $Retrato

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	retrato.hide()
	prompt.hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy":
			retrato.show()
			prompt.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Lucy":
			retrato.hide()
			prompt.hide()
