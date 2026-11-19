extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/maps/menu.tscn")
