extends Area2D

@export var next_level = ""

func _on_body_entered(_body: Node2D) -> void:
	call_deferred("load_next_scene")
	
func load_next_scene():
	var animation_player = get_tree().current_scene.get_node("CanvasLayer/AnimationPlayer")
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/maps/"+ next_level + ".tscn")
