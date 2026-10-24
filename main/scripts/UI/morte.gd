extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/menu.tscn")
	

func _on_sair_para_o_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/caverna_bifurcacao.tscn")
