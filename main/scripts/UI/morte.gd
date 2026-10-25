extends Node2D
@onready var anim_sprite: AnimatedSprite2D = $CanvasLayer/Control/AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var select: AudioStreamPlayer = $AudioStreamPlayer


var voltar = -1

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func escolha():
	if voltar == 0:
		get_tree().change_scene_to_file("res://scenes/maps/caverna_bifurcacao.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/maps/menu.tscn")

func _on_voltar_pressed() -> void:
	anim_sprite.play("voltar")
	voltar = 0;
	select.play()
	anim_player.play("fade_out")

	
	
	

func _on_sair_para_o_menu_pressed() -> void:
	anim_sprite.play("sair")
	anim_player.play("fade_out")
	select.play()
