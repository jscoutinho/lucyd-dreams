extends Node2D

@onready var aranha: CharacterBody2D = $Aranha
@onready var teia: Line2D = $Teia

@export var distancia_cabeca: float = -12.0

func _ready():
	teia.clear_points()
	teia.add_point(Vector2.ZERO)
	teia.add_point(
		aranha.position + Vector2(0, distancia_cabeca)
	)

func _process(_delta):
	if not is_instance_valid(aranha):
		queue_free()
		return

	teia.set_point_position(
		1,
		aranha.position + Vector2(0, distancia_cabeca)
	)
