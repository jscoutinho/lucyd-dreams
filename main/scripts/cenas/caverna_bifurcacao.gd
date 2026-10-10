extends Node2D


func _on_esquerda_body_entered(body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_file","res://scenes/UI/agradecimento.tscn")


func _on_direita_body_entered(body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_file","res://scenes/UI/agradecimento.tscn")
