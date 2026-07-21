extends Node2D

@onready var prompt = $Prompt
@onready var label: Label = $"Abajur nome"
@onready var luz = $"Luz Abajur"
var player_near = false

func _ready() -> void:
	prompt.hide()
	label.hide()
	luz.hide()

func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interact"):
		luz.visible = !luz.visible

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = true
		prompt.show()
		label.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Lucy":
		player_near = false
		prompt.hide()
		label.hide()
