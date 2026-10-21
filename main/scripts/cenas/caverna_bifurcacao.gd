extends Node2D
@onready var anim: AnimationPlayer = $AnimationPlayer


func _on_direita_body_entered(body: Node2D) -> void:
	anim.play("fade_out")
	get_tree().call_deferred("change_scene_to_file","res://scenes/UI/agradecimento.tscn")


func _on_esquerda_body_entered(body: Node2D) -> void:
	anim.play("fade_out")


func sair():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/maps/conexao1.tscn")
