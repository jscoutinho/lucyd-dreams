extends Node2D
@onready var bolinhas: Node2D = $Bolinhas
@onready var hit_position = $HitPosition

var respiration_note = preload("res://scenes/entities/respiration_node.tscn")

const HIT_WINDOW := 20.0

func _ready():
	spawn_note()

func _input(event):
	if event.is_action_pressed("respirar"):
		print("APERTEI ESPAÇO")
		tentar_acertar()



func tentar_acertar():
	print("TENTANDO ACERTAR")

	if bolinhas.get_child_count() == 0:
		print("NÃO TEM BOLINHA")
		return

	var note = bolinhas.get_child(0)

	var distancia = abs(
		note.global_position.x - hit_position.global_position.x
	)

	print("DISTÂNCIA: ", distancia)
	print("HIT WINDOW: ", HIT_WINDOW)

	if distancia <= HIT_WINDOW:
		print("ACERTO!")
		note.queue_free()




func spawn_note():
	var note = respiration_note.instantiate()

	bolinhas.add_child(note)

	note.global_position = hit_position.global_position + Vector2(1100, 0)

	print("BOLINHA CRIADA")
