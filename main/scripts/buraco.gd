extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.tocar_musica(load("res://assets/msc/queda.mp3"), -10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_file", ("res://scenes/UI/capa.tscn"));
