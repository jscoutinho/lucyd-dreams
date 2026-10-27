extends Node2D
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	if GameManager.came_from == "conexao1":
		var marker = $SpawnEsquerda
		$Lucy_fora.global_position = marker.global_position


func _on_direita_body_entered(body: Node2D) -> void:
	anim.play("fade_out")
	get_tree().call_deferred("change_scene_to_file","res://scenes/UI/agradecimento.tscn")


func _on_esquerda_body_entered(body: Node2D) -> void:
	GameManager.spawn_marker = "SpawnEsquerda"
	GameManager.came_from = "conexao1"
	anim.play("fade_out")


func sair():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/maps/conexao1.tscn")
